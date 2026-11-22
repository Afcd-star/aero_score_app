// lib/src/shared/presentation/widgets/aero/aero_section_card.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Contenedor de seccion, con superficie, radio y sombra de la casa.
///
/// Pieza generica de superficie: no conoce ningun modulo y solo envuelve
/// un hijo. Su color de superficie sale de un ternario de brillo, que es
/// deuda de descableado registrada y no se toca aqui.
class AeroSectionCard extends StatelessWidget {
  /// Crea el contenedor con su hijo y su geometria opcional.
  const AeroSectionCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16,
  });

  /// Contenido que envuelve la seccion.
  final Widget child;

  /// Relleno interior. Por defecto veinte en todos los lados.
  final EdgeInsetsGeometry? padding;

  /// Radio de las esquinas. Por defecto dieciseis.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
