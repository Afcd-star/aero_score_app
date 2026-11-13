// lib/src/features/auth/presentation/views/sections/role_management_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/role_management_provider.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/role_assignment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleManagementSection extends ConsumerStatefulWidget {
  const RoleManagementSection({super.key});

  @override
  ConsumerState<RoleManagementSection> createState() => _RoleManagementSectionState();
}

class _RoleManagementSectionState extends ConsumerState<RoleManagementSection> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sincronizar búsqueda con el provider en tiempo real
    _searchCtrl.addListener(() {
      ref.read(roleManagementProvider.notifier).updateSearchQuery(_searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Escuchamos el estado del provider
    final state = ref.watch(roleManagementProvider);
    final notifier = ref.read(roleManagementProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSearchBar(notifier),
        const SizedBox(height: 24),

        // ✅ Renderizado reactivo basado en AsyncValue
        state.users.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: AppColors.fuchsia),
            ),
          ),
          error: (err, _) => _buildErrorState(err.toString(), notifier.loadUsers),
          data: (users) {
            if (users.isEmpty) {
              return _buildEmptyState(_searchCtrl.text.isNotEmpty);
            }
            return ListView.separated(
              shrinkWrap: true, // ✅ CRÍTICO: Para funcionar dentro de SettingsSection
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                return RoleAssignmentCard(
                  user: user,
                  currentRole: user.role,
                  availableRoles: UserRole.values
                      .where((role) => role.isKnown)
                      .toList(),
                  onRoleChanged: notifier.updateUserRole,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.fuchsia, Color(0xFF8B00FF)]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.shield, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gestión de Roles',
                style: AppTextStyles.baseTextTheme.titleLarge
              ),
              Text(
                'Asignar permisos a usuarios registrados',
                style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(RoleManagementNotifier notifier) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _searchCtrl,
      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, email o username...',
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
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: scheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reintentar'),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.person_off,
            size: 48,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            isSearching
                ? 'No se encontraron resultados'
                : 'No hay usuarios registrados',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
