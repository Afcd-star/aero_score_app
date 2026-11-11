// lib/src/features/admin/domain/usecases/recent_activity_usecase.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:either_dart/either.dart';

/// Caso de uso de consulta de actividad reciente.
///
/// Aísla la lectura de la línea de actividad. Cuando exista una
/// colección de auditoría en el backend, este caso de uso cambia
/// de repositorio sin alterar la frontera lógica de la feature.
class RecentActivityUsecase {
  /// Crea el caso de uso sobre un repositorio de administración.
  RecentActivityUsecase(this._repository);

  final AdminRepository _repository;

  /// Obtiene los últimos items de actividad.
  Future<Either<Failure, List<ActivityItemEntity>>> call({
    int limit = 5,
  }) {
    return _repository.getRecentActivity(limit: limit);
  }
}
