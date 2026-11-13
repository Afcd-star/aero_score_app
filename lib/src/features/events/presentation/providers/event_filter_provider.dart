// lib/src/features/events/presentation/providers/event_filter_provider.dart
import 'package:aero_score_app/src/features/events/data/di/event_providers.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Filtro de estado: usa los valores reales de EventStatus.value (español, Title Case)
/// 'all' = sin filtro, 'Planificado', 'En curso', 'Finalizado'
final eventStatusFilterProvider = Provider<String>((ref) {
  return ref.watch(_eventStatusFilterStateProvider);
});

final _eventStatusFilterStateProvider = NotifierProvider<StatusFilterNotifier, String>(() {
  return StatusFilterNotifier();
});

class StatusFilterNotifier extends Notifier<String> {
  @override
  String build() {
    return 'all';
  }

  void updateStatus(String status) {
    state = status;
  }
}

/// ✅ Rango de fechas para filtrar eventos (null = sin filtro)
final eventDateRangeFilterProvider = Provider<DateTimeRange?>((ref) {
  return ref.watch(_eventDateRangeFilterStateProvider);
});

final _eventDateRangeFilterStateProvider = NotifierProvider<DateRangeFilterNotifier, DateTimeRange?>(() {
  return DateRangeFilterNotifier();
});

class DateRangeFilterNotifier extends Notifier<DateTimeRange?> {
  @override
  DateTimeRange? build() {
    return null;
  }

  void updateDateRange(DateTimeRange range) {
    state = range;
  }

  void clearDateFilter() {
    state = null;
  }
}

/// ✅ Provider derivado: aplica filtros SIN doble-envolver AsyncValue
final filteredEventsProvider = Provider<AsyncValue<List<EventEntity>>>((ref) {
  final eventsAsync = ref.watch(eventListProvider);
  final filter = ref.watch(eventFilterProvider);

  // ✅ Transformar solo la rama data y devolver AsyncValue completo
  return eventsAsync.when(
    data: (events) {
      var filtered = events;

      // Filtrar por estado (comparar con EventStatus.value)
      if (filter.status != 'all') {
        filtered = filtered
            .where((e) => e.status.value == filter.status)
            .toList();
      }

      // Filtrar por rango de fechas (inclusive)
      if (filter.dateRange != null) {
        final start = filter.dateRange!.start;
        final end = filter.dateRange!.end.add(const Duration(days: 1)); // Inclusive end
        filtered = filtered
            .where((e) => e.date.isAtSameMomentAs(start) || 
                         (e.date.isAfter(start) && e.date.isBefore(end)))
            .toList();
      }

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

/// ✅ Helper: Resetear todos los filtros
void resetEventFilters(WidgetRef ref) {
  ref.read(_eventStatusFilterStateProvider.notifier).updateStatus('all');
  ref.read(_eventDateRangeFilterStateProvider.notifier).clearDateFilter();
}

/// ✅ Helper opcional: Obtener filtros combinados como objeto
EventFilter getCurrentFilters(WidgetRef ref) {
  return EventFilter(
    status: ref.read(eventStatusFilterProvider),
    dateRange: ref.read(eventDateRangeFilterProvider),
  );
}

/// ✅ Clase simple para representar filtros (opcional, para mejor tipado)
class EventFilter {

  const EventFilter({required this.status, this.dateRange});
  final String status; // 'all' o valor de EventStatus.value
  final DateTimeRange? dateRange;

  EventFilter copyWith({String? status, DateTimeRange? dateRange}) {
    return EventFilter(
      status: status ?? this.status,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

/// ✅ Notifier para gestionar el estado del filtro completo
class EventFilterNotifier extends Notifier<EventFilter> {
  @override
  EventFilter build() {
    return const EventFilter(status: 'all');
  }

  void updateDateRange(DateTimeRange range) {
    state = state.copyWith(dateRange: range);
  }

  void clearDateFilter() {
    state = state.copyWith();
  }

  void updateStatus(String status) {
    state = state.copyWith(status: status);
  }

  void clearAllFilters() {
    state = const EventFilter(status: 'all');
  }
}

/// ✅ Provider para el filtro completo con métodos
final eventFilterProvider = NotifierProvider<EventFilterNotifier, EventFilter>(() {
  return EventFilterNotifier();
});
