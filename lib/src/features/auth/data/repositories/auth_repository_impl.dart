// lib/src/features/auth/data/repositories/auth_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/auth/'
    'data/models/user_model.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/repositories/auth_repository.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repositorio de autenticación contra PocketBase.
class AuthRepositoryImpl implements AuthRepository {
  /// Crea el repositorio con cliente y preferencias.
  AuthRepositoryImpl(this._client, this._prefs);

  final PocketBase _client;
  final SharedPreferences _prefs;

  /// Duración máxima permitida para una sesión.
  static const Duration _maxSessionDuration = Duration(hours: 24);

  /// Inicia sesión y guarda datos locales.
  @override
  Future<Either<Failure, UserEntity>> login(
    String username,
    String password,
  ) async {
    try {
      final authResult =
          await _client.collection('users').authWithPassword(
            username,
            password,
          );

      await _prefs.setString(
        'pb_auth_token',
        authResult.token,
      );
      await _prefs.setString(
        'pb_auth_user_id',
        authResult.record.id,
      );
      await _prefs.setString(
        'pb_auth_email',
        authResult.record.getStringValue('email'),
      );
      await _prefs.setInt(
        'pb_login_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      _client.authStore.save(
        authResult.token,
        authResult.record,
      );
      debugPrint(
        '✅ [Login] AuthStore actualizado',
      );

      final user =
          UserModel.fromPocketBase(authResult.record).toEntity();
      return Right(user);
    } on ClientException catch (error) {
      final responseData = error.response;
      final rawMessage = responseData['message'];
      final message =
          rawMessage is String ? rawMessage : error.toString();
      return Left(
        AuthFailure.credentials(
          message: 'Credenciales inválidas: $message',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error de conexión: $error',
        ),
      );
    }
  }

  /// Registra un usuario nuevo con estado pendiente.
  @override
  Future<Either<Failure, void>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _client.collection('users').create(
        body: {
          'username': username,
          'email': email,
          'password': password,
          'passwordConfirm': passwordConfirm,
          'firstName': firstName,
          'lastName': lastName,
          'role': 'Viewer',
          'status': 'Pending Approval',
        },
      );
      return const Right(null);
    } on ClientException catch (error) {
      final rawMessage = error.response['message'];
      final message =
          rawMessage is String
              ? rawMessage
              : 'Error al registrar';
      return Left(ServerFailure(message: message));
    }
  }

  /// Busca un usuario por nombre de usuario o correo.
  @override
  Future<Either<Failure, UserEntity>> getUserInfo(
    String usernameOrEmail,
  ) async {
    debugPrint(
      ' [Repo] getUserInfo llamado con: "$usernameOrEmail"',
    );

    try {
      final result = await _client.collection('users').getList(
        filter:
            'username ~ "$usernameOrEmail" || '
            'email ~ "$usernameOrEmail"',
        perPage: 1,
      );

      debugPrint(
        '🟢 [Repo] getUserInfo, items: ${result.items.length}',
      );

      if (result.items.isEmpty) {
        debugPrint(
          ' [Repo] búsqueda flexible falló, intento exacta',
        );

        final exactResult =
            await _client.collection('users').getList(
              filter:
                  'username = "$usernameOrEmail" || '
                  'email = "$usernameOrEmail"',
              perPage: 1,
            );

        if (exactResult.items.isEmpty) {
          debugPrint(
            '❌ [Repo] usuario no encontrado',
          );
          return const Left(
            ServerFailure(message: 'Usuario no encontrado'),
          );
        }

        final user = UserModel.fromPocketBase(
          exactResult.items.first,
        ).toEntity();
        debugPrint(
          '✅ [Repo] exacto: ${user.username}, ${user.status}',
        );
        return Right(user);
      }

      final user = UserModel.fromPocketBase(
        result.items.first,
      ).toEntity();
      debugPrint(
        '✅ [Repo] usuario: ${user.username}, ${user.status}',
      );
      return Right(user);
    } on ClientException catch (error) {
      debugPrint(
        '🔴 [Repo] ClientException: $error',
      );
      final rawMessage = error.response['message'];
      final message =
          rawMessage is String
              ? rawMessage
              : 'Error al buscar usuario';
      return Left(ServerFailure(message: message));
    } on Exception catch (error) {
      debugPrint(
        '🔴 [Repo] excepción inesperada: $error',
      );
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  /// Restaura una sesión guardada si sigue vigente.
  @override
  Future<Either<Failure, UserEntity>> restoreSession() async {
    try {
      final token = _prefs.getString('pb_auth_token');
      final userId = _prefs.getString('pb_auth_user_id');
      final loginTimestamp = _prefs.getInt('pb_login_timestamp');

      if (token == null ||
          token.isEmpty ||
          userId == null ||
          userId.isEmpty) {
        return const Left(
          AuthFailure.sessionExpired(
            message: 'No hay sesión guardada',
          ),
        );
      }

      if (loginTimestamp != null) {
        final loginTime =
            DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
        final sessionAge = DateTime.now().difference(loginTime);

        if (sessionAge > _maxSessionDuration) {
          debugPrint(
            '⏰ [Restore] sesión expirada',
          );
          await _clearSession();
          return const Left(
            AuthFailure.sessionExpired(
              message: 'Sesión expirada. Inicia de nuevo.',
            ),
          );
        }

        debugPrint(
          '✅ [Restore] sesión válida',
        );
      }

      _client.authStore.save(token, null);

      try {
        await _client.collection('users').authRefresh();
      } on Exception catch (error) {
        debugPrint(
          '❌ [Restore] token inválido: $error',
        );
        await _clearSession();
        return const Left(
          AuthFailure.sessionExpired(
            message: 'Sesión expirada',
          ),
        );
      }

      final record =
          await _client.collection('users').getOne(userId);
      final user = UserModel.fromPocketBase(record).toEntity();

      if (user.status != 'Active') {
        await _clearSession();
        return const Left(
          AuthFailure.sessionExpired(
            message: 'Cuenta no activa',
          ),
        );
      }

      return Right(user);
    } on Object catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al restaurar sesión: $error',
        ),
      );
    }
  }

  // Limpia token, identificador y marca de tiempo.
  Future<void> _clearSession() async {
    _client.authStore.clear();
    await _prefs.remove('pb_auth_token');
    await _prefs.remove('pb_auth_user_id');
    await _prefs.remove('pb_auth_email');
    await _prefs.remove('pb_login_timestamp');
  }

  /// Cierra la sesión local guardada.
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _clearSession();
      return const Right(null);
    } on Object catch (error) {
      debugPrint(
        '❌ [Logout] error al cerrar sesión: $error',
      );
      return const Left(
        ServerFailure(message: 'Error al cerrar sesión'),
      );
    }
  }
}
