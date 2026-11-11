// lib/src/features/admin/presentation/views/sections/settings_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/sections/role_management_section.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/section_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ CARD BLANCA ENVOLVENTE (consistente con otras secciones)
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),

                // ✅ Gestión de Roles (ya migrada a Riverpod)
                const RoleManagementSection(),
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 24),

                // ✅ Otras Configuraciones
                Text(
                  'Otras Configuraciones',
                  style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
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

                // ✅ Cierre de Sesión (conexión Riverpod segura)
                SizedBox(
                  width: double.infinity,
                  child: AeroButton(
                    label: 'Cerrar Sesión',
                    onPressed: () async {
                      // ✅ Invalida sesión y limpia tokens
                      await ref.read(authProvider.notifier).logout();
                      // ✅ Navega solo si el widget aún está montado
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
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.grey, Colors.grey],
            ),
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
                style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Administración general del sistema',
                style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Fallback seguro si AppColors.mutedLight/Dark no existen en tu tema actual
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceElevated
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
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
                      style: AppTextStyles.baseTextTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
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
        backgroundColor: AppColors.mutedDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}