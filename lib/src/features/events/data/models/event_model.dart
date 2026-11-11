// lib/src/features/events/data/models/event_model.dart
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';

const String _fieldId = 'id';
const String _fieldName = 'name';
const String _fieldDate = 'date';
const String _fieldTime = 'time';
const String _fieldLocation = 'location';
const String _fieldCategory = 'category';
const String _fieldStatus = 'status';
const String _fieldDescription = 'description';
const String _fieldPrincipalJudge = 'principalJudge';
const String _fieldArtistryJudge = 'artistryJudge';
const String _fieldDifficultyJudge = 'difficultyJudge';
const String _fieldExecutionJudge = 'executionJudge';
const String _fieldAdditionalJudges = 'additionalJudges';
const String _fieldTeams = 'teams';
const String _fieldCreated = 'created';
const String _fieldUpdated = 'updated';

/// DTO para serialización y deserialización con PocketBase.
class EventModel {
  /// Crea el modelo con los valores del evento.
  const EventModel({
    required this.name,
    required this.date,
    required this.location,
    required this.category,
    required this.status,
    required this.principalJudgeId,
    required this.artistryJudgeId,
    required this.difficultyJudgeId,
    required this.executionJudgeId,
    required this.teamIds,
    this.id,
    this.time,
    this.description,
    this.additionalJudgeIds = const <String>[],
    this.created,
    this.updated,
  });

  /// Construye un modelo desde el mapa devuelto por PocketBase.
  factory EventModel.fromMap(Map<String, dynamic> map) {
    final eventDate = _readDate(map, _fieldDate);
    if (eventDate == null) {
      throw const FormatException('Fecha de evento inválida.');
    }

    return EventModel(
      id: _readNullableString(map, _fieldId),
      name: _readRequiredString(map, _fieldName),
      date: eventDate,
      time: _readNullableString(map, _fieldTime),
      location: _readRequiredString(map, _fieldLocation),
      category: EventCategory.fromString(
        _readRequiredString(map, _fieldCategory),
      ),
      status: EventStatus.fromString(
        _readRequiredString(map, _fieldStatus),
      ),
      description: _readNullableString(map, _fieldDescription),
      principalJudgeId: _readRelationId(
        map,
        _fieldPrincipalJudge,
      ),
      artistryJudgeId: _readRelationId(
        map,
        _fieldArtistryJudge,
      ),
      difficultyJudgeId: _readRelationId(
        map,
        _fieldDifficultyJudge,
      ),
      executionJudgeId: _readRelationId(
        map,
        _fieldExecutionJudge,
      ),
      additionalJudgeIds: _readStringList(
        map,
        _fieldAdditionalJudges,
      ),
      teamIds: _readStringList(map, _fieldTeams),
      created: _readDate(map, _fieldCreated),
      updated: _readDate(map, _fieldUpdated),
    );
  }

  /// Construye un modelo desde una entidad de dominio.
  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      name: entity.name,
      date: entity.date,
      location: entity.location,
      category: entity.category,
      status: entity.status,
      principalJudgeId: entity.principalJudgeId,
      artistryJudgeId: entity.artistryJudgeId,
      difficultyJudgeId: entity.difficultyJudgeId,
      executionJudgeId: entity.executionJudgeId,
      teamIds: entity.teamIds,
      created: entity.created,
      time: entity.time,
      description: entity.description,
      additionalJudgeIds: entity.additionalJudgeIds,
      updated: entity.updated,
    );
  }

  /// Identificador opcional del evento.
  final String? id;

  /// Nombre del evento.
  final String name;

  /// Fecha del evento.
  final DateTime date;

  /// Lugar del evento.
  final String location;

  /// Categoría del evento.
  final EventCategory category;

  /// Estado del evento.
  final EventStatus status;

  /// Identificador del juez principal.
  final String principalJudgeId;

  /// Identificador del juez de arte.
  final String artistryJudgeId;

  /// Identificador del juez de dificultad.
  final String difficultyJudgeId;

  /// Identificador del juez de ejecución.
  final String executionJudgeId;

  /// Identificadores de equipos participantes.
  final List<String> teamIds;

  /// Hora opcional del evento.
  final String? time;

  /// Descripción opcional del evento.
  final String? description;

  /// Identificadores de jueces adicionales.
  final List<String> additionalJudgeIds;

  /// Fecha de creación.
  final DateTime? created;

  /// Fecha de actualización.
  final DateTime? updated;

  /// Serializa el modelo hacia el mapa esperado por PocketBase.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _fieldName: name,
      _fieldDate: _formatDate(date),
      if (time != null && time!.isNotEmpty) _fieldTime: time,
      _fieldLocation: location,
      _fieldCategory: category.value,
      _fieldStatus: status.value,
      _fieldDescription: description,
      _fieldPrincipalJudge: _relationOrNull(principalJudgeId),
      _fieldArtistryJudge: _relationOrNull(artistryJudgeId),
      _fieldDifficultyJudge: _relationOrNull(difficultyJudgeId),
      _fieldExecutionJudge: _relationOrNull(executionJudgeId),
      _fieldAdditionalJudges: additionalJudgeIds,
      _fieldTeams: teamIds,
    };
  }

  /// Convierte el modelo hacia la entidad de dominio.
  EventEntity toEntity() {
    return EventEntity(
      id: id,
      name: name,
      date: date,
      time: time,
      location: location,
      category: category,
      status: status,
      description: description,
      principalJudgeId: principalJudgeId,
      artistryJudgeId: artistryJudgeId,
      difficultyJudgeId: difficultyJudgeId,
      executionJudgeId: executionJudgeId,
      additionalJudgeIds: additionalJudgeIds,
      teamIds: teamIds,
      created: created,
      updated: updated,
    );
  }

  static String _readRequiredString(
    Map<String, dynamic> map,
    String key,
  ) {
    final value = _readNullableString(map, key);
    if (value == null) {
      throw FormatException('Campo requerido ausente: $key.');
    }
    return value;
  }

  static String? _readNullableString(
    Map<String, dynamic> map,
    String key,
  ) {
    final Object? value = map[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  static DateTime? _readDate(Map<String, dynamic> map, String key) {
    final value = _readNullableString(map, key);
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  static String _readRelationId(
    Map<String, dynamic> map,
    String key,
  ) {
    final Object? value = map[key];
    if (value is String) {
      return value;
    }
    if (value is List<dynamic> && value.isNotEmpty) {
      return _readItemId(value.first) ?? '';
    }
    return '';
  }

  static List<String> _readStringList(
    Map<String, dynamic> map,
    String key,
  ) {
    final Object? value = map[key];
    if (value is! List<dynamic>) {
      return const <String>[];
    }

    final result = <String>[];
    for (final Object? item in value) {
      final itemId = _readItemId(item);
      if (itemId != null && itemId.isNotEmpty) {
        result.add(itemId);
      }
    }

    return List<String>.unmodifiable(result);
  }

  static String? _readItemId(Object? item) {
    if (item is String) {
      return item;
    }
    if (item is Map<String, dynamic>) {
      final Object? rawId = item['id'];
      if (rawId is String) {
        return rawId;
      }
    }
    return item?.toString();
  }

  static String? _relationOrNull(String value) {
    return value.isEmpty ? null : value;
  }

  static String _formatDate(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
    ).toIso8601String();
  }
}
