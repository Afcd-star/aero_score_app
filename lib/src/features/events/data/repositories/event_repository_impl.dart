// lib/src/features/events/data/repositories/event_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/'
    'features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/'
    'features/events/data/models/event_model.dart';
import 'package:aero_score_app/src/'
    'features/events/domain/entities/event_entity.dart';
import 'package:aero_score_app/src/'
    'features/events/domain/repositories/event_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

/// Repositorio de eventos contra PocketBase.
class EventRepositoryImpl implements EventRepository {
  /// Crea el repositorio con el cliente de PocketBase.
  EventRepositoryImpl(this._client);

  final PocketBase _client;

  // ✅ Helper: validar que un ID pertenece a usuario con rol de juez
  Future<bool> _isValidJudge(String userId) async {
    try {
      final user = await _client.collection('users').getOne(userId);
      final roleValue = user.getStringValue('role');
      final role = UserRole.fromStorage(roleValue);

      // ✅ Validar que sea algún tipo de juez sin distinguir mayúsculas
      return role.isJudge;
    } on Exception {
      return false;
    }
  }

  // ✅ Helper: validar jueces obligatorios con roles específicos
  Future<Either<Failure, bool>> _validateRequiredJudges({
    required String principal,
    required String artistry,
    required String difficulty,
    required String execution,
  }) async {
    final judges = <String, String>{
      'Juez Principal': principal,
      'Juez de Arte': artistry,
      'Juez de Dificultad': difficulty,
      'Juez de Ejecución': execution,
    };

    for (final entry in judges.entries) {
      final userId = entry.value;

      if (userId.isEmpty) {
        return Left(
          ValidationFailure(
            message: '${entry.key} es requerido',
          ),
        );
      }

      // ✅ REUTILIZAR _isValidJudge en lugar de duplicar lógica
      final isValid = await _isValidJudge(userId);
      if (!isValid) {
        return Left(
          ValidationFailure(
            message:
                '${entry.key}: El usuario no tiene rol de juez válido',
          ),
        );
      }
    }

   return const Right<Failure, bool>(true);
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getAll({
    EventStatus? status,
    EventCategory? category,
    DateTime? fromDate,
  }) async {
    try {
      final filters = <String>[];
      if (status != null) {
        filters.add('status = "${status.value}"');
      }
      if (category != null) {
        filters.add('category = "${category.value}"');
      }
      if (fromDate != null) {
        final dateStr =
            fromDate.toIso8601String().split('T').first;
        filters.add('date >= "$dateStr"');
      }

      final filter =
          filters.isEmpty ? null : filters.join(' && ');

      final result = await _client.collection('events').getList(
        filter: filter,
        sort: '\u002Ddate',
        perPage: 100,
      );

      final events = result.items
          .map(
            (record) =>
                EventModel.fromMap(record.toJson()).toEntity(),
          )
          .toList();

      return Right(events);
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message:
              'Error al cargar eventos: ${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getByIdWithRelations(
    String id,
  ) async {
    try {
      const expand =
          'principalJudge,artistryJudge,difficultyJudge,'
          'executionJudge,teams';
      final record = await _client.collection('events').getOne(
        id,
        expand: expand,
      );

      return Right(
        EventModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (error) {
      if (_isNotFound(error)) {
        return const Left(
          ServerFailure(message: 'El evento no existe'),
        );
      }

      return Left(
        ServerFailure(
          message:
              'Error al obtener evento: ${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(
    EventEntity event,
  ) async {
    try {
      debugPrint('🔵 [EVENT REPO] Creando evento');

      final body = EventModel.fromEntity(event).toMap();

      debugPrint('📦 Body completo a enviar');
      body.forEach((key, value) {
        debugPrint('   \u002D $key: $value');
      });

      const requiredFields = <String>[
        'principalJudgeId',
        'artistryJudgeId',
        'difficultyJudgeId',
        'executionJudgeId',
        'teamsIds',
      ];

      for (final field in requiredFields) {
        final value = body[field];
        final isEmpty =
            value == null ||
            (value is String && value.isEmpty) ||
            (value is List<dynamic> && value.isEmpty);

        if (isEmpty) {
          debugPrint(
            '❌ [EVENT REPO] Campo requerido vacío: $field',
          );
          return Left(
            ValidationFailure(
              message: 'El campo $field es requerido',
            ),
          );
        }
      }

      debugPrint('📤 Enviando a PocketBase');
      final record =
          await _client.collection('events').create(body: body);
      debugPrint(
        '✅ [EVENT REPO] Evento creado con ID: ${record.id}',
      );

      return Right(
        EventModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (error, stackTrace) {
      debugPrint('❌ [EVENT REPO] ClientException: $error');
      debugPrint('🔍 Stack trace: $stackTrace');

      return Left(
        ServerFailure(
          message:
              'Error al crear evento: ${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('❌ [EVENT REPO] Excepción inesperada: $error');
      debugPrint('🔍 Stack trace: $stackTrace');
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(
    EventEntity event,
  ) async {
    try {
      final hasJudges =
          event.principalJudgeId.isNotEmpty ||
          event.artistryJudgeId.isNotEmpty ||
          event.difficultyJudgeId.isNotEmpty ||
          event.executionJudgeId.isNotEmpty;

      if (hasJudges) {
        final validation = await _validateRequiredJudges(
          principal: event.principalJudgeId,
          artistry: event.artistryJudgeId,
          difficulty: event.difficultyJudgeId,
          execution: event.executionJudgeId,
        );

        if (validation.isLeft) {
          return Left(validation.left);
        }
      }

      final body = EventModel.fromEntity(event).toMap();
      final record =
          await _client.collection('events').update(
            event.id!,
            body: body,
          );

      return Right(
        EventModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (error) {
      if (_isNotFound(error)) {
        return const Left(
          ServerFailure(message: 'El evento no existe'),
        );
      }

      return Left(
        ServerFailure(
          message:
              'Error al actualizar evento: ${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String id) async {
    try {
      await _client.collection('events').delete(id);
      return const Right<Failure, void>(null);
    } on ClientException catch (error) {
      if (_isNotFound(error)) {
        return const Left(
          ServerFailure(message: 'El evento no existe'),
        );
      }

      return Left(
        ServerFailure(
          message:
              'Error al eliminar evento: ${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getByJudgeId(
    String judgeId,
  ) async {
    try {
      final filter =
          'principalJudge = "$judgeId" || '
          'artistryJudge = "$judgeId" || '
          'difficultyJudge = "$judgeId" || '
          'executionJudge = "$judgeId"';

      final result = await _client.collection('events').getList(
        filter: filter,
        sort: '\u002Ddate',
        perPage: 100,
      );

      final events = result.items
          .map(
            (record) =>
                EventModel.fromMap(record.toJson()).toEntity(),
          )
          .toList();

      return Right(events);
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message:
              'Error al buscar eventos del juez: '
              '${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>>
      getUpcomingWithTeams() async {
    try {
      final today =
          DateTime.now().toIso8601String().split('T').first;
      final filter = 'date >= "$today" && '
          'status != "finalizado"';

      final result = await _client.collection('events').getList(
        filter: filter,
        expand: 'teams',
        sort: 'date',
        perPage: 100,
      );

      final events = result.items
          .map(
            (record) =>
                EventModel.fromMap(record.toJson()).toEntity(),
          )
          .toList();

      return Right(events);
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message:
              'Error al cargar eventos próximos: '
              '${_clientMessage(error)}',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, EventEntity>> assignTeam(
    String eventId,
    String teamId,
  ) async {
    try {
      final current = await getByIdWithRelations(eventId);
      if (current.isLeft) {
        return Left(current.left);
      }

      final updatedTeams =
          List<String>.from(current.right.teamIds)..add(teamId);
      final updated =
          current.right.copyWith(teamIds: updatedTeams);

      return updateEvent(updated);
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error al asignar equipo: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, EventEntity>> removeTeam(
    String eventId,
    String teamId,
  ) async {
    try {
      final current = await getByIdWithRelations(eventId);
      if (current.isLeft) {
        return Left(current.left);
      }

      final updatedTeams =
          List<String>.from(current.right.teamIds)..remove(teamId);

      if (updatedTeams.isEmpty) {
        return const Left(
          ValidationFailure(
            message: 'Un evento debe tener al menos un equipo',
          ),
        );
      }

      final updated =
          current.right.copyWith(teamIds: updatedTeams);

      return updateEvent(updated);
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error al remover equipo: $error'),
      );
    }
  }

  static String _clientMessage(ClientException error) {
    final response = error.response;
    final Object? message = response['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
    return error.toString();
  }

  static bool _isNotFound(ClientException error) {
    final response = error.response;
    final Object? status = response['status'];
    if (status is int) {
      return status == 404;
    }
    if (status is String) {
      return status == '404';
    }
    return false;
  }
}
