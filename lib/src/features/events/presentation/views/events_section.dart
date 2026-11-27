// lib/src/features/events/presentation/views/events_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/features/events/data/di/event_providers.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_form_state.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/event_form.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/event_list_view.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsSection extends ConsumerWidget {
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(eventFormProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showForm = formState.mode != FormMode.idle;

    if (showForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: AeroEventForm(
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
          onCancel: () => ref.read(eventFormProvider.notifier).cancelEditing(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: AeroSectionCard(
        child: EventListView(
          onAddEvent: () =>
              ref.read(eventFormProvider.notifier).prepareForCreate(),
          onEdit: (event) =>
              ref.read(eventFormProvider.notifier).prepareForEdit(event),
        ),
      ),
    );
  }
}
