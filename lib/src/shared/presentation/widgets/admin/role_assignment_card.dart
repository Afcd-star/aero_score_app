// lib/src/shared/presentation/widgets/admin/role_assignment_card.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/core/theme/theme_helpers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:flutter/material.dart';

class RoleAssignmentCard extends StatelessWidget {

  const RoleAssignmentCard({
    required this.user, required this.currentRole, required this.availableRoles, required this.onRoleChanged, super.key,
  });
  final UserEntity user;
  final UserRole currentRole;
  final List<UserRole> availableRoles;
  final Function(String userId, UserRole newRole) onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          // Header: Usuario
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.fuchsia, AppColors.coral]),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    user.firstName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: AppTextStyles.baseTextTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      '@${user.username}',
                      style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 16),
          
          // Footer: Rol actual + Botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rol actual:',
                    style: AppTextStyles.baseTextTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      // ✅ CORREGIDO: ThemeHelper requiere context
                      color: ThemeHelper.getRoleColor(currentRole, context).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ThemeHelper.getRoleColor(currentRole, context).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      // ✅ CORREGIDO: Usar enum.label en lugar de método privado
                      currentRole.label,
                      style: AppTextStyles.baseTextTheme.labelSmall?.copyWith(
                        color: ThemeHelper.getRoleColor(currentRole, context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _showRoleDialog(context),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Cambiar Rol'),
                style: TextButton.styleFrom(foregroundColor: AppColors.fuchsia),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRoleDialog(BuildContext context) {
    var selectedRole = currentRole;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surfaceBase,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asignar Rol', style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(user.fullName, style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableRoles.length,
              itemBuilder: (context, index) {
                final role = availableRoles[index];
                final isSelected = selectedRole == role;
                // ✅ CORREGIDO: Usar ThemeHelper con context
                final roleColor = ThemeHelper.getRoleColor(role, context);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isSelected ? roleColor.withValues(alpha: 0.1) : AppColors.surfaceElevated,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isSelected ? roleColor : AppColors.borderSubtle, width: isSelected ? 1.5 : 1),
                  ),
                  child: ListTile(
                    onTap: () => setDialogState(() => selectedRole = role),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.badge, color: roleColor),
                    ),
                    title: Text(
                      // ✅ CORREGIDO: Usar enum.label
                      role.label,
                      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      // ✅ CORREGIDO: Usar enum.description
                      role.description,
                      style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    trailing: isSelected ? Icon(Icons.check_circle, color: roleColor) : null,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary))),
            FilledButton(
              onPressed: () {
                if (selectedRole != currentRole) {
                  onRoleChanged(user.id, selectedRole);
                }
                Navigator.pop(context);
              },
              child: const Text('Asignar'),
            ),
          ],
        ),
      ),
    );
  }
}