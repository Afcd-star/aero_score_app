// lib/src/features/scoring/data/di/scoring_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/scoring/data/repositories/scoring_repository_impl.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/repositories/scoring_repository.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';
import 'package:aero_score_app/src/features/scoring/presentation/providers/scoring_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scoringRepositoryProvider = Provider<ScoringRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  return ScoringRepositoryImpl(pb);
});

// ✅ Patrón A unificado
final scoringProvider = NotifierProvider<ScoringNotifier, ScoringState>(
  ScoringNotifier.new,
);

final scoresByJuryTypeProvider = Provider<AsyncValue<List<ScoreEntity>>>((ref) {
  final juryType = ref.watch(selectedJuryTypeProvider);
  final allScoresAsync = ref.watch(scoringProvider).scores;
  return allScoresAsync.whenData(
    (list) => juryType == null
        ? list
        : list.where((s) => s.juryType == juryType).toList(),
  );
});

class SelectedJuryTypeNotifier extends Notifier<JuryType?> {
  @override
  JuryType? build() => null;
  void selectJuryType(JuryType? type) => state = type;
  void clearSelection() => state = null;
}

final selectedJuryTypeProvider = NotifierProvider<SelectedJuryTypeNotifier, JuryType?>(
  SelectedJuryTypeNotifier.new,
);

class SelectedCompetitorIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void selectCompetitor(String? id) => state = id;
  void clearSelection() => state = null;
}

final selectedCompetitorIdProvider = NotifierProvider<SelectedCompetitorIdNotifier, String?>(
  SelectedCompetitorIdNotifier.new,
);

final consolidatedResultProvider = Provider<AsyncValue<ResultEntity?>>((ref) {
  final competitorId = ref.watch(selectedCompetitorIdProvider);
  if (competitorId == null) return const AsyncValue.data(null);
  return const AsyncValue.loading();
});