import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/converters.dart';
import '../../../core/utils/format.dart';
import 'breeds.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

/// Family roles per pet (spec 6). Owner > Co-owner > Carer > Viewer.
enum PetRole { owner, coowner, carer, viewer }

PetRole parsePetRole(String? s) =>
    PetRole.values.firstWhere((r) => r.name == s, orElse: () => PetRole.viewer);

@freezed
abstract class PetMember with _$PetMember {
  const factory PetMember({
    required String role,
    @Default('') String name,
    @NullableDateConverter() DateTime? expiresAt,
  }) = _PetMember;

  factory PetMember.fromJson(Map<String, dynamic> json) => _$PetMemberFromJson(json);
}

@freezed
abstract class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    @Default(2) int walks,
    @Default(2) int meals,
    @Default(20) int playMinutes,
  }) = _DailyPlan;

  factory DailyPlan.fromJson(Map<String, dynamic> json) => _$DailyPlanFromJson(json);
}

@freezed
abstract class Pet with _$Pet {
  const Pet._();

  const factory Pet({
    @Default('') String id,
    required String ownerId,
    required String name,
    required String species,
    String? breedId,
    String? breedOther,
    @NullableDateConverter() DateTime? birthday,
    String? gender,
    double? weightKg,
    @Default('amber') String colorTag,
    String? photoUrl,
    String? markings,
    String? microchip,
    @Default(false) bool neutered,
    @Default(<String>[]) List<String> allergies,
    String? dietType,
    String? clinicId,
    String? insuranceDocId,
    String? temperament,
    @Default(false) bool archived,
    String? archivedReason,
    @NullableDateConverter() DateTime? archivedAt,
    @Default(false) bool memorial,
    String? memorialNote,
    @Default(<String>[]) List<String> memberIds,
    @Default(<String, PetMember>{}) Map<String, PetMember> members,
    @Default(DailyPlan()) DailyPlan dailyPlan,
    String? qrToken,
    Map<String, dynamic>? lost,
    double? foodBagKg,
    int? dailyPortionG,
    String? foodProductId,
    @NullableDateConverter() DateTime? foodOpenedAt,
    @NullableDateConverter() DateTime? createdAt,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);

  Species get speciesEnum => speciesFromName(species);
  Breed? get breed => breedId == null ? null : breedById[breedId];
  bool get isBird => species == 'bird';
  bool get flatFaced => breed?.flatFaced ?? false;
  BreedSize get size => breed?.size ?? BreedSize.medium;

  String breedName(String lang) {
    if (breedId == mixedBreedId) return switch (lang) { 'hi' => 'मिश्रित / देसी', 'te' => 'మిశ్రమ / దేశీ', _ => 'Mixed / Indie' };
    if (breedId == otherBreedId || breed == null) return breedOther ?? '';
    return breed!.name(lang);
  }

  ({int years, int months})? age([DateTime? now]) =>
      birthday == null ? null : ageParts(birthday!, now ?? DateTime.now());

  /// puppy/kitten/young, adult or senior, by species and size.
  String lifeStage([DateTime? now]) {
    final a = age(now);
    if (a == null) return 'adult';
    final y = a.years + a.months / 12;
    if (y < 1) return 'young';
    final senior = switch (speciesEnum) {
      Species.dog => switch (size) { BreedSize.giant => 6, BreedSize.large => 7, BreedSize.medium => 8, BreedSize.small => 10 },
      Species.cat => 11,
      Species.rabbit => 6,
      Species.bird => 10,
    };
    return y >= senior ? 'senior' : 'adult';
  }

  PetRole roleOf(String uid) {
    if (uid == ownerId) return PetRole.owner;
    final m = members[uid];
    if (m == null) return PetRole.viewer;
    if (m.expiresAt != null && m.expiresAt!.isBefore(DateTime.now())) return PetRole.viewer;
    return parsePetRole(m.role);
  }

  bool canLog(String uid) => roleOf(uid) != PetRole.viewer || members[uid]?.role == 'viewer';
  bool canEdit(String uid) => const [PetRole.owner, PetRole.coowner].contains(roleOf(uid));
  bool canCare(String uid) => const [PetRole.owner, PetRole.coowner, PetRole.carer].contains(roleOf(uid));
  bool canDelete(String uid) => roleOf(uid) == PetRole.owner;
}
