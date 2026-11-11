// lib/src/features/admin/data/repositories/admin_repository_impl.dart
import 'package:aero_score_app/src/core/config/environment.dart';
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/repositories/admin_repository.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:either_dart/either.dart';
import 'package:pocketbase/pocketbase.dart';

/// Repositorio de datos para el panel de administración.
class AdminRepositoryImpl implements AdminRepository {
  /// Crea una implementación con el cliente de PocketBase.
  AdminRepositoryImpl(AppEnvironment env)
      : _client = PocketBase(env.pbUrl);

  final PocketBase _client;

  // ✅ MANTENER: Operaciones transversales reales
  @override
  Future<Either<Failure, AdminStats>> getDashboardStats() async {
    try {
      // ✅ Ejecutar todas las queries en paralelo
      final results = await Future.wait([
        _client.collection('users').getList(
          filter: 'status = "Active"',
          perPage: 1,
        ),
        _client.collection('competitors').getList(
          perPage: 1,
        ),
        _client.collection('teams').getList(
          perPage: 1,
        ),
        _client.collection('events').getList(
          filter:
              'date > "${DateTime.now().toIso8601String()}"',
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
      final Object? responseMessage = error.response['message'];
      final message = responseMessage is String
          ? responseMessage
          : error.toString();
      return Left(ServerFailure(message: message));
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al obtener estadísticas: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>>
      getUsersPendingApproval() async {
    try {
      final result = await _client.collection('users').getList(
        filter: 'status="Pending Approval" || role="Viewer"',
        sort: '-created',
      );

      final users = result.items.map((record) {
        final roleValue = record.getStringValue('role');
        final statusValue = record.getStringValue('status');
        final createdValue = record.getStringValue('created');

        return UserEntity(
          id: record.id,
          username: record.getStringValue('username'),
          email: record.getStringValue('email'),
          firstName: record.getStringValue('firstName'),
          lastName: record.getStringValue('lastName'),
          role: UserRole.values.firstWhere(
            (value) => value.value == roleValue,
            orElse: () => UserRole.viewer,
          ),
          status:
              statusValue.isEmpty ? 'Pending Approval' : statusValue,
          created: DateTime.tryParse(createdValue) ?? DateTime.now(),
        );
      }).toList();

      return Right(users);
    } on ClientException catch (error) {
      final Object? responseMessage = error.response['message'];
      final errorMessage = responseMessage is String
          ? responseMessage
          : error.toString();
      return Left(
        ServerFailure(
          message: 'Error al cargar usuarios: $errorMessage',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error inesperado: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole(
    String userId,
    UserRole newRole,
  ) async {
    try {
      await _client.collection('users').update(
        userId,
        body: {
          'role': newRole.value,
          'status': 'Active',
        },
      );
      return const Right<Failure, void>(null);
    } on ClientException catch (error) {
      final Object? responseMessage = error.response['message'];
      final errorMessage = responseMessage is String
          ? responseMessage
          : error.toString();
      return Left(
        ServerFailure(
          message: 'Error al asignar rol: $errorMessage',
        ),
      );
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error inesperado: $error',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ActivityItemEntity>>>
      getRecentActivity({
    int limit = 5,
  }) async {
    try {
      // ✅ Consultar las últimas actualizaciones en paralelo
      final results = await Future.wait([
        _client.collection('teams').getList(
          sort: '-updated',
          perPage: limit,
        ),
        _client.collection('events').getList(
          sort: '-updated',
          perPage: limit,
        ),
        _client.collection('competitors').getList(
          sort: '-updated',
          perPage: limit,
        ),
      ]);

      final activities = <ActivityItemEntity>[];
      const creationWindow = Duration(seconds: 2);

      // ✅ Procesar equipos
      for (final record in results[0].items) {
        final created =
            DateTime.parse(record.getStringValue('created'));
        final updated =
            DateTime.parse(record.getStringValue('updated'));
        final isCreated =
            created.isAfter(updated.subtract(creationWindow));

        activities.add(
          ActivityItemEntity(
            id: record.id,
            name: record.getStringValue('name'),
            action:
                isCreated
                    ? ActivityAction.created
                    : ActivityAction.updated,
            entityType: ActivityEntityType.team,
            timestamp: updated,
          ),
        );
      }

      // ✅ Procesar eventos
      for (final record in results[1].items) {
        final created =
            DateTime.parse(record.getStringValue('created'));
        final updated =
            DateTime.parse(record.getStringValue('updated'));
        final isCreated =
            created.isAfter(updated.subtract(creationWindow));

        activities.add(
          ActivityItemEntity(
            id: record.id,
            name: record.getStringValue('name'),
            action:
                isCreated
                    ? ActivityAction.created
                    : ActivityAction.updated,
            entityType: ActivityEntityType.event,
            timestamp: updated,
          ),
        );
      }

      // ✅ Procesar competidores
      for (final record in results[2].items) {
        final created =
            DateTime.parse(record.getStringValue('created'));
        final updated =
            DateTime.parse(record.getStringValue('updated'));
        final isCreated =
            created.isAfter(updated.subtract(creationWindow));
        final firstName = record.getStringValue('firstName');
        final lastName = record.getStringValue('lastName');

        activities.add(
          ActivityItemEntity(
            id: record.id,
            name: '$firstName $lastName'.trim(),
            action:
                isCreated
                    ? ActivityAction.created
                    : ActivityAction.updated,
            entityType: ActivityEntityType.competitor,
            timestamp: updated,
          ),
        );
      }

      // ✅ Ordenar por timestamp descendente y limitar
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return Right(activities.take(limit).toList());
    } on ClientException catch (error) {
      final Object? responseMessage = error.response['message'];
      final message = responseMessage is String
          ? responseMessage
          : error.toString();
      return Left(ServerFailure(message: message));
    } on Exception catch (error) {
      return Left(
        ServerFailure(
          message: 'Error al obtener actividad reciente: $error',
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    _client.authStore.clear();
  }

  // ❌ ELIMINAR: createTeam, getTeams, updateTeam,
  // createCompetitor y operaciones similares.
  // ✅ Esas operaciones viven en features/teams/,
  // features/competitors/ y otras features.
}
