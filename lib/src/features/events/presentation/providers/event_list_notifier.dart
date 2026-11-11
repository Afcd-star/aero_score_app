// lib/src/features/events/presentation/providers/event_list_notifier.dart
import 'package:aero_score_app/src/features/events/data/di/event_providers.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:aero_score_app/src/features/events/domain/repositories/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventListNotifier extends AsyncNotifier<List<EventEntity>> {
  EventListNotifier();

  EventRepository get _repository => ref.read(eventRepositoryProvider);

  @override
  Future<List<EventEntity>> build() async {
    final result = await _repository.getAll();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (events) => events,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.getAll();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      AsyncValue.data,
    );
  }

  Future<void> deleteEvent(String id) async {
    final currentEvents = state.value;
    if (currentEvents == null) return;
    final result = await _repository.deleteEvent(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = AsyncValue.data(currentEvents.where((e) => e.id != id).toList()),
    );
  }
}