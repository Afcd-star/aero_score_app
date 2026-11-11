// lib/src/core/routes/app_routes.dart
import 'package:aero_score_app/src/'
    'features/admin/presentation/views/admin_dashboard_view.dart';
import 'package:aero_score_app/src/'
    'features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/'
    'features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/'
    'features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/'
    'features/auth/presentation/providers/auth_notifier.dart';
import 'package:aero_score_app/src/'
    'features/auth/presentation/views/auth_view.dart';
import 'package:aero_score_app/src/'
    'features/auth/presentation/views/pending_approval_view.dart';
import 'package:aero_score_app/src/'
    'features/auth/presentation/views/unknown_role_view.dart';
import 'package:aero_score_app/src/'
    'features/scoring/domain/types.dart';
import 'package:aero_score_app/src/'
    'features/scoring/presentation/'
    'views/judge_principal_placeholder_view.dart';
import 'package:aero_score_app/src/'
    'features/scoring/presentation/views/scoring_main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Proveedor global del enrutador de la aplicación.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (_, state) {
      final location = state.matchedLocation;

      return switch (authState) {
        AuthInitial() || AuthLoading() || AuthError() =>
          location == '/login' ? null : '/login',
        AuthPendingApproval() =>
          location == '/pending-approval'
              ? null
              : '/pending-approval',
        AuthSuccess(:final user) => _successRedirect(
          location: location,
          user: user,
        ),
      };
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const AuthView(),
      ),
      GoRoute(
        path: '/pending-approval',
        builder: (_, _) => const PendingApprovalView(),
      ),
      GoRoute(
        path: '/unknownrole',
        builder: (_, _) => const UnknownRoleView(),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, _) => const AdminDashboardView(),
        routes: [
          GoRoute(
            path: 'home',
            builder: (_, _) => const AdminDashboardView(),
          ),
          GoRoute(
            path: 'teams',
            builder: (_, _) => const AdminDashboardView(),
          ),
          GoRoute(
            path: 'events',
            builder: (_, _) => const AdminDashboardView(),
          ),
          GoRoute(
            path: 'competitors',
            builder: (_, _) => const AdminDashboardView(),
          ),
          GoRoute(
            path: 'settings',
            builder: (_, _) => const AdminDashboardView(),
          ),
          GoRoute(
            path: 'rules',
            builder: (_, _) => const AdminDashboardView(),
          ),
        ],
      ),
      GoRoute(
        path: '/judge/difficulty',
        builder: (_, _) => const ScoringMainView(
          juryType: JuryType.difficulty,
        ),
      ),
      GoRoute(
        path: '/judge/execution',
        builder: (_, _) => const ScoringMainView(
          juryType: JuryType.execution,
        ),
      ),
      GoRoute(
        path: '/judge/artistry',
        builder: (_, _) => const ScoringMainView(
          juryType: JuryType.artistry,
        ),
      ),
      GoRoute(
        path: '/judge/principal',
        builder: (_, _) => const JudgePrincipalPlaceholderView(),
      ),
      GoRoute(
        path: '/coach',
        builder: (_, _) => const Center(
          child: Text('Dashboard Entrenador'),
        ),
      ),
      GoRoute(
        path: '/organizer',
        builder: (_, _) => const Center(
          child: Text('Dashboard Organizador'),
        ),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('Ruta no encontrada: ${state.uri.path}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Ir al login'),
              ),
            ],
          ),
        ),
      );
    },
  );
});

String? _successRedirect({
  required String location,
  required UserEntity user,
}) {
  final isAdminRoute = location.startsWith('/admin');
  final isLoginRoute = location == '/login';
  final isPendingRoute = location == '/pending-approval';
  final isUnknownRoleRoute = location == '/unknownrole';
  final isJudgeRoute = location.startsWith('/judge');
  final isCoachRoute = location == '/coach';
  final isOrganizerRoute = location == '/organizer';

  if (user.role == UserRole.unknown) {
    return isUnknownRoleRoute ? null : '/unknownrole';
  }

  if (user.status != 'Active') {
    return isPendingRoute ? null : '/pending-approval';
  }

  if (isAdminRoute) {
    if (user.role == UserRole.admin) {
      return null;
    }
    return _routeForRole(user.role);
  }

  if (isJudgeRoute) {
    if (user.role == UserRole.admin || user.role.isJudge) {
      return null;
    }
    return _routeForRole(user.role);
  }

  if (isCoachRoute) {
    if (user.role == UserRole.admin || user.role == UserRole.coach) {
      return null;
    }
    return _routeForRole(user.role);
  }

  if (isOrganizerRoute) {
    if (user.role == UserRole.admin ||
        user.role == UserRole.organizer) {
      return null;
    }
    return _routeForRole(user.role);
  }

  if (isLoginRoute || isPendingRoute || isUnknownRoleRoute) {
    final target = _routeForRole(user.role);
    return target == location ? null : target;
  }

  return null;
}

String _routeForRole(UserRole role) {
  return switch (role) {
    UserRole.admin => '/admin/home',
    UserRole.judgeA => '/judge/artistry',
    UserRole.judgeD => '/judge/difficulty',
    UserRole.judgeE => '/judge/execution',
    UserRole.judgeP => '/judge/principal',
    UserRole.organizer => '/organizer',
    UserRole.coach => '/coach',
    UserRole.viewer => '/pending-approval',
    UserRole.unknown => '/unknownrole',
  };
}
