// lib/src/features/admin/data/repositories/admin_repository_impl.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/data/models/activity_item_dto.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:either_dart/either.dart';
import 'package:pocketbase/pocketbase.dart';

/// Repositorio de datos del panel de administracion contra PocketBase.
///
/// Agrega conteos y deduce actividad reciente. No construye entidades
/// de otras features a mano y no importa auth. Replica el patron de
/// inferencia del repositorio de competidores: no nombra el tipo de
/// retorno de `getList`, accede `.items` y `.totalItems`, y extrae el
/// mapa con `record.toJson()`.
class AdminRepositoryImpl implements AdminRepository {
  /// Crea la implementacion con el cliente de PocketBase inyectado.
  ///
  /// El cliente llega ya construido y con la sesion restaurada desde
  /// el proveedor global, igual que en el repositorio de competidores.
  AdminRepositoryImpl(this._client);

  final PocketBase _client;

  @override
  Future<Either<Failure, AdminStats>> getDashboardStats() async {
    try {
      final results = await Future.wait([
        _client.collection('users').getList(
          filter: 'status = "Active"',
          perPage: 1,
        ),
        _client.collection('competitors').getList(perPage: 1),
        _client.collection('teams').getList(perPage: 1),
        _client.collection('events').getList(
          filter: 'date > "${DateTime.now().toIso8601String()}"',
          perPage: 1,
        ),
      ]);
      return Right(
        AdminStats(
          activeUsers: results[0].totalItems,
          totalCompetitors: results[1].totalItems,
          totalTeams: results[2].totalItems,
          upcomingEvents: results[3].totalItems,
        ),
      );
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al obtener estadisticas',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ActivityItemEntity>>>
      getRecentActivity({
    int limit = 5,
  }) async {
    try {
      final results = await Future.wait([
        _client.collection('teams').getList(
          sort: '\u002Dupdated',
          perPage: limit,
        ),
        _client.collection('events').getList(
          sort: '\u002Dupdated',
          perPage: limit,
        ),
        _client.collection('competitors').getList(
          sort: '\u002Dupdated',
          perPage: limit,
        ),
      ]);
      final activities = <ActivityItemEntity>[
        ...results[0].items.map(
          (record) => ActivityItemDto.fromMap(
            record.toJson(),
            ActivityEntityType.team,
          )?.toEntity(),
        ).whereType<ActivityItemEntity>(),
        ...results[1].items.map(
          (record) => ActivityItemDto.fromMap(
            record.toJson(),
            ActivityEntityType.event,
          )?.toEntity(),
        ).whereType<ActivityItemEntity>(),
        ...results[2].items.map(
          (record) => ActivityItemDto.fromMap(
            record.toJson(),
            ActivityEntityType.competitor,
          )?.toEntity(),
        ).whereType<ActivityItemEntity>(),
      ]..sort(
        (a, b) =>
            b.timestamp.compareTo(a.timestamp),
      );
      return Right(activities.take(limit).toList());
    } on ClientException catch (error) {
      return Left(
        ServerFailure(
          message: _clientMessage(
            error,
            'Error al obtener actividad',
          ),
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(message: 'Error inesperado: $error'),
      );
    }
  }

  static String _clientMessage(
    ClientException error,
    String fallback,
  ) {
    final Object response = error.response;
    if (response is Map<String, dynamic>) {
      final Object? message = response['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return '$fallback: $error';
  }
}
