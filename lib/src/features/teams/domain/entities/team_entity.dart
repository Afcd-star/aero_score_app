// lib/src/features/teams/domain/entities/team_entity.dart
class TeamEntity {

  const TeamEntity({
    required this.id,
    required this.name,
    required this.university,
    required this.email, this.faculty,
    this.coachId,
    this.coachName,
    this.created,
    this.status = 'active',
    this.competitorIds = const [],
  });
  final String id;
  final String name;
  final String university;
  final String? faculty;
  final String? coachId;
  final String? coachName;
  final String email;
  final DateTime? created;
  final String status;
  final List<String> competitorIds;

  // ✅ COPYWITH para actualizaciones inmutables
  TeamEntity copyWith({
    String? id,
    String? name,
    String? university,
    String? faculty,
    String? coachId,
    String? coachName,
    String? email,
    DateTime? created,
    String? status,
    List<String>? competitorIds,
  }) {
    return TeamEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      university: university ?? this.university,
      faculty: faculty ?? this.faculty,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      email: email ?? this.email,
      created: created ?? this.created,
      status: status ?? this.status,
      competitorIds: competitorIds ?? this.competitorIds,
    );
  }

  // ✅ GETTERS para UI
  String get displayName => '$name - $university';
  bool get isActive => status.toLowerCase() == 'active';
  
  // ✅ Label legible para facultad (UCI)
  String get facultyLabel {
    if (faculty == null || faculty!.isEmpty) return 'Sin facultad';
    return switch (faculty!.toUpperCase().trim()) {
      'FIO' => 'FIO - Informática Organizacional',
      'FTL' => 'FTL - Tecnologías Libres',
      'FTI' => 'FTI - Tecnologías Interactivas',
      'FTE' => 'FTE - Tecnologías Educativas',
      _ => faculty!,
    };
  }

  // ✅ VALIDACIÓN de negocio centralizada
  String? validate() {
    if (name.trim().length < 3) return 'El nombre del equipo debe tener al menos 3 caracteres';
    if (university.trim().length < 3) return 'La universidad debe tener al menos 3 caracteres';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Email de contacto inválido';
    }
    if (faculty?.trim().isEmpty ?? true) {
      return 'La facultad es requerida';
    }
    if (coachName?.trim().isEmpty ?? true) {
      return 'El nombre del entrenador es requerido';
    }
    return null;
  }

  // ✅ Equality operators para comparaciones en listas
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamEntity &&
        other.id == id &&
        other.name == name &&
        other.university == university &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(id, name, university, email);
}