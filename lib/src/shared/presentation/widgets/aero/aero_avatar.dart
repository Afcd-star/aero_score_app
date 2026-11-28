// lib/src/shared/presentation/widgets/aero/aero_avatar.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Avatar circular con la inicial del nombre sobre el degradado de marca.
///
/// No tiene soporte de imagen: la inicial es lo unico que pinta. El
/// parametro de imagen queda reservado y sin efecto.
class AeroAvatar extends StatelessWidget {
  /// Crea el avatar con el texto del que toma la inicial.
  const AeroAvatar({
    required this.fallbackText,
    super.key,
    this.radius = 20,
    this.onTap,
  });

  /// Texto del que se toma la inicial. Vacio pinta un icono de persona.
  final String fallbackText;

  /// Radio del circulo. Por defecto veinte.
  final double radius;

  /// Accion al tocar el avatar.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.fuchsia, AppColors.coral],
          ),
        ),
        child: Center(
          child: fallbackText.isNotEmpty
              ? Text(
                  fallbackText[0].toUpperCase(),
                  style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: radius * 0.6,
                  ),
                )
              : const Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
    );

    return widget;
  }
}
