// lib/src/features/admin/domain/entities/activity_item_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_item_entity.freezed.dart';

/// Accion registrada sobre una entidad del sistema.
enum ActivityAction {
  /// La entidad fue creada.
  created,

  /// La entidad fue modificada.
  updated,

  /// La entidad fue eliminada de forma logica.
  deleted,
}

/// Tipo de entidad a la que pertenece una actividad.
enum ActivityEntityType {
  /// Se refiere a un equipo.
  team,

  /// Se refiere a un evento.
  event,

  /// Se refiere a un competidor.
  competitor,

  /// Se refiere a un usuario.
  user,
}

/// Item de la linea de actividad reciente del panel.
///
/// Los textos legibles son proyeccion de los enums de negocio y
/// permanecen en dominio porque son cadenas de Dart, no tipos de
/// Flutter. Lo que no puede vivir aqui es un icono, porque eso si
/// pertenece a la presentacion.
@freezed
abstract class ActivityItemEntity with _$ActivityItemEntity {
  /// Crea un item de actividad.
  const factory ActivityItemEntity({
    /// Identificador de la entidad afectada.
    required String id,

    /// Nombre o etiqueta descriptiva de la entidad.
    required String name,

    /// Accion sufrida por la entidad.
    required ActivityAction action,

    /// Tipo de entidad afectada.
    required ActivityEntityType entityType,

    /// Momento en que ocurrio la accion.
    required DateTime timestamp,
  }) = _ActivityItemEntity;

  /// Constructor privado requerido por Freezed para permitir
  /// getters propios en la clase abstracta. Va despues de la
  /// factoria porque la factoria es un constructor sin nombre y
  /// el lint de orden exige los sin nombre antes que los con
  /// nombre, y `_` cuenta como nombre.
  const ActivityItemEntity._();

  /// Texto legible de la accion en espanol.
  String get actionLabel => switch (action) {
    ActivityAction.created => 'creado',
    ActivityAction.updated => 'actualizado',
    ActivityAction.deleted => 'eliminado',
  };

  /// Texto legible del tipo de entidad en espanol.
  String get entityTypeLabel => switch (entityType) {
    ActivityEntityType.team => 'Equipo',
    ActivityEntityType.event => 'Evento',
    ActivityEntityType.competitor => 'Competidor',
    ActivityEntityType.user => 'Usuario',
  };

  /// Glifo representativo del tipo de entidad.
  String get iconLabel => switch (entityType) {
    ActivityEntityType.team => '\u{1F465}',
    ActivityEntityType.event => '\u{1F3C6}',
    ActivityEntityType.competitor => '\u{1F938}',
    ActivityEntityType.user => '\u{1F464}',
  };
}
