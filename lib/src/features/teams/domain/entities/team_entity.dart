// lib/src/features/teams/domain/entities/team_entity.dart

/// Entidad de dominio de un equipo.
///
/// Es pura, no importa Flutter. `coachName` es una proyeccion
/// desnormalizada que llega por la expansion de la relacion y puede ser
/// nula, por eso la validacion de negocio exige `coachId`, la relacion
/// real, y nunca `coachName`.
class TeamEntity {
  /// Crea el equipo con sus campos obligatorios y opcionales.
  const TeamEntity({
    required this.id,
    required this.name,
    required this.university,
    required this.email,
    this.faculty,
    this.coachId,
    this.coachName,
    this.created,
    this.updated,
    this.status = 'active',
    this.competitorIds = const <String>[],
  });

  /// Identificador que asigna el backend.
  final String id;

  /// Nombre visible del equipo.
  final String name;

  /// Universidad a la que pertenece.
  final String university;

  /// Facultad, opcional en el esquema pero exigida por la politica del app.
  final String? faculty;

  /// Identificador del entrenador, relacion real con la coleccion users.
  final String? coachId;

  /// Nombre del entrenador, proyeccion desnormalizada de la expansion.
  final String? coachName;

  /// Correo de contacto del equipo.
  final String email;

  /// Marca de creacion que administra el backend.
  final DateTime? created;

  /// Marca de actualizacion que administra el backend.
  final DateTime? updated;

  /// Estado logico, activo o inactivo.
  final String status;

  /// Identificadores de los competidores del roster.
  final List<String> competitorIds;

  /// Copia el equipo sobrescribiendo solo los campos indicados.
  TeamEntity copyWith({
    String? id,
    String? name,
    String? university,
    String? faculty,
    String? coachId,
    String? coachName,
    String? email,
    DateTime? created,
    DateTime? updated,
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
      updated: updated ?? this.updated,
      status: status ?? this.status,
      competitorIds: competitorIds ?? this.competitorIds,
    );
  }

  /// Nombre compuesto para listas y titulos.
  String get displayName => '$name - $university';

  /// Indica si el equipo esta activo.
  bool get isActive => status.toLowerCase() == 'active';

  /// Etiqueta legible de la facultad del catalogo UCI.
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

  /// Validacion de negocio centralizada, unica fuente para el repositorio.
  ///
  /// Exige la relacion de entrenador `coachId`, no la proyeccion
  /// `coachName`, y al menos un competidor, que es la regla que antes
  /// solo vivia en el formulario.
  String? validate() {
    if (name.trim().length < 3) {
      return 'El nombre del equipo debe tener al menos 3 caracteres';
    }
    if (university.trim().length < 3) {
      return 'La universidad debe tener al menos 3 caracteres';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Email de contacto inválido';
    }
    if (faculty?.trim().isEmpty ?? true) {
      return 'La facultad es requerida';
    }
    if (coachId == null || coachId!.trim().isEmpty) {
      return 'El entrenador es requerido';
    }
    if (competitorIds.isEmpty) {
      return 'El equipo debe tener al menos un competidor';
    }
    return null;
  }

  static bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamEntity &&
        other.id == id &&
        other.name == name &&
        other.university == university &&
        other.faculty == faculty &&
        other.coachId == coachId &&
        other.status == status &&
        _sameList(other.competitorIds, competitorIds);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        university,
        faculty,
        coachId,
        status,
        Object.hashAll(competitorIds),
      );
}
