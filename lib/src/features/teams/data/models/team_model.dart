// lib/src/features/teams/data/models/team_model.dart
import 'package:aero_score_app/src/features/teams/domain/entities/'
    'team_entity.dart';

/// Modelo de datos de un equipo, puente entre PocketBase y la entidad.
///
/// Mapea contra el esquema vivo de la coleccion, no contra migraciones
/// antiguas. `coachName` no es columna del backend, se deriva de la
/// expansion de `coachId`, por eso solo se lee y nunca se envia.
class TeamModel {
  /// Crea el modelo con sus campos.
  const TeamModel({
    required this.id,
    required this.name,
    required this.university,
    required this.email,
    required this.status,
    required this.competitorIds,
    this.faculty,
    this.coachId,
    this.coachName,
    this.created,
    this.updated,
  });

  /// Mapeo desde PocketBase, con lectura segura de la expansion.
  factory TeamModel.fromMap(Map<String, dynamic> map) {
    String? expandedCoachName;
    final Object? expandRaw = map['expand'];
    if (expandRaw is Map<String, dynamic>) {
      final Object? coachRaw = expandRaw['coachId'];
      if (coachRaw is Map<String, dynamic>) {
        final first = (coachRaw['firstName'] as String?) ?? '';
        final last = (coachRaw['lastName'] as String?) ?? '';
        expandedCoachName = '$first $last'.trim();
      }
    }
    final Object? createdRaw = map['created'];
    final createdStr = createdRaw is String ? createdRaw : null;
    final Object? updatedRaw = map['updated'];
    final updatedStr = updatedRaw is String ? updatedRaw : null;
    final Object? competitorRaw = map['competitorIds'];

    return TeamModel(
      id: (map['id'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      university: (map['university'] as String?) ?? '',
      faculty: map['faculty'] as String?,
      coachId: map['coachId'] as String?,
      coachName: expandedCoachName,
      email: (map['email'] as String?) ?? '',
      status: (map['status'] as String?) ?? 'active',
      competitorIds:
          competitorRaw is List ? List<String>.from(competitorRaw) : const <String>[],
      created: createdStr != null ? DateTime.tryParse(createdStr) : null,
      updated: updatedStr != null ? DateTime.tryParse(updatedStr) : null,
    );
  }

  /// Conversion desde la entidad de dominio.
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
      updated: entity.updated,
    );
  }

  /// Identificador que asigna el backend.
  final String id;

  /// Nombre visible del equipo.
  final String name;

  /// Universidad a la que pertenece.
  final String university;

  /// Facultad opcional.
  final String? faculty;

  /// Relacion real con el entrenador.
  final String? coachId;

  /// Proyeccion desnormalizada del nombre del entrenador.
  final String? coachName;

  /// Correo de contacto.
  final String email;

  /// Estado logico.
  final String status;

  /// Identificadores del roster.
  final List<String> competitorIds;

  /// Marca de creacion autogenerada por el backend.
  final DateTime? created;

  /// Marca de actualizacion autogenerada por el backend.
  final DateTime? updated;

  /// Mapeo hacia PocketBase para crear y actualizar.
  ///
  /// Omite `id`, `created`, `updated` y `coachName`: las tres primeras las
  /// administra el backend y la ultima no es columna, es proyeccion.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'university': university,
      'faculty': faculty,
      'coachId': coachId,
      'email': email,
      'status': status,
      'competitorIds': competitorIds,
    };
  }

  /// Conversion a la entidad de dominio.
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
      updated: updated,
    );
  }
}
