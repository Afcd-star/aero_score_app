// test/shared/presentation/widgets/aero/aero_form_scaffold_test.dart
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_form_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el andamiaje no desborda a ancho estrecho', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AeroFormScaffold(
            onBack: () {},
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                20,
                (i) => SizedBox(height: 48, child: Text('campo $i')),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Volver a la lista'), findsOneWidget);
  });

  testWidgets('el retorno no se mueve al desplazar el cuerpo', (tester) async {
    tester.view.physicalSize = const Size(360, 480);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AeroFormScaffold(
            onBack: () {},
            body: Column(
              children: List.generate(
                30,
                (i) => SizedBox(height: 48, child: Text('campo $i')),
              ),
            ),
          ),
        ),
      ),
    );

    final antes = tester.getTopLeft(find.text('Volver a la lista'));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    final despues = tester.getTopLeft(find.text('Volver a la lista'));

    expect(despues, antes);
    expect(tester.takeException(), isNull);
  });
}
