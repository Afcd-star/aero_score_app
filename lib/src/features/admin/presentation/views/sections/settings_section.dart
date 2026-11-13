// lib/src/features/admin/presentation/views/sections/settings_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/presentation/views/'
    'sections/role_management_section.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/'
    'section_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Seccion de configuracion del panel de administracion.
///
/// Monta la gestion de roles, que pertenece a autenticacion, y el
/// resto de preferencias del sistema. Superficies y textos salen del
/// esquema de tema para ser legibles en claro y en oscuro.
class SettingsSection extends ConsumerWidget {
  /// Crea la seccion de configuracion.
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                const RoleManagementSection(),
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 24),
                Text(
                  'Otras Configuraciones',
                  style: text.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Perfil',
                  subtitle: 'Administrador del sistema',
                  onTap: () => _showComingSoon(context, 'Perfil'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  subtitle: 'Preferencias de alertas y recordatorios',
                  onTap: () => _showComingSoon(context, 'Notificaciones'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Seguridad',
                  subtitle: 'Contraseña y autenticación de dos factores',
                  onTap: () => _showComingSoon(context, 'Seguridad'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.language_outlined,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () => _showComingSoon(context, 'Idioma'),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: AeroButton(
                    label: 'Cerrar Sesión',
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    variant: AeroButtonVariant.destructive,
                    icon: const Icon(Icons.logout_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración',
                style: text.titleLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Administración general del sistema',
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.fuchsia, AppColors.coral],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleSmall?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature (Próximamente)'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
