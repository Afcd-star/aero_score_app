// lib/src/features/events/domain/exceptions/event_exceptions.dart
// ✅ Excepciones tipadas - sin strings mágicos, con contexto

abstract class EventException implements Exception { // Para debugging: {fieldName, value, errorCode}
  
  const EventException(this.message, [this.context]);
  final String message;
  final dynamic context;
  
  @override
  String toString() => 'EventException: $message${context != null ? ' | $context' : ''}';
}

class EventAlreadyExistsException extends EventException {
  EventAlreadyExistsException(String eventName) 
    : super('Ya existe un evento registrado con el nombre "$eventName"', {'name': eventName});
}

class InvalidEventDateException extends EventException {
  InvalidEventDateException(DateTime attemptedDate) 
    : super('La fecha del evento debe ser posterior a la fecha actual', {
        'attempted': attemptedDate, 
        'current': DateTime.now(),
      });
}

class InsufficientJudgesException extends EventException {
  InsufficientJudgesException(int provided, int required) 
    : super('El evento requiere $required jueces asignados, se proporcionaron $provided', {
        'provided': provided, 
        'required': required,
      });
}