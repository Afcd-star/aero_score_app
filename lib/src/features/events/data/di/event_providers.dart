// lib/src/features/events/data/di/event_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/events/data/repositories/event_repository_impl.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:aero_score_app/src/features/events/domain/repositories/event_repository.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_form_notifier.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_form_state.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  return EventRepositoryImpl(pb);
});

// ✅ Patrón A unificado
final eventFormProvider = NotifierProvider<EventFormNotifier, EventFormState>(
  EventFormNotifier.new,
);

final eventListProvider = AsyncNotifierProvider<EventListNotifier, List<EventEntity>>(
  EventListNotifier.new,
);
