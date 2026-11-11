// lib/src/features/auth/domain/entities/role_config_entity.dart
import 'package:aero_score_app/src/'
    'features/auth/domain/entities/role_permission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_config_entity.freezed.dart';

/// Estado operativo de una configuracion de rol.
///
/// Coincide con el vocabulario de la coleccion de roles del
/// backend, que usa valores en minuscula. No se confunde con el
/// estado de usuario, que usa otro vocabulario.
enum RoleStatus {
  /// El rol esta habilitado para asignarse.
  active('active'),

  /// El rol esta deshabilitado.
  inactive('inactive');

  /// Crea el estado con su valor de almacenamiento.
  const RoleStatus(this.value);

  /// Valor de almacenamiento coincidente con el backend.
  final String value;
}

/// Configuracion dinamica de un rol gestionada por el backend.
///
/// Porta el nombre visible y el conjunto de permisos que ese rol
/// otorga. Es la mitad dinamica del modelo de roles; la mitad
/// estable es el catalogo de identidad.
@freezed
abstract class RoleConfigEntity with _$RoleConfigEntity {
  /// Crea la configuracion de un rol.
  const factory RoleConfigEntity({
    /// Identificador del registro de rol.
    required String id,

    /// Nombre del rol, alineado con el valor de almacenamiento
    /// del campo de rol en la coleccion de usuarios.
    required String roleName,

    /// Conjunto de capacidades que otorga este rol.
    required Set<RolePermission> permissions,

    /// Estado operativo del rol.
    required RoleStatus status,

    /// Momento de creacion del registro.
    required DateTime created,

    /// Momento de ultima actualizacion del registro.
    required DateTime updated,
  }) = _RoleConfigEntity;

  /// Constructor privado requerido por Freezed para los getters
  /// propios. Va despues de la factoria por el orden que exige
  /// el lint de constructores sin nombre primero.
  const RoleConfigEntity._();

  /// Indica si el rol puede asignarse actualmente.
  bool get isEnabled => status == RoleStatus.active;

  /// Indica si el rol otorga una capacidad concreta.
  bool can(RolePermission permission) =>
      permissions.contains(permission);
}
