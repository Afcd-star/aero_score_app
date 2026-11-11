// lib/src/features/auth/data/repositories/user_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/auth/'
    'data/models/user_model.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/repositories/user_repository.dart';
import 'package:either_dart/either.dart';
import 'package:pocketbase/pocketbase.dart';

/// Repositorio de datos para la gestión de usuarios.
class UserRepositoryImpl implements UserRepository {
  /// Crea el repositorio con el cliente de PocketBase.
  UserRepositoryImpl(this._client);
  final PocketBase _client;

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers({
    String? search}) async {
    try {
      final filter = search != null && search.isNotEmpty
          ? '''
            (username ~ "$search") ||
            (email ~ "$search") ||
            (firstName ~ "$search") ||
            (lastName ~ "$search")
            '''
          : '';

      final records = await _client.collection('users').getFullList(
        sort: '-created',
        filter: filter.isEmpty ? null : filter,
      );

      final users = records
          .map((record) => UserModel.fromPocketBase(record).toEntity())
          .toList();

      return Right(users);
      
    } on ClientException catch (e) {
      final responseData = e.response;
      final errorMessage = responseData['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: errorMessage));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole({
    required String userId,
    required UserRole newRole,
  }) async {
    try {
      await _client.collection('users').update(userId, body: {
        'role': newRole.value,
      });

      return const Right(null);
      
    } on ClientException catch (e) {
      final responseData = e.response;
      final errorMessage = responseData['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: errorMessage));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar rol: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserStatus({
    required String userId,
    required String newStatus,
  }) async {
    try {
      await _client.collection('users').update(userId, body: {
        'status': newStatus,
      });
      return const Right(null);
    } on ClientException catch (e) {
      final responseData = e.response;
      final errorMessage = responseData['message'] as String? ?? e.toString();
      return Left(ServerFailure(message: errorMessage));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar estado: $e'));
    }
  }
}
