// lib/src/features/admin/domain/usecases/admin_dashboard_stats_usecase.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:either_dart/either.dart';

/// Caso de uso de obtención de métricas del dashboard.
///
/// Encapsula la agregación transversal por encima del repositorio,
/// de modo que la lógica de negocio compuesta no dependa de la
/// forma del acceso a datos.
class AdminDashboardStatsUsecase {
  /// Crea el caso de uso sobre un repositorio de administración.
  AdminDashboardStatsUsecase(this._repository);

  final AdminRepository _repository;

  /// Obtiene el paquete de métricas del panel.
  Future<Either<Failure, AdminStats>> call() {
    return _repository.getDashboardStats();
  }
}
