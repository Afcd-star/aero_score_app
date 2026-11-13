import 'package:aero_score_app/src/features/scoring/domain/entities/deduction_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';

class DeductionModel {

  const DeductionModel({
    required this.id,
    required this.scoreId,
    required this.judgeId,
    required this.deductionType,
    required this.value,
    this.description,
    this.created,
    this.updated,
  });

  factory DeductionModel.fromMap(Map<String, dynamic> map) {
    return DeductionModel(
      id: map['id'] ?? '',
      scoreId: map['scoreId'] ?? '',
      judgeId: map['judgeId'] ?? '',
      deductionType: map['deductionType'] ?? 'other',
      value: (map['value'] ?? 0).toDouble(),
      description: map['description'],
      created: map['created'] != null ? DateTime.parse(map['created']) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
    );
  }

  factory DeductionModel.fromEntity(DeductionEntity entity) {
    return DeductionModel(
      id: entity.id,
      scoreId: entity.scoreId,
      judgeId: entity.judgeId,
      deductionType: entity.type.label,
      value: entity.value,
      description: entity.description,
      created: entity.timestamp,
    );
  }
  final String id;
  final String scoreId;
  final String judgeId;
  final String deductionType;
  final double value;
  final String? description;
  final DateTime? created;
  final DateTime? updated;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scoreId': scoreId,
      'judgeId': judgeId,
      'deductionType': deductionType,
      'value': value,
      'description': description,
      if (created != null) 'created': created!.toIso8601String(),
      if (updated != null) 'updated': updated!.toIso8601String(),
    };
  }

  DeductionEntity toEntity() {
    return DeductionEntity(
      id: id,
      scoreId: scoreId,
      judgeId: judgeId,
      type: DeductionType.values.firstWhere(
        (e) => e.label == deductionType,
        orElse: () => DeductionType.other,
      ),
      value: value,
      description: description,
      timestamp: created ?? DateTime.now(),
    );
  }
}
