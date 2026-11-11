// lib/src/features/competitors/data/repositories/competitor_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/competitors/data/models/competitor_model.dart';
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/features/competitors/domain/repositories/competitor_repository.dart';
import 'package:either_dart/either.dart';
import 'package:pocketbase/pocketbase.dart';

/// Repositorio de datos para competidores contra PocketBase.
class CompetitorRepositoryImpl implements CompetitorRepository {
  /// Crea el repositorio con el cliente de PocketBase.
  CompetitorRepositoryImpl(this._client);

  final PocketBase _client;

  static final RegExp _nationalIdPattern = RegExp(r'^\d{11}$');

  @override
  Future<Either<Failure, List<CompetitorEntity>>> getAll({
    String? search,
    String? teamId,
    CompetitorCategory? category,
    CompetitorStatus? status,
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final filters = <String>[];

      if (search?.isNotEmpty == true) {
        final value = search!.toLowerCase();
        filters.add(
          '(firstName ~ "$value") || '
          '(lastName ~ "$value") || '
          '(CI ~ "$value")',
        );
      }

      if (teamId?.isNotEmpty == true) {
        filters.add('teamId = "$teamId"');
      }

      if (category != null) {
        final value = CompetitorModel.categoryValue(category);
        filters.add('category = "$value"');
      }

      if (status != null) {
        final value = CompetitorModel.statusValue(status);
        filters.add('status = "$value"');
      }

      final filter =
          filters.isEmpty ? null : filters.join(' && ');

      final result = await _client.collection('competitors').getList(
        page: page,
        perPage: perPage,
        filter: filter,
        sort: '\u002Dcreated',
        expand: 'teamId',
      );

      final competitors = result.items
          .map(
            (record) =>
                CompetitorModel.fromMap(record.toJson()).toEntity(),
          )
          .toList();

      return Right(competitors);
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(error, 'Error inesperado'),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, CompetitorEntity?>> getById(String id) async {
    try {
      final record = await _client.collection('competitors').getOne(
        id,
        expand: 'teamId',
      );

      return Right(
        CompetitorModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (error) {
      if (_isNotFound(error)) {
        return const Right(null);
      }

      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al obtener competidor',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al obtener competidor: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CompetitorEntity>> createCompetitor(
    CompetitorEntity competitor,
  ) async {
    try {
      final validationError = _validate(competitor);
      if (validationError != null) {
        return Left(ValidationFailure(message: validationError));
      }

      final existing = await getByCI(competitor.nationalId);
      if (existing.isRight && existing.right != null) {
        return const Left(
          ValidationFailure(
            message: 'Ya existe un competidor con este CI',
          ),
        );
      }

      final body =
          CompetitorModel.fromEntity(competitor).toMap();
      final record = await _client
          .collection('competitors')
          .create(body: body);

      return Right(
        CompetitorModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al crear competidor',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al crear competidor: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CompetitorEntity>> updateCompetitor(
    CompetitorEntity competitor,
  ) async {
    try {
      final validationError = _validate(competitor);
      if (validationError != null) {
        return Left(ValidationFailure(message: validationError));
      }

      final body =
          CompetitorModel.fromEntity(competitor).toMap();
      final record = await _client
          .collection('competitors')
          .update(
            competitor.id,
            body: body,
          );

      return Right(
        CompetitorModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al actualizar competidor',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al actualizar competidor: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteCompetitor(String id) async {
    try {
      await _client.collection('competitors').update(
        id,
        body: {
          'status':
              CompetitorModel.statusValue(CompetitorStatus.suspended),
        },
      );

      return const Right(null);
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al eliminar competidor',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al eliminar competidor: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CompetitorEntity?>> getByCI(String ci) async {
    try {
      final result = await _client.collection('competitors').getList(
        filter: 'CI = "$ci"',
        perPage: 1,
      );

      if (result.items.isEmpty) {
        return const Right(null);
      }

      return Right(
        CompetitorModel.fromMap(
          result.items.first.toJson(),
        ).toEntity(),
      );
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al buscar por CI',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al buscar por CI: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getCountBy({
    String? teamId,
    CompetitorCategory? category,
  }) async {
    try {
      final filters = <String>[];

      if (teamId?.isNotEmpty == true) {
        filters.add('teamId = "$teamId"');
      }

      if (category != null) {
        final value = CompetitorModel.categoryValue(category);
        filters.add('category = "$value"');
      }

      final filter =
          filters.isEmpty ? null : filters.join(' && ');

      final result = await _client.collection('competitors').getList(
        filter: filter,
        perPage: 500,
        fields: 'id,category,teamId',
      );

      final byCategory = <String, int>{};

      for (final record in result.items) {
        final value = _recordStringValue(record.data, 'category');
        byCategory[value] = (byCategory[value] ?? 0) + 1;
      }

      return Right(byCategory);
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error al contar: $error'),
      );
    }
  }

  static String _clientMessage(
    ClientException error,
    String fallback,
  ) {
    final Object response = error.response;

    if (response is Map<String, dynamic>) {
      final Object? message = response['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return '$fallback: $error';
  }

  static bool _isNotFound(ClientException error) {
    final Object response = error.response;

    if (response is Map<String, dynamic>) {
      final Object? status = response['status'];

      if (status is int) {
        return status == 404;
      }

      if (status is String) {
        return status == '404';
      }
    }

    return false;
  }

  static String _recordStringValue(Object? data, String key) {
    if (data is Map<String, dynamic>) {
      final Object? value = data[key];
      if (value is String) {
        return value;
      }
    }

    return '';
  }

  String? _validate(CompetitorEntity competitor) {
    if (competitor.firstName.trim().length < 2) {
      return 'Nombre inválido';
    }

    if (competitor.lastName.trim().length < 2) {
      return 'Apellido inválido';
    }

    if (!_nationalIdPattern.hasMatch(competitor.nationalId)) {
      return 'CI debe tener 11 dígitos';
    }

    if (
      competitor.academicYear < 1 ||
      competitor.academicYear > 6
    ) {
      return 'Año académico inválido';
    }

    return null;
  }
}
