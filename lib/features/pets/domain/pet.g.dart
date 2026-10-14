// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetMember _$PetMemberFromJson(Map<String, dynamic> json) => _PetMember(
  role: json['role'] as String,
  name: json['name'] as String? ?? '',
  expiresAt: const NullableDateConverter().fromJson(json['expiresAt']),
);

Map<String, dynamic> _$PetMemberToJson(_PetMember instance) =>
    <String, dynamic>{
      'role': instance.role,
      'name': instance.name,
      'expiresAt': const NullableDateConverter().toJson(instance.expiresAt),
    };

_DailyPlan _$DailyPlanFromJson(Map<String, dynamic> json) => _DailyPlan(
  walks: (json['walks'] as num?)?.toInt() ?? 2,
  meals: (json['meals'] as num?)?.toInt() ?? 2,
  playMinutes: (json['playMinutes'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$DailyPlanToJson(_DailyPlan instance) =>
    <String, dynamic>{
      'walks': instance.walks,
      'meals': instance.meals,
      'playMinutes': instance.playMinutes,
    };

_Pet _$PetFromJson(Map<String, dynamic> json) => _Pet(
  id: json['id'] as String? ?? '',
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  species: json['species'] as String,
  breedId: json['breedId'] as String?,
  breedOther: json['breedOther'] as String?,
  birthday: const NullableDateConverter().fromJson(json['birthday']),
  gender: json['gender'] as String?,
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  colorTag: json['colorTag'] as String? ?? 'amber',
  photoUrl: json['photoUrl'] as String?,
  markings: json['markings'] as String?,
  microchip: json['microchip'] as String?,
  neutered: json['neutered'] as bool? ?? false,
  allergies:
      (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  dietType: json['dietType'] as String?,
  clinicId: json['clinicId'] as String?,
  insuranceDocId: json['insuranceDocId'] as String?,
  temperament: json['temperament'] as String?,
  archived: json['archived'] as bool? ?? false,
  archivedReason: json['archivedReason'] as String?,
  archivedAt: const NullableDateConverter().fromJson(json['archivedAt']),
  memorial: json['memorial'] as bool? ?? false,
  memorialNote: json['memorialNote'] as String?,
  memberIds:
      (json['memberIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  members:
      (json['members'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, PetMember.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, PetMember>{},
  dailyPlan: json['dailyPlan'] == null
      ? const DailyPlan()
      : DailyPlan.fromJson(json['dailyPlan'] as Map<String, dynamic>),
  qrToken: json['qrToken'] as String?,
  lost: json['lost'] as Map<String, dynamic>?,
  foodBagKg: (json['foodBagKg'] as num?)?.toDouble(),
  dailyPortionG: (json['dailyPortionG'] as num?)?.toInt(),
  foodProductId: json['foodProductId'] as String?,
  foodOpenedAt: const NullableDateConverter().fromJson(json['foodOpenedAt']),
  createdAt: const NullableDateConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$PetToJson(_Pet instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'name': instance.name,
  'species': instance.species,
  'breedId': instance.breedId,
  'breedOther': instance.breedOther,
  'birthday': const NullableDateConverter().toJson(instance.birthday),
  'gender': instance.gender,
  'weightKg': instance.weightKg,
  'colorTag': instance.colorTag,
  'photoUrl': instance.photoUrl,
  'markings': instance.markings,
  'microchip': instance.microchip,
  'neutered': instance.neutered,
  'allergies': instance.allergies,
  'dietType': instance.dietType,
  'clinicId': instance.clinicId,
  'insuranceDocId': instance.insuranceDocId,
  'temperament': instance.temperament,
  'archived': instance.archived,
  'archivedReason': instance.archivedReason,
  'archivedAt': const NullableDateConverter().toJson(instance.archivedAt),
  'memorial': instance.memorial,
  'memorialNote': instance.memorialNote,
  'memberIds': instance.memberIds,
  'members': instance.members,
  'dailyPlan': instance.dailyPlan,
  'qrToken': instance.qrToken,
  'lost': instance.lost,
  'foodBagKg': instance.foodBagKg,
  'dailyPortionG': instance.dailyPortionG,
  'foodProductId': instance.foodProductId,
  'foodOpenedAt': const NullableDateConverter().toJson(instance.foodOpenedAt),
  'createdAt': const NullableDateConverter().toJson(instance.createdAt),
};
