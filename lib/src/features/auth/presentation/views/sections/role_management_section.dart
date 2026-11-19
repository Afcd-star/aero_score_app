// lib/src/features/auth/presentation/views/sections/role_management_section.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/'
    'role_management_provider.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/'
    'role_assignment_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/'
    'section_card.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_alert_dialog.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_empty_state.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_filter_bar.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Etiquetas del filtro de estado, en su orden de aparicion.
const List<String> _statusLabels = <String>[
  'Todos',
  'Pendientes',
  'Activos',
  'Inactivos',
];

/// Valores de estado por posicion del filtro. Nulo significa todos.
const List<String?> _statusValues = <String?>[
  null,
  'Pending Approval',
  'Active',
  'Inactive',
];

/// Roles filtrables, con todos al frente representado por nulo.
final List<UserRole?> _roleValues = <UserRole?>[
  null,
  ...UserRole.values.where((r) => r.isKnown),
];

/// Seccion de gestion de usuarios, roles y estados de cuenta.
///
/// Pantalla propia del panel, al mismo nivel que equipos y eventos, con
/// encabezado, filtros en cliente, busqueda y accion de refrescar. Los
/// filtros viven en el notificador, no en el widget, para que sobrevivan
/// a la reconstruccion y se puedan probar sin interfaz.
class RoleManagementSection extends ConsumerStatefulWidget {
  /// Crea la seccion de gestion de usuarios.
  const RoleManagementSection({super.key});

  @override
  ConsumerState<RoleManagementSection> createState() =>
      _RoleManagementSectionState();
}

