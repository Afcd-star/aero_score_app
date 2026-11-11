// lib/src/features/auth/domain/repositories/user_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:either_dart/either.dart';

abstract class UserRepository {
  /// Lista todos los usuarios (solo admin)
  Future<Either<Failure, List<UserEntity>>> getAllUsers({String? search});
  
  /// Actualiza el rol de un usuario
  Future<Either<Failure, void>> updateUserRole({
    required String userId,
    required UserRole newRole,
  });
  
  /// Actualiza el estado de un usuario
  Future<Either<Failure, void>> updateUserStatus({
    required String userId,
    required String newStatus,
  });
}