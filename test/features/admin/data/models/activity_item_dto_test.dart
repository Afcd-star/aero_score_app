// test/features/admin/data/models/activity_item_dto_test.dart
import 'package:aero_score_app/src/features/admin/data/models/'
    'activity_item_dto.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/'
    'activity_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite del modelo de actividad.
void main() {
  const creado = '2026-01-01T10:00:00.000Z';
  const editadoCerca = '2026-01-01T10:00:01.000Z';
  const editadoLejos = '2026-01-01T10:00:10.000Z';

  group('ActivityItemDto.fromMap', () {
    test('devuelve null sin marcas de tiempo', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{'id': 'x', 'name': 'Equipo'},
        ActivityEntityType.team,
      );
      expect(dto, isNull);
    });

    test('lee name en equipos y eventos', () {
      for (final tipo in <ActivityEntityType>[
        ActivityEntityType.team,
        ActivityEntityType.event,
      ]) {
        final dto = ActivityItemDto.fromMap(
          <String, dynamic>{
            'id': 'x',
            'name': 'Registro',
            'created': creado,
            'updated': editadoLejos,
          },
          tipo,
        )!;
        expect(dto.name, 'Registro');
        expect(dto.entityType, tipo);
      }
    });

    test('compone el nombre del competidor con los campos nuevos', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{
          'id': 'x',
          'firstName': 'Airam',
          'lastName': 'Cuesta',
          'created': creado,
          'updated': editadoLejos,
        },
        ActivityEntityType.competitor,
      )!;
      expect(dto.name, 'Airam Cuesta');
    });

    test('usa el vocabulario legacy cuando faltan los campos nuevos', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{
          'id': 'x',
          'nombre': 'Airam',
          'apellido': 'Cuesta',
          'created': creado,
          'updated': editadoLejos,
        },
        ActivityEntityType.competitor,
      )!;
      expect(dto.name, 'Airam Cuesta');
    });

    test('deduce creacion con marcas a menos de dos segundos', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{
          'id': 'x',
          'name': 'Registro',
          'created': creado,
          'updated': editadoCerca,
        },
        ActivityEntityType.team,
      )!;
      expect(dto.action, ActivityAction.created);
    });

    test('deduce edicion con marcas separadas', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{
          'id': 'x',
          'name': 'Registro',
          'created': creado,
          'updated': editadoLejos,
        },
        ActivityEntityType.team,
      )!;
      expect(dto.action, ActivityAction.updated);
      expect(dto.timestamp, DateTime.parse(editadoLejos));
    });

    test('usa created como marca cuando falta updated', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{
          'id': 'x',
          'name': 'Registro',
          'created': creado,
        },
        ActivityEntityType.team,
      )!;
      expect(dto.timestamp, DateTime.parse(creado));
    });

    test('toEntity conserva los cinco campos', () {
      final dto = ActivityItemDto.fromMap(
        <String, dynamic>{
          'id': 'x',
          'name': 'Registro',
          'created': creado,
          'updated': editadoLejos,
        },
        ActivityEntityType.event,
      )!;
      final entidad = dto.toEntity();
      expect(entidad.id, dto.id);
      expect(entidad.name, dto.name);
      expect(entidad.action, dto.action);
      expect(entidad.entityType, dto.entityType);
      expect(entidad.timestamp, dto.timestamp);
    });
  });
}
