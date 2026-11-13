import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';

class CalculateFinalScoreUseCase {
  ResultEntity execute({
    required String competitorId,
    required String eventId,
    required String category,
    required List<ScoreEntity> scores,
  }) {
    final dScores = scores.where((s) => s.juryType == JuryType.difficulty).map((s) => s.rawValue).toList();
    final eScores = scores.where((s) => s.juryType == JuryType.execution).map((s) => s.rawValue).toList();
    final aScores = scores.where((s) => s.juryType == JuryType.artistry).map((s) => s.rawValue).toList();
    
    final totalDeductions = scores.fold<double>(0, (sum, s) => sum + s.deductionsValue);

    final difficultyTotal = dScores.isNotEmpty ? _average(dScores) : 0.0;
    final executionTotal = eScores.isNotEmpty ? _average(eScores) : 0.0;
    final artistryTotal = aScores.isNotEmpty ? _average(aScores) : 0.0;
    
    final finalScore = _figRound(difficultyTotal + executionTotal + artistryTotal - totalDeductions);

    return ResultEntity(
      id: '${competitorId}_${eventId}_${category}_result',
      competitorId: competitorId,
      eventId: eventId,
      category: category,
      difficultyTotal: _figRound(difficultyTotal),
      executionTotal: _figRound(executionTotal),
      artistryTotal: _figRound(artistryTotal),
      deductionsTotal: _figRound(totalDeductions),
      finalScore: finalScore,
      calculatedAt: DateTime.now(),
    );
  }

  static double _figRound(double value) => double.parse(value.toStringAsFixed(3));
  static double _average(List<double> values) => values.reduce((a, b) => a + b) / values.length;
}
