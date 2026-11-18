// lib/src/features/auth/domain/entities/user_entity.dart
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';

/// Identidad de un usuario del sistema tal como la expone el dominio.
///
/// Es pura, no importa Flutter. El estado de cuenta llega como cadena del
/// backend, con valores conocidos de activo, pendiente de aprobación e
/// inactivo.
class UserEntity {
  /// Crea la identidad con sus datos obligatorios y los opcionales.
  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    this.profilePhoto,
    this.created,
    this.updated,
  });

  /// Identificador del registro en el backend.
  final String id;

  /// Nombre de usuario con el que inicia sesión.
  final String username;

  /// Correo electrónico de contacto.
  final String email;

  /// Nombre de pila.
  final String firstName;

  /// Apellidos.
  final String lastName;

  /// Ruta o identificador de la foto de perfil, si tiene.
  final String? profilePhoto;

  /// Rol catalogado del usuario.
  final UserRole role;

  /// Estado de cuenta según el backend.
  ///
  /// Valores conocidos: `Active`, `Pending Approval` e `Inactive`.
  final String status;

  /// Marca de creación del registro, si el backend la envió.
  final DateTime? created;

  /// Marca de la última actualización del registro, si llegó.
  ///
  /// Es del registro, no de la sesión: cambia cuando un administrador
  /// edita al usuario, así que no sirve para medir actividad.
  final DateTime? updated;

  /// Nombre completo listo para mostrar.
  String get fullName => '$firstName $lastName'.trim();

  /// Indica si la cuenta está aprobada y puede operar.
  bool get isApproved => status == 'Active';

  /// Indica si la cuenta espera aprobación de un administrador.
  bool get isPending => status == 'Pending Approval';

  /// Indica si la cuenta fue desactivada.
  bool get isInactive => status == 'Inactive';
}
