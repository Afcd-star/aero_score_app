// lib/src/core/config/environment.dart (versión corregida)
import 'package:flutter/foundation.dart';

enum Flavor { dev, staging, prod }

enum AppEnvironment {
  devEmulator._(
    flavor: Flavor.dev,
    pbUrl: 'http://10.0.2.2:8090',
    isDebug: true,
  ),
  devPhysical._(
    flavor: Flavor.dev,
    pbUrl: 'http://192.168.1.50:8090',
    isDebug: true,
  ),
  prod._(
    flavor: Flavor.prod,
    pbUrl: 'https://tu-pb-server.com',
  );


  const AppEnvironment._({
    required this.flavor,
    required this.pbUrl,
    this.isDebug = false,
  });
  final Flavor flavor;
  final String pbUrl;
  final bool isDebug;
  
  /// Helper para obtener el environment actual
  static AppEnvironment get current {
    if (kReleaseMode) return prod;
    return devEmulator; // o devPhysical según tu setup
  }
}
