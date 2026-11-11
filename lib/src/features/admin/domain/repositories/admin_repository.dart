// lib/src/features/admin/domain/repositories/admin_repository.dart
import 'package:aero_score_app/src/core/error/failures.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/activity_item_entity.dart';
import 'package:aero_score_app/src/features/admin/domain/entities/admin_stats_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:either_dart/either.dart';

/// Contrato de repositorio para operaciones ADMINISTRATIVAS TRANSVERSALES.
/// ❌ NO incluir CRUD de entidades que ya tienen su propio módulo feature.
/// ✅ Solo: métricas agregadas, gestión de usuarios globales, config del sistema.
abstract class AdminRepository {
  // ═════════════════════════════════════════════════════════════
  // ESTADÍSTICAS DEL DASHBOARD (operación transversal real)
  // ═════════════════════════════════════════════════════════════
  Future<Either<Failure, AdminStats>> getDashboardStats();

  // ═════════════════════════════════════════════════════════════
  // GESTIÓN DE USUARIOS GLOBALES (no de entidades de dominio)
  // ═════════════════════════════════════════════════════════════
  Future<Either<Failure, List<UserEntity>>> getUsersPendingApproval();
  Future<Either<Failure, void>> updateUserRole(String userId, UserRole newRole);

  // ═════════════════════════════════════════════════════════════
  // ACTIVIDAD RECIENTE (operación real)
  // ═════════════════════════════════════════════════════════════
  Future<Either<Failure, List<ActivityItemEntity>>> getRecentActivity({int limit = 5});

  // ═════════════════════════════════════════════════════════════
  // UTILIDADES
  // ═════════════════════════════════════════════════════════════
  Future<void> logout();
}
