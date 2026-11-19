// lib/src/shared/presentation/widgets/admin/role_assignment_card.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/theme_helpers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/'
    'user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/'
    'user_role.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_alert_dialog.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_avatar.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_button.dart';
import 'package:flutter/material.dart';

/// Tarjeta de un usuario con su rol actual y la accion de cambiarlo.
///
/// Las superficies y los textos salen del esquema de tema, no de
/// constantes cableadas, para que sea legible en claro y en oscuro.
class RoleAssignmentCard extends StatelessWidget {
  /// Crea la tarjeta con el usuario, su rol y el catalogo disponible.
  const RoleAssignmentCard({
    required this.user,
    required this.currentRole,
    required this.availableRoles,
    required this.onRoleChanged,
    required this.onStatusChanged,
    super.key,
  });

  /// Usuario al que pertenece la tarjeta.
  final UserEntity user;

  /// Rol que el usuario tiene actualmente.
  final UserRole currentRole;

  /// Roles que se pueden asignar, ya filtrados por el consumidor.
  final List<UserRole> availableRoles;

  /// Accion solicitada al confirmar un rol distinto del actual.
  ///
  /// Devuelve el resultado de la escritura para que la tarjeta avise del
  /// fallo en lugar de descartarlo en silencio.
  final Future<bool> Function(String userId, UserRole newRole) onRoleChanged;

  /// Accion solicitada al aprobar la cuenta pendiente.
  final Future<bool> Function(String userId, String newStatus) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final roleColor = ThemeHelper.getRoleColor(currentRole, context);
    final primary = _primaryAction;
    final secondary = _secondaryAction;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AeroAvatar(fallbackText: user.fullName, radius: 25),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      '@${user.username}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: scheme.outlineVariant),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rol actual:',
                      style: text.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: roleColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        currentRole.label,
                        style: text.labelSmall?.copyWith(
                          color: roleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => _showRoleDialog(context),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Cambiar Rol'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.fuchsia,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado de la cuenta:',
                      style: text.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _statusLabel,
                      style: text.labelSmall?.copyWith(
                        color: _statusColor(scheme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (primary != null)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    AeroButton(
                      label: primary.label,
                      size: AeroButtonSize.sm,
                      variant: primary.destructive
                          ? AeroButtonVariant.destructive
                          : AeroButtonVariant.primary,
                      icon: Icon(
                        primary.destructive
                            ? Icons.block
                            : Icons.check_circle_outline,
                        size: 16,
                      ),
                      onPressed: () =>
                          unawaited(_runStatusAction(context, primary)),
                    ),
                    if (secondary != null)
                      AeroButton(
                        label: secondary.label,
                        size: AeroButtonSize.sm,
                        variant: AeroButtonVariant.destructive,
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () =>
                            unawaited(_runStatusAction(context, secondary)),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  String get _statusLabel {
    if (user.isApproved) {
      return 'Activo';
    }
    if (user.isPending) {
      return 'Pendiente de aprobación';
    }
    if (user.isInactive) {
      return 'Inactivo';
    }
    return 'Estado no reconocido';
  }

  Color _statusColor(ColorScheme scheme) {
    if (user.isApproved) {
      return scheme.primary;
    }
    if (user.isPending) {
      return scheme.tertiary;
    }
    if (user.isInactive) {
      return scheme.outline;
    }
    return scheme.error;
  }

  ({String label, String target, bool destructive})? get _primaryAction {
    if (user.isPending) {
      return (label: 'Aprobar', target: 'Active', destructive: false);
    }
    if (user.isApproved) {
      return (label: 'Desactivar', target: 'Inactive', destructive: true);
    }
    if (user.isInactive) {
      return (label: 'Reactivar', target: 'Active', destructive: false);
    }
    return null;
  }

  ({String label, String target, bool destructive})? get _secondaryAction {
    if (user.isPending) {
      return (label: 'Rechazar', target: 'Inactive', destructive: true);
    }
    return null;
  }

  Future<void> _runStatusAction(
    BuildContext context,
    ({String label, String target, bool destructive}) action,
  ) async {
    if (action.destructive) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AeroAlertDialog(
          title: '${action.label} cuenta',
          content: action.label == 'Rechazar'
              ? 'La solicitud se rechaza y la cuenta queda inactiva. '
                    'No se borra el registro y puedes reactivarla.'
              : 'La persona no podrá entrar a la app hasta que su cuenta '
                    'se reactive. Puedes reactivarla desde esta tarjeta.',
          icon: Icons.warning_amber_rounded,
          actions: <Widget>[
            AeroButton(
              label: 'Cancelar',
              variant: AeroButtonVariant.ghost,
              size: AeroButtonSize.sm,
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            AeroButton(
              label: 'Desactivar',
              variant: AeroButtonVariant.destructive,
              size: AeroButtonSize.sm,
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        return;
      }
    }
    if (!context.mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final ok = await onStatusChanged(user.id, action.target);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Cuenta actualizada.' : 'No se pudo actualizar la cuenta.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _assignRole(
    BuildContext dialogContext,
    UserRole selectedRole,
  ) async {
    if (selectedRole == currentRole) {
      Navigator.pop(dialogContext);
      return;
    }
    final messenger = ScaffoldMessenger.of(dialogContext);
    Navigator.pop(dialogContext);
    final ok = await onRoleChanged(user.id, selectedRole);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ok ? 'Rol actualizado.' : 'No se pudo actualizar el rol.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showRoleDialog(BuildContext context) {
    var selectedRole = currentRole;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: scheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asignar Rol',
                    style: text.titleMedium?.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.fullName,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
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
                    final roleColor = ThemeHelper.getRoleColor(role, context);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isSelected
                          ? roleColor.withValues(alpha: 0.1)
                          : scheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? roleColor : scheme.outlineVariant,
                          width: isSelected ? 1.5 : 1,
                        ),
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
                          role.label,
                          style: text.bodyMedium?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          role.description,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: roleColor)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    unawaited(_assignRole(dialogContext, selectedRole));
                  },
                  child: const Text('Asignar'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
