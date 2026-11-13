// lib/src/features/admin/presentation/views/admin_dashboard_view.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/admin/domain/admin_section.dart';
import 'package:aero_score_app/src/features/admin/presentation/'
    'admin_section_ui.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/'
    'sections/home_section.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/'
    'sections/rules_section.dart';
import 'package:aero_score_app/src/features/admin/presentation/views/'
    'sections/settings_section.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/'
    'user_entity.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/'
    'auth_notifier.dart';
import 'package:aero_score_app/src/features/competitors/presentation/views/'
    'competitors_section.dart';
import 'package:aero_score_app/src/features/events/presentation/views/'
    'events_section.dart';
import 'package:aero_score_app/src/features/teams/presentation/views/'
    'teams_section.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Secciones del menu lateral, en su orden de aparicion.
const List<AdminSection> _menuSections = <AdminSection>[
  AdminSection.home,
  AdminSection.events,
  AdminSection.teams,
  AdminSection.competitors,
  AdminSection.rules,
  AdminSection.settings,
];

/// Secciones de la barra inferior, en su orden de aparicion.
const List<AdminSection> _bottomSections = <AdminSection>[
  AdminSection.home,
  AdminSection.events,
  AdminSection.teams,
  AdminSection.rules,
];

/// Vista principal del panel de administracion.
///
/// La seccion activa se deriva de la ruta en cada construccion, asi que
/// el enrutador es la unica fuente de verdad. El unico estado local es
/// la apertura del menu lateral, que es efimero y no navega.
class AdminDashboardView extends ConsumerStatefulWidget {
  /// Crea la vista del panel de administracion.
  const AdminDashboardView({super.key});

  @override
  ConsumerState<AdminDashboardView> createState() =>
      _AdminDashboardViewState();
}

class _AdminDashboardViewState extends ConsumerState<AdminDashboardView> {
  bool _showMenu = false;

  /// Deduce la seccion activa desde la ruta actual.
  AdminSection _sectionFromRoute(String location) {
    final parts = location.split('/');
    if (parts.length > 2 && parts[1] == 'admin') {
      for (final section in AdminSection.values) {
        if (section.pathName == parts[2]) {
          return section;
        }
      }
    }
    return AdminSection.home;
  }

  /// Navega a la seccion indicada y cierra el menu si se solicita.
  void _navigateTo(AdminSection section, {bool closeMenu = false}) {
    if (closeMenu) {
      setState(() => _showMenu = false);
    }
    context.go('/admin/${section.pathName}');
  }

  /// Cierra la sesion y navega al login solo cuando el cierre termina.
  Future<void> _signOut() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) {
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = switch (authState) {
      AuthSuccess(:final user) => user,
      _ => null,
    };
    final activeSection = _sectionFromRoute(
      GoRouterState.of(context).uri.path,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: Stack(
        children: [
          AeroBackground(
            isDashboard: true,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildContent(activeSection)),
                  _buildBottomNavigation(activeSection),
                ],
              ),
            ),
          ),
          if (_showMenu) _buildSideMenu(user, activeSection),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.fuchsia, AppColors.glowViolet],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => setState(() => _showMenu = true),
          ),
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
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => unawaited(_signOut()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AdminSection section) {
    return switch (section) {
      AdminSection.home => const HomeSection(),
      AdminSection.teams => const TeamsSection(),
      AdminSection.events => const EventsSection(),
      AdminSection.competitors => const CompetitorsSection(),
      AdminSection.rules => const RulesSection(),
      AdminSection.settings => const SettingsSection(),
    };
  }

  Widget _buildBottomNavigation(AdminSection activeSection) {
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
        children: _bottomSections.map((section) {
          return _buildBottomNavItem(
            section: section,
            isActive: activeSection == section,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required AdminSection section,
    required bool isActive,
  }) {
    final color =
        isActive ? AppColors.fuchsia : Colors.grey.shade600;
    return GestureDetector(
      onTap: () => _navigateTo(section),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(section.iconRounded, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            section.label,
            style: AppTextStyles.baseTextTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu(UserEntity? user, AdminSection activeSection) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showMenu = false),
          child: Container(color: Colors.black.withValues(alpha: 0.5)),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Monograma de la aplicacion, no avatar de usuario.
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.fuchsia,
                              AppColors.coral,
                            ],
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
                            user?.fullName ?? 'Usuario',
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
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: _menuSections.map((section) {
                      return _buildMenuItem(
                        section: section,
                        isActive: activeSection == section,
                      );
                    }).toList(),
                  ),
                ),
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
                  onTap: () => unawaited(_signOut()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required AdminSection section,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _navigateTo(section, closeMenu: true),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.fuchsia, AppColors.glowViolet],
                )
              : null,
          borderRadius: BorderRadius.circular(8),
          color: isActive ? null : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              section.iconOutlined,
              color: isActive ? Colors.white : section.accentColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              section.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
