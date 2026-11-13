// lib/src/shared/presentation/widgets/aero/aero_background.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Fondo decorativo con efectos de glow para pantallas de auth y dashboard.
/// ✅ Widget puro: sin lógica de estado, sin dependencias de tema.
class AeroBackground extends StatelessWidget {

  const AeroBackground({
    required this.child, super.key,
    this.isDashboard = false,
  });
  final Widget child;
  final bool isDashboard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.backgroundBase),
        ..._buildGlowCircles(context),
        child,
      ],
    );
  }

  List<Widget> _buildGlowCircles(BuildContext context) {
    final circles = <Widget>[];
    final opacity = isDashboard ? 0.2 : 0.3;

    circles..add(
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
            opacity: 0.2,
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
