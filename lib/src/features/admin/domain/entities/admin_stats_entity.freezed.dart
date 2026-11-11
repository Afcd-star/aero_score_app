// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminStats {

/// Cantidad de usuarios con estado activo.
 int get activeUsers;/// Cantidad total de competidores registrados.
 int get totalCompetitors;/// Cantidad total de equipos registrados.
 int get totalTeams;/// Cantidad de eventos cuya fecha aún no ha ocurrido.
 int get upcomingEvents;
/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStatsCopyWith<AdminStats> get copyWith => _$AdminStatsCopyWithImpl<AdminStats>(this as AdminStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminStats&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers)&&(identical(other.totalCompetitors, totalCompetitors) || other.totalCompetitors == totalCompetitors)&&(identical(other.totalTeams, totalTeams) || other.totalTeams == totalTeams)&&(identical(other.upcomingEvents, upcomingEvents) || other.upcomingEvents == upcomingEvents));
}


@override
int get hashCode => Object.hash(runtimeType,activeUsers,totalCompetitors,totalTeams,upcomingEvents);

@override
String toString() {
  return 'AdminStats(activeUsers: $activeUsers, totalCompetitors: $totalCompetitors, totalTeams: $totalTeams, upcomingEvents: $upcomingEvents)';
}


}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res>  {
  factory $AdminStatsCopyWith(AdminStats value, $Res Function(AdminStats) _then) = _$AdminStatsCopyWithImpl;
@useResult
$Res call({
 int activeUsers, int totalCompetitors, int totalTeams, int upcomingEvents
});




}
/// @nodoc
class _$AdminStatsCopyWithImpl<$Res>
    implements $AdminStatsCopyWith<$Res> {
  _$AdminStatsCopyWithImpl(this._self, this._then);

  final AdminStats _self;
  final $Res Function(AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeUsers = null,Object? totalCompetitors = null,Object? totalTeams = null,Object? upcomingEvents = null,}) {
  return _then(_self.copyWith(
activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,totalCompetitors: null == totalCompetitors ? _self.totalCompetitors : totalCompetitors // ignore: cast_nullable_to_non_nullable
as int,totalTeams: null == totalTeams ? _self.totalTeams : totalTeams // ignore: cast_nullable_to_non_nullable
as int,upcomingEvents: null == upcomingEvents ? _self.upcomingEvents : upcomingEvents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminStats].
extension AdminStatsPatterns on AdminStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeUsers,  int totalCompetitors,  int totalTeams,  int upcomingEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.activeUsers,_that.totalCompetitors,_that.totalTeams,_that.upcomingEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeUsers,  int totalCompetitors,  int totalTeams,  int upcomingEvents)  $default,) {final _that = this;
switch (_that) {
case _AdminStats():
return $default(_that.activeUsers,_that.totalCompetitors,_that.totalTeams,_that.upcomingEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeUsers,  int totalCompetitors,  int totalTeams,  int upcomingEvents)?  $default,) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.activeUsers,_that.totalCompetitors,_that.totalTeams,_that.upcomingEvents);case _:
  return null;

}
}

}

/// @nodoc


class _AdminStats implements AdminStats {
  const _AdminStats({required this.activeUsers, required this.totalCompetitors, required this.totalTeams, required this.upcomingEvents});
  

/// Cantidad de usuarios con estado activo.
@override final  int activeUsers;
/// Cantidad total de competidores registrados.
@override final  int totalCompetitors;
/// Cantidad total de equipos registrados.
@override final  int totalTeams;
/// Cantidad de eventos cuya fecha aún no ha ocurrido.
@override final  int upcomingEvents;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStatsCopyWith<_AdminStats> get copyWith => __$AdminStatsCopyWithImpl<_AdminStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminStats&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers)&&(identical(other.totalCompetitors, totalCompetitors) || other.totalCompetitors == totalCompetitors)&&(identical(other.totalTeams, totalTeams) || other.totalTeams == totalTeams)&&(identical(other.upcomingEvents, upcomingEvents) || other.upcomingEvents == upcomingEvents));
}


@override
int get hashCode => Object.hash(runtimeType,activeUsers,totalCompetitors,totalTeams,upcomingEvents);

@override
String toString() {
  return 'AdminStats(activeUsers: $activeUsers, totalCompetitors: $totalCompetitors, totalTeams: $totalTeams, upcomingEvents: $upcomingEvents)';
}


}

/// @nodoc
abstract mixin class _$AdminStatsCopyWith<$Res> implements $AdminStatsCopyWith<$Res> {
  factory _$AdminStatsCopyWith(_AdminStats value, $Res Function(_AdminStats) _then) = __$AdminStatsCopyWithImpl;
@override @useResult
$Res call({
 int activeUsers, int totalCompetitors, int totalTeams, int upcomingEvents
});




}
/// @nodoc
class __$AdminStatsCopyWithImpl<$Res>
    implements _$AdminStatsCopyWith<$Res> {
  __$AdminStatsCopyWithImpl(this._self, this._then);

  final _AdminStats _self;
  final $Res Function(_AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeUsers = null,Object? totalCompetitors = null,Object? totalTeams = null,Object? upcomingEvents = null,}) {
  return _then(_AdminStats(
activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as int,totalCompetitors: null == totalCompetitors ? _self.totalCompetitors : totalCompetitors // ignore: cast_nullable_to_non_nullable
as int,totalTeams: null == totalTeams ? _self.totalTeams : totalTeams // ignore: cast_nullable_to_non_nullable
as int,upcomingEvents: null == upcomingEvents ? _self.upcomingEvents : upcomingEvents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
