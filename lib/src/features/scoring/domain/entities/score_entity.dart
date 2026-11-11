import 'package:aero_score_app/src/features/scoring/domain/types.dart';

/// Representa la calificación emitida por UN juez para UNA participación específica.
class ScoreEntity {

  const ScoreEntity({
    required this.id,
    required this.competitorId,
    required this.eventId,
    required this.category,
    required this.judgeId,
    required this.juryType,
    required this.rawValue,
    required this.deductionsValue,
    required this.finalValue,
    required this.timestamp, this.observations,
    this.status = ScoreStatus.pending,
  });
  final String id;
  final String competitorId;
  final String eventId;
  final String category;
  final String judgeId;
  final JuryType juryType;
  final double rawValue;
  final double deductionsValue;
  final double finalValue;
  final String? observations;
  final ScoreStatus status;
  final DateTime timestamp;

  bool get isWithinRange => finalValue >= 0.0 && finalValue <= 10.0;
  bool get isSubmitted => status != ScoreStatus.pending;
}