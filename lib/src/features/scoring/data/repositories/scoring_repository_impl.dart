// lib/src/features/scoring/data/repositories/scoring_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/scoring/data/models/score_model.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/repositories/scoring_repository.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';
import 'package:either_dart/either.dart';
import 'package:pocketbase/pocketbase.dart';

class ScoringRepositoryImpl implements ScoringRepository {

  ScoringRepositoryImpl(this._client);
  final PocketBase _client;

  @override
  Future<Either<Failure, List<ScoreEntity>>> getScores({
    required String competitorId,
    JuryType? juryType,
  }) async {
    try {
      var filter = 'competitorId = "$competitorId"';
      if (juryType != null) {
        filter += ' && juryType = "${juryType.label}"';
      }

      final result = await _client.collection('scores').getList(
        filter: filter,
        sort: 'created',
        expand: 'competitorId,judgeId',
      );

      final scores = result.items
          .map((record) => ScoreModel.fromMap(record.toJson()).toEntity())
          .toList();

      return Right(scores);
    } on ClientException catch (e) {
      final errorMessage = e.response['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: 'Error al cargar calificaciones: $errorMessage'));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, ScoreEntity>> saveScore({
    required String competitorId,
    required JuryType juryType,
    required double value,
    double? deductions,
    String? observations,
  }) async {
    try {
      final body = {
        'competitorId': competitorId,
        'juryType': juryType.label,
        'value': value,
        'deductions': deductions,
        'observations': observations,
        'judgeId': _client.authStore.record?.id,
        'status': 'submitted',
      };

      final record = await _client.collection('scores').create(body: body);
      final score = ScoreModel.fromMap(record.toJson()).toEntity();
      return Right(score);
    } on ClientException catch (e) {
      final errorMessage = e.response['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: 'Error al guardar calificación: $errorMessage'));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, ResultEntity>> calculateResult(String competitorId) {
    // TODO: Implementar lógica real de cálculo agregando scores por juryType
    // Por ahora, retornar placeholder
    return Future.value(const Right(ResultEntity(
      id: '',
      category: '',
      eventId: '',
      competitorId: '',
      difficultyTotal: 0,
      executionTotal: 0,
      artistryTotal: 0,
      deductionsTotal: 0,
      finalScore: 0,
    )));
  }

  @override
  Future<Either<Failure, void>> deleteScore(String scoreId) async {
    try {
      await _client.collection('scores').delete(scoreId);
      return const Right(null);
    } on ClientException catch (e) {
      if (e.response['status'] == 404) {
        return const Left(ServerFailure(message: 'La calificación no existe'));
      }
      final errorMessage = e.response['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: 'Error al eliminar: $errorMessage'));
    } catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }
}