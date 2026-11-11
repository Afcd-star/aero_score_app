// lib/src/features/auth/presentation/views/pending_approval_view.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/'
    'presentation/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vista que informa al usuario que su cuenta está pendiente de aprobación.
class PendingApprovalView extends ConsumerWidget {
  /// Crea la vista de cuenta pendiente.
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // ✅ EXTRAER USER CON TYPE SAFETY
    final user = switch (authState) {
      AuthSuccess(:final user) => user,
      _ => null,
    };

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.hourglass_empty,
                    size: 64,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 32),

                // ✅ TEXTO CON CONTRASTE ALTO
                Text(
                  'Cuenta Pendiente de Aprobación',
                  style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Text(
                  'Tu cuenta ha sido creada exitosamente, '
                  'pero aún está esperando la aprobación '
                  'de un administrador.',
                  style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // ✅ MOSTRAR INFO SOLO SI USER NO ES NULL
                if (user != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información de la cuenta:',
                          style: AppTextStyles
                              .baseTextTheme.labelLarge
                              ?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Usuario', user.username),
                        _buildInfoRow('Email', user.email),
                        _buildInfoRow('Estado', user.status),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade300,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '¿Qué debes hacer?',
                            style: AppTextStyles
                                .baseTextTheme.labelLarge
                                ?.copyWith(
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• Un administrador revisará tu solicitud\n'
                        '• Recibirás una notificación cuando sea aprobada\n'
                        '• Esto puede tomar de 24 a 48 horas',
                        style: AppTextStyles
                            .baseTextTheme.bodySmall
                            ?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      unawaited(
                        ref.read(authProvider.notifier).logout(),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.destructiveDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    // Actualizar estado de la cuenta
                    unawaited(
                      ref.read(authProvider.notifier).login('', ''),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Verificar Estado'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.mint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Protegido',
              style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
