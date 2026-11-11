// lib/src/features/events/presentation/views/events_section.dart
// ✅ Corrige imports y usa el widget correcto
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/events/data/di/event_providers.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_form_state.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/event_form.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/event_list_view.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsSection extends ConsumerWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(eventFormProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final showForm = formState.mode != FormMode.idle; // ← Lógica unificada para mostrar el formulario

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showForm) ...[
              _buildFormHeader(
                title: formState.mode == FormMode.edit
                    ? 'Editar Evento'
                    : 'Nuevo Evento',
                onBack: () =>
                    ref.read(eventFormProvider.notifier).cancelEditing(),
              ),
              const SizedBox(height: 16),
              AeroEventForm(
                // ✅ Usa el nombre correcto del widget
                initialEvent: formState.draft,
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        formState.isEditing
                            ? 'Evento actualizado ✓'
                            : 'Evento creado ✓',
                      ),
                      backgroundColor: isDark
                          ? AppColors.successDark
                          : AppColors.successLight,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                    ),
                  );

                  ref.read(eventFormProvider.notifier).cancelEditing();
                  ref.invalidate(eventListProvider);
                },
                onCancel: () =>
                    ref.read(eventFormProvider.notifier).cancelEditing(),
              ),
            ] else ...[
              EventListView(
                onAddEvent: () =>
                    ref.read(eventFormProvider.notifier).prepareForCreate(),
                onEdit: (event) =>
                    ref.read(eventFormProvider.notifier).prepareForEdit(event),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
