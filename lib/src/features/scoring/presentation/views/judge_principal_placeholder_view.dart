// lib/src/features/scoring/presentation/views/judge_principal_placeholder_view.dart
import 'dart:async';

import 'package:aero_score_app/src/'
    'features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/'
    'features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_module_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Vista provisional del módulo de juez.
///
/// Sirve a los cuatro roles de juez mientras el módulo de puntuación no
/// está construido. El título sale de la etiqueta en español del catálogo
/// de identidad, para no duplicar copia. Conserva la palabra principal en
/// su nombre por historia. Su casco y su contenido viven ahora en el
/// marcador del catálogo, así que esta vista es solo el adaptador que
/// aporta título, descripción y acción.
class JudgePrincipalPlaceholderView extends ConsumerWidget {
  /// Crea la vista provisional para el rol de juez indicado.
  const JudgePrincipalPlaceholderView({required this.role, super.key});

  /// Rol de juez al que se muestra el módulo pendiente.
  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AeroModulePlaceholder(
      title: role.label,
      description:
          'Este módulo está en desarrollo. '
          'Aún no permite $_pendingAction.',
      icon: Icons.verified_outlined,
      actionLabel: 'Cerrar sesión',
      actionIcon: Icons.logout_rounded,
      onAction: () => unawaited(_signOut(context, ref)),
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
