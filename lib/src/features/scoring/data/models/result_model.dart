import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';

class ResultModel {

  const ResultModel({
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
    this.created,
    this.updated,
  });

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      id: map['id'] ?? '',
      competitorId: map['competitorId'] ?? '',
      eventId: map['eventId'] ?? '',
      category: map['category'] ?? '',
      difficultyTotal: (map['difficultyTotal'] ?? 0).toDouble(),
      executionTotal: (map['executionTotal'] ?? 0).toDouble(),
      artistryTotal: (map['artistryTotal'] ?? 0).toDouble(),
      deductionsTotal: (map['deductionsTotal'] ?? 0).toDouble(),
      finalScore: (map['finalScore'] ?? 0).toDouble(),
      calculatedAt: map['calculatedAt'] != null 
          ? DateTime.parse(map['calculatedAt']) 
          : null,
      created: map['created'] != null ? DateTime.parse(map['created']) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
    );
  }

  factory ResultModel.fromEntity(ResultEntity entity) {
    return ResultModel(
      id: entity.id,
      competitorId: entity.competitorId,
      eventId: entity.eventId,
      category: entity.category,
      difficultyTotal: entity.difficultyTotal,
      executionTotal: entity.executionTotal,
      artistryTotal: entity.artistryTotal,
      deductionsTotal: entity.deductionsTotal,
      finalScore: entity.finalScore,
      calculatedAt: entity.calculatedAt,
    );
  }
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
  final DateTime? created;
  final DateTime? updated;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'competitorId': competitorId,
      'eventId': eventId,
      'category': category,
      'difficultyTotal': difficultyTotal,
      'executionTotal': executionTotal,
      'artistryTotal': artistryTotal,
      'deductionsTotal': deductionsTotal,
      'finalScore': finalScore,
      if (calculatedAt != null) 'calculatedAt': calculatedAt!.toIso8601String(),
      if (created != null) 'created': created!.toIso8601String(),
      if (updated != null) 'updated': updated!.toIso8601String(),
    };
  }

  ResultEntity toEntity() {
    return ResultEntity(
      id: id,
      competitorId: competitorId,
      eventId: eventId,
      category: category,
      difficultyTotal: difficultyTotal,
      executionTotal: executionTotal,
      artistryTotal: artistryTotal,
      deductionsTotal: deductionsTotal,
      finalScore: finalScore,
      calculatedAt: calculatedAt,
    );
  }
}
