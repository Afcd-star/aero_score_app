// lib/src/features/admin/presentation/views/admin_dashboard_view.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/admin/domain/types.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/sections/home_section.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/sections/rules_section.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/sections/settings_section.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:aero_score_app/src/features/competitors/presentation/views/competitors_section.dart';
import 'package:aero_score_app/src/features/events/presentation/views/events_section.dart';
import 'package:aero_score_app/src/features/teams/presentation/views/teams_section.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Vista principal del panel de administración.
class AdminDashboardView extends ConsumerStatefulWidget {
  /// Crea la vista del panel de administración.
  const AdminDashboardView({super.key});

  @override
  ConsumerState<AdminDashboardView> createState() =>
      _AdminDashboardViewState();
}

class _AdminDashboardViewState extends ConsumerState<AdminDashboardView> {
  AdminSection _activeSection = AdminSection.home;
  bool _showMenu = false;
  bool _isInitialized = false;

  // ✅ Sidebar Items (6 items: Configuración incluida, Pool eliminada)
  final List<Map<String, dynamic>> _menuItems = [
    {
      'section': AdminSection.home,
      'icon': Icons.home,
      'label': 'Inicio',
      'color': AppColors.fuchsia,
    },
    {
      'section': AdminSection.events,
      'icon': Icons.event,
      'label': 'Eventos',
      'color': Colors.green,
    },
    {
      'section': AdminSection.teams,
      'icon': Icons.people,
      'label': 'Equipos',
      'color': Colors.blue,
    },
    {
      'section': AdminSection.competitors,
      'icon': Icons.person,
      'label': 'Competidores',
      'color': Colors.pink,
    },
    {
      'section': AdminSection.rules,
      'icon': Icons.description,
      'label': 'Reglamento',
      'color': Colors.orange,
    },
    {
      'section': AdminSection.settings,
      'icon': Icons.settings,
      'label': 'Configuración',
      'color': Colors.grey,
    },
  ];

  // ✅ Bottom Nav Items (4 items: Pool eliminada)
  final List<Map<String, dynamic>> _bottomNavItems = [
    {
      'section': AdminSection.home,
      'icon': Icons.home_rounded,
      'label': 'Inicio',
    },
    {
      'section': AdminSection.events,
      'icon': Icons.event_rounded,
      'label': 'Eventos',
    },
    {
      'section': AdminSection.teams,
      'icon': Icons.groups_rounded,
      'label': 'Equipos',
    },
    {
      'section': AdminSection.rules,
      'icon': Icons.description_rounded,
      'label': 'Reglamento',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Sincronizar sección activa con la ruta actual
    if (!_isInitialized) {
      final location = GoRouterState.of(context).uri.path;
      _updateSectionFromRoute(location);
      _isInitialized = true;
    }
  }

  void _updateSectionFromRoute(String location) {
    // Extraer la sección de la ruta: /admin/teams -> teams
    final parts = location.split('/');
    if (parts.length > 2 && parts[1] == 'admin') {
      final sectionName = parts[2];
      if (sectionName.isNotEmpty) {
        final section = AdminSection.values.firstWhere(
          (s) => s.name == sectionName,
          orElse: () => AdminSection.home,
        );
        setState(() => _activeSection = section);
      }
    }
  }

  // ✅ Navegación unificada
  void _navigateTo(AdminSection section, {bool closeMenu = false}) {
    setState(() => _activeSection = section);
    if (closeMenu) setState(() => _showMenu = false);
    context.go('/admin/${section.name}');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = switch (authState) {
      AuthSuccess(:final user) => user,
      _ => null,
    };
    final location = GoRouterState.of(context).uri.path;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateSectionFromRoute(location);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: Stack(
        children: [
          // ✅ CORRECCIÓN: Pasar el contenido principal como child
          AeroBackground(
            isDashboard: true,
            // ✅ Contenido principal envuelto en SafeArea
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(context, user),
                  Expanded(child: _buildContent()),
                  _buildBottomNavigation(context),
                ],
              ),
            ),
          ),

          // ✅ Overlay del Menú Lateral
          if (_showMenu) _buildSideMenu(context, user),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // UI BUILDERS
  // ═══════════════════════════════════════════════════════════

  Widget _buildHeader(BuildContext context, UserEntity? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.fuchsia, Color(0xFF8B00FF)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menú Hamburguesa
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => setState(() => _showMenu = true),
          ),

          // Logo y Usuario
          Column(
            children: [
              Text(
                'AeroScore',
                style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Panel de Administración',
                style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),

          // Logout
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () {
              unawaited(
                ref.read(authProvider.notifier).logout(),
              );
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Switch optimizado para renderizado de secciones
    return switch (_activeSection) {
      AdminSection.home => const HomeSection(),
      AdminSection.teams => const TeamsSection(),
      AdminSection.events => const EventsSection(),
      AdminSection.competitors => const CompetitorsSection(),
      AdminSection.rules => const RulesSection(),
      AdminSection.settings => const SettingsSection(),
    };
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEEEEEE)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _bottomNavItems.map((item) {
          final section = item['section'] as AdminSection;
          final isActive = _activeSection == section;
          return _buildBottomNavItem(
            context,
            icon: item['icon'] as IconData,
            label: item['label'] as String,
            section: section,
            isActive: isActive,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required AdminSection section,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _navigateTo(section),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.fuchsia : Colors.grey.shade600,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.baseTextTheme.labelSmall?.copyWith(
              color: isActive ? AppColors.fuchsia : Colors.grey.shade600,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu(BuildContext context, UserEntity? user) {
    return Stack(
      children: [
        // Fondo oscuro para cerrar menú
        GestureDetector(
          onTap: () => setState(() => _showMenu = false),
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
        // Panel lateral
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                // Header del Sidebar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.fuchsia, AppColors.coral],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'AS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'Administrador',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Lista de Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: _menuItems.map((item) {
                      final section = item['section'] as AdminSection;
                      final isActive = _activeSection == section;
                      return GestureDetector(
                        onTap: () =>
                            _navigateTo(section, closeMenu: true),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? const LinearGradient(
                                    colors: [
                                      AppColors.fuchsia,
                                      Color(0xFF8B00FF),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8),
                            color: isActive
                                ? null
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: isActive
                                    ? Colors.white
                                    : item['color'] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item['label'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Logout en Sidebar
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    unawaited(
                      ref.read(authProvider.notifier).logout(),
                    );
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
