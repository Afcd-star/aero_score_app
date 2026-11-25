// test/shared/presentation/widgets/aero/aero_sheet_test.dart
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AeroSheet no desborda a ancho estrecho', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AeroSheet(
            title: 'Prueba',
            child: const Text('Contenido'),
            onClose: () {},
          ),
        ),
      ),
    );
    expect(find.text('Prueba'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
