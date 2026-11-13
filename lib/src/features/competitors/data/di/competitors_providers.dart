// lib/src/features/competitors/data/di/competitors_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/competitors/data/di/competitor_filter_provider.dart';
import 'package:aero_score_app/src/features/competitors/data/repositories/competitor_repository_impl.dart';
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/features/competitors/domain/repositories/competitor_repository.dart';
import 'package:aero_score_app/src/features/competitors/presentation/providers/competitor_form_notifier.dart';
import 'package:aero_score_app/src/features/competitors/presentation/providers/competitor_list_notifier.dart';
import 'package:aero_score_app/src/features/competitors/presentation/providers/competitor_selector_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final competitorRepositoryProvider = Provider<CompetitorRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  return CompetitorRepositoryImpl(pb);
});

// ✅ Patrón A: AsyncNotifierProvider con constructor vacío
final competitorListProvider =
    AsyncNotifierProvider<CompetitorListNotifier, List<CompetitorEntity>>(
      CompetitorListNotifier.new,
    );

// ✅ Patrón A: NotifierProvider con constructor vacío
final competitorFormProvider =
    NotifierProvider<CompetitorFormNotifier, CompetitorFormState>(
      CompetitorFormNotifier.new,
    );

final FutureProvider<List<CompetitorSelectionInfo>>
competitorSelectionProvider =
    FutureProvider.autoDispose<List<CompetitorSelectionInfo>>((ref) async {
      final pb = ref.watch(pocketBaseClientProvider);
      final result = await pb
          .collection('competitors')
          .getList(
            page: 1,
            perPage: 200,
            filter: 'status = "Activo"',
            sort: 'firstName',
          );
      return result.items
          .map(
            (record) => CompetitorSelectionInfo(
              id: record.id,
              firstName: record.getStringValue('firstName'),
              lastName: record.getStringValue('lastName'),
              nationalId: record.getStringValue('nationalId'),
              university: record.getStringValue('university'),
            ),
          )
          .toList();
    });

final competitorsByTeamProvider = Provider<AsyncValue<List<CompetitorEntity>>>((
  ref,
) {
  final teamId = ref.watch(selectedTeamIdProvider);
  final allCompetitors = ref.watch(competitorListProvider);
  return allCompetitors.whenData(
    (list) =>
        teamId == null ? list : list.where((c) => c.teamId == teamId).toList(),
  );
});
