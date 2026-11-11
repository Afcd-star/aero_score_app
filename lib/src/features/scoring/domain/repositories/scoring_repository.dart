// lib/src/features/scoring/domain/repositories/scoring_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';
import 'package:either_dart/either.dart';

abstract class ScoringRepository {
  /// Obtener scores de un competidor (opcionalmente filtrado por juryType)
  Future<Either<Failure, List<ScoreEntity>>> getScores({
    required String competitorId,
    JuryType? juryType,
  });

  /// Crear/actualizar un score individual
  Future<Either<Failure, ScoreEntity>> saveScore({
    required String competitorId,
    required JuryType juryType,
    required double value,
    double? deductions,
    String? observations,
  });

  /// Calcular resultado consolidado para un competidor
  Future<Either<Failure, ResultEntity>> calculateResult(String competitorId);

  /// Eliminar un score (solo si no ha sido finalizado)
  Future<Either<Failure, void>> deleteScore(String scoreId);
}