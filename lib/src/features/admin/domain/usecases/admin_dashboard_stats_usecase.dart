// lib/src/features/admin/domain/usecases/admin_dashboard_stats_usecase.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:either_dart/either.dart';

/// Caso de uso de metricas del dashboard.
///
/// Primitivo sin consumidor aun. Encapsula la agregacion por encima del
/// repositorio para que la logica compuesta no dependa de la forma del
/// acceso a datos. La presentacion lo conecta en capa cuatro.
class AdminDashboardStatsUsecase {
  /// Crea el caso de uso sobre un repositorio de administracion.
  AdminDashboardStatsUsecase(this._repository);

  final AdminRepository _repository;

  /// Obtiene el paquete de metricas del panel.
  Future<Either<Failure, AdminStats>> call() {
    return _repository.getDashboardStats();
  }
}
