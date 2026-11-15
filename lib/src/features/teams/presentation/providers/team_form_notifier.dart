// lib/src/features/teams/presentation/providers/team_form_notifier.dart
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modo del formulario de equipo.
enum TeamFormMode { 
  ///Modo inactivo, sin borrador ni operaciones en curso.
  idle, 

  ///Modo para crear un nuevo equipo.
  create, 

  ///Modo para editar un equipo existente.
  edit 
}

/// Estado del formulario de equipo.
class TeamFormState {
  /// Crea el estado con sus banderas y borrador opcionales.
  const TeamFormState({
    this.isLoading = false,
    this.error,
    this.draft,
    this.isEditing = false,
    this.isSuccess = false,
    this.mode = TeamFormMode.idle,
  });

  /// Indica si hay una operacion de guardado en curso.
  final bool isLoading;

  /// Mensaje de error de la ultima operacion, o null si no hubo.
  final String? error;

  /// Borrador del equipo en edicion o recien creado.
  final TeamEntity? draft;

  /// Indica si el formulario esta en modo edicion.
  final bool isEditing;

  /// Indica si la ultima operacion termino con exito.
  final bool isSuccess;

  /// Modo actual del formulario.
  final TeamFormMode mode;

  /// Copia el estado sobrescribiendo solo los campos indicados.
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

/// Notificador del formulario de equipo.
///
/// Al iniciar una operacion construye un estado nuevo, no copia el
/// anterior, para que el error de un intento previo no quede fantasma
/// en la siguiente transicion de carga.
class TeamFormNotifier extends Notifier<TeamFormState> {
  /// Crea el notificador sin dependencias directas.
  TeamFormNotifier();

  TeamRepository get _repository => ref.read(teamRepositoryProvider);

  @override
  TeamFormState build() => const TeamFormState();

  /// Prepara el formulario para crear un equipo nuevo.
  void prepareForCreate() => state = const TeamFormState(
    mode: TeamFormMode.create,
  );

  /// Prepara el formulario para editar un equipo existente.
  void prepareForEdit(TeamEntity team) => state = TeamFormState(
    draft: team,
    isEditing: true,
    mode: TeamFormMode.edit,
  );

  /// Vuelve el formulario al modo inactivo.
  void cancelEditing() => state = const TeamFormState();

  /// Crea un equipo y refleja el resultado en el estado.
  Future<bool> createTeam({
    required String name,
    required String university,
    required String faculty,
    required String email,
    String? coachId,
    String? coachName,
    List<String>? competitorIds,
  }) async {
    state = TeamFormState(
      mode: state.mode,
      draft: state.draft,
      isEditing: state.isEditing,
      isLoading: true,
    );
    final team = TeamEntity(
      id: '',
      name: name,
      university: university,
      faculty: faculty,
      email: email,
      coachId: coachId,
      coachName: coachName,
      competitorIds: competitorIds ?? const <String>[],
    );
    final result = await _repository.createTeam(team);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (created) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          draft: created,
        );
        return true;
      },
    );
  }

  /// Actualiza un equipo y refleja el resultado en el estado.
  Future<bool> updateTeam(TeamEntity team) async {
    state = TeamFormState(
      mode: state.mode,
      draft: state.draft,
      isEditing: state.isEditing,
      isLoading: true,
    );
    final result = await _repository.updateTeam(team);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (updated) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          draft: updated,
        );
        return true;
      },
    );
  }

  /// Limpia el error conservando el modo y el borrador.
  void clearError() => state = TeamFormState(
    mode: state.mode,
    draft: state.draft,
    isEditing: state.isEditing,
  );

  /// Limpia el exito conservando el resto del estado.
  void clearSuccess() => state = state.copyWith(isSuccess: false);

  /// Vuelve el formulario al estado inicial.
  void reset() => state = const TeamFormState();
}
