// test/features/auth/presentation/providers/role_management_bulk_test.dart
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/role_management_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_user_repository.dart';

UserEntity _user(String id, String status) => UserEntity(
  id: id,
  username: 'u$id',
  email: 'u$id@x.cu',
  firstName: 'N',
  lastName: 'A',
  role: UserRole.coach,
  status: status,
);

/// Punto de entrada de la suite del lote de estados de cuenta.
void main() {
  group('applyBulkStatus', () {
    test('salta a quien ya esta en el estado destino', () async {
      final written = <String>[];
      final outcome = await applyBulkStatus(
        users: <UserEntity>[
          _user('a', 'Active'),
          _user('b', 'Pending Approval'),
        ],
        target: 'Active',
        write: (id, status) async {
          written.add(id);
          return true;
        },
      );
      expect(outcome.updated, 1);
      expect(outcome.skipped, 1);
      expect(outcome.failed, 0);
      expect(written, <String>['b']);
    });

    test('continua ante fallo y cuenta los fallos', () async {
      final outcome = await applyBulkStatus(
        users: <UserEntity>[
          _user('a', 'Pending Approval'),
          _user('b', 'Pending Approval'),
          _user('c', 'Pending Approval'),
        ],
        target: 'Active',
        write: (id, status) async => id != 'b',
      );
      expect(outcome.updated, 2);
      expect(outcome.failed, 1);
      expect(outcome.skipped, 0);
    });

    test('lista vacia devuelve conteos en cero', () async {
      final outcome = await applyBulkStatus(
        users: const <UserEntity>[],
        target: 'Active',
        write: (id, status) async => true,
      );
      expect(outcome.updated, 0);
      expect(outcome.failed, 0);
      expect(outcome.skipped, 0);
    });
  });

  group('RoleManagementNotifier.updateUsersStatus', () {
    test('escribe solo los que cambian y recarga la lista', () async {
      final fake = FakeUserRepository(
        users: <UserEntity>[
          _user('a', 'Active'),
          _user('b', 'Pending Approval'),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);
      await container.read(roleManagementProvider.notifier).loadUsers();
      final outcome = await container
          .read(roleManagementProvider.notifier)
          .updateUsersStatus(fake.users, 'Active');
      expect(outcome.updated, 1);
      expect(outcome.skipped, 1);
      expect(fake.written, <String>['b']);
      expect(
        container.read(roleManagementProvider).users.value?.length,
        2,
      );
    });
  });
}
