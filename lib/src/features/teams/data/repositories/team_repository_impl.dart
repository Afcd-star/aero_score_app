// lib/src/features/teams/data/repositories/team_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/core/utils/pocketbase_filter.dart';
import 'package:aero_score_app/src/features/teams/data/models/team_model.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:either_dart/either.dart';
import 'package:pocketbase/pocketbase.dart';

/// Implementacion del repositorio de equipos contra PocketBase.
///
/// La garantia de permiso vive en las reglas de la coleccion del server,
/// no aqui: el cliente no vuelve a comprobar el rol, solo traduce el 403
/// que el server devuelve. Los valores del usuario se escapan antes de
/// interpolarse en el filter.
class TeamRepositoryImpl implements TeamRepository {
  /// Crea la implementacion con el cliente global inyectado.
  TeamRepositoryImpl(this._client);

  final PocketBase _client;

  @override
  Future<Either<Failure, List<TeamEntity>>> getAll({
    String? search,
    String? university,
    String? faculty,
    String? status,
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final filters = <String>[];
      if (search?.isNotEmpty == true) {
        final s = escapeFilterValue(search!.toLowerCase());
        filters.add('(name ~ "$s") || (university ~ "$s") || (email ~ "$s")');
      }
      if (university?.isNotEmpty == true) {
        filters.add('university = "${escapeFilterValue(university!)}"');
      }
      if (faculty?.isNotEmpty == true) {
        filters.add('faculty = "${escapeFilterValue(faculty!)}"');
      }
      if (status?.isNotEmpty == true) {
        filters.add('status = "${escapeFilterValue(status!)}"');
      }
      final filter = filters.isNotEmpty ? filters.join(' && ') : null;

      final result = await _client.collection('teams').getList(
        page: page,
        perPage: perPage,
        filter: filter,
        sort: '-created',
        expand: 'coachId',
      );
      final teams = result.items
          .map((r) => TeamModel.fromMap(r.toJson()).toEntity())
          .toList();
          return Right<Failure, List<TeamEntity>>(teams);
    } on ClientException catch (e) {
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, List<TeamEntity>>(
        ServerFailure(message: errorMessage),
      );
    } on Exception catch (e) {
      return Left<Failure, List<TeamEntity>>(
        ServerFailure(message: 'Error inesperado: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, TeamEntity?>> getById(String id) async {
    try {
      final record = await _client.collection('teams').getOne(
        id,
        expand: 'coachId',
      );
      return Right<Failure, TeamEntity?>(
        TeamModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (e) {
      if ((e.response['status'] as int?) == 404) {
        return const Right<Failure, TeamEntity?>(null);
      }
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, TeamEntity?>(
        ServerFailure(message: errorMessage),
      );
    } on Exception catch (e) {
      return Left<Failure, TeamEntity?>(
        ServerFailure(message: 'Error al obtener equipo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> createTeam(TeamEntity team) async {
    final validationError = team.validate();
    if (validationError != null) {
      return Left<Failure, TeamEntity>(
        ValidationFailure(message: validationError),
      );
    }
    try {
      final body = TeamModel.fromEntity(team).toMap();
      final record =
          await _client.collection('teams').create(body: body);
      return Right<Failure, TeamEntity>(
        TeamModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (e) {
      if ((e.response['status'] as int?) == 403) {
        return const Left<Failure, TeamEntity>(
          ServerFailure(message: 'Permiso denegado para crear equipos'),
        );
      }
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, TeamEntity>(
        ServerFailure(message: 'Error al crear equipo: $errorMessage'),
      );
    } on Exception catch (e) {
      return Left<Failure, TeamEntity>(
        ServerFailure(message: 'Error al crear equipo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> updateTeam(TeamEntity team) async {
    final validationError = team.validate();
    if (validationError != null) {
      return Left<Failure, TeamEntity>(
        ValidationFailure(message: validationError),
      );
    }
    try {
      final body = TeamModel.fromEntity(team).toMap();
      final record = await _client.collection('teams').update(
        team.id,
        body: body,
      );
      return Right<Failure, TeamEntity>(
        TeamModel.fromMap(record.toJson()).toEntity(),
      );
    } on ClientException catch (e) {
      if ((e.response['status'] as int?) == 403) {
        return const Left<Failure, TeamEntity>(
          ServerFailure(message: 'Permiso denegado para actualizar equipos'),
        );
      }
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, TeamEntity>(
        ServerFailure(message: 'Error al actualizar equipo: $errorMessage'),
      );
    } on Exception catch (e) {
      return Left<Failure, TeamEntity>(
        ServerFailure(message: 'Error al actualizar equipo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeam(String id) async {
    try {
      await _client.collection('teams').update(id, body: <String, dynamic>{
        'status': 'inactive',
      });
      return const Right<Failure, void>(null);
    } on ClientException catch (e) {
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, void>(
        ServerFailure(message: 'Error al eliminar equipo: $errorMessage'),
      );
    } on Exception catch (e) {
      return Left<Failure, void>(
        ServerFailure(message: 'Error al eliminar equipo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getByUniversity(
    String university,
  ) async {
    return getAll(university: university);
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getByFaculty(String faculty) async {
    return getAll(faculty: faculty);
  }

  @override
  Future<Either<Failure, Map<String, int>>> getCountBy({
    String? university,
    String? faculty,
  }) async {
    try {
      final filters = <String>[];
      if (university?.isNotEmpty == true) {
        filters.add('university = "${escapeFilterValue(university!)}"');
      }
      if (faculty?.isNotEmpty == true) {
        filters.add('faculty = "${escapeFilterValue(faculty!)}"');
      }
      final filter = filters.isNotEmpty ? filters.join(' && ') : null;

      final result = await _client.collection('teams').getList(
        filter: filter,
        perPage: 500,
        fields: 'id,university,faculty',
      );
      final byUniversity = <String, int>{};
      final byFaculty = <String, int>{};
      for (final r in result.items) {
        final uni = r.getStringValue('university');
        final fac = r.getStringValue('faculty');
        byUniversity[uni] = (byUniversity[uni] ?? 0) + 1;
        if (fac.isNotEmpty) {
          byFaculty[fac] = (byFaculty[fac] ?? 0) + 1;
        }
      }
      return Right<Failure, Map<String, int>>(<String, int>{
        if (university != null) 'university': byUniversity[university] ?? 0,
        if (faculty != null) 'faculty': byFaculty[faculty] ?? 0,
      });
    } on ClientException catch (e) {
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, Map<String, int>>(
        ServerFailure(message: 'Error al contar equipos: $errorMessage'),
      );
    } on Exception catch (e) {
      return Left<Failure, Map<String, int>>(
        ServerFailure(message: 'Error al contar equipos: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> emailExists(String email) async {
    try {
      final result = await _client.collection('teams').getList(
        filter: 'email = "${escapeFilterValue(email)}"',
        perPage: 1,
      );
      return Right<Failure, bool>(result.items.isNotEmpty);
    } on ClientException catch (e) {
      final errorMessage =
          (e.response['message'] as String?) ?? e.toString();
      return Left<Failure, bool>(
        ServerFailure(message: 'Error al verificar email: $errorMessage'),
      );
    } on Exception catch (e) {
      return Left<Failure, bool>(
        ServerFailure(message: 'Error al verificar email: $e'),
      );
    }
  }
}
