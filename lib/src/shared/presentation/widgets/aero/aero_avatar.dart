// lib/src/shared/presentation/widgets/aero/aero_avatar.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// ✅ Avatar circular con gradiente fucsia-coral (siguiendo EventForm.tsx)
/// Muestra inicial del nombre si no hay imagen
class AeroAvatar extends StatelessWidget {

  const AeroAvatar({
    required this.fallbackText, super.key,
    this.imageUrl,
    this.radius = 20,
    this.onTap,
  });
  final String? imageUrl;
  final String fallbackText;
  final double radius;
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