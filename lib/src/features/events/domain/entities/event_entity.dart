// lib/src/features/events/domain/entities/event_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_entity.freezed.dart';

/// Categorías disponibles para un evento.
enum EventCategory {
  /// Competición de ámbito regional.
  regional('Regional'),

  /// Competición de ámbito universitario.
  universitario('Universitario'),

  /// Competición de ámbito nacional.
  nacional('Nacional'),

  /// Evento tipo festival.
  festival('Festival'),

  /// Evento tipo torneo.
  torneo('Torneo');

  /// Crea la categoría con su etiqueta legible.
  const EventCategory(this.value);

  /// Etiqueta legible asociada a la categoría.
  final String value;

  /// Convierte una etiqueta opcional a categoría válida.
  static EventCategory fromString(String? value) {
    return EventCategory.values.firstWhere(
      (item) => item.value == value,
      orElse: () => EventCategory.regional,
    );
  }
}

/// Estados disponibles para un evento.
enum EventStatus {
  /// Evento programado y no iniciado.
  planned('Planificado'),

  /// Evento en desarrollo.
  ongoing('En curso'),

  /// Evento terminado.
  completed('Finalizado');

  /// Crea el estado con su etiqueta legible.
  const EventStatus(this.value);

  /// Etiqueta legible asociada al estado.
  final String value;

  /// Convierte una etiqueta opcional a estado válido.
  static EventStatus fromString(String? value) {
    return EventStatus.values.firstWhere(
      (item) => item.value == value,
      orElse: () => EventStatus.planned,
    );
  }
}

/// Entidad de dominio que representa un evento.
@freezed
abstract class EventEntity with _$EventEntity {
  /// Crea una entidad de evento.
  const factory EventEntity({
    required String name,
    required DateTime date,
    required String location,
    required EventCategory category,
    required EventStatus status,
    required String principalJudgeId,
    required String artistryJudgeId,
    required String difficultyJudgeId,
    required String executionJudgeId,
    required List<String> teamIds,
    String? id,
    String? time,
    String? description,
    @Default(<String>[]) List<String> additionalJudgeIds,
    DateTime? created,
    DateTime? updated,
  }) = _EventEntity;
}
