// lib/src/features/teams/presentation/views/sections/teams_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_form_notifier.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/team_competitors_sheet.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/team_form.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/team_list_view.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/section_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsSection extends ConsumerWidget {
  const TeamsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(teamFormProvider);
    final listState = ref.watch(teamListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final textSecondary = isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight;

    // ✅ Lógica unificada: mostrar formulario si mode != idle
    final showForm = formState.mode != TeamFormMode.idle;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SectionCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showForm) ...[
              // ✅ MODO FORMULARIO: Header de navegación + formulario
              _buildFormHeader(
                title: formState.mode == TeamFormMode.edit
                    ? 'Editar Equipo'
                    : 'Nuevo Equipo',
                onBack: () =>
                    ref.read(teamFormProvider.notifier).cancelEditing(),
              ),
              const SizedBox(height: 16),
              AeroTeamForm(
                initialTeam: formState.draft,
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        formState.isEditing
                            ? 'Equipo actualizado ✓'
                            : 'Equipo creado ✓',
                      ),
                      backgroundColor: isDark
                          ? AppColors.successDark
                          : AppColors.successLight,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  ref.read(teamFormProvider.notifier).cancelEditing();
                  ref.invalidate(teamListProvider);
                },
                onCancel: () =>
                    ref.read(teamFormProvider.notifier).cancelEditing(),
              ),
            ] else ...[
              // ✅ MODO LISTA: Header original + botón crear + lista
              _buildSectionHeader(listState, textPrimary, textSecondary),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AeroButton(
                  label: 'Crear Nuevo Equipo',
                  onPressed: () =>
                      ref.read(teamFormProvider.notifier).prepareForCreate(),
                  icon: const Icon(Icons.add, size: 20),
                  gradient: AppColors.getGlowGradient(),
                ),
              ),
              const SizedBox(height: 24),
              TeamListView(
                onEdit: (team) =>
                    ref.read(teamFormProvider.notifier).prepareForEdit(team),
                onDelete: (id) => _showDeleteConfirmation(context, ref, id),
                onViewCompetitors: (team) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => TeamCompetitorsSheet(team: team),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ✅ HEADER ORIGINAL restaurado (con ícono, título y contador)
  Widget _buildSectionHeader(
    AsyncValue<dynamic> listState,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.getGlowGradient(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.groups,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Equipos',
                style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              listState.when(
                data: (list) => Text(
                  '${list.length} equipo(s) registrado(s)',
                  style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                    color: textSecondary,
                  ),
                ),
                loading: () => Text(
                  'Cargando...',
                  style: TextStyle(color: textSecondary.withValues(alpha: 0.7)),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Eliminar Equipo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(teamListProvider.notifier).deleteTeam(id);
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.destructiveLight,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // ✅ Header de navegación para el modo formulario
  Widget _buildFormHeader({
    required String title,
    required VoidCallback onBack,
  }) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.fuchsia.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.fuchsia.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, size: 18, color: AppColors.fuchsia),
            const SizedBox(width: 6),
            Text(
              'Volver a la lista',
              style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                color: AppColors.fuchsia,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
