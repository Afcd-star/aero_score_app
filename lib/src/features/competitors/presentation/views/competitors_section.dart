// lib/src/features/competitors/presentation/views/competitors_section.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/'
    'competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/'
    'competitors/presentation/providers/'
    'competitor_form_notifier.dart';
import 'package:aero_score_app/src/features/'
    'competitors/presentation/widgets/competitor_form_sheet.dart';
import 'package:aero_score_app/src/features/'
    'competitors/presentation/widgets/competitor_list_view.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/admin/section_card.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vista de sección para gestionar competidores.
class CompetitorsSection extends ConsumerWidget {
  /// Crea la sección de competidores.
  const CompetitorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(competitorListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.foregroundDark
        : AppColors.foregroundLight;
    final textSecondary = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;

    // Escuchar cambios del formulario para reacciones.
    ref.listen<CompetitorFormState>(
      competitorFormProvider,
      (previous, next) {
        if (previous?.isLoading == true && !next.isLoading) {
          // Si hay draft y no hay error, hubo éxito.
          if (next.draft != null && next.error == null) {
            unawaited(
              ref.read(competitorListProvider.notifier).refresh(),
            );
            ref.read(competitorFormProvider.notifier).clearSuccess();

            if (context.mounted) {
              Navigator.pop(context);
            }
          }

          // Mostrar error si existe.
          if (next.error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.error!),
                backgroundColor: isDark
                    ? AppColors.destructiveDark
                    : AppColors.destructiveLight,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SectionCard(
        // SectionCard envuelve encabezado, botón y lista.
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado dentro de la card.
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
                        style: AppTextStyles.baseTextTheme.titleLarge
                            ?.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      listState.when(
                        data: (list) => Text(
                          '${list.length} competidor(es) '
                          'registrado(s)',
                          style: AppTextStyles
                              .baseTextTheme.bodySmall
                              ?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        loading: () => Text(
                          'Cargando...',
                          style: TextStyle(
                            color: textSecondary.withValues(
                              alpha: 0.7,
                            ),
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

            // Botón debajo del encabezado.
            SizedBox(
              width: double.infinity,
              child: AeroButton(
                label: 'Crear Nuevo Competidor',
                onPressed: () {
                  ref
                      .read(competitorFormProvider.notifier)
                      .prepareForCreate();
                  unawaited(
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return const CompetitorFormSheet();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 20),
                gradient: AppColors.getGlowGradient(),
              ),
            ),

            const SizedBox(height: 24),

            // Lista de competidores.
            CompetitorListView(
              onEdit: (competitor) {
                ref
                    .read(competitorFormProvider.notifier)
                    .prepareForEdit(competitor);
                unawaited(
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return const CompetitorFormSheet();
                    },
                  ),
                );
              },
              onDelete: (id) {
                _showDeleteConfirmation(context, ref, id);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de confirmación simplificado.
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
