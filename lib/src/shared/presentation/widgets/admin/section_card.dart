// lib/src/shared/presentation/widgets/admin/section_card.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {

  const SectionCard({
    required this.child, super.key,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
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