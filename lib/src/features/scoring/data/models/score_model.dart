import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';

class ScoreModel {

  const ScoreModel({
    required this.id,
    required this.competitorId,
    required this.eventId,
    required this.category,
    required this.judgeId,
    required this.juryType,
    required this.rawValue,
    required this.deductionsValue,
    required this.finalValue,
    required this.status, required this.timestamp, this.observations,
    this.created,
    this.updated,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'] ?? '',
      competitorId: map['competitorId'] ?? '',
      eventId: map['eventId'] ?? '',
      category: map['category'] ?? '',
      judgeId: map['judgeId'] ?? '',
      juryType: map['juryType'] ?? 'D',
      rawValue: (map['rawValue'] ?? 0).toDouble(),
      deductionsValue: (map['deductionsValue'] ?? 0).toDouble(),
      finalValue: (map['finalValue'] ?? 0).toDouble(),
      observations: map['observations'],
      status: map['status'] ?? 'pending',
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      created: map['created'] != null ? DateTime.parse(map['created']) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
    );
  }

  factory ScoreModel.fromEntity(ScoreEntity entity) {
    return ScoreModel(
      id: entity.id,
      competitorId: entity.competitorId,
      eventId: entity.eventId,
      category: entity.category,
      judgeId: entity.judgeId,
      juryType: entity.juryType.code,
      rawValue: entity.rawValue,
      deductionsValue: entity.deductionsValue,
      finalValue: entity.finalValue,
      observations: entity.observations,
      status: entity.status.label,
      timestamp: entity.timestamp,
    );
  }
  final String id;
  final String competitorId;
  final String eventId;
  final String category;
  final String judgeId;
  final String juryType;
  final double rawValue;
  final double deductionsValue;
  final double finalValue;
  final String? observations;
  final String status;
  final DateTime timestamp;
  final DateTime? created;
  final DateTime? updated;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'competitorId': competitorId,
      'eventId': eventId,
      'category': category,
      'judgeId': judgeId,
      'juryType': juryType,
      'rawValue': rawValue,
      'deductionsValue': deductionsValue,
      'finalValue': finalValue,
      'observations': observations,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      if (created != null) 'created': created!.toIso8601String(),
      if (updated != null) 'updated': updated!.toIso8601String(),
    };
  }

  ScoreEntity toEntity() {
    return ScoreEntity(
      id: id,
      competitorId: competitorId,
      eventId: eventId,
      category: category,
      judgeId: judgeId,
      juryType: JuryType.fromCode(juryType),
      rawValue: rawValue,
      deductionsValue: deductionsValue,
      finalValue: finalValue,
      observations: observations,
      status: ScoreStatus.values.firstWhere(
        (e) => e.label == status,
        orElse: () => ScoreStatus.pending,
      ),
      timestamp: timestamp,
    );
  }
}
