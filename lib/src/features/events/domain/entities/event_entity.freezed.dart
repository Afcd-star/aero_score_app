// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventEntity {

 String get name; DateTime get date; String get location; EventCategory get category; EventStatus get status; String get principalJudgeId; String get artistryJudgeId; String get difficultyJudgeId; String get executionJudgeId; List<String> get teamIds; String? get id; String? get time; String? get description; List<String> get additionalJudgeIds; DateTime? get created; DateTime? get updated;
/// Create a copy of EventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventEntityCopyWith<EventEntity> get copyWith => _$EventEntityCopyWithImpl<EventEntity>(this as EventEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.principalJudgeId, principalJudgeId) || other.principalJudgeId == principalJudgeId)&&(identical(other.artistryJudgeId, artistryJudgeId) || other.artistryJudgeId == artistryJudgeId)&&(identical(other.difficultyJudgeId, difficultyJudgeId) || other.difficultyJudgeId == difficultyJudgeId)&&(identical(other.executionJudgeId, executionJudgeId) || other.executionJudgeId == executionJudgeId)&&const DeepCollectionEquality().equals(other.teamIds, teamIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.additionalJudgeIds, additionalJudgeIds)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}


@override
int get hashCode => Object.hash(runtimeType,name,date,location,category,status,principalJudgeId,artistryJudgeId,difficultyJudgeId,executionJudgeId,const DeepCollectionEquality().hash(teamIds),id,time,description,const DeepCollectionEquality().hash(additionalJudgeIds),created,updated);

@override
String toString() {
  return 'EventEntity(name: $name, date: $date, location: $location, category: $category, status: $status, principalJudgeId: $principalJudgeId, artistryJudgeId: $artistryJudgeId, difficultyJudgeId: $difficultyJudgeId, executionJudgeId: $executionJudgeId, teamIds: $teamIds, id: $id, time: $time, description: $description, additionalJudgeIds: $additionalJudgeIds, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $EventEntityCopyWith<$Res>  {
  factory $EventEntityCopyWith(EventEntity value, $Res Function(EventEntity) _then) = _$EventEntityCopyWithImpl;
@useResult
$Res call({
 String name, DateTime date, String location, EventCategory category, EventStatus status, String principalJudgeId, String artistryJudgeId, String difficultyJudgeId, String executionJudgeId, List<String> teamIds, String? id, String? time, String? description, List<String> additionalJudgeIds, DateTime? created, DateTime? updated
});




}
/// @nodoc
class _$EventEntityCopyWithImpl<$Res>
    implements $EventEntityCopyWith<$Res> {
  _$EventEntityCopyWithImpl(this._self, this._then);

  final EventEntity _self;
  final $Res Function(EventEntity) _then;

/// Create a copy of EventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? date = null,Object? location = null,Object? category = null,Object? status = null,Object? principalJudgeId = null,Object? artistryJudgeId = null,Object? difficultyJudgeId = null,Object? executionJudgeId = null,Object? teamIds = null,Object? id = freezed,Object? time = freezed,Object? description = freezed,Object? additionalJudgeIds = null,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,principalJudgeId: null == principalJudgeId ? _self.principalJudgeId : principalJudgeId // ignore: cast_nullable_to_non_nullable
as String,artistryJudgeId: null == artistryJudgeId ? _self.artistryJudgeId : artistryJudgeId // ignore: cast_nullable_to_non_nullable
as String,difficultyJudgeId: null == difficultyJudgeId ? _self.difficultyJudgeId : difficultyJudgeId // ignore: cast_nullable_to_non_nullable
as String,executionJudgeId: null == executionJudgeId ? _self.executionJudgeId : executionJudgeId // ignore: cast_nullable_to_non_nullable
as String,teamIds: null == teamIds ? _self.teamIds : teamIds // ignore: cast_nullable_to_non_nullable
as List<String>,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,additionalJudgeIds: null == additionalJudgeIds ? _self.additionalJudgeIds : additionalJudgeIds // ignore: cast_nullable_to_non_nullable
as List<String>,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventEntity].
extension EventEntityPatterns on EventEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventEntity value)  $default,){
final _that = this;
switch (_that) {
case _EventEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EventEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DateTime date,  String location,  EventCategory category,  EventStatus status,  String principalJudgeId,  String artistryJudgeId,  String difficultyJudgeId,  String executionJudgeId,  List<String> teamIds,  String? id,  String? time,  String? description,  List<String> additionalJudgeIds,  DateTime? created,  DateTime? updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventEntity() when $default != null:
return $default(_that.name,_that.date,_that.location,_that.category,_that.status,_that.principalJudgeId,_that.artistryJudgeId,_that.difficultyJudgeId,_that.executionJudgeId,_that.teamIds,_that.id,_that.time,_that.description,_that.additionalJudgeIds,_that.created,_that.updated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DateTime date,  String location,  EventCategory category,  EventStatus status,  String principalJudgeId,  String artistryJudgeId,  String difficultyJudgeId,  String executionJudgeId,  List<String> teamIds,  String? id,  String? time,  String? description,  List<String> additionalJudgeIds,  DateTime? created,  DateTime? updated)  $default,) {final _that = this;
switch (_that) {
case _EventEntity():
return $default(_that.name,_that.date,_that.location,_that.category,_that.status,_that.principalJudgeId,_that.artistryJudgeId,_that.difficultyJudgeId,_that.executionJudgeId,_that.teamIds,_that.id,_that.time,_that.description,_that.additionalJudgeIds,_that.created,_that.updated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DateTime date,  String location,  EventCategory category,  EventStatus status,  String principalJudgeId,  String artistryJudgeId,  String difficultyJudgeId,  String executionJudgeId,  List<String> teamIds,  String? id,  String? time,  String? description,  List<String> additionalJudgeIds,  DateTime? created,  DateTime? updated)?  $default,) {final _that = this;
switch (_that) {
case _EventEntity() when $default != null:
return $default(_that.name,_that.date,_that.location,_that.category,_that.status,_that.principalJudgeId,_that.artistryJudgeId,_that.difficultyJudgeId,_that.executionJudgeId,_that.teamIds,_that.id,_that.time,_that.description,_that.additionalJudgeIds,_that.created,_that.updated);case _:
  return null;

}
}

}

/// @nodoc


class _EventEntity implements EventEntity {
  const _EventEntity({required this.name, required this.date, required this.location, required this.category, required this.status, required this.principalJudgeId, required this.artistryJudgeId, required this.difficultyJudgeId, required this.executionJudgeId, required final  List<String> teamIds, this.id, this.time, this.description, final  List<String> additionalJudgeIds = const <String>[], this.created, this.updated}): _teamIds = teamIds,_additionalJudgeIds = additionalJudgeIds;
  

@override final  String name;
@override final  DateTime date;
@override final  String location;
@override final  EventCategory category;
@override final  EventStatus status;
@override final  String principalJudgeId;
@override final  String artistryJudgeId;
@override final  String difficultyJudgeId;
@override final  String executionJudgeId;
 final  List<String> _teamIds;
@override List<String> get teamIds {
  if (_teamIds is EqualUnmodifiableListView) return _teamIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teamIds);
}

@override final  String? id;
@override final  String? time;
@override final  String? description;
 final  List<String> _additionalJudgeIds;
@override@JsonKey() List<String> get additionalJudgeIds {
  if (_additionalJudgeIds is EqualUnmodifiableListView) return _additionalJudgeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_additionalJudgeIds);
}

