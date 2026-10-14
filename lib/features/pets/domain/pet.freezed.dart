// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PetMember {

 String get role; String get name;@NullableDateConverter() DateTime? get expiresAt;
/// Create a copy of PetMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetMemberCopyWith<PetMember> get copyWith => _$PetMemberCopyWithImpl<PetMember>(this as PetMember, _$identity);

  /// Serializes this PetMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PetMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PetMember&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PetMember;
  return Object.hash(runtimeType,_this.role,_this.name,_this.expiresAt);
}

@override
String toString() {
  final _this = this as PetMember;
  return 'PetMember(role: ${_this.role}, name: ${_this.name}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $PetMemberCopyWith<$Res>  {
  factory $PetMemberCopyWith(PetMember value, $Res Function(PetMember) _then) = _$PetMemberCopyWithImpl;
@useResult
$Res call({
 String role, String name,@NullableDateConverter() DateTime? expiresAt
});




}
/// @nodoc
class _$PetMemberCopyWithImpl<$Res>
    implements $PetMemberCopyWith<$Res> {
  _$PetMemberCopyWithImpl(this._self, this._then);

  final PetMember _self;
  final $Res Function(PetMember) _then;

/// Create a copy of PetMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? name = null,Object? expiresAt = freezed,}) {
  return _then(PetMember(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PetMember].
extension PetMemberPatterns on PetMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PetMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PetMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PetMember value)  $default,){
final _that = this;
switch (_that) {
case _PetMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PetMember value)?  $default,){
final _that = this;
switch (_that) {
case _PetMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String name, @NullableDateConverter()  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PetMember() when $default != null:
return $default(_that.role,_that.name,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String name, @NullableDateConverter()  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _PetMember():
return $default(_that.role,_that.name,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String name, @NullableDateConverter()  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _PetMember() when $default != null:
return $default(_that.role,_that.name,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PetMember implements PetMember {
  const _PetMember({required this.role, this.name = '', @NullableDateConverter() this.expiresAt});
  factory _PetMember.fromJson(Map<String, dynamic> json) => _$PetMemberFromJson(json);

@override final  String role;
@override@JsonKey() final  String name;
@override@NullableDateConverter() final  DateTime? expiresAt;

/// Create a copy of PetMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetMemberCopyWith<_PetMember> get copyWith => __$PetMemberCopyWithImpl<_PetMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PetMember&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,role,name,expiresAt);
}

@override
String toString() {
    return 'PetMember(role: $role, name: $name, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PetMemberCopyWith<$Res> implements $PetMemberCopyWith<$Res> {
  factory _$PetMemberCopyWith(_PetMember value, $Res Function(_PetMember) _then) = __$PetMemberCopyWithImpl;
@override @useResult
$Res call({
 String role, String name,@NullableDateConverter() DateTime? expiresAt
});




}
/// @nodoc
class __$PetMemberCopyWithImpl<$Res>
    implements _$PetMemberCopyWith<$Res> {
  __$PetMemberCopyWithImpl(this._self, this._then);

  final _PetMember _self;
  final $Res Function(_PetMember) _then;

/// Create a copy of PetMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? name = null,Object? expiresAt = freezed,}) {
  return _then(_PetMember(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DailyPlan {

 int get walks; int get meals; int get playMinutes;
/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyPlanCopyWith<DailyPlan> get copyWith => _$DailyPlanCopyWithImpl<DailyPlan>(this as DailyPlan, _$identity);

  /// Serializes this DailyPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailyPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyPlan&&(identical(other.walks, _this.walks) || other.walks == _this.walks)&&(identical(other.meals, _this.meals) || other.meals == _this.meals)&&(identical(other.playMinutes, _this.playMinutes) || other.playMinutes == _this.playMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailyPlan;
  return Object.hash(runtimeType,_this.walks,_this.meals,_this.playMinutes);
}

@override
String toString() {
  final _this = this as DailyPlan;
  return 'DailyPlan(walks: ${_this.walks}, meals: ${_this.meals}, playMinutes: ${_this.playMinutes})';
}


}

/// @nodoc
abstract mixin class $DailyPlanCopyWith<$Res>  {
  factory $DailyPlanCopyWith(DailyPlan value, $Res Function(DailyPlan) _then) = _$DailyPlanCopyWithImpl;
@useResult
$Res call({
 int walks, int meals, int playMinutes
});




}
/// @nodoc
class _$DailyPlanCopyWithImpl<$Res>
    implements $DailyPlanCopyWith<$Res> {
  _$DailyPlanCopyWithImpl(this._self, this._then);

  final DailyPlan _self;
  final $Res Function(DailyPlan) _then;

/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? walks = null,Object? meals = null,Object? playMinutes = null,}) {
  return _then(DailyPlan(
walks: null == walks ? _self.walks : walks // ignore: cast_nullable_to_non_nullable
as int,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as int,playMinutes: null == playMinutes ? _self.playMinutes : playMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyPlan].
extension DailyPlanPatterns on DailyPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyPlan value)  $default,){
final _that = this;
switch (_that) {
case _DailyPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyPlan value)?  $default,){
final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int walks,  int meals,  int playMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
return $default(_that.walks,_that.meals,_that.playMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int walks,  int meals,  int playMinutes)  $default,) {final _that = this;
switch (_that) {
case _DailyPlan():
return $default(_that.walks,_that.meals,_that.playMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int walks,  int meals,  int playMinutes)?  $default,) {final _that = this;
switch (_that) {
case _DailyPlan() when $default != null:
return $default(_that.walks,_that.meals,_that.playMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyPlan implements DailyPlan {
  const _DailyPlan({this.walks = 2, this.meals = 2, this.playMinutes = 20});
  factory _DailyPlan.fromJson(Map<String, dynamic> json) => _$DailyPlanFromJson(json);

@override@JsonKey() final  int walks;
@override@JsonKey() final  int meals;
@override@JsonKey() final  int playMinutes;

/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyPlanCopyWith<_DailyPlan> get copyWith => __$DailyPlanCopyWithImpl<_DailyPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyPlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyPlan&&(identical(other.walks, walks) || other.walks == walks)&&(identical(other.meals, meals) || other.meals == meals)&&(identical(other.playMinutes, playMinutes) || other.playMinutes == playMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,walks,meals,playMinutes);
}

@override
String toString() {
    return 'DailyPlan(walks: $walks, meals: $meals, playMinutes: $playMinutes)';
}


}

/// @nodoc
abstract mixin class _$DailyPlanCopyWith<$Res> implements $DailyPlanCopyWith<$Res> {
  factory _$DailyPlanCopyWith(_DailyPlan value, $Res Function(_DailyPlan) _then) = __$DailyPlanCopyWithImpl;
@override @useResult
$Res call({
 int walks, int meals, int playMinutes
});




}
/// @nodoc
class __$DailyPlanCopyWithImpl<$Res>
    implements _$DailyPlanCopyWith<$Res> {
  __$DailyPlanCopyWithImpl(this._self, this._then);

  final _DailyPlan _self;
  final $Res Function(_DailyPlan) _then;

/// Create a copy of DailyPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? walks = null,Object? meals = null,Object? playMinutes = null,}) {
  return _then(_DailyPlan(
walks: null == walks ? _self.walks : walks // ignore: cast_nullable_to_non_nullable
as int,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as int,playMinutes: null == playMinutes ? _self.playMinutes : playMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Pet {

 String get id; String get ownerId; String get name; String get species; String? get breedId; String? get breedOther;@NullableDateConverter() DateTime? get birthday; String? get gender; double? get weightKg; String get colorTag; String? get photoUrl; String? get markings; String? get microchip; bool get neutered; List<String> get allergies; String? get dietType; String? get clinicId; String? get insuranceDocId; String? get temperament; bool get archived; String? get archivedReason;@NullableDateConverter() DateTime? get archivedAt; bool get memorial; String? get memorialNote; List<String> get memberIds; Map<String, PetMember> get members; DailyPlan get dailyPlan; String? get qrToken; Map<String, dynamic>? get lost; double? get foodBagKg; int? get dailyPortionG; String? get foodProductId;@NullableDateConverter() DateTime? get foodOpenedAt;@NullableDateConverter() DateTime? get createdAt;
/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PetCopyWith<Pet> get copyWith => _$PetCopyWithImpl<Pet>(this as Pet, _$identity);

  /// Serializes this Pet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Pet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.species, _this.species) || other.species == _this.species)&&(identical(other.breedId, _this.breedId) || other.breedId == _this.breedId)&&(identical(other.breedOther, _this.breedOther) || other.breedOther == _this.breedOther)&&(identical(other.birthday, _this.birthday) || other.birthday == _this.birthday)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.colorTag, _this.colorTag) || other.colorTag == _this.colorTag)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.markings, _this.markings) || other.markings == _this.markings)&&(identical(other.microchip, _this.microchip) || other.microchip == _this.microchip)&&(identical(other.neutered, _this.neutered) || other.neutered == _this.neutered)&&const DeepCollectionEquality().equals(other.allergies, _this.allergies)&&(identical(other.dietType, _this.dietType) || other.dietType == _this.dietType)&&(identical(other.clinicId, _this.clinicId) || other.clinicId == _this.clinicId)&&(identical(other.insuranceDocId, _this.insuranceDocId) || other.insuranceDocId == _this.insuranceDocId)&&(identical(other.temperament, _this.temperament) || other.temperament == _this.temperament)&&(identical(other.archived, _this.archived) || other.archived == _this.archived)&&(identical(other.archivedReason, _this.archivedReason) || other.archivedReason == _this.archivedReason)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt)&&(identical(other.memorial, _this.memorial) || other.memorial == _this.memorial)&&(identical(other.memorialNote, _this.memorialNote) || other.memorialNote == _this.memorialNote)&&const DeepCollectionEquality().equals(other.memberIds, _this.memberIds)&&const DeepCollectionEquality().equals(other.members, _this.members)&&(identical(other.dailyPlan, _this.dailyPlan) || other.dailyPlan == _this.dailyPlan)&&(identical(other.qrToken, _this.qrToken) || other.qrToken == _this.qrToken)&&const DeepCollectionEquality().equals(other.lost, _this.lost)&&(identical(other.foodBagKg, _this.foodBagKg) || other.foodBagKg == _this.foodBagKg)&&(identical(other.dailyPortionG, _this.dailyPortionG) || other.dailyPortionG == _this.dailyPortionG)&&(identical(other.foodProductId, _this.foodProductId) || other.foodProductId == _this.foodProductId)&&(identical(other.foodOpenedAt, _this.foodOpenedAt) || other.foodOpenedAt == _this.foodOpenedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Pet;
  return Object.hashAll([runtimeType,_this.id,_this.ownerId,_this.name,_this.species,_this.breedId,_this.breedOther,_this.birthday,_this.gender,_this.weightKg,_this.colorTag,_this.photoUrl,_this.markings,_this.microchip,_this.neutered,const DeepCollectionEquality().hash(_this.allergies),_this.dietType,_this.clinicId,_this.insuranceDocId,_this.temperament,_this.archived,_this.archivedReason,_this.archivedAt,_this.memorial,_this.memorialNote,const DeepCollectionEquality().hash(_this.memberIds),const DeepCollectionEquality().hash(_this.members),_this.dailyPlan,_this.qrToken,const DeepCollectionEquality().hash(_this.lost),_this.foodBagKg,_this.dailyPortionG,_this.foodProductId,_this.foodOpenedAt,_this.createdAt]);
}

@override
String toString() {
  final _this = this as Pet;
  return 'Pet(id: ${_this.id}, ownerId: ${_this.ownerId}, name: ${_this.name}, species: ${_this.species}, breedId: ${_this.breedId}, breedOther: ${_this.breedOther}, birthday: ${_this.birthday}, gender: ${_this.gender}, weightKg: ${_this.weightKg}, colorTag: ${_this.colorTag}, photoUrl: ${_this.photoUrl}, markings: ${_this.markings}, microchip: ${_this.microchip}, neutered: ${_this.neutered}, allergies: ${_this.allergies}, dietType: ${_this.dietType}, clinicId: ${_this.clinicId}, insuranceDocId: ${_this.insuranceDocId}, temperament: ${_this.temperament}, archived: ${_this.archived}, archivedReason: ${_this.archivedReason}, archivedAt: ${_this.archivedAt}, memorial: ${_this.memorial}, memorialNote: ${_this.memorialNote}, memberIds: ${_this.memberIds}, members: ${_this.members}, dailyPlan: ${_this.dailyPlan}, qrToken: ${_this.qrToken}, lost: ${_this.lost}, foodBagKg: ${_this.foodBagKg}, dailyPortionG: ${_this.dailyPortionG}, foodProductId: ${_this.foodProductId}, foodOpenedAt: ${_this.foodOpenedAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PetCopyWith<$Res>  {
  factory $PetCopyWith(Pet value, $Res Function(Pet) _then) = _$PetCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String name, String species, String? breedId, String? breedOther,@NullableDateConverter() DateTime? birthday, String? gender, double? weightKg, String colorTag, String? photoUrl, String? markings, String? microchip, bool neutered, List<String> allergies, String? dietType, String? clinicId, String? insuranceDocId, String? temperament, bool archived, String? archivedReason,@NullableDateConverter() DateTime? archivedAt, bool memorial, String? memorialNote, List<String> memberIds, Map<String, PetMember> members, DailyPlan dailyPlan, String? qrToken, Map<String, dynamic>? lost, double? foodBagKg, int? dailyPortionG, String? foodProductId,@NullableDateConverter() DateTime? foodOpenedAt,@NullableDateConverter() DateTime? createdAt
});


$DailyPlanCopyWith<$Res> get dailyPlan;

}
/// @nodoc
class _$PetCopyWithImpl<$Res>
    implements $PetCopyWith<$Res> {
  _$PetCopyWithImpl(this._self, this._then);

  final Pet _self;
  final $Res Function(Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? species = null,Object? breedId = freezed,Object? breedOther = freezed,Object? birthday = freezed,Object? gender = freezed,Object? weightKg = freezed,Object? colorTag = null,Object? photoUrl = freezed,Object? markings = freezed,Object? microchip = freezed,Object? neutered = null,Object? allergies = null,Object? dietType = freezed,Object? clinicId = freezed,Object? insuranceDocId = freezed,Object? temperament = freezed,Object? archived = null,Object? archivedReason = freezed,Object? archivedAt = freezed,Object? memorial = null,Object? memorialNote = freezed,Object? memberIds = null,Object? members = null,Object? dailyPlan = null,Object? qrToken = freezed,Object? lost = freezed,Object? foodBagKg = freezed,Object? dailyPortionG = freezed,Object? foodProductId = freezed,Object? foodOpenedAt = freezed,Object? createdAt = freezed,}) {
  return _then(Pet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,breedId: freezed == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as String?,breedOther: freezed == breedOther ? _self.breedOther : breedOther // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,colorTag: null == colorTag ? _self.colorTag : colorTag // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,markings: freezed == markings ? _self.markings : markings // ignore: cast_nullable_to_non_nullable
as String?,microchip: freezed == microchip ? _self.microchip : microchip // ignore: cast_nullable_to_non_nullable
as String?,neutered: null == neutered ? _self.neutered : neutered // ignore: cast_nullable_to_non_nullable
as bool,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,dietType: freezed == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as String?,clinicId: freezed == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String?,insuranceDocId: freezed == insuranceDocId ? _self.insuranceDocId : insuranceDocId // ignore: cast_nullable_to_non_nullable
as String?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,archivedReason: freezed == archivedReason ? _self.archivedReason : archivedReason // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memorial: null == memorial ? _self.memorial : memorial // ignore: cast_nullable_to_non_nullable
as bool,memorialNote: freezed == memorialNote ? _self.memorialNote : memorialNote // ignore: cast_nullable_to_non_nullable
as String?,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as Map<String, PetMember>,dailyPlan: null == dailyPlan ? _self.dailyPlan : dailyPlan // ignore: cast_nullable_to_non_nullable
as DailyPlan,qrToken: freezed == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String?,lost: freezed == lost ? _self.lost : lost // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,foodBagKg: freezed == foodBagKg ? _self.foodBagKg : foodBagKg // ignore: cast_nullable_to_non_nullable
as double?,dailyPortionG: freezed == dailyPortionG ? _self.dailyPortionG : dailyPortionG // ignore: cast_nullable_to_non_nullable
as int?,foodProductId: freezed == foodProductId ? _self.foodProductId : foodProductId // ignore: cast_nullable_to_non_nullable
as String?,foodOpenedAt: freezed == foodOpenedAt ? _self.foodOpenedAt : foodOpenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyPlanCopyWith<$Res> get dailyPlan {
  
  return $DailyPlanCopyWith<$Res>(_self.dailyPlan, (value) {
    return _then(_self.copyWith(dailyPlan: value));
  });
}
}


/// Adds pattern-matching-related methods to [Pet].
extension PetPatterns on Pet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pet value)  $default,){
final _that = this;
switch (_that) {
case _Pet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pet value)?  $default,){
final _that = this;
switch (_that) {
case _Pet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String species,  String? breedId,  String? breedOther, @NullableDateConverter()  DateTime? birthday,  String? gender,  double? weightKg,  String colorTag,  String? photoUrl,  String? markings,  String? microchip,  bool neutered,  List<String> allergies,  String? dietType,  String? clinicId,  String? insuranceDocId,  String? temperament,  bool archived,  String? archivedReason, @NullableDateConverter()  DateTime? archivedAt,  bool memorial,  String? memorialNote,  List<String> memberIds,  Map<String, PetMember> members,  DailyPlan dailyPlan,  String? qrToken,  Map<String, dynamic>? lost,  double? foodBagKg,  int? dailyPortionG,  String? foodProductId, @NullableDateConverter()  DateTime? foodOpenedAt, @NullableDateConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pet() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.species,_that.breedId,_that.breedOther,_that.birthday,_that.gender,_that.weightKg,_that.colorTag,_that.photoUrl,_that.markings,_that.microchip,_that.neutered,_that.allergies,_that.dietType,_that.clinicId,_that.insuranceDocId,_that.temperament,_that.archived,_that.archivedReason,_that.archivedAt,_that.memorial,_that.memorialNote,_that.memberIds,_that.members,_that.dailyPlan,_that.qrToken,_that.lost,_that.foodBagKg,_that.dailyPortionG,_that.foodProductId,_that.foodOpenedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String species,  String? breedId,  String? breedOther, @NullableDateConverter()  DateTime? birthday,  String? gender,  double? weightKg,  String colorTag,  String? photoUrl,  String? markings,  String? microchip,  bool neutered,  List<String> allergies,  String? dietType,  String? clinicId,  String? insuranceDocId,  String? temperament,  bool archived,  String? archivedReason, @NullableDateConverter()  DateTime? archivedAt,  bool memorial,  String? memorialNote,  List<String> memberIds,  Map<String, PetMember> members,  DailyPlan dailyPlan,  String? qrToken,  Map<String, dynamic>? lost,  double? foodBagKg,  int? dailyPortionG,  String? foodProductId, @NullableDateConverter()  DateTime? foodOpenedAt, @NullableDateConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Pet():
return $default(_that.id,_that.ownerId,_that.name,_that.species,_that.breedId,_that.breedOther,_that.birthday,_that.gender,_that.weightKg,_that.colorTag,_that.photoUrl,_that.markings,_that.microchip,_that.neutered,_that.allergies,_that.dietType,_that.clinicId,_that.insuranceDocId,_that.temperament,_that.archived,_that.archivedReason,_that.archivedAt,_that.memorial,_that.memorialNote,_that.memberIds,_that.members,_that.dailyPlan,_that.qrToken,_that.lost,_that.foodBagKg,_that.dailyPortionG,_that.foodProductId,_that.foodOpenedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String name,  String species,  String? breedId,  String? breedOther, @NullableDateConverter()  DateTime? birthday,  String? gender,  double? weightKg,  String colorTag,  String? photoUrl,  String? markings,  String? microchip,  bool neutered,  List<String> allergies,  String? dietType,  String? clinicId,  String? insuranceDocId,  String? temperament,  bool archived,  String? archivedReason, @NullableDateConverter()  DateTime? archivedAt,  bool memorial,  String? memorialNote,  List<String> memberIds,  Map<String, PetMember> members,  DailyPlan dailyPlan,  String? qrToken,  Map<String, dynamic>? lost,  double? foodBagKg,  int? dailyPortionG,  String? foodProductId, @NullableDateConverter()  DateTime? foodOpenedAt, @NullableDateConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Pet() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.species,_that.breedId,_that.breedOther,_that.birthday,_that.gender,_that.weightKg,_that.colorTag,_that.photoUrl,_that.markings,_that.microchip,_that.neutered,_that.allergies,_that.dietType,_that.clinicId,_that.insuranceDocId,_that.temperament,_that.archived,_that.archivedReason,_that.archivedAt,_that.memorial,_that.memorialNote,_that.memberIds,_that.members,_that.dailyPlan,_that.qrToken,_that.lost,_that.foodBagKg,_that.dailyPortionG,_that.foodProductId,_that.foodOpenedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pet extends Pet {
  const _Pet({this.id = '', required this.ownerId, required this.name, required this.species, this.breedId, this.breedOther, @NullableDateConverter() this.birthday, this.gender, this.weightKg, this.colorTag = 'amber', this.photoUrl, this.markings, this.microchip, this.neutered = false,  List<String> allergies = const <String>[], this.dietType, this.clinicId, this.insuranceDocId, this.temperament, this.archived = false, this.archivedReason, @NullableDateConverter() this.archivedAt, this.memorial = false, this.memorialNote,  List<String> memberIds = const <String>[],  Map<String, PetMember> members = const <String, PetMember>{}, this.dailyPlan = const DailyPlan(), this.qrToken,  Map<String, dynamic>? lost, this.foodBagKg, this.dailyPortionG, this.foodProductId, @NullableDateConverter() this.foodOpenedAt, @NullableDateConverter() this.createdAt}): _allergies = allergies,_memberIds = memberIds,_members = members,_lost = lost,super._();
  factory _Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

@override@JsonKey() final  String id;
@override final  String ownerId;
@override final  String name;
@override final  String species;
@override final  String? breedId;
@override final  String? breedOther;
@override@NullableDateConverter() final  DateTime? birthday;
@override final  String? gender;
@override final  double? weightKg;
@override@JsonKey() final  String colorTag;
@override final  String? photoUrl;
@override final  String? markings;
@override final  String? microchip;
@override@JsonKey() final  bool neutered;
 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

@override final  String? dietType;
@override final  String? clinicId;
@override final  String? insuranceDocId;
@override final  String? temperament;
@override@JsonKey() final  bool archived;
@override final  String? archivedReason;
@override@NullableDateConverter() final  DateTime? archivedAt;
@override@JsonKey() final  bool memorial;
@override final  String? memorialNote;
 final  List<String> _memberIds;
@override@JsonKey() List<String> get memberIds {
  if (_memberIds is EqualUnmodifiableListView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberIds);
}

 final  Map<String, PetMember> _members;
@override@JsonKey() Map<String, PetMember> get members {
  if (_members is EqualUnmodifiableMapView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_members);
}

@override@JsonKey() final  DailyPlan dailyPlan;
@override final  String? qrToken;
 final  Map<String, dynamic>? _lost;
@override Map<String, dynamic>? get lost {
  final value = _lost;
  if (value == null) return null;
  if (_lost is EqualUnmodifiableMapView) return _lost;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  double? foodBagKg;
@override final  int? dailyPortionG;
@override final  String? foodProductId;
@override@NullableDateConverter() final  DateTime? foodOpenedAt;
@override@NullableDateConverter() final  DateTime? createdAt;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PetCopyWith<_Pet> get copyWith => __$PetCopyWithImpl<_Pet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pet&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.species, species) || other.species == species)&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.breedOther, breedOther) || other.breedOther == breedOther)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.colorTag, colorTag) || other.colorTag == colorTag)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.markings, markings) || other.markings == markings)&&(identical(other.microchip, microchip) || other.microchip == microchip)&&(identical(other.neutered, neutered) || other.neutered == neutered)&&const DeepCollectionEquality().equals(other.allergies, _allergies)&&(identical(other.dietType, dietType) || other.dietType == dietType)&&(identical(other.clinicId, clinicId) || other.clinicId == clinicId)&&(identical(other.insuranceDocId, insuranceDocId) || other.insuranceDocId == insuranceDocId)&&(identical(other.temperament, temperament) || other.temperament == temperament)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.archivedReason, archivedReason) || other.archivedReason == archivedReason)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.memorial, memorial) || other.memorial == memorial)&&(identical(other.memorialNote, memorialNote) || other.memorialNote == memorialNote)&&const DeepCollectionEquality().equals(other.memberIds, _memberIds)&&const DeepCollectionEquality().equals(other.members, _members)&&(identical(other.dailyPlan, dailyPlan) || other.dailyPlan == dailyPlan)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken)&&const DeepCollectionEquality().equals(other.lost, _lost)&&(identical(other.foodBagKg, foodBagKg) || other.foodBagKg == foodBagKg)&&(identical(other.dailyPortionG, dailyPortionG) || other.dailyPortionG == dailyPortionG)&&(identical(other.foodProductId, foodProductId) || other.foodProductId == foodProductId)&&(identical(other.foodOpenedAt, foodOpenedAt) || other.foodOpenedAt == foodOpenedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,ownerId,name,species,breedId,breedOther,birthday,gender,weightKg,colorTag,photoUrl,markings,microchip,neutered,const DeepCollectionEquality().hash(_allergies),dietType,clinicId,insuranceDocId,temperament,archived,archivedReason,archivedAt,memorial,memorialNote,const DeepCollectionEquality().hash(_memberIds),const DeepCollectionEquality().hash(_members),dailyPlan,qrToken,const DeepCollectionEquality().hash(_lost),foodBagKg,dailyPortionG,foodProductId,foodOpenedAt,createdAt]);
}

