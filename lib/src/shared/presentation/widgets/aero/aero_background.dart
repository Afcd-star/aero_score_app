// lib/src/shared/presentation/widgets/aero/aero_background.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Fondo decorativo con circulos de brillo para autenticacion y panel.
///
/// La base sigue el brillo del tema, oscura en oscuro y muy clara en
/// claro, y los circulos se atenuan en claro para no competir con el
/// contenido. Lo que vive encima, texto del logo y barra de estado,
/// sigue tambien el brillo, segun la regla de acoplamiento.
class AeroBackground extends StatelessWidget {
  /// Crea el fondo con su contenido y su variante de panel.
  const AeroBackground({
    required this.child,
    super.key,
    this.isDashboard = false,
  });

  /// Contenido que se pinta sobre el fondo.
  final Widget child;

  /// Si es verdadero, usa la variante de panel, con menos brillo.
  final bool isDashboard;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          color: isDark ? AppColors.backgroundBase : AppColors.surfaceBase,
        ),
        ..._buildGlowCircles(context, isDark),
        child,
      ],
    );
  }

  List<Widget> _buildGlowCircles(BuildContext context, bool isDark) {
    final circles = <Widget>[];
    final opacity = isDashboard ? (isDark ? 0.2 : 0.10) : (isDark ? 0.3 : 0.14);

    circles
      ..add(
        Positioned(
          top: -128,
          left: -128,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 256,
              height: 256,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.glowFuchsia, AppColors.glowViolet],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      )
      ..add(
        Positioned(
          bottom: -192,
          right: -192,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 384,
              height: 384,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.glowFuchsia, AppColors.glowViolet],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      );

    if (!isDashboard) {
      circles.add(
        Positioned(
          right: 0,
          top: MediaQuery.of(context).size.height * 0.25,
          child: Opacity(
            opacity: isDark ? 0.2 : 0.10,
            child: Container(
              width: 192,
              height: 192,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.glowViolet,
              ),
            ),
          ),
        ),
      );
    }

    return circles;
  }
}
