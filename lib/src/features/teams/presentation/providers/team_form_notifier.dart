// lib/src/features/teams/presentation/providers/team_form_notifier.dart
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ NUEVO: Enum para modo del formulario (consistente con EventFormState)
enum TeamFormMode { idle, create, edit }

class TeamFormState { // ✅ NUEVO

  const TeamFormState({
    this.isLoading = false,
    this.error,
    this.draft,
    this.isEditing = false,
    this.isSuccess = false,
    this.mode = TeamFormMode.idle, // ✅ NUEVO
  });
  final bool isLoading;
  final String? error;
  final TeamEntity? draft;
  final bool isEditing;
  final bool isSuccess;
  final TeamFormMode mode;

  TeamFormState copyWith({
    bool? isLoading,
    String? error,
    TeamEntity? draft,
    bool? isEditing,
    bool? isSuccess,
    TeamFormMode? mode,
  }) {
    return TeamFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      draft: draft ?? this.draft,
      isEditing: isEditing ?? this.isEditing,
      isSuccess: isSuccess ?? this.isSuccess,
      mode: mode ?? this.mode,
    );
  }
}

class TeamFormNotifier extends Notifier<TeamFormState> {
  TeamFormNotifier();

  TeamRepository get _repository => ref.read(teamRepositoryProvider);

  @override
  TeamFormState build() => const TeamFormState();

  // ✅ NUEVO: Preparar para crear (modo create)
  void prepareForCreate() => state = const TeamFormState(
    mode: TeamFormMode.create,
  );

  // ✅ NUEVO: Preparar para editar (modo edit)
  void prepareForEdit(TeamEntity team) => state = TeamFormState(
    draft: team,
    isEditing: true,
    mode: TeamFormMode.edit,
  );

  // ✅ NUEVO: Cancelar edición (vuelve a idle)
  void cancelEditing() => state = const TeamFormState();

  Future<bool> createTeam({
    required String name,
    required String university,
    required String faculty,
    required String email,
    String? coachId,
    String? coachName,
    List<String>? competitorIds,
  }) async {
    state = state.copyWith(isLoading: true);
    final team = TeamEntity(
      id: '',
      name: name,
      university: university,
      faculty: faculty,
      email: email,
      coachId: coachId,
      coachName: coachName,
      competitorIds: competitorIds ?? [],
    );
    final result = await _repository.createTeam(team);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (created) {
        state = state.copyWith(isLoading: false, isSuccess: true, draft: created);
        return true;
      },
    );
  }

  Future<bool> updateTeam(TeamEntity team) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.updateTeam(team);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (updated) {
        state = state.copyWith(isLoading: false, isSuccess: true, draft: updated);
        return true;
      },
    );
  }

  void reset() => state = const TeamFormState();
  void clearError() => state = state.copyWith();
  void clearSuccess() => state = state.copyWith(isSuccess: false);
}