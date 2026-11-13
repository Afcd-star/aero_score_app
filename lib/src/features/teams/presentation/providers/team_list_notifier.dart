// lib/src/features/teams/presentation/providers/team_list_notifier.dart
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamListNotifier extends AsyncNotifier<List<TeamEntity>> {
  TeamListNotifier();

  TeamRepository get _repository => ref.read(teamRepositoryProvider);

  @override
  Future<List<TeamEntity>> build() async {
    final result = await _repository.getAll();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (teams) => teams,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _repository.getAll();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      AsyncValue.data,
    );
  }

  Future<void> deleteTeam(String id) async {
    final currentTeams = state.value;
    if (currentTeams == null) return;
    final result = await _repository.deleteTeam(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = AsyncValue.data(currentTeams.where((t) => t.id != id).toList()),
    );
  }
}
