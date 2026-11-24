// lib/src/shared/presentation/views/splash_view.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de arranque con el arte de marca a sangre.
///
/// Es la capa rica de la splash, montada como ruta inicial del
/// enrutador. La capa nativa, con color y logo, cubre el negro anterior
/// al motor. Esta capa pinta la cinta de degradado a sangre con el logo
/// real compuesto encima y un fundido de entrada, meseta y salida. El
/// fondo es oscuro fijo, asi que el texto del logo usa claro fijo,
/// conforme a la regla de acoplamiento, y la barra de estado hereda los
/// iconos claros globales.
class SplashView extends StatefulWidget {
  /// Crea la pantalla de arranque.
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  static const int _totalMillis = 2500;
  static const int _fadeInWeight = 200;
  static const int _plateauWeight = 600;
  static const int _fadeOutWeight = 200;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMillis),
    );
    _fade = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: _fadeInWeight.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1),
          weight: _plateauWeight.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: _fadeOutWeight.toDouble(),
        ),
      ],
    ).animate(_controller);
    _controller.addStatusListener(_onStatus);
    unawaited(_controller.forward());
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatus)
      ..dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/splash_ribbons_portrait.png',
              fit: BoxFit.cover,
            ),
            Align(
              alignment: const Alignment(0, -0.45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo_sin_fondo.png',
                    width: 132,
                    height: 132,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AeroScore',
                    style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
