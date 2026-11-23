// lib/src/features/scoring/presentation/views/judge_principal_placeholder_view.dart
import 'dart:async';

import 'package:aero_score_app/src/'
    'core/theme/app_colors.dart';
import 'package:aero_score_app/src/'
    'core/theme/text_styles.dart';
import 'package:aero_score_app/src/'
    'features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/'
    'features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/'
    'shared/presentation/widgets/aero/aero_background.dart';
import 'package:aero_score_app/src/'
    'shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Vista provisional del módulo de juez.
///
/// Sirve a los cuatro roles de juez mientras el módulo de puntuación no
/// está construido. El título sale de la etiqueta en español del catálogo
/// de identidad, para no duplicar copia. Conserva la palabra principal en
/// su nombre por historia, y está destinada a ser absorbida por el
/// marcador de módulo del catálogo cuando se audite shared, así que no se
/// invierte en renombrarla ahora.
class JudgePrincipalPlaceholderView extends ConsumerWidget {
  /// Crea la vista provisional para el rol de juez indicado.
  const JudgePrincipalPlaceholderView({required this.role, super.key});

  /// Rol de juez al que se muestra el módulo pendiente.
  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: AeroBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    size: 64,
                    color: AppColors.fuchsia,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    role.label,
                    style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Este módulo está en desarrollo. '
                    'Aún no permite $_pendingAction.',
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AeroButton(
                    label: 'Cerrar sesión',
                    onPressed: () {
                      unawaited(_signOut(context, ref));
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Acción que el rol todavía no puede ejecutar, con el vocabulario de
  /// la federación.
  String get _pendingAction => switch (role) {
    UserRole.judgeP => 'validar puntuaciones',
    _ => 'puntuar',
  };
}

Future<void> _signOut(BuildContext context, WidgetRef ref) async {
  await ref.read(authProvider.notifier).logout();
  if (context.mounted) {
    context.go('/login');
  }
}
