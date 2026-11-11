// lib/src/features/auth/presentation/providers/auth_notifier.dart
import 'dart:async';

import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/auth/data/di/auth_providers.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/'
    'domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado base sellado para el flujo de autenticación.
sealed class AuthState {
  /// Crea el estado base de autenticación.
  const AuthState();
}

/// Estado inicial, antes de cualquier interacción.
final class AuthInitial extends AuthState {
  /// Crea el estado inicial con flag opcional de registro.
  const AuthInitial({this.registrationSuccess = false});

  /// Indica si el usuario acaba de registrarse con éxito.
  final bool registrationSuccess;
}

/// Estado de carga durante operaciones asíncronas.
final class AuthLoading extends AuthState {
  /// Crea el estado de carga.
  const AuthLoading();
}

/// Estado de cuenta pendiente de aprobación por el administrador.
class AuthPendingApproval extends AuthState {
  /// Crea el estado con datos del solicitante.
  const AuthPendingApproval({
    required this.username,
    required this.email,
  });

  /// Nombre de usuario de la cuenta pendiente.
  final String username;

  /// Correo electrónico de la cuenta pendiente.
  final String email;
}

/// Estado de autenticación exitosa con datos del usuario.
final class AuthSuccess extends AuthState {
  /// Crea el estado con la entidad del usuario autenticado.
  const AuthSuccess(this.user);

  /// Entidad del usuario autenticado.
  final UserEntity user;
}

/// Estado de error con el fallo de dominio correspondiente.
final class AuthError extends AuthState {
  /// Crea el estado con el fallo capturado.
  const AuthError(this.failure);

  /// Fallo de dominio que originó el error.
  final Failure failure;
}

/// Notificador de estado de autenticación con Riverpod 3.
class AuthNotifier extends Notifier<AuthState> {
  /// Crea el notificador sin dependencias externas directas.
  AuthNotifier();

  bool _sessionRestored = false;

  @override
  AuthState build() {
    if (!_sessionRestored) {
      _sessionRestored = true;
      unawaited(Future.microtask(_restoreSession));
    }
    return const AuthInitial();
  }

  /// Expone el estado actual para providers derivados.
  AuthState get currentState => state;

  AuthRepository get _repository =>
      ref.read(authRepositoryProvider);

  /// Inicia sesión con nombre de usuario y contraseña.
  Future<void> login(
    String username,
    String password,
  ) async {
    debugPrint(
      '🔵 [Auth] Iniciando login para: $username',
    );
    state = const AuthLoading();

    final result =
        await _repository.login(username, password);

    result.fold(
      (failure) {
        debugPrint(
          '🔴 [Auth] Login falló: ${failure.message}',
        );

        final isAuthRuleBlocked = failure.message
            .contains('pendiente de aprobación');

        if (isAuthRuleBlocked) {
          unawaited(
            _handlePendingApproval(username, failure),
          );
        } else {
          state = AuthError(failure);
        }
      },
      (user) {
        debugPrint(
          '✅ [Auth] Login exitoso: ${user.username}',
        );
        state = AuthSuccess(user);
      },
    );
  }

  /// Registra un nuevo usuario con datos de perfil.
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
  }) async {
    state = const AuthLoading();

    final result = await _repository.register(
      username: username,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
      firstName: firstName,
      lastName: lastName,
    );

    result.fold(
      (failure) => state = AuthError(failure),
      (_) {
        debugPrint('✅ [Auth] Registro exitoso');
        state = const AuthInitial(
          registrationSuccess: true,
        );
      },
    );
  }

  /// Cierra la sesión actual y limpia el estado.
  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    _sessionRestored = false;
    state = const AuthInitial();
  }

  /// Restablece el estado inicial tras un registro exitoso.
  void clearRegistrationSuccess() {
    state = const AuthInitial();
  }

  Future<void> _restoreSession() async {
    debugPrint(
      '🔄 [Auth] Intentando restaurar sesión...',
    );
    final result = await _repository.restoreSession();

    result.fold(
      (failure) {
        debugPrint(
          '❌ [Auth] Restore falló: ${failure.message}',
        );
        if (state is AuthInitial) {
          state = const AuthInitial();
        }
      },
      (user) {
        debugPrint(
          '✅ [Auth] Restore exitoso: ${user.username}',
        );
        state = AuthSuccess(user);
      },
    );
  }

  Future<void> _handlePendingApproval(
    String username,
    Failure failure,
  ) async {
    final userResult =
        await _repository.getUserInfo(username);

    userResult.fold(
      (_) => state = AuthError(failure),
      (user) => state = AuthPendingApproval(
        username: user.username,
        email: user.email,
      ),
    );
  }
}
