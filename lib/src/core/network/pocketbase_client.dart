// lib/src/core/network/pocketbase_client.dart
import 'package:aero_score_app/src/core/config/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

/// Proveedor del cliente PocketBase.
/// ✅ Reemplaza al Singleton legacy. Ciclo de vida gestionado por Riverpod.
/// ✅ URL inyectada dinámicamente desde AppEnvironment (Dev/Prod).
final pocketBaseProvider = Provider<PocketBase>((ref) {
  const env = AppEnvironment.devEmulator;
  final client = PocketBase(env.pbUrl);

  if (kDebugMode) {
    debugPrint('[PocketBase] ✅ Inicializado en ${env.pbUrl}');
  }

  ref.onDispose(() {
    client.authStore.clear();
    if (kDebugMode) debugPrint('[PocketBase]  Cliente liberado');
  });

  return client;
});

/// Stream reactivo del estado de autenticación.
/// ✅ Reemplaza a StreamController manual y notificaciones push imperativas.
/// ✅ Los Repositorios y Providers de UI escuchan este stream para reaccionar a login/logout.
final authStreamProvider = StreamProvider<bool>((ref) {
  final client = ref.watch(pocketBaseProvider);
  return client.authStore.onChange.map((_) => client.authStore.isValid);
});

/// Proveedor de conectividad (stub para Fase Offline).
/// ✅ Se integrará con connectivity_plus + StreamProvider en el siguiente paso.
final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Clase placeholder para gestión de red y sincronización.
class ConnectivityService {
  bool get isConnected => true; // TODO: Implementar stream real con connectivity_plus
  Future<bool> checkConnectivity() async => isConnected;
}
