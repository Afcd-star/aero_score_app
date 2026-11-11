// lib/src/features/scoring/presentation/views/judge_principal_placeholder_view.dart
import 'dart:async';
import 'package:aero_score_app/src/'
    'core/theme/app_colors.dart';
import 'package:aero_score_app/src/'
    'core/theme/text_styles.dart';
import 'package:aero_score_app/src/'
    'features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/'
    'shared/presentation/widgets/aero/aero_background.dart';
import 'package:aero_score_app/src/'
    'shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Vista provisional del módulo de juez principal.
class JudgePrincipalPlaceholderView extends ConsumerWidget {
  /// Crea la vista provisional.
  const JudgePrincipalPlaceholderView({super.key});

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
                    'Juez principal',
                    style: AppTextStyles.baseTextTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Este módulo está en desarrollo. '
                    'Aún no permite validar calificaciones.',
                    style: AppTextStyles.baseTextTheme.bodyMedium,
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
}

Future<void> _signOut(BuildContext context, WidgetRef ref) async {
  await ref.read(authProvider.notifier).logout();
  if (context.mounted) {
    context.go('/login');
  }
}
