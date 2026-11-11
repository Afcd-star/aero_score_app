// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivityItemEntity {

/// Identificador de la entidad afectada.
 String get id;/// Nombre o etiqueta descriptiva de la entidad.
 String get name;/// Acción sufrida por la entidad.
 ActivityAction get action;/// Tipo de entidad afectada.
 ActivityEntityType get entityType;/// Momento en que ocurrió la acción.
 DateTime get timestamp;
/// Create a copy of ActivityItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityItemEntityCopyWith<ActivityItemEntity> get copyWith => _$ActivityItemEntityCopyWithImpl<ActivityItemEntity>(this as ActivityItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,action,entityType,timestamp);

@override
String toString() {
  return 'ActivityItemEntity(id: $id, name: $name, action: $action, entityType: $entityType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ActivityItemEntityCopyWith<$Res>  {
  factory $ActivityItemEntityCopyWith(ActivityItemEntity value, $Res Function(ActivityItemEntity) _then) = _$ActivityItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, ActivityAction action, ActivityEntityType entityType, DateTime timestamp
});




}
/// @nodoc
class _$ActivityItemEntityCopyWithImpl<$Res>
    implements $ActivityItemEntityCopyWith<$Res> {
  _$ActivityItemEntityCopyWithImpl(this._self, this._then);

  final ActivityItemEntity _self;
  final $Res Function(ActivityItemEntity) _then;

/// Create a copy of ActivityItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? action = null,Object? entityType = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ActivityAction,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as ActivityEntityType,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityItemEntity].
extension ActivityItemEntityPatterns on ActivityItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _ActivityItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ActivityAction action,  ActivityEntityType entityType,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityItemEntity() when $default != null:
return $default(_that.id,_that.name,_that.action,_that.entityType,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ActivityAction action,  ActivityEntityType entityType,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _ActivityItemEntity():
return $default(_that.id,_that.name,_that.action,_that.entityType,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ActivityAction action,  ActivityEntityType entityType,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ActivityItemEntity() when $default != null:
return $default(_that.id,_that.name,_that.action,_that.entityType,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _ActivityItemEntity extends ActivityItemEntity {
  const _ActivityItemEntity({required this.id, required this.name, required this.action, required this.entityType, required this.timestamp}): super._();
  

/// Identificador de la entidad afectada.
@override final  String id;
/// Nombre o etiqueta descriptiva de la entidad.
@override final  String name;
/// Acción sufrida por la entidad.
@override final  ActivityAction action;
/// Tipo de entidad afectada.
@override final  ActivityEntityType entityType;
/// Momento en que ocurrió la acción.
@override final  DateTime timestamp;

/// Create a copy of ActivityItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityItemEntityCopyWith<_ActivityItemEntity> get copyWith => __$ActivityItemEntityCopyWithImpl<_ActivityItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,action,entityType,timestamp);

@override
String toString() {
  return 'ActivityItemEntity(id: $id, name: $name, action: $action, entityType: $entityType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ActivityItemEntityCopyWith<$Res> implements $ActivityItemEntityCopyWith<$Res> {
  factory _$ActivityItemEntityCopyWith(_ActivityItemEntity value, $Res Function(_ActivityItemEntity) _then) = __$ActivityItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ActivityAction action, ActivityEntityType entityType, DateTime timestamp
});




}
/// @nodoc
class __$ActivityItemEntityCopyWithImpl<$Res>
    implements _$ActivityItemEntityCopyWith<$Res> {
  __$ActivityItemEntityCopyWithImpl(this._self, this._then);

  final _ActivityItemEntity _self;
  final $Res Function(_ActivityItemEntity) _then;

/// Create a copy of ActivityItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? action = null,Object? entityType = null,Object? timestamp = null,}) {
  return _then(_ActivityItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ActivityAction,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as ActivityEntityType,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
