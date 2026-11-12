// lib/src/features/admin/domain/usecases/recent_activity_usecase.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:either_dart/either.dart';

/// Caso de uso de actividad reciente.
///
/// Primitivo sin consumidor aun. Aisla la lectura de la linea de
/// actividad. Cuando exista coleccion de auditoria, cambia de
/// repositorio sin alterar la frontera logica de la feature.
class RecentActivityUsecase {
  /// Crea el caso de uso sobre un repositorio de administracion.
  RecentActivityUsecase(this._repository);

  final AdminRepository _repository;

  /// Obtiene los ultimos items de actividad.
  Future<Either<Failure, List<ActivityItemEntity>>> call({
    int limit = 5,
  }) {
    return _repository.getRecentActivity(limit: limit);
  }
}
