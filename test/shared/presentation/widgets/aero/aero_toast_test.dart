// test/shared/presentation/widgets/aero/aero_toast_test.dart
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el aviso no desborda a ancho estrecho', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => AeroToast.success(
                  context,
                  message: 'Guardado exitoso',
                ),
                child: const Text('Mostrar'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mostrar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Guardado exitoso'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la etiqueta sin devolución lanza aserción', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            expect(
              () => AeroToast.info(
                context,
                message: 'x',
                actionLabel: 'y',
              ),
              throwsAssertionError,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
