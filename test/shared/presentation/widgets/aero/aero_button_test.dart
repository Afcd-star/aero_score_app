// test/shared/presentation/widgets/aero/aero_button_test.dart
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el boton circular de solo icono no desborda a ancho estrecho', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: AeroButton(
              icon: Icon(Icons.arrow_upward),
              iconOnly: true,
              width: 48,
              height: 48,
              borderRadius: 24,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
  });

  testWidgets('la etiqueta larga salta de linea y no se trunca', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const etiqueta = 'Registrar competidor en la categoría dúo mixto';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: AeroButton(label: etiqueta)),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(tester.widget<Text>(find.text(etiqueta)).maxLines, isNull);
  });
}
