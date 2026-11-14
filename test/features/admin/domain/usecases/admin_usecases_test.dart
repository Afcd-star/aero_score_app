// test/features/admin/domain/usecases/admin_usecases_test.dart
import 'package:aero_score_app/src/core/error/failures.dart';
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
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

/// Doble hecho a mano del contrato de administracion.
class _FakeAdminRepository implements AdminRepository {
  _FakeAdminRepository({required this.stats, required this.activity});

  final Either<Failure, AdminStats> stats;
  final Either<Failure, List<ActivityItemEntity>> activity;
  int? requestedLimit;

  @override
  Future<Either<Failure, AdminStats>> getDashboardStats() async => stats;

  @override
  Future<Either<Failure, List<ActivityItemEntity>>> getRecentActivity({
    int limit = 5,
  }) async {
    requestedLimit = limit;
    return activity;
  }
}

/// Punto de entrada de la suite de casos de uso.
void main() {
  const stats = AdminStats(
    activeUsers: 11,
    totalCompetitors: 10,
    totalTeams: 2,
    upcomingEvents: 1,
  );
  final item = ActivityItemEntity(
    id: 'x',
    name: 'Registro',
    action: ActivityAction.updated,
    entityType: ActivityEntityType.team,
    timestamp: DateTime.utc(2026),
  );
  const Either<Failure, List<ActivityItemEntity>> vacio =
      Right<Failure, List<ActivityItemEntity>>(<ActivityItemEntity>[]);

  group('AdminDashboardStatsUsecase', () {
    test('propaga el exito del repositorio', () async {
      final repo = _FakeAdminRepository(
        stats: const Right<Failure, AdminStats>(stats),
        activity: vacio,
      );
      final resultado =
          await AdminDashboardStatsUsecase(repo)();
      expect(resultado.isRight, isTrue);
      expect(resultado.right, stats);
    });

    test('propaga el fallo tipado del repositorio', () async {
      final repo = _FakeAdminRepository(
        stats: const Left<Failure, AdminStats>(
          ServerFailure(message: 'sin conexion'),
        ),
        activity: vacio,
      );
      final resultado =
          await AdminDashboardStatsUsecase(repo)();
      expect(resultado.isLeft, isTrue);
      expect(resultado.left, isA<ServerFailure>());
      expect(resultado.left.message, 'sin conexion');
    });
  });

  group('RecentActivityUsecase', () {
    test('reenvia el limite solicitado al repositorio', () async {
      final repo = _FakeAdminRepository(
        stats: const Right<Failure, AdminStats>(stats),
        activity: Right<Failure, List<ActivityItemEntity>>(
          <ActivityItemEntity>[item],
        ),
      );
      final resultado =
          await RecentActivityUsecase(repo)(limit: 3);
      expect(repo.requestedLimit, 3);
      expect(resultado.right, <ActivityItemEntity>[item]);
    });

    test('usa cinco como limite por defecto', () async {
      final repo = _FakeAdminRepository(
        stats: const Right<Failure, AdminStats>(stats),
        activity: vacio,
      );
      await RecentActivityUsecase(repo)();
      expect(repo.requestedLimit, 5);
    });
  });
}
