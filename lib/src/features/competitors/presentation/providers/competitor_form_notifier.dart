// lib/src/features/competitors/presentation/providers/competitor_form_notifier.dart
import 'package:aero_score_app/src/features/competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/features/competitors/domain/repositories/competitor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompetitorFormState {

  const CompetitorFormState({
    this.isLoading = false,
    this.error,
    this.draft,
    this.isEditing = false,
    this.isSuccess = false,
  });
  final bool isLoading;
  final String? error;
  final CompetitorEntity? draft;
  final bool isEditing;
  final bool isSuccess;

  CompetitorFormState copyWith({
    bool? isLoading,
    String? error,
    CompetitorEntity? draft,
    bool? isEditing,
    bool? isSuccess,
  }) {
    return CompetitorFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      draft: draft ?? this.draft,
      isEditing: isEditing ?? this.isEditing,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class CompetitorFormNotifier extends Notifier<CompetitorFormState> {
  CompetitorFormNotifier();

  CompetitorRepository get _repository => ref.read(competitorRepositoryProvider);

  @override
  CompetitorFormState build() => const CompetitorFormState();

  void prepareForCreate() => state = const CompetitorFormState();

  void prepareForEdit(CompetitorEntity competitor) => state = CompetitorFormState(
    draft: competitor,
    isEditing: true,
  );

  Future<bool> createCompetitor({
    required String firstName,
    required String lastName,
    required String nationalId,
    required CompetitorSex sex, required int academicYear, required CompetitorCategory category, String? solapin,
    String? teamId,
  }) async {
    state = state.copyWith(isLoading: true);
    final competitor = CompetitorEntity(
      id: '',
      firstName: firstName,
      lastName: lastName,
      nationalId: nationalId,
      solapin: solapin,
      sex: sex,
      academicYear: academicYear,
      category: category,
      teamId: teamId,
    );
    final result = await _repository.createCompetitor(competitor);
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

  Future<bool> updateCompetitor(CompetitorEntity competitor) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.updateCompetitor(competitor);
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

  void reset() => state = const CompetitorFormState();
  void clearError() => state = state.copyWith();
  void clearSuccess() => state = state.copyWith(isSuccess: false);
}
