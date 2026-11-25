// test/shared/presentation/widgets/aero/aero_progress_test.dart
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AeroProgress.circular no desborda a ancho estrecho', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: AeroProgress.circular())),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('AeroProgress.linear no desborda a ancho estrecho', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: AeroProgress.linear())),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
