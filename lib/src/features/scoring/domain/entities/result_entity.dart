/// Resultado consolidado de una participación específica.
class ResultEntity {

  const ResultEntity({
    required this.id,
    required this.competitorId,
    required this.eventId,
    required this.category,
    required this.difficultyTotal,
    required this.executionTotal,
    required this.artistryTotal,
    required this.deductionsTotal,
    required this.finalScore,
    this.calculatedAt,
  });
  final String id;
  final String competitorId;
  final String eventId;
  final String category;
  final double difficultyTotal;
  final double executionTotal;
  final double artistryTotal;
  final double deductionsTotal;
  final double finalScore;
  final DateTime? calculatedAt;

  bool get isMathematicallyConsistent {
    const tolerance = 0.001;
    final expected = difficultyTotal + executionTotal + artistryTotal - deductionsTotal;
    return (finalScore - expected).abs() < tolerance;
  }
}
