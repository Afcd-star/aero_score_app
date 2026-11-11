// lib/main.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/core/routes/app_routes.dart';
import 'package:aero_score_app/src/core/theme/app_theme.dart';
import 'package:aero_score_app/src/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Punto de entrada de la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const AeroScoreApp(),
    ),
  );
}

/// Widget raíz de AeroScore.
class AeroScoreApp extends ConsumerWidget {
  /// Crea el widget raíz.
  const AeroScoreApp({super.key});

  /// Construye la interfaz raíz.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: themeMode == ThemeMode.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        title: 'AeroScore',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: router,
        locale: const Locale('es', 'ES'),
        supportedLocales: const [
          Locale('es', 'ES'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
