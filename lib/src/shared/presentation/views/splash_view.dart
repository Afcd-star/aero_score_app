// lib/src/shared/presentation/views/splash_view.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de arranque con el arte de marca a sangre.
///
/// Es la capa rica de la splash, montada como ruta inicial del
/// enrutador. La capa nativa, con color y logo centrado, cubre el negro
/// anterior al motor.
///
/// El conjunto de marca va centrado, igual que en la capa nativa, para
/// que no salte de posicion entre capas. Detras lleva un velo radial a
/// sangre que oscurece el arte solo en la zona central, de modo que el
/// cruce de cintas no se lleve el contraste del logo ni del nombre. El
/// velo es a sangre y no una caja ajustada, porque una caja rectangular
/// recortaria su degradado en el borde y dejaria un canto duro.
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

  /// Opacidad del velo en su meseta central, sobre el arte.
  static const double _veilOpacity = 0.82;

  /// Radio del velo como fraccion del lado corto de la pantalla.
  static const double _veilRadius = 0.55;

  /// Fraccion del radio donde termina la meseta opaca.
  static const double _veilPlateau = 0.5;

  /// Lado del logo de marca en la pantalla de arranque.
  static const double _logoSize = 156;

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
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: _veilRadius,
                  colors: [
                    AppColors.backgroundBase.withValues(alpha: _veilOpacity),
                    AppColors.backgroundBase.withValues(alpha: _veilOpacity),
                    AppColors.backgroundBase.withValues(alpha: 0),
                  ],
                  stops: const [0, _veilPlateau, 1],
                ),
              ),
              child: const SizedBox.expand(),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo_sin_fondo.png',
                    width: _logoSize,
                    height: _logoSize,
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
