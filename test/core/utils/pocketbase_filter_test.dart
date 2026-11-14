// test/core/utils/pocketbase_filter_test.dart
import 'package:aero_score_app/src/core/utils/pocketbase_filter.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite del escape de filtros.
void main() {
  group('escapeFilterValue', () {
    test('la cadena vacia queda vacia', () {
      expect(escapeFilterValue(''), '');
    });

    test('escapa la comilla doble', () {
      expect(escapeFilterValue('"'), r'\"');
    });

    test('escapa la barra invertida', () {
      expect(escapeFilterValue(r'\'), r'\\');
    });

    test('escapa comilla dentro de texto', () {
      expect(escapeFilterValue('a"b'), r'a\"b');
    });

    test('escapa barra dentro de texto', () {
      expect(escapeFilterValue(r'a\b'), r'a\\b');
    });

    test('la barra se escapa antes que la comilla, sin doblarse', () {
      expect(escapeFilterValue(r'a\"b'), r'a\\\"b');
    });

    test('neutraliza un intento de cerrar el filtro', () {
      final escaped = escapeFilterValue('a" || deleted=true || "b');
      expect(escaped, r'a\" || deleted=true || \"b');
    });
  });
}
