// lib/src/features/admin/domain/entities/admin_stats_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_stats_entity.freezed.dart';

/// Métricas agregadas del panel de administración.
///
/// Representa el estado global del sistema en un instante de lectura.
/// No conoce Flutter, no conoce PocketBase, no conoce Riverpod.
@freezed
abstract class AdminStats with _$AdminStats {
  /// Crea el paquete de métricas del dashboard.
  const factory AdminStats({
    /// Cantidad de usuarios con estado activo.
    required int activeUsers,

    /// Cantidad total de competidores registrados.
    required int totalCompetitors,

    /// Cantidad total de equipos registrados.
    required int totalTeams,

    /// Cantidad de eventos cuya fecha aún no ha ocurrido.
    required int upcomingEvents,
  }) = _AdminStats;
}
