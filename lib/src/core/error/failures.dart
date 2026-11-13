// lib/src/core/error/failures.dart
abstract class Failure implements Exception {

  const Failure({required this.message, this.originalError});
  final String message;
  final dynamic originalError;

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.originalError});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.originalError});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.originalError});
}

class AuthFailure extends Failure {
  const AuthFailure.credentials({required super.message, super.originalError});

  const AuthFailure.sessionExpired({required super.message, super.originalError});

  const AuthFailure.pendingApproval({required super.message, super.originalError});

  const AuthFailure.inactive({required super.message, super.originalError});
}
