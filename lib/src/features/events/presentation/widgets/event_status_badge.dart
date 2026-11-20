// lib/src/features/events/presentation/widgets/event_status_badge.dart
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart'; // ✅ Para EventStatus enum
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_badge.dart';
import 'package:flutter/material.dart';

/// ✅ Badge especializado para estados de evento
/// Acepta EventStatus enum para type-safety y labels en español
class EventStatusBadge extends StatelessWidget {
  const EventStatusBadge({
    required this.status,
    super.key,
    this.size = BadgeSize.medium,
    this.showIcon = true,
  });
  final EventStatus status; // ✅ Enum en lugar de String
  final BadgeSize size;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final config = _getEventStatusConfig(status);

    // ✅ CORREGIDO: Usar parámetros reales de AeroBadge
    return AeroBadge(
      label: config.label,
      variant: config.variant,
      size: size, // ✅ El fontSize se deriva del size
      showIcon: showIcon,
      icon: showIcon ? config.icon : null,
    );
  }

  /// ✅ Mapeo enum → config visual (labels en español per Idioma de la App.md)
  static ({String label, BadgeVariant variant, IconData? icon})
  _getEventStatusConfig(EventStatus status) {
    return switch (status) {
      EventStatus.planned => (
        label: 'Próximo',
        variant: BadgeVariant.info,
        icon: Icons.calendar_today_outlined,
      ),
      EventStatus.ongoing => (
        label: 'En curso',
        variant: BadgeVariant.success,
        icon: Icons.play_circle_outline,
      ),
      EventStatus.completed => (
        label: 'Finalizado',
        variant: BadgeVariant.secondary,
        icon: Icons.check_circle_outline,
      ),
    };
  }

  /// ✅ Helper estático para obtener label en español
  static String getLabel(EventStatus status) {
    return _getEventStatusConfig(status).label;
  }
}
