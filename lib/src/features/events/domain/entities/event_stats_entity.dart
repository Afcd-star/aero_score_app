// lib/src/features/events/domain/entities/event_stats_entity.dart
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';

/// Estadísticas agregadas de eventos para dashboard admin.
/// ✅ Solo datos computados, NO lógica de negocio.
class EventStats { // fecha del próximo evento (null si no hay)

  const EventStats({
    required this.totalEvents,
    required this.upcomingEvents,
    required this.inProgressEvents,
    required this.completedEvents,
    required this.totalParticipants,
    this.nextEventDate,
  });

  /// Factory desde lista de eventos (para computar stats en repo/UI)
  factory EventStats.fromEvents(List<EventEntity> events) {
    final now = DateTime.now();
    final upcoming = events.where((e) => 
      e.status.value == 'planned' && e.date.isAfter(now)
    ).length;
    
    final inProgress = events.where((e) => 
      e.status.value == 'in_progress'
    ).length;
    
    final completed = events.where((e) => 
      e.status.value == 'completed'
    ).length;
    
    final nextDate = events
        .where((e) => e.status.value == 'planned' && e.date.isAfter(now))
        .map((e) => e.date)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    // TODO: Calcular totalParticipants desde relación events↔competitors
    // Por ahora, placeholder
    const totalParticipants = 0;

    return EventStats(
      totalEvents: events.length,
      upcomingEvents: upcoming,
      inProgressEvents: inProgress,
      completedEvents: completed,
      totalParticipants: totalParticipants,
      nextEventDate: nextDate,
    );
  }
  final int totalEvents;
  final int upcomingEvents;    // status == 'planned' && date >= hoy
  final int inProgressEvents;  // status == 'in_progress'
  final int completedEvents;   // status == 'completed'
  final int totalParticipants; // suma de participantes de todos los eventos
  final DateTime? nextEventDate;

  /// Merge con otros stats (para combinar filtros)
  EventStats copyWith({
    int? totalEvents,
    int? upcomingEvents,
    int? inProgressEvents,
    int? completedEvents,
    int? totalParticipants,
    DateTime? nextEventDate,
  }) {
    return EventStats(
      totalEvents: totalEvents ?? this.totalEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      inProgressEvents: inProgressEvents ?? this.inProgressEvents,
      completedEvents: completedEvents ?? this.completedEvents,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      nextEventDate: nextEventDate ?? this.nextEventDate,
    );
  }
}
