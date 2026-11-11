// lib/src/core/di/dependency_injection.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proveedor global del cliente de PocketBase.
final Provider<PocketBase> pocketBaseClientProvider =
    Provider<PocketBase>((ref) {
  const pbUrl = String.fromEnvironment(
    'POCKETBASE_URL',
    defaultValue: 'http://10.0.2.2:8090',
  );
  final client = PocketBase(pbUrl);

  final prefs = ref.read(sharedPrefsProvider);
  final token = prefs.getString('pb_auth_token') ?? '';
  final userId = prefs.getString('pb_auth_user_id') ?? '';

  if (token.isNotEmpty && userId.isNotEmpty) {
    client.authStore.save(token, null);
  }

  return client;
});

/// Proveedor global de SharedPreferences.
final Provider<SharedPreferences> sharedPrefsProvider =
    Provider<SharedPreferences>((_) {
  throw UnimplementedError(
    'sharedPrefsProvider debe ser sobreescrito en main.dart '
    'con SharedPreferences.getInstance()',
  );
});

/// Proveedor opcional de configuración por entorno.
// final environmentProvider =
//     Provider<AppEnvironment>((ref) => AppEnvironment.prod);
