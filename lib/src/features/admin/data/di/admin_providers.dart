// lib/src/features/admin/data/di/admin_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/admin/data/repositories/'
    'admin_repository_impl.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/'
    'activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/'
    'admin_stats_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/'
    'admin_repository.dart';
import 'package:aero_score_app/src/features/admin/domain/usecases/'
    'admin_dashboard_stats_usecase.dart';
import 'package:aero_score_app/src/features/admin/domain/usecases/'
    'recent_activity_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor del repositorio de administracion.
///
/// Usa el cliente global de PocketBase, que ya restaura la sesion
/// guardada, en lugar de construir un cliente propio sin sesion.
final Provider<AdminRepository> adminRepositoryProvider =
    Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(pocketBaseClientProvider));
});

/// Proveedor del caso de uso de metricas del dashboard.
final Provider<AdminDashboardStatsUsecase>
    adminDashboardStatsUsecaseProvider =
    Provider<AdminDashboardStatsUsecase>((ref) {
  return AdminDashboardStatsUsecase(ref.watch(adminRepositoryProvider));
});

/// Proveedor del caso de uso de actividad reciente.
final Provider<RecentActivityUsecase> recentActivityUsecaseProvider =
    Provider<RecentActivityUsecase>((ref) {
  return RecentActivityUsecase(ref.watch(adminRepositoryProvider));
});

/// Proveedor de metricas del dashboard de administracion.
///
/// Conserva el fallo tipado en el estado de error en lugar de
/// envolverlo en una excepcion generica.
final FutureProvider<AdminStats> adminDashboardStatsProvider =
    FutureProvider<AdminStats>((ref) async {
  final usecase = ref.watch(adminDashboardStatsUsecaseProvider);
  final result = await usecase();
  return result.fold(
    (failure) => throw failure,
    (stats) => stats,
  );
});

/// Proveedor de actividad reciente del panel.
final FutureProvider<List<ActivityItemEntity>> recentActivityProvider =
    FutureProvider<List<ActivityItemEntity>>((ref) async {
  final usecase = ref.watch(recentActivityUsecaseProvider);
  final result = await usecase();
  return result.fold(
    (failure) => throw failure,
    (activities) => activities,
  );
});

/// Estado de seleccion de equipo para las vistas del panel.
///
/// Deuda de capa cuatro: este estado de interfaz vive hoy en la capa
/// de inyeccion de datos; se reubica a presentacion junto con sus
/// consumidores cuando se audite la presentacion del panel.
class SelectedTeamIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  /// Selecciona el equipo activo del filtro.
  void selectTeam(String? teamId) {
    state = teamId;
  }

  /// Limpia la seleccion de equipo.
  void clearSelection() {
    state = null;
  }
}

/// Proveedor del filtro de equipo seleccionado.
final NotifierProvider<SelectedTeamIdNotifier, String?>
    selectedTeamIdProvider =
    NotifierProvider<SelectedTeamIdNotifier, String?>(
  SelectedTeamIdNotifier.new,
);
