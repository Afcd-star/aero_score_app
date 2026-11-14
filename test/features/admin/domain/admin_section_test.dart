// test/features/admin/domain/admin_section_test.dart
import 'package:aero_score_app/src/features/admin/domain/admin_section.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite de secciones.
void main() {
  group('AdminSection', () {
    test('el catalogo tiene las seis secciones del panel', () {
      expect(AdminSection.values.length, 6);
    });

    test('pathName coincide con el nombre del enum', () {
      for (final seccion in AdminSection.values) {
        expect(seccion.pathName, seccion.name);
      }
    });

    test('cada seccion tiene su etiqueta en espanol', () {
      const <AdminSection, String>{
        AdminSection.home: 'Inicio',
        AdminSection.teams: 'Equipos',
        AdminSection.events: 'Eventos',
        AdminSection.competitors: 'Competidores',
        AdminSection.rules: 'Reglamento',
        AdminSection.settings: 'Configuración',
      }.forEach((seccion, etiqueta) {
        expect(seccion.label, etiqueta);
      });
    });
  });
}
