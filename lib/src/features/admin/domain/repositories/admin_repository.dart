// lib/src/features/admin/domain/repositories/admin_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:either_dart/either.dart';

/// Contrato de datos del panel de administracion.
///
/// Podado a dos metodos. `getUsersPendingApproval`, `updateUserRole` y
/// `logout` pertenecen a auth, porque mutan la entidad User, no porque
/// el admin tenga permiso para dispararlos. Permiso y propiedad del
/// dato son capas distintas.
abstract class AdminRepository {
  /// Obtiene el paquete de metricas agregadas del dashboard.
  Future<Either<Failure, AdminStats>> getDashboardStats();

  /// Obtiene los ultimos items de actividad reciente.
  Future<Either<Failure, List<ActivityItemEntity>>> getRecentActivity({
    int limit = 5,
  });
}