@override
String toString() {
    return 'Pet(id: $id, ownerId: $ownerId, name: $name, species: $species, breedId: $breedId, breedOther: $breedOther, birthday: $birthday, gender: $gender, weightKg: $weightKg, colorTag: $colorTag, photoUrl: $photoUrl, markings: $markings, microchip: $microchip, neutered: $neutered, allergies: $allergies, dietType: $dietType, clinicId: $clinicId, insuranceDocId: $insuranceDocId, temperament: $temperament, archived: $archived, archivedReason: $archivedReason, archivedAt: $archivedAt, memorial: $memorial, memorialNote: $memorialNote, memberIds: $memberIds, members: $members, dailyPlan: $dailyPlan, qrToken: $qrToken, lost: $lost, foodBagKg: $foodBagKg, dailyPortionG: $dailyPortionG, foodProductId: $foodProductId, foodOpenedAt: $foodOpenedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PetCopyWith<$Res> implements $PetCopyWith<$Res> {
  factory _$PetCopyWith(_Pet value, $Res Function(_Pet) _then) = __$PetCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String name, String species, String? breedId, String? breedOther,@NullableDateConverter() DateTime? birthday, String? gender, double? weightKg, String colorTag, String? photoUrl, String? markings, String? microchip, bool neutered, List<String> allergies, String? dietType, String? clinicId, String? insuranceDocId, String? temperament, bool archived, String? archivedReason,@NullableDateConverter() DateTime? archivedAt, bool memorial, String? memorialNote, List<String> memberIds, Map<String, PetMember> members, DailyPlan dailyPlan, String? qrToken, Map<String, dynamic>? lost, double? foodBagKg, int? dailyPortionG, String? foodProductId,@NullableDateConverter() DateTime? foodOpenedAt,@NullableDateConverter() DateTime? createdAt
});


