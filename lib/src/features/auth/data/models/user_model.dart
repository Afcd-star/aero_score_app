// lib/src/features/auth/data/models/user_model.dart
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:pocketbase/pocketbase.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,  // ← camelCase en Dart Y en PocketBase
    required super.lastName,   required super.role, required super.status, // ← camelCase en Dart Y en PocketBase
    super.profilePhoto,
    super.created,
    super.updated,
  });

  /// ✅ Factory desde PocketBase Record (campos camelCase)
  factory UserModel.fromPocketBase(RecordModel record) {
    return UserModel(
      id: record.id,
      username: record.getStringValue('username'),
      email: record.getStringValue('email'),
      // ✅ PocketBase usa camelCase: firstName, lastName
      firstName: record.getStringValue('firstName'),  // ← NO 'first_name'
      lastName: record.getStringValue('lastName'),    // ← NO 'last_name'
      profilePhoto: record.getStringValue('profilePhoto'),
      role: UserRole.fromStorage(record.getStringValue('role')), // ← 'Admin', 'JudgeP', etc.
      status: record.getStringValue('status'), // ← "Active", "Pending Approval"
      created: DateTime.parse(record.getStringValue('created')),
      updated: DateTime.parse(record.getStringValue('updated')),
    );
  }

  /// Convertir a Entity
  UserModel toEntity() => UserModel(
        id: id, username: username, email: email,
        firstName: firstName, lastName: lastName,
        profilePhoto: profilePhoto, role: role, status: status,
        created: created, updated: updated,
      );

  /// ✅ Convertir a Map para PocketBase (camelCase)
  Map<String, dynamic> toPocketBaseMap() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,  // ← camelCase para PB
      'lastName': lastName,    // ← camelCase para PB
      'profilePhoto': profilePhoto,
      'role': role.value,      // ← 'Admin', 'JudgeP', etc.
      'status': status,        // ← "Active", "Pending Approval"
    };
  }
}
