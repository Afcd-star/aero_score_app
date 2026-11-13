// lib/src/features/auth/presentation/providers/role_management_provider.dart
import 'dart:async';

import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de la gestión de roles y usuarios.
class RoleManagementState {
  /// Crea el estado inicial de gestión de roles.
  const RoleManagementState({
    this.users = const AsyncValue.loading(),
    this.searchQuery = '',
    this.isUpdating = false,
  });

  /// Usuarios cargados o error de carga.
  final AsyncValue<List<UserEntity>> users;

  /// Texto actual del buscador.
  final String searchQuery;

  /// Indica si hay una actualización en curso.
  final bool isUpdating;

  /// Copia el estado con valores opcionales sobrescritos.
  RoleManagementState copyWith({
    AsyncValue<List<UserEntity>>? users,
    String? searchQuery,
    bool? isUpdating,
  }) {
    return RoleManagementState(
      users: users ?? this.users,
      searchQuery: searchQuery ?? this.searchQuery,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

/// Notificador encargado de gestionar usuarios y roles.
class RoleManagementNotifier extends Notifier<RoleManagementState> {
  /// Crea el notificador sin dependencias externas directas.
  RoleManagementNotifier();

  @override
  RoleManagementState build() {
    return const RoleManagementState();
  }

  /// Expone el estado actual para lectura controlada.
  RoleManagementState get currentState => state;

  UserRepository get _repository => ref.read(userRepositoryProvider);

  /// Carga la lista de usuarios desde el repositorio.
  Future<void> loadUsers({String? search}) async {
    final query = search ?? state.searchQuery;
    state = state.copyWith(users: const AsyncValue.loading());

    final result = await _repository.getAllUsers(search: query);

    result.fold(
      (failure) {
        state = state.copyWith(
          users: AsyncValue.error(
            failure.message,
            StackTrace.current,
          ),
        );
      },
      (data) {
        state = state.copyWith(users: AsyncValue.data(data));
      },
    );
  }

  /// Actualiza el término de búsqueda y recarga usuarios.
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    unawaited(loadUsers(search: query));
  }

  /// Cambia el rol de un usuario y recarga si la operación es correcta.
  Future<bool> updateUserRole(
    String userId,
    UserRole newRole,
  ) async {
    state = state.copyWith(isUpdating: true);

    final result = await _repository.updateUserRole(
      userId: userId,
      newRole: newRole,
    );

    final success = result.fold(
      (failure) {
        state = state.copyWith(isUpdating: false);
        return false;
      },
      (_) {
        state = state.copyWith(isUpdating: false);
        return true;
      },
    );

    if (success) {
      unawaited(loadUsers());
    }

    return success;
  }

  /// Cambia el estado de un usuario y recarga si la operación es correcta.
  Future<bool> updateUserStatus(
    String userId,
    String newStatus,
  ) async {
    state = state.copyWith(isUpdating: true);

    final result = await _repository.updateUserStatus(
      userId: userId,
      newStatus: newStatus,
    );

    final success = result.fold(
      (failure) {
        state = state.copyWith(isUpdating: false);
        return false;
      },
      (_) {
        state = state.copyWith(isUpdating: false);
        return true;
      },
    );

    if (success) {
      unawaited(loadUsers());
    }

    return success;
  }
}