@override $DailyPlanCopyWith<$Res> get dailyPlan;

}
/// @nodoc
class __$PetCopyWithImpl<$Res>
    implements _$PetCopyWith<$Res> {
  __$PetCopyWithImpl(this._self, this._then);

  final _Pet _self;
  final $Res Function(_Pet) _then;

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? species = null,Object? breedId = freezed,Object? breedOther = freezed,Object? birthday = freezed,Object? gender = freezed,Object? weightKg = freezed,Object? colorTag = null,Object? photoUrl = freezed,Object? markings = freezed,Object? microchip = freezed,Object? neutered = null,Object? allergies = null,Object? dietType = freezed,Object? clinicId = freezed,Object? insuranceDocId = freezed,Object? temperament = freezed,Object? archived = null,Object? archivedReason = freezed,Object? archivedAt = freezed,Object? memorial = null,Object? memorialNote = freezed,Object? memberIds = null,Object? members = null,Object? dailyPlan = null,Object? qrToken = freezed,Object? lost = freezed,Object? foodBagKg = freezed,Object? dailyPortionG = freezed,Object? foodProductId = freezed,Object? foodOpenedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_Pet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,breedId: freezed == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as String?,breedOther: freezed == breedOther ? _self.breedOther : breedOther // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,colorTag: null == colorTag ? _self.colorTag : colorTag // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,markings: freezed == markings ? _self.markings : markings // ignore: cast_nullable_to_non_nullable
as String?,microchip: freezed == microchip ? _self.microchip : microchip // ignore: cast_nullable_to_non_nullable
as String?,neutered: null == neutered ? _self.neutered : neutered // ignore: cast_nullable_to_non_nullable
as bool,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,dietType: freezed == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as String?,clinicId: freezed == clinicId ? _self.clinicId : clinicId // ignore: cast_nullable_to_non_nullable
as String?,insuranceDocId: freezed == insuranceDocId ? _self.insuranceDocId : insuranceDocId // ignore: cast_nullable_to_non_nullable
as String?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as String?,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,archivedReason: freezed == archivedReason ? _self.archivedReason : archivedReason // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memorial: null == memorial ? _self.memorial : memorial // ignore: cast_nullable_to_non_nullable
as bool,memorialNote: freezed == memorialNote ? _self.memorialNote : memorialNote // ignore: cast_nullable_to_non_nullable
as String?,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as Map<String, PetMember>,dailyPlan: null == dailyPlan ? _self.dailyPlan : dailyPlan // ignore: cast_nullable_to_non_nullable
as DailyPlan,qrToken: freezed == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String?,lost: freezed == lost ? _self._lost : lost // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,foodBagKg: freezed == foodBagKg ? _self.foodBagKg : foodBagKg // ignore: cast_nullable_to_non_nullable
as double?,dailyPortionG: freezed == dailyPortionG ? _self.dailyPortionG : dailyPortionG // ignore: cast_nullable_to_non_nullable
as int?,foodProductId: freezed == foodProductId ? _self.foodProductId : foodProductId // ignore: cast_nullable_to_non_nullable
as String?,foodOpenedAt: freezed == foodOpenedAt ? _self.foodOpenedAt : foodOpenedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Pet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyPlanCopyWith<$Res> get dailyPlan {
  
  return $DailyPlanCopyWith<$Res>(_self.dailyPlan, (value) {
    return _then(_self.copyWith(dailyPlan: value));
  });
}
}

// dart format on
