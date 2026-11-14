// test/features/admin/domain/entities/activity_item_entity_test.dart
import 'package:aero_score_app/src/features/admin/domain/entities/'
    'activity_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite de actividad.
void main() {
  final item = ActivityItemEntity(
    id: 'abc',
    name: 'Equipo A',
    action: ActivityAction.created,
    entityType: ActivityEntityType.team,
    timestamp: DateTime.utc(2026),
  );

  group('ActivityItemEntity', () {
    test('la igualdad compara todos los campos', () {
      expect(item.copyWith(), item);
      expect(item.copyWith(name: 'Otro'), isNot(item));
    });

    test('actionLabel proyecta cada accion en espanol', () {
      expect(
        item.copyWith(action: ActivityAction.created).actionLabel,
        'creado',
      );
      expect(
        item.copyWith(action: ActivityAction.updated).actionLabel,
        'actualizado',
      );
      expect(
        item.copyWith(action: ActivityAction.deleted).actionLabel,
        'eliminado',
      );
    });

    test('entityTypeLabel proyecta cada tipo en espanol', () {
      const <ActivityEntityType, String>{
        ActivityEntityType.team: 'Equipo',
        ActivityEntityType.event: 'Evento',
        ActivityEntityType.competitor: 'Competidor',
        ActivityEntityType.user: 'Usuario',
      }.forEach((tipo, etiqueta) {
        expect(item.copyWith(entityType: tipo).entityTypeLabel, etiqueta);
      });
    });

    test('iconLabel no esta vacio para ningun tipo', () {
      for (final tipo in ActivityEntityType.values) {
        expect(item.copyWith(entityType: tipo).iconLabel, isNotEmpty);
      }
    });
  });
}
