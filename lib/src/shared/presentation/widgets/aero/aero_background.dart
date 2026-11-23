// lib/src/shared/presentation/widgets/aero/aero_background.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Fondo decorativo de nivel trabajo, con lavados radiales de brillo.
///
/// La base es oscura fija en ambos modos por decision de marca: el modo
/// claro aclara tarjetas, campos y controles, nunca el casco. Los lavados
/// son degradados radiales que se desvanecen a transparente, sin bordes
/// duros ni raster que ampliar.
///
/// Regla de acoplamiento: como este fondo no sigue el brillo, todo lo
/// que se pinta encima, texto y barra de estado, usa color claro fijo y
/// no color de tema.
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
    return Stack(
      children: [
        Container(color: AppColors.backgroundBase),
        ..._buildGlowWashes(context),
        child,
      ],
    );
  }

  /// Lavados radiales que se desvanecen a transparente.
  ///
  /// Un degradado radial de color a transparente da el mismo aspecto de
  /// brillo difuso que un circulo desenfocado, sin imagen ni filtro, y
  /// por tanto sin costo de raster ni bordes duros.
  List<Widget> _buildGlowWashes(BuildContext context) {
    final strength = isDashboard ? 0.2 : 0.3;

    return [
      Positioned(
        top: -160,
        left: -160,
        child: _wash(
          size: 480,
          strength: strength,
          inner: AppColors.glowViolet,
        ),
      ),
      Positioned(
        bottom: -220,
        right: -220,
        child: _wash(
          size: 640,
          strength: strength,
          inner: AppColors.glowFuchsia,
        ),
      ),
      if (!isDashboard)
        Positioned(
          right: -140,
          top: MediaQuery.of(context).size.height * 0.30,
          child: _wash(
            size: 420,
            strength: strength * 0.7,
            inner: AppColors.glowViolet,
          ),
        ),
    ];
  }

  /// Un lavado circular que va del color al transparente.
  Widget _wash({
    required double size,
    required double strength,
    required Color inner,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            inner.withValues(alpha: strength),
            inner.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
