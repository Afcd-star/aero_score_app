// test/features/teams/presentation/providers/team_list_notifier_test.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_team_repository.dart';

TeamEntity _team(String id, {String status = 'active'}) => TeamEntity(
  id: id,
  name: 'Equipo $id',
  university: 'Universidad',
  email: 'e$id@x.cu',
  faculty: 'FIO',
  coachId: 'c1',
  status: status,
  competitorIds: const <String>['k1'],
);

/// Punto de entrada de la suite del notifier de lista.
void main() {
  group('TeamListNotifier', () {
    test('build filtra los equipos inactivos', () async {
      final fake = FakeTeamRepository(
        getAllImpl: () => <TeamEntity>[
          _team('a'),
          _team('b', status: 'inactive'),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          teamRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      final teams = await container.read(teamListProvider.future);
      expect(teams.map((t) => t.id), <String>['a']);
    });

    test('refresh no hace reaparecer un borrado logico', () async {
      final fake = FakeTeamRepository(
        getAllImpl: () => <TeamEntity>[
          _team('a'),
          _team('b', status: 'inactive'),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          teamRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      await container.read(teamListProvider.future);
      await container.read(teamListProvider.notifier).refresh();
      final state = container.read(teamListProvider);
      expect(state.value!.map((t) => t.id), <String>['a']);
    });

    test('deleteTeam exitoso retira el equipo de la lista local', () async {
      final fake = FakeTeamRepository(
        getAllImpl: () => <TeamEntity>[_team('a'), _team('b')],
        deleteImpl: (id) async => const Right<Failure, void>(null),
      );
      final container = ProviderContainer(
        overrides: [
          teamRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      await container.read(teamListProvider.future);
      await container.read(teamListProvider.notifier).deleteTeam('a');
      final state = container.read(teamListProvider);
      expect(state.value!.map((t) => t.id), <String>['b']);
    });

    test(
      'deleteTeam fallido conserva la lista y propaga el fallo tipado',
      () async {
        final fake = FakeTeamRepository(
          getAllImpl: () => <TeamEntity>[_team('a')],
          deleteImpl: (id) async =>
              const Left<Failure, void>(ServerFailure(message: 'sin conexion')),
        );
        final container = ProviderContainer(
          overrides: [
            teamRepositoryProvider.overrideWithValue(fake),
          ],
        );
        addTearDown(container.dispose);

        await container.read(teamListProvider.future);
        await container.read(teamListProvider.notifier).deleteTeam('a');
        final state = container.read(teamListProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<ServerFailure>());
      },
    );
  });
}
