// lib/src/features/teams/presentation/widgets/team_list_view.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/core/theme/theme_helpers.dart';
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamListView extends ConsumerWidget { // ✅ Nuevo callback opcional

  const TeamListView({
    required this.onEdit, required this.onDelete, this.onAddTeam,
    super.key,
    this.onViewCompetitors,
  });
  final VoidCallback? onAddTeam;
  final Function(TeamEntity) onEdit;
  final Function(String) onDelete;
  final Function(TeamEntity)? onViewCompetitors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teamListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return state.when(
      loading: _buildSkeleton,
      error: (error, _) => _buildError(error.toString(), isDark),
      data: (teams) => teams.isEmpty
          ? _buildEmptyState(isDark)
          : _buildList(teams, context),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: AeroSkeleton(height: 280), // ✅ Altura aumentada para nuevo diseño
        ),
      ),
    );
  }

  Widget _buildError(String error, bool isDark) {
    final errorColor = isDark ? AppColors.destructiveDark : AppColors.destructiveLight;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: errorColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error: $error',
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.groups_outlined,
            size: 64,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay equipos registrados',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<TeamEntity> teams, BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: teams.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildTeamCard(teams[index], context),
    );
  }

  Widget _buildTeamCard(TeamEntity team, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final textPrimary = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final textSecondary = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;
    final competitorCount = team.competitorIds.length;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ HEADER: Avatar + Nombre + Competidores
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar circular con gradiente
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.getGlowGradient(),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.groups,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Info del equipo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$competitorCount competidor${competitorCount == 1 ? '' : 'es'}',
                        style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          
          // ✅ SECCIÓN: Universidad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.fuchsia,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    team.university,
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ SECCIÓN: Facultad (AHORA INDEPENDIENTE)
          if (team.faculty != null && team.faculty!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.school_outlined, // ✅ Icono propio
                    size: 18,
                    color: AppColors.fuchsia,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      team.faculty!,
                      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                        color: ThemeHelper.getFacultyColor(team.faculty!),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // ✅ SECCIÓN: Entrenador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.fuchsia,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Entrenador: ${team.coachName ?? "No asignado"}',
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ SECCIÓN: Email
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 18,
                  color: AppColors.fuchsia,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    team.email,
                    style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                      color: textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ✅ BOTÓN: Ver competidores
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => onViewCompetitors?.call(team),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.fuchsia.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.fuchsia.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ver competidores ($competitorCount)',
                      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                        color: AppColors.fuchsia,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.fuchsia,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Botón Editar - Gradiente fucsia con label
                Expanded(
                  child: AeroButton(
                    label: 'Editar',
                    onPressed: () => onEdit(team),
                    icon: const Icon(Icons.edit, size: 18),
                    gradient: AppColors.getGlowGradient(),
                    height: 44,
                  ),
                ),
                const SizedBox(width: 12),
                // Botón Eliminar - Solo ícono, variante destructive
                AeroButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  iconOnly: true,
                  variant: AeroButtonVariant.destructive,
                  width: 44,
                  height: 44,
                  onPressed: () => onDelete(team.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}