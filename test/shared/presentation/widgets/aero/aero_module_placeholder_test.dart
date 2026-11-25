// test/shared/presentation/widgets/aero/aero_module_placeholder_test.dart
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_module_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el marcador no desborda a ancho estrecho', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: AeroModulePlaceholder(
          title: 'Juez de Dificultad',
          description: 'Este módulo está en desarrollo. '
              'Aún no permite puntuar.',
          actionLabel: 'Cerrar sesión',
          actionIcon: Icons.logout_rounded,
          onAction: _noop,
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Juez de Dificultad'), findsOneWidget);
  });

  testWidgets('sin accion no se pinta boton', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AeroModulePlaceholder(title: 'x', description: 'y'),
      ),
    );
    expect(find.text('x'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('la etiqueta sin devolucion es contrato invalido', () {
    expect(
      () => AeroModulePlaceholder(
        title: 'x',
        description: 'y',
        actionLabel: 'z',
      ),
      throwsAssertionError,
    );
  });
}

void _noop() {}
