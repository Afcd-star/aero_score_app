// lib/src/features/scoring/presentation/providers/scoring_notifier.dart
import 'package:aero_score_app/src/features/scoring/data/di/scoring_providers.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/repositories/scoring_repository.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoringState {

  const ScoringState({
    this.scores = const AsyncValue.loading(),
    this.result = const AsyncValue.loading(),
    this.currentJuryType,
    this.selectedCompetitorId,
    this.isSubmitting = false,
  });
  final AsyncValue<List<ScoreEntity>> scores;
  final AsyncValue<ResultEntity?> result;
  final JuryType? currentJuryType;
  final String? selectedCompetitorId;
  final bool isSubmitting;

  ScoringState copyWith({
    AsyncValue<List<ScoreEntity>>? scores,
    AsyncValue<ResultEntity?>? result,
    JuryType? currentJuryType,
    String? selectedCompetitorId,
    bool? isSubmitting,
  }) => ScoringState(
    scores: scores ?? this.scores,
    result: result ?? this.result,
    currentJuryType: currentJuryType ?? this.currentJuryType,
    selectedCompetitorId: selectedCompetitorId ?? this.selectedCompetitorId,
    isSubmitting: isSubmitting ?? this.isSubmitting,
  );
}

class ScoringNotifier extends Notifier<ScoringState> {
  ScoringNotifier();

  ScoringRepository get _repository => ref.read(scoringRepositoryProvider);

  @override
  ScoringState build() => const ScoringState();

  void setCurrentJuryType(JuryType type) {
    state = state.copyWith(currentJuryType: type);
  }

  Future<void> loadScores({
    required String competitorId,
    JuryType? juryType,
  }) async {
    state = state.copyWith(
      selectedCompetitorId: competitorId,
      scores: const AsyncValue.loading(),
    );
    final result = await _repository.getScores(
      competitorId: competitorId,
      juryType: juryType,
    );
    result.fold(
      (failure) => state = state.copyWith(
        scores: AsyncValue.error(failure.message, StackTrace.current),
      ),
      (scores) => state = state.copyWith(scores: AsyncValue.data(scores)),
    );
  }

  void selectCompetitor(String competitorId) {
    state = state.copyWith(selectedCompetitorId: competitorId);
    loadScores(competitorId: competitorId);
  }

  Future<bool> saveScore({
    required String competitorId,
    required JuryType juryType,
    required double value,
    double? deductions,
    String? observations,
  }) async {
    state = state.copyWith(isSubmitting: true);
    final result = await _repository.saveScore(
      competitorId: competitorId,
      juryType: juryType,
      value: value,
      deductions: deductions,
      observations: observations,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(isSubmitting: false);
        return false;
      },
      (_) async {
        await loadScores(competitorId: competitorId);
        final resultResult = await _repository.calculateResult(competitorId);
        resultResult.fold(
          (failure) => state = state.copyWith(
            result: AsyncValue.error(failure.message, StackTrace.current),
            isSubmitting: false,
          ),
          (resultEntity) => state = state.copyWith(
            result: AsyncValue.data(resultEntity),
            isSubmitting: false,
          ),
        );
        return true;
      },
    );
  }
}
