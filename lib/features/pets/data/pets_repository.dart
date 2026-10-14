import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../domain/pet.dart';

class PetsRepository {
  PetsRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('pets');

  /// All pets the user owns or is a family member of.
  Stream<List<Pet>> watchMyPets(String uid) => _col
      .where('memberIds', arrayContains: uid)
      .snapshots()
      .map((s) => fromQuery(s, Pet.fromJson)..sort((a, b) => (a.createdAt ?? DateTime(2000)).compareTo(b.createdAt ?? DateTime(2000))));

  Stream<Pet?> watchPet(String id) =>
      _col.doc(id).snapshots().map((d) => d.exists ? fromDoc(d, Pet.fromJson) : null);

  Future<Pet?> getPet(String id) async {
    final d = await _col.doc(id).get();
    return d.exists ? fromDoc(d, Pet.fromJson) : null;
  }

  Future<String> addPet(Pet pet, {required String ownerName}) async {
    final ref = _col.doc();
    final json = toDoc(pet.toJson())
      ..['memberIds'] = [pet.ownerId]
      ..['members'] = {
        pet.ownerId: {'role': 'owner', 'name': ownerName, 'expiresAt': null}
      }
      ..['dailyPlan'] = pet.dailyPlan.toJson()
      ..['qrToken'] = 'qr_${ref.id}'
      ..['createdAt'] = DateTime.now();
    await ref.set(json);
    return ref.id;
  }

  Future<void> updatePet(String id, Map<String, dynamic> fields) => _col.doc(id).update(fields);

  Future<void> logActivity({
    required String petId,
    required String actorId,
    required String actorName,
    required String type,
    String? detail,
  }) =>
      _db.collection('activity').add({
        'petId': petId,
        'actorId': actorId,
        'actorName': actorName,
        'type': type,
        'detail': detail,
        'createdAt': DateTime.now(),
      });
}

final petsRepositoryProvider = Provider<PetsRepository>((ref) => PetsRepository(ref.watch(firestoreProvider)));

/// Pets for the signed-in user (active and archived).
final myPetsProvider = StreamProvider<List<Pet>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(petsRepositoryProvider).watchMyPets(user.uid);
});

final activePetsProvider = Provider<List<Pet>>((ref) {
  return (ref.watch(myPetsProvider).value ?? const []).where((p) => !p.archived).toList();
});

final petProvider = StreamProvider.family<Pet?, String>((ref, id) {
  return ref.watch(petsRepositoryProvider).watchPet(id);
});

/// The pet chosen in the top-bar switcher; null means "All pets".
final selectedPetProvider = Provider<Pet?>((ref) {
  final pets = ref.watch(activePetsProvider);
  final id = ref.watch(settingsProvider).selectedPetId;
  if (id == 'all') return null;
  if (pets.isEmpty) return null;
  return pets.firstWhere((p) => p.id == id, orElse: () => pets.first);
});

final allPetsSelectedProvider = Provider<bool>((ref) => ref.watch(settingsProvider).selectedPetId == 'all');
