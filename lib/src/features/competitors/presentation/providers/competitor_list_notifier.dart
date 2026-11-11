// lib/src/features/competitors/presentation/providers/competitor_list_notifier.dart
import 'package:aero_score_app/src/features/competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/features/competitors/domain/repositories/competitor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompetitorListNotifier extends AsyncNotifier<List<CompetitorEntity>> {
  CompetitorListNotifier();

  CompetitorRepository get _repository => ref.read(competitorRepositoryProvider);

  @override
  Future<List<CompetitorEntity>> build() async {
    final result = await _repository.getAll();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (competitors) => competitors,
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

  Future<void> deleteCompetitor(String id) async {
    final currentCompetitors = state.value;
    if (currentCompetitors == null) return;
    final result = await _repository.deleteCompetitor(id);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = AsyncValue.data(currentCompetitors.where((c) => c.id != id).toList()),
    );
  }
}