// lib/src/features/events/presentation/providers/event_form_notifier.dart
import 'package:aero_score_app/src/features/events/data/di/event_providers.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:aero_score_app/src/features/events/domain/repositories/event_repository.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventFormNotifier extends Notifier<EventFormState> {
  EventFormNotifier();

  EventRepository get _repository => ref.read(eventRepositoryProvider);

  @override
  EventFormState build() => const EventFormState();

  void prepareForCreate() => state = const EventFormState(
    mode: FormMode.create,
  );

  void prepareForEdit(EventEntity event) => state = EventFormState(
    draft: event,
    mode: FormMode.edit,
  );

  void cancelEditing() => state = const EventFormState();

  void clearFeedback() => state = state.copyWith(
    isSuccess: false,
  );

  Future<bool> submit({
    required String name,
    required DateTime date,
    required String location, required EventCategory category, required String principalJudgeId, required String artistryJudgeId, required String difficultyJudgeId, required String executionJudgeId, required List<String> teamIds, String? time,
    String? description,
    EventStatus status = EventStatus.planned,
    List<String>? additionalJudgeIds = const [],
  }) async {
    if (teamIds.length < 2) {
      state = state.copyWith(errorMessage: 'Debe agregar al menos dos equipos');
      return false;
    }
    state = state.copyWith(isLoading: true, isSuccess: false);
    try {
      final event = state.mode == FormMode.edit && state.draft != null
          ? state.draft!.copyWith(
              name: name, date: date, time: time, location: location,
              description: description, category: category, status: status,
              principalJudgeId: principalJudgeId, artistryJudgeId: artistryJudgeId,
              difficultyJudgeId: difficultyJudgeId, executionJudgeId: executionJudgeId,
              additionalJudgeIds: additionalJudgeIds, teamIds: teamIds,
            )
          : EventEntity.newEvent(
              name: name, date: date, time: time, location: location,
              description: description, category: category, status: status,
              principalJudgeId: principalJudgeId, artistryJudgeId: artistryJudgeId,
              difficultyJudgeId: difficultyJudgeId, executionJudgeId: executionJudgeId,
              additionalJudgeIds: additionalJudgeIds, teamIds: teamIds,
            );
      state.mode == FormMode.edit
          ? await _repository.updateEvent(event)
          : await _repository.createEvent(event);
      state = state.copyWith(isSuccess: true, isLoading: false, draft: event);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}