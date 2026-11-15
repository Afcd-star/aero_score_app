// test/features/teams/presentation/providers/team_form_notifier_test.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_form_notifier.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_team_repository.dart';

TeamEntity _created() => const TeamEntity(
      id: 'n1',
      name: 'Nuevo',
      university: 'Universidad',
      email: 'n@x.cu',
      faculty: 'FIO',
      coachId: 'c1',
      competitorIds: <String>['k1'],
    );

ProviderContainer _container(FakeTeamRepository fake) {
  final container = ProviderContainer(
    overrides: [
      teamRepositoryProvider.overrideWithValue(fake),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Punto de entrada de la suite del notifier de formulario.
void main() {
  group('TeamFormNotifier', () {
    test('prepareForCreate pone el modo create sin error', () {
      final container = _container(FakeTeamRepository());
      container.read(teamFormProvider.notifier).prepareForCreate();
      final state = container.read(teamFormProvider);
      expect(state.mode, TeamFormMode.create);
      expect(state.error, isNull);
    });

    test('createTeam fallido deja el mensaje de fallo', () async {
      final container = _container(
        FakeTeamRepository(
          createImpl: (t) async =>
              const Left<Failure, TeamEntity>(
                ValidationFailure(message: 'sin entrenador'),
              ),
        ),
      );
      final ok = await container.read(teamFormProvider.notifier).createTeam(
        name: 'X',
        university: 'U',
        faculty: 'FIO',
        email: 'e@x.cu',
      );
      expect(ok, isFalse);
      expect(container.read(teamFormProvider).error, 'sin entrenador');
    });

    test('createTeam exitoso guarda el borrador y marca exito', () async {
      final container = _container(
        FakeTeamRepository(
          createImpl: (t) async =>
              Right<Failure, TeamEntity>(_created()),
        ),
      );
      final ok = await container.read(teamFormProvider.notifier).createTeam(
        name: 'X',
        university: 'U',
        faculty: 'FIO',
        email: 'e@x.cu',
        coachId: 'c1',
        competitorIds: const <String>['k1'],
      );
      expect(ok, isTrue);
      final state = container.read(teamFormProvider);
      expect(state.isSuccess, isTrue);
      expect(state.draft?.id, 'n1');
    });

    test('clearError limpia el error conservando el modo', () {
      final container = _container(FakeTeamRepository());
      container.read(teamFormProvider.notifier).prepareForCreate();
      container.read(teamFormProvider.notifier).clearError();
      final state = container.read(teamFormProvider);
      expect(state.error, isNull);
      expect(state.mode, TeamFormMode.create);
    });

    test('un reintento tras fallo no arrastra el error anterior', () async {
      var calls = 0;
      final container = _container(
        FakeTeamRepository(
          createImpl: (t) async {
            calls++;
            if (calls == 1) {
              return const Left<Failure, TeamEntity>(
                ValidationFailure(message: 'fallo uno'),
              );
            }
            return Right<Failure, TeamEntity>(_created());
          },
        ),
      );
      await container.read(teamFormProvider.notifier).createTeam(
        name: 'X',
        university: 'U',
        faculty: 'FIO',
        email: 'e@x.cu',
      );
      expect(container.read(teamFormProvider).error, 'fallo uno');
      await container.read(teamFormProvider.notifier).createTeam(
        name: 'X',
        university: 'U',
        faculty: 'FIO',
        email: 'e@x.cu',
        coachId: 'c1',
        competitorIds: const <String>['k1'],
      );
      expect(container.read(teamFormProvider).error, isNull);
    });
  });
}
