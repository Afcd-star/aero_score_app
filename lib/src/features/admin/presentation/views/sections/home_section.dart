// lib/src/features/admin/presentation/views/sections/home_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/admin/data/di/admin_providers.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/admin_quick_action.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/admin_stats_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeSection extends ConsumerWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    const headerTextPrimary = AppColors.textPrimary;
    final headerTextSecondary = AppColors.textPrimary.withValues(alpha: 0.7);
    
    final cardTextPrimary = theme.colorScheme.onSurface;
    final cardTextSecondary = theme.colorScheme.onSurfaceVariant;
    final cardBg = theme.colorScheme.surfaceContainer;
    final borderColor = theme.colorScheme.outline;
    
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    final activityAsync = ref.watch(recentActivityProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Bienvenido, Administrador!',
            style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
              color: headerTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Resumen del sistema AeroScore',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: headerTextSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // ✅ Stats en orden: Usuarios activos, Competidores, Equipos, Próximos eventos
          statsAsync.when(
            loading: () => _buildStatsSkeleton(cardBg, borderColor),
            error: (err, _) => _buildStatsError(err.toString(), theme.colorScheme.error),
            data: (stats) => _buildStatsGrid(context, stats),
          ),
          const SizedBox(height: 24),

          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Acciones Rápidas',
                  style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                    color: cardTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AdminQuickAction(
                        label: 'Nuevo Equipo',
                        icon: Icons.people_outline,
                        gradientColor: AppColors.fuchsia,
                        gradientColorEnd: AppColors.glowViolet.withValues(alpha: 0.7),
                        onTap: () => context.go('/admin/teams'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AdminQuickAction(
                        label: 'Ver Eventos',
                        icon: Icons.event_outlined,
                        gradientColor: isDark ? AppColors.successDark : AppColors.successLight,
                        gradientColorEnd: (isDark ? AppColors.roleCoachDark : AppColors.roleCoachLight).withValues(alpha: 0.7),
                        onTap: () => context.go('/admin/events'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ✅ Actividad reciente REAL desde providers
          _buildRecentActivity(context, activityAsync, cardBg, borderColor, cardTextPrimary, cardTextSecondary),
        ],
      ),
    );
  }

  Widget _buildStatsSkeleton(Color cardBg, Color borderColor) {
    return Column(
      children: [
        _buildStatCardSkeleton(cardBg, borderColor),
        const SizedBox(height: 12),
        _buildStatCardSkeleton(cardBg, borderColor),
        const SizedBox(height: 12),
        _buildStatCardSkeleton(cardBg, borderColor),
        const SizedBox(height: 12),
        _buildStatCardSkeleton(cardBg, borderColor),
      ],
    );
  }

  // ✅ SIN glow, solo fondo sólido
  Widget _buildStatCardSkeleton(Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 12,
                color: borderColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 28,
                color: borderColor.withValues(alpha: 0.5),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: borderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsError(String error, Color errorColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: errorColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error al cargar estadísticas: $error',
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Orden correcto: Usuarios activos, Competidores, Equipos, Próximos eventos
  Widget _buildStatsGrid(BuildContext context, AdminStats stats) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        // 1. Usuarios activos
        AdminStatsCard(
          label: 'Usuarios Activos',
          value: '${stats.activeUsers}',
          icon: Icons.person_outline,
          accentColor: isDark ? AppColors.successDark : AppColors.successLight,
        ),
        const SizedBox(height: 12),
        // 2. Total competidores
        AdminStatsCard(
          label: 'Competidores',
          value: '${stats.totalCompetitors}',
          icon: Icons.emoji_events_outlined,
          accentColor: AppColors.coral,
        ),
        const SizedBox(height: 12),
        // 3. Total equipos
        AdminStatsCard(
          label: 'Equipos',
          value: '${stats.totalTeams}',
          icon: Icons.people_outline,
          accentColor: AppColors.fuchsia,
        ),
        const SizedBox(height: 12),
        // 4. Próximos eventos
        AdminStatsCard(
          label: 'Próximos Eventos',
          value: '${stats.upcomingEvents}',
          icon: Icons.event_available_outlined,
          accentColor: isDark ? AppColors.destructiveDark : AppColors.destructiveLight,
        ),
      ],
    );
  }

  // ✅ Actividad reciente REAL con AsyncValue
  Widget _buildRecentActivity(
    BuildContext context,
    AsyncValue<List<ActivityItemEntity>> activityAsync,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividad Reciente',
            style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          activityAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: AppColors.fuchsia),
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error al cargar actividad: $err',
                  style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ),
            ),
            data: (activities) {
              if (activities.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No hay actividad reciente',
                      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: activities.map((activity) => _buildActivityItem(
                  activity, textPrimary, textSecondary,
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    ActivityItemEntity activity,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.fuchsia.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.fuchsia.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(
                activity.iconLabel,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      color: textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: activity.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' ${activity.actionLabel}',
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Formatea timestamp a texto legible en español
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Ahora mismo';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} día${diff.inDays > 1 ? 's' : ''}';
    
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}
