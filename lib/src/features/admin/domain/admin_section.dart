// lib/src/features/admin/domain/admin_section.dart

/// Secciones disponibles en el panel de administracion.
///
/// Dominio puro: no importa Flutter. Las etiquetas son cadenas de
/// negocio en espanol; los iconos viven en la extension de
/// presentacion porque IconData si es un tipo de Flutter.
enum AdminSection {
  /// Resumen de metricas y actividad.
  home,

  /// Gestion de equipos.
  teams,

  /// Gestion de eventos.
  events,

  /// Gestion de competidores.
  competitors,

  /// Consulta del reglamento.
  rules,

  /// Configuracion del panel.
  settings,
}

/// Proyecciones de texto y ruta de las secciones del panel.
extension AdminSectionX on AdminSection {
  /// Segmento de ruta usado por el enrutador.
  String get pathName => name;

  /// Etiqueta visible en espanol.
  String get label => switch (this) {
    AdminSection.home => 'Inicio',
    AdminSection.teams => 'Equipos',
    AdminSection.events => 'Eventos',
    AdminSection.competitors => 'Competidores',
    AdminSection.rules => 'Reglamento',
    AdminSection.settings => 'Configuración',
  };
}
