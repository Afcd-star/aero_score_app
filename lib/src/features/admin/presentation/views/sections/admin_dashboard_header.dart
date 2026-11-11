// lib/src/features/admin/presentation/widgets/admin_dashboard_header.dart

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
// TODOVINCULAR CON EL HOME SECTION
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardHeader extends StatelessWidget {

  const AdminDashboardHeader({
    required this.stats, required this.isSyncing, required this.onRefresh, super.key,
  });
  final AsyncValue<Map<String, int>> stats;
  final bool isSyncing;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Stats cards
          Expanded(
            child: stats.when(
              loading: () => const SizedBox(
                height: 60,
                child: LinearProgressIndicator(),
              ),
              error: (e, _) => Text(
                'Error: $e',
                style: const TextStyle(color: AppColors.destructiveLight),
              ),
              data: (data) => Row(
                children: [
                  _buildStatChip('Equipos', data['totalTeams'] ?? 0, Icons.groups),
                  const SizedBox(width: 16),
                  _buildStatChip('Competidores', data['totalCompetitors'] ?? 0, Icons.person),
                  const SizedBox(width: 16),
                  _buildStatChip('Eventos', data['totalEvents'] ?? 0, Icons.event),
                ],
              ),
            ),
          ),
          
          // Botón refresh
          IconButton(
            icon: Icon(
              isSyncing ? Icons.refresh : Icons.refresh,
              color: AppColors.fuchsia,
            ),
            onPressed: isSyncing ? null : onRefresh,
            tooltip: 'Actualizar datos',
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.fuchsia.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fuchsia.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.fuchsia),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
              color: AppColors.fuchsia,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}