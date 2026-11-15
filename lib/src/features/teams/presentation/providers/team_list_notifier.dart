// lib/src/features/teams/presentation/providers/team_list_notifier.dart
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notificador de la lista de equipos activos.
///
/// El borrado es logico: el backend marca `inactive` y la coleccion
/// conserva el registro. Por eso `build` y `refresh` filtran por
/// `isActive`, para que un equipo borrado no reaparezca al recargar.
class TeamListNotifier extends AsyncNotifier<List<TeamEntity>> {
  /// Crea el notificador sin dependencias directas.
  TeamListNotifier();

  TeamRepository get _repository => ref.read(teamRepositoryProvider);

  @override
  Future<List<TeamEntity>> build() async {
    final result = await _repository.getAll();
    return result.fold(
      (failure) => throw failure,
      (teams) => teams.where((t) => t.isActive).toList(),
    );
  }

  /// Recarga la lista desde el backend, filtrando inactivos.
  Future<void> refresh() async {
    state = const AsyncValue<List<TeamEntity>>.loading();
    final result = await _repository.getAll();
    state = result.fold(
      (failure) => AsyncValue<List<TeamEntity>>.error(failure, StackTrace.current),
      (teams) => AsyncValue<List<TeamEntity>>.data(
        teams.where((t) => t.isActive).toList(),
      ),
    );
  }

  /// Borra logicamente un equipo y lo retira de la lista local.
  Future<void> deleteTeam(String id) async {
    final currentTeams = state.value;
    if (currentTeams == null) return;
    final result = await _repository.deleteTeam(id);
    result.fold(
      (failure) => state = AsyncValue<List<TeamEntity>>.error(
        failure,
        StackTrace.current,
      ),
      (_) => state = AsyncValue<List<TeamEntity>>.data(
        currentTeams.where((t) => t.id != id).toList(),
      ),
    );
  }
}
