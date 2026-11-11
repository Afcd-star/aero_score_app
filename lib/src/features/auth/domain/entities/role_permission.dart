// lib/src/features/auth/domain/entities/role_permission.dart
/// Capacidad puntual que un rol puede otorgar a un usuario.
///
/// El catálogo de permisos lo define el sistema, no el
/// administrador. El administrador asigna qué permisos tiene un
/// rol, pero no inventa permisos nuevos desde la interfaz. Esta
/// separación es la que permite que renombrar o crear un rol no
/// obligue a tocar la lógica de autorización.
enum RolePermission {
  /// Gestionar el ciclo de vida de usuarios.
  manageUsers,

  /// Asignar o retirar roles a usuarios.
  assignRoles,

  /// Aprobar o rechazar cuentas pendientes.
  approveUsers,

  /// Gestionar eventos de competición.
  manageEvents,

  /// Gestionar equipos.
  manageTeams,

  /// Gestionar competidores.
  manageCompetitors,

  /// Consultar el reglamento.
  viewRules,

  /// Configurar parámetros del sistema.
  configureSystem,

  /// Emitir calificación de expresión artística.
  judgeArtistry,

  /// Emitir calificación de dificultad.
  judgeDifficulty,

  /// Emitir calificación de ejecución.
  judgeExecution,

  /// Validar y consolidar calificaciones.
  judgeMain,

  /// Consultar resultados.
  viewResults,

  /// Consultar el panel de administración.
  viewDashboard,
}
