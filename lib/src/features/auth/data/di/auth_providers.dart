// lib/src/features/auth/data/di/auth_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:aero_score_app/src/features/auth/data/repositories/user_repository_impl.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:aero_score_app/src/features/auth/domain/repositories/user_repository.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/role_management_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Repository provider: UserRepository (scope: auth)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  return UserRepositoryImpl(pb);
});

/// ✅ Repository provider: AuthRepository (scope: auth)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  return AuthRepositoryImpl(pb, prefs);
});

// ✅ SINTAXIS CORRECTA RIVERPOD 3.0: Factory sin parámetros
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

// ✅ SINTAXIS CORRECTA RIVERPOD 3.0: Factory sin parámetros
final roleManagementProvider = NotifierProvider<RoleManagementNotifier, RoleManagementState>(
  RoleManagementNotifier.new,
);

/// ✅ Provider derivado: usuario actual
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authProvider);
  return switch (authState) {
    AuthSuccess(:final user) => user,
    _ => null,
  };
});

/// ✅ Provider derivado: ¿está autenticado?
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthSuccess;
});

/// ✅ Provider derivado: rol del usuario actual
final currentUserRoleProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return switch (authState) {
    AuthSuccess(:final user) => user.role.value,
    _ => null,
  };
});
