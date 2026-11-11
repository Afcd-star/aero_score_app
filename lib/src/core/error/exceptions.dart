// lib/src/core/error/exceptions.dart
/// Excepciones personalizadas para manejo de errores en la capa de datos.
/// ✅ Usar en Repositorios y DataSources para comunicar fallos específicos.
library;


/// Excepción cuando una operación de red falla.
class ServerException implements Exception {

  const ServerException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (código: $statusCode)';
}

/// Excepción cuando no hay conexión a internet.
class NoInternetException implements Exception {
  const NoInternetException();

  @override
  String toString() => 'NoInternetException: Sin conexión a internet';
}

/// Excepción cuando una entidad no se encuentra.
class NotFoundException implements Exception {

  const NotFoundException(this.entity, this.id);
  final String entity;
  final String id;

  @override
  String toString() => 'NotFoundException: $entity con id $id no encontrado';
}

/// Excepción cuando una operación de validación FIG falla.
class ValidationException implements Exception {

  const ValidationException(this.field, this.message);
  final String field;
  final String message;

  @override
  String toString() => 'ValidationException: $field - $message';
}

/// Excepción cuando el cálculo de puntuación excede límites FIG.
class ScoreOutOfRangeException implements Exception {

  const ScoreOutOfRangeException(this.value, this.min, this.max);
  final double value;
  final double min;
  final double max;

  @override
  String toString() => 
      'ScoreOutOfRangeException: $value está fuera del rango válido [$min, $max]';
}