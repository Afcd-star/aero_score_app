// lib/src/shared/presentation/widgets/admin/admin_stats_card.dart
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AdminStatsCard extends StatelessWidget {

  const AdminStatsCard({
    required this.label, required this.value, required this.icon, required this.accentColor, super.key,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ✅ GRADIENTE 100% OPACO: Sin transparencia
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor, // Color base sólido
            _getDarkerShade(accentColor), // Variante más oscura, NO transparente
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        // ✅ BORDE SÓLIDO con más opacidad
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.4), // Sombra más intensa
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95), // Más opaco
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  letterSpacing: -0.5, // Mejor legibilidad
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25), // Más opaco
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }

  // ✅ Helper: Crea variante más oscura SIN transparencia
  Color _getDarkerShade(Color color) {
    return Color.lerp(color, Colors.black, 0.15)!;
  }
}
