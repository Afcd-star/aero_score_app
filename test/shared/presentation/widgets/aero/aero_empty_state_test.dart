import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite del estado vacio.
void main() {
  group('AeroEmptyState', () {
    testWidgets('muestra titulo y mensaje', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AeroEmptyState(
              icon: Icons.people_outline,
              title: 'No hay usuarios',
              message: 'Registra el primero',
            ),
          ),
        ),
      );
      expect(find.text('No hay usuarios'), findsOneWidget);
      expect(find.text('Registra el primero'), findsOneWidget);
    });

    testWidgets('omite mensaje y accion cuando no se pasan', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AeroEmptyState(
              icon: Icons.search_off,
              title: 'Sin resultados',
            ),
          ),
        ),
      );
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('muestra la accion cuando se pasa', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AeroEmptyState(
              icon: Icons.people_outline,
              title: 'No hay usuarios',
              action: TextButton(
                onPressed: () {},
                child: const Text('Crear'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Crear'), findsOneWidget);
    });
  });
}
