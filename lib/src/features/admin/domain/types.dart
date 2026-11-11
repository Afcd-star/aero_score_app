// lib/src/features/admin/domain/types.dart
import 'package:flutter/material.dart';

/// Tipos compartidos para la feature Admin
/// ✅ Single Source of Truth para enums y tipos de dominio

/// Secciones disponibles en el dashboard de administración
enum AdminSection {
  home,
  teams,
  events,
  competitors,
  rules,
  settings,  // ✅ Configuración (NO 'roles')
}

/// Extensiones útiles para AdminSection
extension AdminSectionX on AdminSection {
  String get pathName => name; // Para GoRouter: '/admin/${section.pathName}'
  
  String get label => switch (this) {
    AdminSection.home => 'Inicio',
    AdminSection.teams => 'Equipos',
    AdminSection.events => 'Eventos',
    AdminSection.competitors => 'Competidores',
    AdminSection.rules => 'Reglamento',
    AdminSection.settings => 'Configuración',
  };
  
  IconData get icon => switch (this) {
    AdminSection.home => Icons.home_rounded,
    AdminSection.teams => Icons.people_rounded,
    AdminSection.events => Icons.event_rounded,
    AdminSection.competitors => Icons.person_rounded,
    AdminSection.rules => Icons.description_rounded,
    AdminSection.settings => Icons.settings_rounded,
  };
}
