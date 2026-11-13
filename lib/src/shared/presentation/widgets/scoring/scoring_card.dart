import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/core/theme/theme_helpers.dart';
import 'package:flutter/material.dart';

class ScoringCard extends StatelessWidget {

  const ScoringCard({
    required this.competitorName, required this.teamName, required this.currentScore, required this.canScore, required this.isScored, required this.onScoreTap, super.key,
  });
  final String competitorName;
  final String teamName;
  final double? currentScore;
  final bool canScore;
  final bool isScored;
  final VoidCallback onScoreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: canScore ? onScoreTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.fuchsia, AppColors.coral]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    competitorName.isNotEmpty ? competitorName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      competitorName,
                      style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teamName,
                      style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isScored && currentScore != null) ...[
                    Text(
                      currentScore!.toStringAsFixed(2),
                      style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                        color: AppColors.fuchsia,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThemeHelper.getSuccess(context).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Calificado',
                        style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          color: ThemeHelper.getSuccess(context),
                        ),
                      ),
                    ),
                  ] else if (canScore) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.fuchsia, AppColors.coral]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Calificar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Pendiente',
                      style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
