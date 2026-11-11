// lib/src/features/auth/domain/entities/user_entity.dart
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';

class UserEntity { // Para control de expiración de sesión

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role, required this.status, this.profilePhoto,
    this.created,
    this.updated,
  });
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePhoto;
  final UserRole role;
  final String status; // 'Active', 'Pending Approval'
  final DateTime? created;
  final DateTime? updated;

  String get fullName => '$firstName $lastName'.trim();
  bool get isApproved => status == 'Active';
  bool get isPending => status == 'Pending Approval';
  bool get isInactive => status == 'Inactive';

  bool get isExpired {
    if (updated == null) return false;
    // Sesión expira después de 24 horas sin actividad
    return DateTime.now().difference(updated!) > const Duration(hours: 24);
  }
}
