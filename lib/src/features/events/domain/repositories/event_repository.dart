// lib/src/features/events/domain/repositories/event_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:either_dart/either.dart';

/// Contrato de repositorio para gestión de eventos de competición.
/// ✅ Define operaciones de dominio, no operaciones de base de datos.
abstract class EventRepository {
  /// Obtener todos los eventos (opcionalmente filtrados por estado/categoría)
  Future<Either<Failure, List<EventEntity>>> getAll({
    EventStatus? status,
    EventCategory? category,
    DateTime? fromDate,
  });

  /// Obtener evento por ID con relaciones expandidas (jueces, equipos)
  Future<Either<Failure, EventEntity>> getByIdWithRelations(String id);

  /// Crear nuevo evento (valida jueces obligatorios)
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event);

  /// Actualizar evento existente
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event);

  /// Eliminar evento (solo si no tiene resultados publicados)
  Future<Either<Failure, void>> deleteEvent(String id);

  /// ✅ CASOS DE USO ESPECÍFICOS
  /// Obtener eventos donde un juez participa (cualquier rol)
  Future<Either<Failure, List<EventEntity>>> getByJudgeId(String judgeId);

  /// Obtener eventos próximos (hoy o futuro) con equipos asignados
  Future<Either<Failure, List<EventEntity>>> getUpcomingWithTeams();

  /// Asignar equipo a evento existente
  Future<Either<Failure, EventEntity>> assignTeam(String eventId, String teamId);

  /// Remover equipo de evento
  Future<Either<Failure, EventEntity>> removeTeam(String eventId, String teamId);
}
