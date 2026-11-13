// lib/src/shared/presentation/widgets/admin/admin_quick_action.dart
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AdminQuickAction extends StatelessWidget {

  const AdminQuickAction({
    required this.label, required this.icon, required this.onTap, required this.gradientColor, required this.gradientColorEnd, super.key,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color gradientColor;
  final Color gradientColorEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientColor, gradientColorEnd.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradientColor.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
