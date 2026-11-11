import 'package:aero_score_app/src/features/scoring/domain/types.dart';

/// Penalización específica aplicada a una calificación.
class DeductionEntity {

  const DeductionEntity({
    required this.id,
    required this.scoreId,
    required this.judgeId,
    required this.type,
    required this.value,
    required this.timestamp, this.description,
  });
  final String id;
  final String scoreId;
  final String judgeId;
  final DeductionType type;
  final double value;
  final String? description;
  final DateTime timestamp;

  bool get isValid => value > 0.0;
  String get typeLabel => type.label;
}