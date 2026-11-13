// lib/src/features/admin/presentation/admin_section_ui.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/features/admin/domain/admin_section.dart';
import 'package:flutter/material.dart';

/// Proyecciones visuales de las secciones del panel.
///
/// Vive en presentacion porque IconData y Color son tipos de Flutter.
/// Se conservan dos familias de iconos para no alterar el aspecto
/// actual: linea solida en el menu lateral y redondeada en la barra
/// inferior.
extension AdminSectionUi on AdminSection {
  /// Icono de linea solida para el menu lateral.
  IconData get iconOutlined => switch (this) {
    AdminSection.home => Icons.home,
    AdminSection.teams => Icons.people,
    AdminSection.events => Icons.event,
    AdminSection.competitors => Icons.person,
    AdminSection.rules => Icons.description,
    AdminSection.settings => Icons.settings,
  };

  /// Icono redondeado para la barra inferior.
  IconData get iconRounded => switch (this) {
    AdminSection.home => Icons.home_rounded,
    AdminSection.teams => Icons.groups_rounded,
    AdminSection.events => Icons.event_rounded,
    AdminSection.competitors => Icons.person_rounded,
    AdminSection.rules => Icons.description_rounded,
    AdminSection.settings => Icons.settings_rounded,
  };

  /// Color de acento de la seccion en el menu lateral.
  Color get accentColor => switch (this) {
    AdminSection.home => AppColors.fuchsia,
    AdminSection.teams => Colors.blue,
    AdminSection.events => Colors.green,
    AdminSection.competitors => Colors.pink,
    AdminSection.rules => Colors.orange,
    AdminSection.settings => Colors.grey,
  };
}
