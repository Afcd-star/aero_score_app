// lib/src/features/teams/domain/repositories/team_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:either_dart/either.dart';

/// Contrato de acceso a datos de la funcionalidad de equipos.
///
/// Define las operaciones de consulta, creación, actualización,
/// borrado lógico y agregación que la capa de datos implementa contra
/// PocketBase, devolviendo siempre un resultado tipado con Either.
abstract class TeamRepository {
  /// Obtener todos los equipos con filtros opcionales
  Future<Either<Failure, List<TeamEntity>>> getAll({
    String? search,
    String? university,
    String? faculty,
    String? status,
    int page = 1,
    int perPage = 50,
  });

  /// Obtener equipo por ID
  Future<Either<Failure, TeamEntity?>> getById(String id);

  /// Crear nuevo equipo
  Future<Either<Failure, TeamEntity>> createTeam(TeamEntity team);

  /// Actualizar equipo existente
  Future<Either<Failure, TeamEntity>> updateTeam(TeamEntity team);

  /// Eliminar equipo (soft delete)
  Future<Either<Failure, void>> deleteTeam(String id);

  /// Buscar equipos por universidad
  Future<Either<Failure, List<TeamEntity>>> getByUniversity(String university);

  /// Buscar equipos por facultad
  Future<Either<Failure, List<TeamEntity>>> getByFaculty(String faculty);

  /// Contar equipos por facultad/universidad
  Future<Either<Failure, Map<String, int>>> getCountBy({
    String? university,
    String? faculty,
  });

  /// Verificar si existe un email de contacto
  Future<Either<Failure, bool>> emailExists(String email);
}
