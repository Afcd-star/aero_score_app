// lib/src/features/teams/data/models/team_model.dart
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';

class TeamModel {

  const TeamModel({
    required this.id,
    required this.name,
    required this.university,
    required this.email, required this.status, required this.competitorIds, this.faculty,
    this.coachId,
    this.coachName,
    this.created,
  });

  /// Mapeo desde PocketBase (Data Source)
  factory TeamModel.fromMap(Map<String, dynamic> map) {
    // Manejo seguro de relaciones expandidas
    String? expandedCoachName;
    if (map['expand'] != null && map['expand']['coachId'] != null) {
      final coach = map['expand']['coachId'];
      expandedCoachName = '${coach['firstName'] ?? ''} ${coach['lastName'] ?? ''}'.trim();
    }

    return TeamModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      university: map['university'] ?? '',
      faculty: map['faculty'],
      coachId: map['coachId'],
      coachName: expandedCoachName,
      email: map['email'] ?? '',
      status: map['status'] ?? 'active',
      competitorIds: map['competitorIds'] != null ? List<String>.from(map['competitorIds']) : [],
      created: map['created'] != null ? DateTime.tryParse(map['created']) : null,
    );
  }

  /// Conversión desde Entidad
  factory TeamModel.fromEntity(TeamEntity entity) {
    return TeamModel(
      id: entity.id,
      name: entity.name,
      university: entity.university,
      faculty: entity.faculty,
      coachId: entity.coachId,
      coachName: entity.coachName,
      email: entity.email,
      status: entity.status,
      competitorIds: entity.competitorIds,
      created: entity.created,
    );
  }
  final String id;
  final String name;
  final String university;
  final String? faculty;
  final String? coachId; // Relación con usuario
  final String? coachName; // Denormalizado para visualización rápida
  final String email;
  final String status;
  final List<String> competitorIds;
  final DateTime? created;

  /// Mapeo hacia PocketBase (para Create/Update)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'university': university,
      'faculty': faculty,
      'coachId': coachId,
      'email': email,
      'status': status,
      'competitorIds': competitorIds,
    };
  }

  /// Conversión a Entidad de Dominio
  TeamEntity toEntity() {
    return TeamEntity(
      id: id,
      name: name,
      university: university,
      faculty: faculty,
      coachId: coachId,
      coachName: coachName,
      email: email,
      status: status,
      competitorIds: competitorIds,
      created: created,
    );
  }
}
