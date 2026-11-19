// lib/src/features/auth/presentation/providers/role_management_provider.dart
import 'dart:async';

import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de la gestion de usuarios, roles y estados de cuenta.
class RoleManagementState {
  /// Crea el estado con sus datos, su busqueda y sus filtros.
  const RoleManagementState({
    this.users = const AsyncValue.loading(),
    this.searchQuery = '',
    this.isUpdating = false,
    this.statusFilter,
    this.roleFilter,
  });

  /// Usuarios cargados o error de carga.
  final AsyncValue<List<UserEntity>> users;

  /// Texto actual del buscador.
  final String searchQuery;

  /// Indica si hay una actualizacion en curso.
  final bool isUpdating;

  /// Estado de cuenta por el que filtrar. Nulo significa todos.
  final String? statusFilter;

  /// Rol por el que filtrar. Nulo significa todos.
  final UserRole? roleFilter;

  /// Copia el estado sobrescribiendo los campos indicados.
  ///
  /// No puede devolver los filtros a nulo, porque un argumento nulo
  /// significa no cambiar. Para limpiar un filtro se usan los metodos
  /// del notificador, que construyen estado nuevo.
  RoleManagementState copyWith({
    AsyncValue<List<UserEntity>>? users,
    String? searchQuery,
    bool? isUpdating,
    String? statusFilter,
    UserRole? roleFilter,
  }) {
    return RoleManagementState(
      users: users ?? this.users,
      searchQuery: searchQuery ?? this.searchQuery,
      isUpdating: isUpdating ?? this.isUpdating,
      statusFilter: statusFilter ?? this.statusFilter,
      roleFilter: roleFilter ?? this.roleFilter,
    );
  }

  /// Usuarios que pasan los filtros activos, en el orden cargado.
  ///
  /// El filtrado es en cliente porque el repositorio ya trae la lista
  /// completa. Es puro, asi que se prueba sin notificador ni red.
  List<UserEntity> get filteredUsers {
    final loaded = users.value ?? const <UserEntity>[];
    return loaded.where((u) {
      if (statusFilter != null && u.status != statusFilter) {
        return false;
      }
      if (roleFilter != null && u.role != roleFilter) {
        return false;
      }
      return true;
    }).toList();
  }
}

/// Notificador encargado de gestionar usuarios, roles y estados.
class RoleManagementNotifier extends Notifier<RoleManagementState> {
  /// Crea el notificador sin dependencias externas directas.
  RoleManagementNotifier();

  /// Temporizador de espera para no consultar en cada tecla.
  Timer? _debounce;

  @override
  RoleManagementState build() {
    ref.onDispose(() => _debounce?.cancel());
    unawaited(Future<void>.microtask(loadUsers));
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
          users: AsyncValue.error(failure.message, StackTrace.current),
        );
      },
      (data) {
        state = state.copyWith(users: AsyncValue.data(data));
      },
    );
  }

  /// Actualiza el termino de busqueda y recarga tras una pausa.
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(loadUsers(search: query));
    });
  }

  /// Fija el filtro de estado de cuenta. Nulo significa todos.
  ///
  /// Construye estado nuevo en lugar de copiar, porque la copia no
  /// puede devolver el filtro a nulo y limpiarlo quedaria imposible.
  void updateStatusFilter(String? value) {
    state = RoleManagementState(
      users: state.users,
      searchQuery: state.searchQuery,
      isUpdating: state.isUpdating,
      roleFilter: state.roleFilter,
      statusFilter: value,
    );
  }

  /// Fija el filtro de rol. Nulo significa todos.
  void updateRoleFilter(UserRole? value) {
    state = RoleManagementState(
      users: state.users,
      searchQuery: state.searchQuery,
      isUpdating: state.isUpdating,
      statusFilter: state.statusFilter,
      roleFilter: value,
    );
  }

  /// Cambia el rol de un usuario y recarga si la operacion es correcta.
  Future<bool> updateUserRole(String userId, UserRole newRole) async {
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

  /// Cambia el estado de un usuario y recarga si es correcta.
  Future<bool> updateUserStatus(String userId, String newStatus) async {
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

  /// Cambia el estado de varias cuentas y recarga al terminar.
  ///
  /// Aporta el escritor real a la funcion pura de lote y mantiene la
  /// marca de actualizacion durante todo el recorrido, con una sola
  /// recarga al final para no reconstruir la lista en cada escritura.
  Future<BulkStatusOutcome> updateUsersStatus(
    List<UserEntity> targets,
    String newStatus,
  ) async {
    state = state.copyWith(isUpdating: true);
    final outcome = await applyBulkStatus(
      users: targets,
      target: newStatus,
      write: (id, status) async {
        final result = await _repository.updateUserStatus(
          userId: id,
          newStatus: status,
        );
        return result.isRight;
      },
    );
    state = state.copyWith(isUpdating: false);
    await loadUsers();
    return outcome;
  }
}

/// Resultado de un cambio de estado aplicado a varias cuentas.
typedef BulkStatusOutcome = ({int updated, int failed, int skipped});

/// Aplica un estado a varias cuentas con las reglas de lote acordadas.
///
/// Salta a quien ya esta en el estado destino, continua ante fallo y
/// devuelve los conteos reales. Es pura porque recibe el escritor, asi
/// que las reglas se prueban sin red ni proveedor.
Future<BulkStatusOutcome> applyBulkStatus({
  required List<UserEntity> users,
  required String target,
  required Future<bool> Function(String userId, String status) write,
}) async {
  var updated = 0;
  var failed = 0;
  var skipped = 0;
  for (final user in users) {
    if (user.status == target) {
      skipped++;
      continue;
    }
    if (await write(user.id, target)) {
      updated++;
    } else {
      failed++;
    }
  }
  return (updated: updated, failed: failed, skipped: skipped);
}