@override final  DateTime? created;
@override final  DateTime? updated;

/// Create a copy of EventEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventEntityCopyWith<_EventEntity> get copyWith => __$EventEntityCopyWithImpl<_EventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.location, location) || other.location == location)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.principalJudgeId, principalJudgeId) || other.principalJudgeId == principalJudgeId)&&(identical(other.artistryJudgeId, artistryJudgeId) || other.artistryJudgeId == artistryJudgeId)&&(identical(other.difficultyJudgeId, difficultyJudgeId) || other.difficultyJudgeId == difficultyJudgeId)&&(identical(other.executionJudgeId, executionJudgeId) || other.executionJudgeId == executionJudgeId)&&const DeepCollectionEquality().equals(other._teamIds, _teamIds)&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._additionalJudgeIds, _additionalJudgeIds)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}


@override
int get hashCode => Object.hash(runtimeType,name,date,location,category,status,principalJudgeId,artistryJudgeId,difficultyJudgeId,executionJudgeId,const DeepCollectionEquality().hash(_teamIds),id,time,description,const DeepCollectionEquality().hash(_additionalJudgeIds),created,updated);

@override
String toString() {
  return 'EventEntity(name: $name, date: $date, location: $location, category: $category, status: $status, principalJudgeId: $principalJudgeId, artistryJudgeId: $artistryJudgeId, difficultyJudgeId: $difficultyJudgeId, executionJudgeId: $executionJudgeId, teamIds: $teamIds, id: $id, time: $time, description: $description, additionalJudgeIds: $additionalJudgeIds, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$EventEntityCopyWith<$Res> implements $EventEntityCopyWith<$Res> {
  factory _$EventEntityCopyWith(_EventEntity value, $Res Function(_EventEntity) _then) = __$EventEntityCopyWithImpl;
@override @useResult
$Res call({
 String name, DateTime date, String location, EventCategory category, EventStatus status, String principalJudgeId, String artistryJudgeId, String difficultyJudgeId, String executionJudgeId, List<String> teamIds, String? id, String? time, String? description, List<String> additionalJudgeIds, DateTime? created, DateTime? updated
});




}
/// @nodoc
class __$EventEntityCopyWithImpl<$Res>
    implements _$EventEntityCopyWith<$Res> {
  __$EventEntityCopyWithImpl(this._self, this._then);

  final _EventEntity _self;
  final $Res Function(_EventEntity) _then;

/// Create a copy of EventEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? date = null,Object? location = null,Object? category = null,Object? status = null,Object? principalJudgeId = null,Object? artistryJudgeId = null,Object? difficultyJudgeId = null,Object? executionJudgeId = null,Object? teamIds = null,Object? id = freezed,Object? time = freezed,Object? description = freezed,Object? additionalJudgeIds = null,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_EventEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,principalJudgeId: null == principalJudgeId ? _self.principalJudgeId : principalJudgeId // ignore: cast_nullable_to_non_nullable
as String,artistryJudgeId: null == artistryJudgeId ? _self.artistryJudgeId : artistryJudgeId // ignore: cast_nullable_to_non_nullable
as String,difficultyJudgeId: null == difficultyJudgeId ? _self.difficultyJudgeId : difficultyJudgeId // ignore: cast_nullable_to_non_nullable
as String,executionJudgeId: null == executionJudgeId ? _self.executionJudgeId : executionJudgeId // ignore: cast_nullable_to_non_nullable
as String,teamIds: null == teamIds ? _self._teamIds : teamIds // ignore: cast_nullable_to_non_nullable
as List<String>,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,additionalJudgeIds: null == additionalJudgeIds ? _self._additionalJudgeIds : additionalJudgeIds // ignore: cast_nullable_to_non_nullable
as List<String>,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
