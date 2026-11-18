// test/shared/presentation/widgets/aero/aero_narrow_layout_test.dart
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite de layout a ancho estrecho.
///
/// El analizador no detecta desbordes de render, asi que estas pruebas
/// existen para cazarlos. Se asserta que no se lanza excepcion y que el
/// texto sigue completo, para distinguir salto de linea de truncado.
void main() {
  testWidgets('la etiqueta del campo no desborda en ancho estrecho', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 60,
              child: AeroFormField(
                label: 'Contraseña',
                required: true,
                field: TextField(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Contraseña'), findsOneWidget);
  });

  testWidgets('el rotulo del boton no desborda en ancho estrecho', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 60,
              child: AeroButton(
                label: 'Iniciar sesión',
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
