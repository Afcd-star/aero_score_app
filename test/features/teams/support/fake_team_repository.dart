// test/features/teams/support/fake_team_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:either_dart/either.dart';

/// Doble hecho a mano del contrato de equipos, para probar notifiers.
///
/// Solo implementan comportamiento los metodos que consumen los
/// notifiers; el resto lanza `UnimplementedError`, que es valido como
/// implementacion y senala si un test empieza a depender de ellos.
class FakeTeamRepository implements TeamRepository {
  /// Crea el doble con las implementaciones que se vayan a ejercer.
  FakeTeamRepository({
    this.getAllImpl,
    this.createImpl,
    this.updateImpl,
    this.deleteImpl,
  });

  /// Devuelve el conjunto de equipos que el backend tendria.
  final List<TeamEntity> Function()? getAllImpl;

  /// Simula la creacion, con exito o fallo.
  final Future<Either<Failure, TeamEntity>> Function(TeamEntity team)? createImpl;

  /// Simula la actualizacion, con exito o fallo.
  final Future<Either<Failure, TeamEntity>> Function(TeamEntity team)? updateImpl;

  /// Simula el borrado logico, con exito o fallo.
  final Future<Either<Failure, void>> Function(String id)? deleteImpl;

  @override
  Future<Either<Failure, List<TeamEntity>>> getAll({
    String? search,
    String? university,
    String? faculty,
    String? status,
    int page = 1,
    int perPage = 50,
  }) async {
    return Right<Failure, List<TeamEntity>>(getAllImpl!());
  }

  @override
  Future<Either<Failure, TeamEntity>> createTeam(TeamEntity team) async {
    return createImpl!(team);
  }

  @override
  Future<Either<Failure, TeamEntity>> updateTeam(TeamEntity team) async {
    return updateImpl!(team);
  }

  @override
  Future<Either<Failure, void>> deleteTeam(String id) async {
    return deleteImpl!(id);
  }

  @override
  Future<Either<Failure, TeamEntity?>> getById(String id) async {
    throw UnimplementedError('getById no se ejerce en estos tests');
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getByUniversity(String university) async {
    throw UnimplementedError('getByUniversity no se ejerce en estos tests');
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getByFaculty(String faculty) async {
    throw UnimplementedError('getByFaculty no se ejerce en estos tests');
  }

  @override
  Future<Either<Failure, Map<String, int>>> getCountBy({
    String? university,
    String? faculty,
  }) async {
    throw UnimplementedError('getCountBy no se ejerce en estos tests');
  }

  @override
  Future<Either<Failure, bool>> emailExists(String email) async {
    throw UnimplementedError('emailExists no se ejerce en estos tests');
  }
}
