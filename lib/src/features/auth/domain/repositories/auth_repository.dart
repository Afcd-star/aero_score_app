// lib/src/features/auth/domain/repositories/auth_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:either_dart/either.dart';


/// Contrato de autenticación para el dominio.
/// ✅ No conoce Flutter, ni PocketBase, ni SharedPreferences.
/// ✅ Solo conoce Entidades y Fallos.
abstract class AuthRepository {
  /// Autentica usuario y contraseña contra el backend.
  Future<Either<Failure, UserEntity>> login(String username, String password);

  /// Registra un nuevo usuario.
  Future<Either<Failure, void>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  });

  // ✅ NUEVO: Método para obtener info del usuario (sin autenticar)
  Future<Either<Failure, UserEntity>> getUserInfo(String usernameOrEmail);  

  /// Cierra sesión y limpia tokens locales.
  Future<void> logout();

  /// Intenta restaurar la sesión desde el almacenamiento local (Auto-login).
  Future<Either<Failure, UserEntity>> restoreSession();
}
