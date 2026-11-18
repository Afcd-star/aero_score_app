import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite de la barra de filtros.
void main() {
  group('AeroFilterBar', () {
    testWidgets('muestra el titulo y todas las opciones', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AeroFilterBar(
              label: 'Estado',
              options: const <String>['Todos', 'Pendientes', 'Activos'],
              selectedIndex: 0,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Estado'), findsOneWidget);
      expect(find.text('Pendientes'), findsOneWidget);
      expect(find.text('Activos'), findsOneWidget);
    });

    testWidgets('avisa el indice pulsado', (tester) async {
      int? recibido;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AeroFilterBar(
              options: const <String>['Todos', 'Pendientes'],
              selectedIndex: 0,
              onChanged: (i) => recibido = i,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Pendientes'));
      expect(recibido, 1);
    });

    testWidgets('no cambia sola, el indice lo decide el consumidor', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AeroFilterBar(
              options: const <String>['Todos', 'Pendientes'],
              selectedIndex: 0,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.tap(find.text('Pendientes'));
      await tester.pump();
      final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Pendientes'),
      );
      expect(chip.selected, isFalse);
    });
  });
}
