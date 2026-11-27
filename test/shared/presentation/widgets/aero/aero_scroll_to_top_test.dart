// test/shared/presentation/widgets/aero/aero_scroll_to_top_test.dart
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_scroll_to_top.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el control no desborda a ancho estrecho y nace oculto', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ListView.builder(
                controller: controller,
                itemCount: 40,
                itemBuilder: (_, i) => SizedBox(
                  height: 60,
                  child: Text('elemento $i'),
                ),
              ),
              AeroScrollToTop(controller: controller),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0,
    );
  });

  testWidgets('aparece pasado el umbral y devuelve al principio', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ListView.builder(
                controller: controller,
                itemCount: 60,
                itemBuilder: (_, i) => SizedBox(
                  height: 60,
                  child: Text('elemento $i'),
                ),
              ),
              AeroScrollToTop(controller: controller),
            ],
          ),
        ),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();

    expect(controller.offset, greaterThan(320));
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pumpAndSettle();

    expect(controller.offset, 0);
    expect(tester.takeException(), isNull);
  });
}
