// lib/src/features/teams/data/di/teams_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/teams/data/repositories/team_repository_impl.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_form_notifier.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  return TeamRepositoryImpl(pb);
});

// ✅ Patrón A unificado
final teamListProvider = AsyncNotifierProvider<TeamListNotifier, List<TeamEntity>>(
  TeamListNotifier.new,
);

final teamFormProvider = NotifierProvider<TeamFormNotifier, TeamFormState>(
  TeamFormNotifier.new,
);