// lib/src/features/teams/presentation/views/teams_section.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_form_notifier.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/team_competitors_sheet.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/team_form.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/team_list_view.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sección del panel que alterna entre la lista de equipos y el
/// formulario de creación o edición, según el modo del notificador
/// de formulario.
///
/// El formulario monta su propio retorno con el andamiaje del catálogo,
/// así que la sección no pinta navegación y lo devuelve sin envolverlo
/// en tarjeta ni en desplazamiento propio. El relleno exterior coincide
/// con el de las demás secciones para que el cambio de vista no salte.
class TeamsSection extends ConsumerWidget {
  /// Crea la sección sin parámetros propios.
  const TeamsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(teamFormProvider);
    final showForm = formState.mode != TeamFormMode.idle;

    if (showForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: AeroTeamForm(
          initialTeam: formState.draft,
          onSuccess: () {
            final isDark = Theme.of(context).brightness == Brightness.dark;
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
          onCancel: () => ref.read(teamFormProvider.notifier).cancelEditing(),
        ),
      );
    }

    final listState = ref.watch(teamListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.foregroundDark
        : AppColors.foregroundLight;
    final textSecondary = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AeroSectionCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                unawaited(
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => TeamCompetitorsSheet(team: team),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    AsyncValue<List<TeamEntity>> listState,
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
          child: const Icon(Icons.groups, color: Colors.white, size: 24),
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
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Eliminar Equipo',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            '¿Estás seguro? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                unawaited(ref.read(teamListProvider.notifier).deleteTeam(id));
                Navigator.pop(dialogContext);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.destructiveLight,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}
