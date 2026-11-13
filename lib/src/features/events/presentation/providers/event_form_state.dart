// lib/src/features/events/presentation/providers/event_form_state.dart

import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';

enum FormMode { idle, create, edit }

class EventFormState {

  const EventFormState({
    this.draft,
    this.mode = FormMode.idle,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });
  final EventEntity? draft;
  final FormMode mode; // ← Fuente de verdad para modo
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  // Getter para compatibilidad con código existente
  bool get isEditing => mode == FormMode.edit;

  EventFormState copyWith({
    EventEntity? draft,
    FormMode? mode,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EventFormState(
      draft: draft ?? this.draft,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
