// test/features/auth/presentation/providers/role_management_state_test.dart
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/'
    'role_management_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

UserEntity _user(
  String id, {
  String status = 'Active',
  UserRole role = UserRole.coach,
}) => UserEntity(
  id: id,
  username: 'u$id',
  email: 'u$id@x.cu',
  firstName: 'Nombre',
  lastName: 'Apellido',
  role: role,
  status: status,
);

RoleManagementState _state(
  List<UserEntity> users, {
  String? statusFilter,
  UserRole? roleFilter,
}) => RoleManagementState(
  users: AsyncValue<List<UserEntity>>.data(users),
  statusFilter: statusFilter,
  roleFilter: roleFilter,
);

/// Punto de entrada de la suite del filtrado de usuarios.
void main() {
  group('RoleManagementState.filteredUsers', () {
    final loaded = <UserEntity>[
      _user('a'),
      _user('b', status: 'Pending Approval'),
      _user('c', status: 'Inactive'),
      _user('d', role: UserRole.judgeD),
      _user('e', status: 'Pending Approval', role: UserRole.viewer),
    ];

    test('sin filtros devuelve todos en el orden cargado', () {
      final state = _state(loaded);
      expect(
        state.filteredUsers.map((u) => u.id).toList(),
        <String>['a', 'b', 'c', 'd', 'e'],
      );
    });

    test('filtra por estado pendiente', () {
      final state = _state(loaded, statusFilter: 'Pending Approval');
      expect(
        state.filteredUsers.map((u) => u.id).toList(),
        <String>['b', 'e'],
      );
    });

    test('filtra por estado inactivo, que el dominio si declara', () {
      final state = _state(loaded, statusFilter: 'Inactive');
      expect(
        state.filteredUsers.map((u) => u.id).toList(),
        <String>['c'],
      );
    });

    test('filtra por rol', () {
      final state = _state(loaded, roleFilter: UserRole.judgeD);
      expect(
        state.filteredUsers.map((u) => u.id).toList(),
        <String>['d'],
      );
    });

    test('combina estado y rol por interseccion', () {
      final state = _state(
        loaded,
        statusFilter: 'Pending Approval',
        roleFilter: UserRole.viewer,
      );
      expect(
        state.filteredUsers.map((u) => u.id).toList(),
        <String>['e'],
      );
    });

    test('combinacion sin coincidencias devuelve vacio', () {
      final state = _state(
        loaded,
        statusFilter: 'Active',
        roleFilter: UserRole.viewer,
      );
      expect(state.filteredUsers, isEmpty);
    });

    test('sin datos cargados devuelve vacio y no lanza', () {
      const state = RoleManagementState();
      expect(state.filteredUsers, isEmpty);
    });
  });
}
