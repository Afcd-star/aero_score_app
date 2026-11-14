// test/features/teams/domain/entities/team_entity_test.dart
import 'package:aero_score_app/src/features/teams/domain/entities/'
    'team_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite de la entidad de equipo.
void main() {
  TeamEntity valid() => const TeamEntity(
        id: 't1',
        name: 'Estrellas Ritmicas',
        university: 'Universidad de La Habana',
        email: 'contacto@uh.cu',
        faculty: 'FIO',
        coachId: 'c1',
        coachName: 'Ana Lopez',
        competitorIds: <String>['k1', 'k2'],
      );

  group('TeamEntity.validate', () {
    test('un equipo completo pasa', () {
      expect(valid().validate(), isNull);
    });

    test('exige la relacion del entrenador, no la proyeccion', () {
      const sinCoachId = TeamEntity(
        id: 't1',
        name: 'Estrellas Ritmicas',
        university: 'Universidad de La Habana',
        email: 'contacto@uh.cu',
        faculty: 'FIO',
        coachName: 'Ana Lopez',
        competitorIds: <String>['k1', 'k2'],
      );
      expect(sinCoachId.validate(), 'El entrenador es requerido');
    });

    test('acepta entrenador con coachName nulo si hay coachId', () {
      const sinNombre = TeamEntity(
        id: 't1',
        name: 'Estrellas Ritmicas',
        university: 'Universidad de La Habana',
        email: 'contacto@uh.cu',
        faculty: 'FIO',
        coachId: 'c1',
        competitorIds: <String>['k1', 'k2'],
      );
      expect(sinNombre.validate(), isNull);
    });

    test('exige al menos un competidor', () {
      final vacio = valid().copyWith(competitorIds: const <String>[]);
      expect(vacio.validate(), 'El equipo debe tener al menos un competidor');
    });

    test('rechaza facultad en blanco', () {
      expect(valid().copyWith(faculty: '  ').validate(), 'La facultad es requerida');
    });

    test('rechaza email invalido', () {
      expect(valid().copyWith(email: 'no-es-email').validate(), 'Email de contacto inválido');
    });

    test('rechaza nombre corto', () {
      expect(valid().copyWith(name: 'Ab').validate(), 'El nombre del equipo debe tener al menos 3 caracteres');
    });
  });

  group('TeamEntity equality', () {
    test('dos equipos identicos son iguales', () {
      expect(valid(), valid());
      expect(valid().hashCode, valid().hashCode);
    });

    test('un cambio de estado los hace distintos', () {
      expect(valid().copyWith(status: 'inactive'), isNot(valid()));
    });

    test('un cambio del roster los hace distintos', () {
      expect(
        valid().copyWith(competitorIds: const <String>['k1']),
        isNot(valid()),
      );
    });

    test('la proyeccion desnormalizada no afecta la igualdad', () {
      expect(valid().copyWith(coachName: 'Otro Nombre'), valid());
    });

    test('las marcas de tiempo no afectan la igualdad', () {
      expect(
        valid().copyWith(created: DateTime.utc(2026), updated: DateTime.utc(2026)),
        valid(),
      );
    });

    test('copyWith no nulifica campos opcionales, limitacion conocida', () {
      final original = valid();
      final intentado = original.copyWith();
      expect(intentado.coachId, 'c1');
    });
  });
}
