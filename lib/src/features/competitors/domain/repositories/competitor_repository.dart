// lib/src/features/admin/domain/repositories/competitor_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';
import 'package:either_dart/either.dart';

abstract class CompetitorRepository {
  /// Listar competidores con filtros
  Future<Either<Failure, List<CompetitorEntity>>> getAll({
    String? search,
    String? teamId,
    CompetitorCategory? category,
    CompetitorStatus? status,
    int page,
    int perPage,
  });

  /// Obtener por ID con datos del equipo (expand)
  Future<Either<Failure, CompetitorEntity?>> getById(String id);

  /// Crear nuevo competidor (valida CI único)
  Future<Either<Failure, CompetitorEntity>> createCompetitor(CompetitorEntity competitor);

  /// Actualizar existente
  Future<Either<Failure, CompetitorEntity>> updateCompetitor(CompetitorEntity competitor);

  /// Soft delete (cambiar status a suspended)
  Future<Either<Failure, void>> deleteCompetitor(String id);

  /// Buscar por CI (único)
  Future<Either<Failure, CompetitorEntity?>> getByCI(String ci);

  /// Contar por categoría/equipo
  Future<Either<Failure, Map<String, int>>> getCountBy({
    String? teamId,
    CompetitorCategory? category,
  });
}