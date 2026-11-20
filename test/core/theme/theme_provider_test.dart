// test/core/theme/theme_provider_test.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Punto de entrada de la suite del modo de tema persistente.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> container0() async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('ThemeModeNotifier', () {
    test('sin valor guardado arranca en sistema', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final container = await container0();
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('lee el modo guardado al construirse', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'theme_mode': 'dark',
      });
      final container = await container0();
      expect(container.read(themeModeProvider), ThemeMode.dark);
    });

    test('un valor desconocido cae en sistema', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'theme_mode': 'azure',
      });
      final container = await container0();
      expect(container.read(themeModeProvider), ThemeMode.system);
    });

    test('cambiar el modo lo persiste', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);
      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      await Future<void>.delayed(Duration.zero);
      expect(prefs.getString('theme_mode'), 'light');
      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });
}
