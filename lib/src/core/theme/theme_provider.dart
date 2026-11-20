// lib/src/core/theme/theme_provider.dart
import 'dart:async';

import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Clave bajo la que se guarda el modo de tema elegido.
const String _kThemeModeKey = 'theme_mode';

/// Traduce una clave guardada a un modo de tema valido.
///
/// Un valor ausente o desconocido cae en el sistema, que es el
/// predeterminado seguro.
ThemeMode _parseThemeMode(String? raw) {
  return switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

/// Notificador del modo de tema de la aplicacion.
///
/// Lee el modo guardado al construirse y lo persiste en cada cambio, asi
/// que la eleccion sobrevive al reinicio de la app. Sustituye el
/// interruptor binario anterior, que no podia representar el sistema.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// Construye el estado desde el modo guardado en preferencias.
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPrefsProvider);
    return _parseThemeMode(prefs.getString(_kThemeModeKey));
  }

  /// Fija el modo de tema y lo guarda en preferencias.
  void setThemeMode(ThemeMode mode) {
    state = mode;
    final prefs = ref.read(sharedPrefsProvider);
    final stored = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    unawaited(prefs.setString(_kThemeModeKey, stored));
  }
}

/// Proveedor global del modo de tema.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
