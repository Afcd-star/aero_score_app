// lib/src/features/competitors/presentation/views/competitors_section.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/'
    'competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/'
    'competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/features/'
    'competitors/presentation/widgets/competitor_form.dart';
import 'package:aero_score_app/src/features/'
    'competitors/presentation/widgets/competitor_list_view.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vista de sección para gestionar competidores.
///
/// Alterna entre la lista y el formulario en línea. El formulario monta
/// su propio botón de volver y gestiona su scroll interno, así que la
/// sección lo devuelve directo, sin envolverlo en otro scroll.
class CompetitorsSection extends ConsumerStatefulWidget {
  /// Crea la sección de competidores.
  const CompetitorsSection({super.key});

  @override
  ConsumerState<CompetitorsSection> createState() => _CompetitorsSectionState();
}

class _CompetitorsSectionState extends ConsumerState<CompetitorsSection> {
  bool _showForm = false;

  void _openCreate() {
    ref.read(competitorFormProvider.notifier).prepareForCreate();
    setState(() => _showForm = true);
  }

  void _openEdit(CompetitorEntity competitor) {
    ref.read(competitorFormProvider.notifier).prepareForEdit(competitor);
    setState(() => _showForm = true);
  }

  void _onSaved() {
    unawaited(ref.read(competitorListProvider.notifier).refresh());
    ref.read(competitorFormProvider.notifier).clearSuccess();
    setState(() => _showForm = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: CompetitorForm(
          onSuccess: _onSaved,
          onCancel: () => setState(() => _showForm = false),
        ),
      );
    }

    final listState = ref.watch(competitorListProvider);
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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.getGlowGradient(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people_outline,
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
                        'Competidores',
                        style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      listState.when(
                        data: (list) => Text(
                          '${list.length} competidor(es) '
                          'registrado(s)',
                          style: AppTextStyles.baseTextTheme.bodySmall
                              ?.copyWith(color: textSecondary),
                        ),
                        loading: () => Text(
                          'Cargando...',
                          style: TextStyle(
                            color: textSecondary.withValues(alpha: 0.7),
                          ),
                        ),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AeroButton(
                label: 'Crear Nuevo Competidor',
                onPressed: _openCreate,
                icon: const Icon(Icons.add, size: 20),
                gradient: AppColors.getGlowGradient(),
              ),
            ),
            const SizedBox(height: 24),
            CompetitorListView(
              onEdit: _openEdit,
              onDelete: (id) => _showDeleteConfirmation(context, ref, id),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Eliminar Competidor',
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
                  unawaited(
                    ref
                        .read(competitorListProvider.notifier)
                        .deleteCompetitor(id),
                  );
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
          );
        },
      ),
    );
  }
}
