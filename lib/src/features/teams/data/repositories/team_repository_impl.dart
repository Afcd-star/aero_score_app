// lib/src/features/admin/data/repositories/team_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/teams/data/models/team_model.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class TeamRepositoryImpl implements TeamRepository {

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
        final s = search!.toLowerCase();
        filters.add('(name ~ "$s") || (university ~ "$s") || (email ~ "$s")');
      }
      if (university?.isNotEmpty == true) {
        filters.add('university = "$university"');
      }
      if (faculty?.isNotEmpty == true) {
        filters.add('faculty = "$faculty"');
      }
      if (status?.isNotEmpty == true) {
        filters.add('status = "$status"');
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

      return Right(teams);
      
    } on ClientException catch (e) {
      final errorMessage = e.response['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity?>> getById(String id) async {
    try {
      final record = await _client.collection('teams').getOne(
        id,
        expand: 'coachId',
      );
      return Right(TeamModel.fromMap(record.toJson()).toEntity());
    } on ClientException catch (e) {
      final errorMessage = e.response['message'] as String? ?? e.toString();
      if (e.response['status'] == 404) return const Right(null);
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener equipo: $e'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> createTeam(TeamEntity team) async {
    try {
      // ✅ VERIFICAR autenticación antes de crear
      final pb = _client; // tu instancia de PocketBase

      if (!pb.authStore.isValid) {
        return const Left(ValidationFailure(message: 'No hay sesión activa. Inicia sesión primero.'));
      }

      final currentUser = pb.authStore.record;
      final userRole = currentUser?.getStringValue('role') ?? '';

      debugPrint('🔐 [CreateTeam] Usuario actual: ${currentUser?.id}');
      debugPrint('🔐 [CreateTeam] Rol: $userRole');

      if (userRole != 'Admin') {
        return const Left(ValidationFailure(
          message: 'Permiso denegado. Solo los administradores pueden crear equipos.',
        ));
      }

      // ✅ Si todo está bien, proceder con la creación
      final body = TeamModel.fromEntity(team).toMap();
      final record = await pb.collection('teams').create(body: body);

      return Right(TeamModel.fromMap(record.toJson()).toEntity());

    } catch (e) {
      return Left(ServerFailure(message: 'Error al crear equipo: $e'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> updateTeam(TeamEntity team) async {
    try {
      final validationError = _validate(team);
      if (validationError != null) {
        return Left(ValidationFailure(message: validationError));
      }

      final body = TeamModel.fromEntity(team).toMap();
      final record = await _client.collection('teams').update(
        team.id,
        body: body,
      );
      
      return Right(TeamModel.fromMap(record.toJson()).toEntity());
      
    } on ClientException catch (e) {
      final errorMessage = e.response['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: 'Error al actualizar equipo: $errorMessage'));
    } catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar equipo: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeam(String id) async {
    try {
      // Soft delete: cambiar status a 'inactive'
      await _client.collection('teams').update(id, body: {
        'status': 'inactive',
      });
      return const Right(null);
    } on ClientException catch (e) {
      final errorMessage = e.response['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: 'Error al eliminar equipo: $errorMessage'));
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar equipo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getByUniversity(String university) async {
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
      if (university?.isNotEmpty == true) filters.add('university = "$university"');
      if (faculty?.isNotEmpty == true) filters.add('faculty = "$faculty"');
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

      return Right({
        if (university != null) 'university': byUniversity[university] ?? 0,
        if (faculty != null) 'faculty': byFaculty[faculty] ?? 0,
      });
      
    } catch (e) {
      return Left(ServerFailure(message: 'Error al contar equipos: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> emailExists(String email) async {
    try {
      final result = await _client.collection('teams').getList(
        filter: 'email = "$email"',
        perPage: 1,
      );
      return Right(result.items.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al verificar email: $e'));
    }
  }

  /// Validación de negocio
  String? _validate(TeamEntity team) {
    if (team.name.trim().length < 3) return 'El nombre del equipo debe tener al menos 3 caracteres';
    if (team.university.trim().length < 3) return 'La universidad debe tener al menos 3 caracteres';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(team.email)) {
      return 'Email de contacto inválido';
    }
    if (team.faculty?.trim().isEmpty ?? false) {
      return 'La facultad es requerida';
    }
    return null;
  }
}