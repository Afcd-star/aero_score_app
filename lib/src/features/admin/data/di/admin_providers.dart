// lib/src/features/admin/data/di/admin_providers.dart
import 'package:aero_score_app/src/core/config/environment.dart';
import 'package:aero_score_app/src/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Repository provider para lógica administrativa transversal
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  const env = AppEnvironment.devEmulator; // O ref.watch(environmentProvider)
  return AdminRepositoryImpl(env);
});

/// ✅ Provider para métricas del dashboard admin (NO para CRUD de entidades)
final adminDashboardStatsProvider = FutureProvider<AdminStats>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getDashboardStats();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

/// ✅ Provider de estado UI: filtro de equipo seleccionado (para vistas admin)
class SelectedTeamIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectTeam(String? teamId) {
    state = teamId;
  }

  void clearSelection() {
    state = null;
  }
}

/// ✅ Provider de estado UI: filtro de equipo seleccionado (para vistas admin)
final selectedTeamIdProvider = NotifierProvider<SelectedTeamIdNotifier, String?>(
  SelectedTeamIdNotifier.new,
);

/// ✅ Provider de actividad reciente (últimas 5 acciones)
final recentActivityProvider = FutureProvider<List<ActivityItemEntity>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getRecentActivity();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (activities) => activities,
  );
});

/// ❌ NO AGREGAR: teamsProvider, competitorsProvider, eventsProvider
/// ✅ Esos viven en sus módulos: features/teams/, features/competitors/, features/events/