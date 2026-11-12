// lib/src/features/admin/data/models/activity_item_dto.dart
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';

/// Umbral de ventana para deducir si un registro fue creado o editado.
///
/// Deuda explicita: el backend no tiene coleccion de auditoria, asi que
/// la accion se deduce comparando marcas de tiempo. Cuando exista la
/// coleccion de auditoria, este umbral y su logica desaparecen.
const Duration _creationWindow = Duration(seconds: 2);

/// Modelo de datos que traduce un registro de PocketBase a actividad.
///
/// Manual, coherente con los modelos de produccion de la casa. Recibe el
/// mapa de `record.toJson()` y ramifica el nombre segun el tipo de
/// coleccion, porque `teams` y `events` exponen `name` mientras
/// `competitors` compone `firstName` mas `lastName`.
class ActivityItemDto {
  /// Crea el modelo con los valores ya leidos del registro.
  const ActivityItemDto({
    required this.id,
    required this.name,
    required this.action,
    required this.entityType,
    required this.timestamp,
  });

  /// Construye el modelo desde el mapa de un registro de PocketBase.
  ///
  /// Devuelve `null` cuando el registro carece de marcas de tiempo,
  /// senal de anomalía que el repositorio debe filtrar en vez de
  /// falsear con la fecha actual.
  static ActivityItemDto? fromMap(
    Map<String, dynamic> map,
    ActivityEntityType entityType,
  ) {
    final created = _readDate(map, 'created');
    final updated = _readDate(map, 'updated');

    if (created == null && updated == null) {
      return null;
    }

    final timestamp = updated ?? created!;
    final isCreated = created != null &&
        updated != null &&
        created.isAfter(updated.subtract(_creationWindow));

    return ActivityItemDto(
      id: _readString(map, 'id'),
      name: _resolveName(map, entityType),
      action: isCreated
          ? ActivityAction.created
          : ActivityAction.updated,
      entityType: entityType,
      timestamp: timestamp,
    );
  }

  /// Convierte el modelo a la entidad de dominio.
  ActivityItemEntity toEntity() {
    return ActivityItemEntity(
      id: id,
      name: name,
      action: action,
      entityType: entityType,
      timestamp: timestamp,
    );
  }

  /// Identificador del registro.
  final String id;

  /// Nombre o etiqueta descriptiva de la entidad.
  final String name;

  /// Accion deducida de las marcas de tiempo.
  final ActivityAction action;

  /// Tipo de coleccion de origen.
  final ActivityEntityType entityType;

  /// Momento de la ultima variacion util.
  final DateTime timestamp;

  /// Resuelve el nombre segun el vocabulario de cada coleccion.
  static String _resolveName(
    Map<String, dynamic> map,
    ActivityEntityType entityType,
  ) {
    if (entityType != ActivityEntityType.competitor) {
      return _readString(map, 'name');
    }

    final first = _readString(map, 'firstName');
    final last = _readString(map, 'lastName');
    final composed = '$first $last'.trim();
    if (composed.isNotEmpty) {
      return composed;
    }

    final legacyFirst = _readString(map, 'nombre');
    final legacyLast = _readString(map, 'apellido');
    return '$legacyFirst $legacyLast'.trim();
  }

  static String _readString(Map<String, dynamic> map, String key) {
    final Object? value = map[key];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return '';
  }

  static DateTime? _readDate(Map<String, dynamic> map, String key) {
    final Object? value = map[key];
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}
