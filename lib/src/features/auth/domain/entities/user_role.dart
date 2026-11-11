// lib/src/features/auth/domain/entities/user_role.dart
/// Identidad canónica de un usuario en el sistema.
///
/// Los valores de este catálogo los fija la federación y son
/// estables. Lo dinámico, es decir el permiso y el nombre visible,
/// vive en la entidad de configuración de rol, no aquí. El valor
/// `unknown` representa un rol recibido del backend que no está
/// catalogado; sustituye la caída silenciosa a `viewer` que
/// convertía jueces y capitanes en espectadores sin aviso.
enum UserRole {
  /// Administrador del sistema.
  admin('Admin'),

  /// Juez de expresión artística.
  judgeA('JudgeA'),

  /// Juez de dificultad.
  judgeD('JudgeD'),

  /// Juez de ejecución.
  judgeE('JudgeE'),

  /// Juez principal, supervisa y valida calificaciones.
  judgeP('JudgeP'),

  /// Organizador de eventos y competencias.
  organizer('Organizer'),

  /// Entrenador de equipos y competidores.
  coach('Coach'),

  /// Espectador con acceso de solo lectura.
  viewer('Viewer'),

  /// Rol no reconocido en el catálogo.
  unknown('Unknown');

  /// Crea el rol con su valor de almacenamiento.
  const UserRole(this.value);

  /// Valor de almacenamiento coincidente con el backend.
  final String value;

  /// Convierte el valor de almacenamiento en un rol.
  ///
  /// Devuelve `unknown` cuando el valor no pertenece al catálogo,
  /// en lugar de asumir `viewer`. Un rol desconocido es un error
  /// de datos que debe ser visible, no tragado.
  static UserRole fromStorage(String role) {
    for (final candidate in UserRole.values) {
      if (candidate.value == role) {
        return candidate;
      }
    }
    return UserRole.unknown;
  }

  /// Etiqueta legible para la interfaz en español.
  String get label => switch (this) {
    UserRole.admin => 'Administrador',
    UserRole.judgeA => 'Juez de Arte',
    UserRole.judgeD => 'Juez de Dificultad',
    UserRole.judgeE => 'Juez de Ejecución',
    UserRole.judgeP => 'Juez Principal',
    UserRole.organizer => 'Organizador',
    UserRole.coach => 'Entrenador',
    UserRole.viewer => 'Espectador',
    UserRole.unknown => 'Rol desconocido',
  };

  /// Descripción breve para ayuda contextual en español.
  String get description => switch (this) {
    UserRole.admin => 'Acceso total al sistema',
    UserRole.judgeA => 'Evalúa la expresión artística',
    UserRole.judgeD => 'Evalúa la complejidad técnica',
    UserRole.judgeE => 'Evalúa la ejecución técnica',
    UserRole.judgeP => 'Supervisa y valida calificaciones',
    UserRole.organizer => 'Gestiona eventos y competencias',
    UserRole.coach => 'Gestiona equipos y competidores',
    UserRole.viewer => 'Solo puede ver resultados',
    UserRole.unknown => 'Rol no reconocido en el catálogo',
  };

  /// Indica si el rol corresponde a alguna variante de juez.
  bool get isJudge =>
      this == UserRole.judgeP ||
      this == UserRole.judgeA ||
      this == UserRole.judgeD ||
      this == UserRole.judgeE;

  /// Indica si el rol fue reconocido en el catálogo.
  bool get isKnown => this != UserRole.unknown;
}
