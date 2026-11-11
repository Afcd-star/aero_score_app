// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_config_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoleConfigEntity {

/// Identificador del registro de rol.
 String get id;/// Nombre del rol, alineado con el valor de almacenamiento
/// del campo de rol en la colección de usuarios.
 String get roleName;/// Conjunto de capacidades que otorga este rol.
 Set<RolePermission> get permissions;/// Estado operativo del rol.
 RoleStatus get status;/// Momento de creación del registro.
 DateTime get created;/// Momento de última actualización del registro.
 DateTime get updated;
/// Create a copy of RoleConfigEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleConfigEntityCopyWith<RoleConfigEntity> get copyWith => _$RoleConfigEntityCopyWithImpl<RoleConfigEntity>(this as RoleConfigEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleConfigEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.status, status) || other.status == status)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}


@override
int get hashCode => Object.hash(runtimeType,id,roleName,const DeepCollectionEquality().hash(permissions),status,created,updated);

@override
String toString() {
  return 'RoleConfigEntity(id: $id, roleName: $roleName, permissions: $permissions, status: $status, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $RoleConfigEntityCopyWith<$Res>  {
  factory $RoleConfigEntityCopyWith(RoleConfigEntity value, $Res Function(RoleConfigEntity) _then) = _$RoleConfigEntityCopyWithImpl;
@useResult
$Res call({
 String id, String roleName, Set<RolePermission> permissions, RoleStatus status, DateTime created, DateTime updated
});




}
/// @nodoc
class _$RoleConfigEntityCopyWithImpl<$Res>
    implements $RoleConfigEntityCopyWith<$Res> {
  _$RoleConfigEntityCopyWithImpl(this._self, this._then);

  final RoleConfigEntity _self;
  final $Res Function(RoleConfigEntity) _then;

/// Create a copy of RoleConfigEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roleName = null,Object? permissions = null,Object? status = null,Object? created = null,Object? updated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<RolePermission>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoleStatus,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleConfigEntity].
extension RoleConfigEntityPatterns on RoleConfigEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleConfigEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleConfigEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleConfigEntity value)  $default,){
final _that = this;
switch (_that) {
case _RoleConfigEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleConfigEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RoleConfigEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String roleName,  Set<RolePermission> permissions,  RoleStatus status,  DateTime created,  DateTime updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleConfigEntity() when $default != null:
return $default(_that.id,_that.roleName,_that.permissions,_that.status,_that.created,_that.updated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String roleName,  Set<RolePermission> permissions,  RoleStatus status,  DateTime created,  DateTime updated)  $default,) {final _that = this;
switch (_that) {
case _RoleConfigEntity():
return $default(_that.id,_that.roleName,_that.permissions,_that.status,_that.created,_that.updated);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String roleName,  Set<RolePermission> permissions,  RoleStatus status,  DateTime created,  DateTime updated)?  $default,) {final _that = this;
switch (_that) {
case _RoleConfigEntity() when $default != null:
return $default(_that.id,_that.roleName,_that.permissions,_that.status,_that.created,_that.updated);case _:
  return null;

}
}

}

/// @nodoc


class _RoleConfigEntity extends RoleConfigEntity {
  const _RoleConfigEntity({required this.id, required this.roleName, required final  Set<RolePermission> permissions, required this.status, required this.created, required this.updated}): _permissions = permissions,super._();
  

/// Identificador del registro de rol.
@override final  String id;
/// Nombre del rol, alineado con el valor de almacenamiento
/// del campo de rol en la colección de usuarios.
@override final  String roleName;
/// Conjunto de capacidades que otorga este rol.
 final  Set<RolePermission> _permissions;
/// Conjunto de capacidades que otorga este rol.
@override Set<RolePermission> get permissions {
  if (_permissions is EqualUnmodifiableSetView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_permissions);
}

/// Estado operativo del rol.
@override final  RoleStatus status;
/// Momento de creación del registro.
@override final  DateTime created;
/// Momento de última actualización del registro.
@override final  DateTime updated;

/// Create a copy of RoleConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleConfigEntityCopyWith<_RoleConfigEntity> get copyWith => __$RoleConfigEntityCopyWithImpl<_RoleConfigEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleConfigEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.roleName, roleName) || other.roleName == roleName)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.status, status) || other.status == status)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}


@override
int get hashCode => Object.hash(runtimeType,id,roleName,const DeepCollectionEquality().hash(_permissions),status,created,updated);

@override
String toString() {
  return 'RoleConfigEntity(id: $id, roleName: $roleName, permissions: $permissions, status: $status, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$RoleConfigEntityCopyWith<$Res> implements $RoleConfigEntityCopyWith<$Res> {
  factory _$RoleConfigEntityCopyWith(_RoleConfigEntity value, $Res Function(_RoleConfigEntity) _then) = __$RoleConfigEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String roleName, Set<RolePermission> permissions, RoleStatus status, DateTime created, DateTime updated
});




}
/// @nodoc
class __$RoleConfigEntityCopyWithImpl<$Res>
    implements _$RoleConfigEntityCopyWith<$Res> {
  __$RoleConfigEntityCopyWithImpl(this._self, this._then);

  final _RoleConfigEntity _self;
  final $Res Function(_RoleConfigEntity) _then;

/// Create a copy of RoleConfigEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roleName = null,Object? permissions = null,Object? status = null,Object? created = null,Object? updated = null,}) {
  return _then(_RoleConfigEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roleName: null == roleName ? _self.roleName : roleName // ignore: cast_nullable_to_non_nullable
as String,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as Set<RolePermission>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoleStatus,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
