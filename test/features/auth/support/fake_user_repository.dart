// test/features/auth/support/fake_user_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/domain/repositories/user_repository.dart';
import 'package:either_dart/either.dart';

/// Doble a mano del contrato de usuarios, con fallos configurables.
///
/// Registra los identificadores escritos para que las pruebas verifiquen
/// que el lote salta a quien ya esta en el estado destino.
class FakeUserRepository implements UserRepository {
  /// Crea el doble con su lista y sus identificadores que fallan.
  FakeUserRepository({
    this.users = const <UserEntity>[],
    this.failIds = const <String>{},
  });

  /// Lista que devuelve la carga.
  final List<UserEntity> users;

  /// Identificadores cuya escritura debe fallar.
  final Set<String> failIds;

  /// Identificadores escritos, en orden.
  final List<String> written = <String>[];

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers({
    String? search,
  }) async {
    return Right<Failure, List<UserEntity>>(users);
  }

  @override
  Future<Either<Failure, void>> updateUserRole({
    required String userId,
    required UserRole newRole,
  }) async {
    return const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> updateUserStatus({
    required String userId,
    required String newStatus,
  }) async {
    if (failIds.contains(userId)) {
      return const Left<Failure, void>(ServerFailure(message: 'fallo'));
    }
    written.add(userId);
    return const Right<Failure, void>(null);
  }
}