class _RoleManagementSectionState extends ConsumerState<RoleManagementSection> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      ref
          .read(roleManagementProvider.notifier)
          .updateSearchQuery(_searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roleManagementProvider);
    final notifier = ref.read(roleManagementProvider.notifier);
    final visible = state.filteredUsers;
    final pendingView = state.statusFilter == 'Pending Approval';
    final inactiveView = state.statusFilter == 'Inactive';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(state, visible.length),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 16),
            AeroFilterBar(
              label: 'Estado de la cuenta',
              options: _statusLabels,
              selectedIndex: _statusIndex(state.statusFilter),
              onChanged: (i) => notifier.updateStatusFilter(_statusValues[i]),
            ),
            const SizedBox(height: 12),
            AeroFilterBar(
              label: 'Rol',
              options: _roleValues.map((r) => r?.label ?? 'Todos').toList(),
              selectedIndex: _roleIndex(state.roleFilter),
              onChanged: (i) => notifier.updateRoleFilter(_roleValues[i]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AeroButton(
                label: 'Refrescar listado',
                icon: const Icon(Icons.refresh, size: 18),
                variant: AeroButtonVariant.outline,
                onPressed: () => unawaited(notifier.loadUsers()),
              ),
            ),
            const SizedBox(height: 20),
            if (pendingView) ...[
              Row(
                children: <Widget>[
                  Expanded(
                    child: AeroButton(
                      label: 'Aprobar (${visible.length})',
                      size: AeroButtonSize.sm,
                      onPressed: visible.isEmpty
                          ? null
                          : () => unawaited(
                              _runBulk(
                                context,
                                notifier,
                                visible,
                                'Active',
                                'Aprobar',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AeroButton(
                      label: 'Rechazar (${visible.length})',
                      size: AeroButtonSize.sm,
                      variant: AeroButtonVariant.destructive,
                      onPressed: visible.isEmpty
                          ? null
                          : () => unawaited(
                              _runBulk(
                                context,
                                notifier,
                                visible,
                                'Inactive',
                                'Rechazar',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (inactiveView) ...[
              SizedBox(
                width: double.infinity,
                child: AeroButton(
                  label: 'Reactivar (${visible.length})',
                  size: AeroButtonSize.sm,
                  onPressed: visible.isEmpty
                      ? null
                      : () => unawaited(
                          _runBulk(
                            context,
                            notifier,
                            visible,
                            'Active',
                            'Reactivar',
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            state.users.when(
              loading: _buildSkeleton,
              error: (err, _) => _buildErrorState(
                err.toString(),
                () => unawaited(notifier.loadUsers()),
              ),
              data: (loaded) => _buildBody(
                loaded: loaded,
                visible: visible,
                notifier: notifier,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _statusIndex(String? value) {
    final i = _statusValues.indexOf(value);
    return i < 0 ? 0 : i;
  }

  int _roleIndex(UserRole? value) {
    final i = _roleValues.indexOf(value);
    return i < 0 ? 0 : i;
  }

  Widget _buildHeader(RoleManagementState state, int visibleCount) {
    final scheme = Theme.of(context).colorScheme;
    final total = state.users.value?.length ?? 0;
    final detail = state.users.isLoading
        ? 'Cargando usuarios...'
        : '$visibleCount de $total usuario(s)';

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.getGlowGradient(),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.manage_accounts,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usuarios',
                style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                detail,
                style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _searchCtrl,
      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, email o usuario...',
        hintStyle: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(Icons.search, color: scheme.onSurfaceVariant),
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.fuchsia,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: List<Widget>.generate(
        3,
        (i) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: AeroSkeleton(height: 180),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.error),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: scheme.error, size: 32),
          const SizedBox(height: 8),
          Text(
            'Error: $error',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: scheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 12),
          AeroButton(
            label: 'Reintentar',
            icon: const Icon(Icons.refresh, size: 18),
            variant: AeroButtonVariant.outline,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }

  Widget _buildBody({
    required List<UserEntity> loaded,
    required List<UserEntity> visible,
    required RoleManagementNotifier notifier,
  }) {
    if (loaded.isEmpty) {
      return AeroEmptyState(
        icon: Icons.person_off_outlined,
        title: _searchCtrl.text.isNotEmpty
            ? 'No se encontraron resultados'
            : 'No hay usuarios registrados',
        message: _searchCtrl.text.isNotEmpty
            ? 'Prueba con otro nombre, correo o usuario.'
            : 'Los usuarios aparecen aqui al registrarse en la app.',
      );
    }
    if (visible.isEmpty) {
      return const AeroEmptyState(
        icon: Icons.filter_alt_off_outlined,
        title: 'Ningun usuario coincide con los filtros',
        message: 'Cambia el estado o el rol para ver mas usuarios.',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: visible.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = visible[index];
        return RoleAssignmentCard(
          user: user,
          currentRole: user.role,
          availableRoles: UserRole.values
              .where((role) => role.isKnown)
              .toList(),
          onRoleChanged: notifier.updateUserRole,
          onStatusChanged: notifier.updateUserStatus,
        );
      },
    );
  }

  Future<void> _runBulk(
    BuildContext context,
    RoleManagementNotifier notifier,
    List<UserEntity> targets,
    String target,
    String verb,
  ) async {
    final destructive = target == 'Inactive';
    final verb = destructive ? 'Rechazar' : 'Aprobar';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AeroAlertDialog(
        title: '$verb ${targets.length} cuenta(s)',
        content: destructive
            ? 'Las cuentas quedan inactivas y no podrán entrar a la app. '
                  'No se borra ningún registro y puedes reactivarlas.'
            : 'Las cuentas quedan activas y podrán entrar a la app.',
        icon: destructive
            ? Icons.warning_amber_rounded
            : Icons.check_circle_outline,
        actions: <Widget>[
          AeroButton(
            label: 'Cancelar',
            variant: AeroButtonVariant.ghost,
            size: AeroButtonSize.sm,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          AeroButton(
            label: verb,
            size: AeroButtonSize.sm,
            variant: destructive
                ? AeroButtonVariant.destructive
                : AeroButtonVariant.primary,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final outcome = await notifier.updateUsersStatus(
      targets,
      target,
    );
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${outcome.updated} actualizada(s), ${outcome.failed} '
            'fallida(s), ${outcome.skipped} omitida(s).',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
