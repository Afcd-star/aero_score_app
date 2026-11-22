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
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Punto de entrada de la suite de contraste de las variantes suaves y de
/// los pares de superficie de control.
///
/// El analizador no mide contraste, asi que esta prueba fija
/// numericamente que cada par de tinte suave es legible en ambos modos,
/// que la pestana de acceso es legible en ambos modos, y que primary con
/// fucsia queda pendiente del frente de marca.
void main() {
  group('contraste WCAG de las variantes de tinte suave', () {
    test('success es seguro en claro y en oscuro', () {
      expect(
        _ratio(
          AppColors.successContainerLight,
          AppColors.successOnContainerLight,
        ),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(
          AppColors.successContainerDark,
          AppColors.successOnContainerDark,
        ),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('info es seguro en claro y en oscuro', () {
      expect(
        _ratio(AppColors.infoContainerLight, AppColors.infoOnContainerLight),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(AppColors.infoContainerDark, AppColors.infoOnContainerDark),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('warning es seguro en claro y en oscuro, sin condicion invertida', () {
      expect(
        _ratio(
          AppColors.warningContainerLight,
          AppColors.warningOnContainerLight,
        ),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(
          AppColors.warningContainerDark,
          AppColors.warningOnContainerDark,
        ),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });

    test('destructive es seguro en claro y en oscuro', () {
      expect(
        _ratio(
          AppColors.destructiveContainerLight,
          AppColors.destructiveOnContainerLight,
        ),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(
          AppColors.destructiveContainerDark,
          AppColors.destructiveOnContainerDark,
        ),
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

    test('primary con fucsia NO llega al umbral, deuda de marca', () {
      expect(_ratio(AppColors.fuchsia, Colors.white), lessThan(_kMinRatio));
    });
  });

  group('contraste WCAG de la pestana de acceso', () {
    test('la pestana es segura en claro y en oscuro', () {
      expect(
        _ratio(AppColors.mutedLight, AppColors.foregroundLight),
        greaterThanOrEqualTo(_kMinRatio),
      );
      expect(
        _ratio(AppColors.mutedDark, AppColors.mutedForegroundDark),
        greaterThanOrEqualTo(_kMinRatio),
      );
    });
  });
}
