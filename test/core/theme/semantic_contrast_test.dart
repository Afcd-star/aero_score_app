// test/core/theme/semantic_contrast_test.dart
import 'dart:math' as math;

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Umbral de contraste para texto pequeno, que usan las tres tallas del
/// badge (diez, doce y catorce puntos).
const double _kMinRatio = 4.5;

double _channel(double c) =>
    c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

double _luminance(Color color) {
  return 0.2126 * _channel(color.r) +
      0.7152 * _channel(color.g) +
      0.0722 * _channel(color.b);
}

double _ratio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

/// Punto de entrada de la suite de contraste de los tokens de estado.
///
/// El analizador no mide contraste, asi que esta prueba fija
/// numericamente que las variantes de estado del catalogo son legibles
/// en ambos modos, y que primary e info quedan pendientes de marca.
void main() {
  group('contraste WCAG de las variantes de estado', () {
    test('success es seguro en claro y en oscuro', () {
      expect(
        _ratio(AppColors.successLight, AppColors.successOnSolid),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(AppColors.successDark, AppColors.successOnSolid),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('warning es seguro en claro y en oscuro, sin condicion invertida', () {
      expect(
        _ratio(AppColors.warningSolid, AppColors.warningOnSolid),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('destructive es seguro con blanco en claro y en oscuro', () {
      expect(
        _ratio(AppColors.destructiveLight, Colors.white),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(AppColors.destructiveDark, Colors.white),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('secondary es seguro en claro y en oscuro', () {
      expect(
        _ratio(Colors.grey.shade100, AppColors.foregroundLight),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(AppColors.cardDark, AppColors.foregroundDark),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('primary e info con fucsia NO llegan al umbral, deuda de marca', () {
      expect(
        _ratio(AppColors.fuchsia, Colors.white),
        lessThan(_kMinRatio),
      );
    });
  });
}
