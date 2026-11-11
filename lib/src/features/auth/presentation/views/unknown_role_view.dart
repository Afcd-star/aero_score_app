// lib/src/features/auth/presentation/views/unknown_role_view.dart
import 'dart:async';
import 'package:aero_score_app/src/'
    'core/theme/app_colors.dart';
import 'package:aero_score_app/src/'
    'core/theme/text_styles.dart';
import 'package:aero_score_app/src/'
    'features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/'
    'features/auth/presentation/providers/auth_notifier.dart';
import 'package:aero_score_app/src/'
    'shared/presentation/widgets/aero/aero_background.dart';
import 'package:aero_score_app/src/'
    'shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Vista para un usuario autenticado con rol no reconocido.
class UnknownRoleView extends ConsumerStatefulWidget {
  /// Crea la vista de rol no reconocido.
  const UnknownRoleView({super.key});

  @override
  ConsumerState<UnknownRoleView> createState() =>
      _UnknownRoleViewState();
}

class _UnknownRoleViewState extends ConsumerState<UnknownRoleView> {
  @override
  void initState() {
    super.initState();
    unawaited(_reportIncident());
  }

  Future<void> _reportIncident() async {
    final authState = ref.read(authProvider);
    final user = switch (authState) {
      AuthSuccess(:final user) => user,
      _ => null,
    };

    if (user == null || !kDebugMode) {
      return;
    }

    debugPrint(
      'UnknownRoleView incident user=${user.id} '
      'role=${user.role.value}',
    );
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Icons.lock_outline,
                    size: 64,
                    color: AppColors.fuchsia,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rol no reconocido',
                    style: AppTextStyles.baseTextTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu cuenta no tiene un rol válido asignado. '
                    'Contacta al administrador del sistema.',
                    style: AppTextStyles.baseTextTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AeroButton(
                    label: 'Cerrar sesión',
                    onPressed: () {
                      unawaited(_logout());
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
