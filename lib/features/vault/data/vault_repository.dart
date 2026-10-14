import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../album/data/album_repository.dart';
import '../../health/data/health_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../domain/auto_read.dart';
import '../domain/insurance.dart';
import '../domain/pin_hash.dart';
import '../domain/share_rules.dart';
import '../domain/storage_quota.dart';
import '../domain/vault_models.dart';

/// A file that was just uploaded.
class StoredFile {
  const StoredFile({required this.url, required this.path, required this.sizeBytes});
  final String url;
  final String path;
  final int sizeBytes;
}

/// Uploads a vault or album file into the person's own storage folder
/// (storage.rules: users/{uid}/...).
Future<StoredFile> uploadUserFile(StorageService storage, Uint8List bytes,
    {required String uid, required String folder, required String ext, required String contentType}) async {
  final name = '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1 << 20)}.$ext';
  final path = 'users/$uid/$folder/$name';
  final url = await storage.upload(bytes, path: path, contentType: contentType);
  return StoredFile(url: url, path: path, sizeBytes: bytes.length);
}

/// Device description for share-link access logs.
String accessDeviceLabel() {
  if (kIsWeb) return 'Web browser';
  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'Android app',
    TargetPlatform.iOS => 'iPhone app',
    _ => 'App',
  };
}

class VaultRepository {
  VaultRepository(this._db, this._storage, this._health);
  final FirebaseFirestore _db;
  final StorageService _storage;
  final HealthRepository _health;

  CollectionReference<Map<String, dynamic>> get _docs => _db.collection('documents');

  // ---------- documents ----------

  Stream<List<VaultDoc>> watchPetDocs(String petId) =>
      _docs.where('petId', isEqualTo: petId).snapshots().map((s) => [for (final d in s.docs) VaultDoc(d.id, d.data())]);

  Stream<VaultDoc?> watchDoc(String id) => _docs.doc(id).snapshots().map((d) => d.exists ? VaultDoc(d.id, d.data()!) : null);

  Future<String> addDoc({
    required Pet pet,
    required AppUser by,
    required String type,
    required String title,
    required String? url,
    required String contentType,
    List<String> tags = const [],
    int sizeBytes = 0,
    String? fileName,
    String? storagePath,
    DateTime? expiry,
    String source = 'upload',
    String readStatus = 'none',
    Map<String, dynamic>? extracted,
    Map<String, dynamic> extra = const {},
  }) async {
    final ref = await _docs.add({
      ...extra,
      'ownerId': by.uid,
      'petId': pet.id,
      'type': type,
      'title': title,
      'tags': cleanTags(tags),
      'url': url,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'fileName': fileName,
      'storagePath': storagePath,
      'expiry': expiry,
      'source': source,
      'readStatus': readStatus,
      'extracted': extracted,
      'byName': by.name,
      'createdAt': DateTime.now(),
    });
    return ref.id;
  }

  Future<void> updateDoc(String id, Map<String, dynamic> fields) => _docs.doc(id).update(fields);

  Future<void> deleteDoc(VaultDoc d) async {
    await _docs.doc(d.id).delete();
    await _deleteReminders('docId', d.id);
    final url = d.url;
    if (url != null && !d.isSample && !url.startsWith('seed:')) await _storage.delete(url);
    // Unlink the certificate from a vaccine record so the health tab stays tidy.
    final linked = await _db.collection('vaccinations').where('certificateDocId', isEqualTo: d.id).get();
    for (final v in linked.docs) {
      await v.reference.update({'certificateDocId': null});
    }
  }

  Future<void> _deleteReminders(String field, String id) async {
    final old = await _db.collection('reminders').where(field, isEqualTo: id).get();
    for (final r in old.docs) {
      await r.reference.delete();
    }
  }

  /// One reminder per document with an expiry date (14 days before).
  /// Vaccine certificates are covered by the vaccine schedule instead.
  Future<void> setExpiryReminder({required String docId, required String type, required Pet pet, required String ownerId, required DateTime? expiry, required String title}) async {
    await _deleteReminders('docId', docId);
    if (expiry == null || type == 'vaccination') return;
    final at = expiryReminderAt(expiry, DateTime.now());
    if (at == null) return;
    await _db.collection('reminders').add({
      'ownerId': ownerId,
      'petId': pet.id,
      'type': type == 'insurance' ? 'insurance' : (type == 'licence' ? 'licence' : 'custom'),
      'title': title,
      'at': at,
      'repeat': 'none',
      'done': false,
      'docId': docId,
    });
  }

  /// Saves what the owner confirmed on the auto-read screen. Vaccines go
  /// into the health records through the health repository, insurance
  /// policies into the insurance tracker.
  Future<({bool vaccineRecorded, String? policyId})> saveReadDetails({
    required VaultDoc doc,
    required Pet pet,
    required AppUser by,
    required ExtractedDetails details,
    required String title,
    required List<String> tags,
    required bool addToHealth,
    required bool trackInsurance,
    required String reminderTitle,
  }) async {
    final expiry = details.type == 'insurance' ? details.expiry : (details.expiry ?? (details.type == 'vaccination' ? details.nextDue : null));
    await _docs.doc(doc.id).update({
      'type': details.type,
      'title': title,
      'tags': cleanTags(tags),
      'expiry': expiry,
      'extracted': {...details.toMap(), 'confirmedAt': DateTime.now(), 'confirmedBy': by.name},
      'readStatus': 'confirmed',
    });
    var recorded = false;
    if (addToHealth && details.isVaccine) {
      final records = await _health.watchVaccines(pet.id).first;
      final given = details.dateGiven ?? DateTime.now();
      final key = matchVaccineTemplate(
        species: pet.speciesEnum,
        vaccineName: details.vaccineName!,
        birthday: pet.birthday,
        givenDate: given,
        records: records,
      );
      await _health.recordVaccine(
        pet: pet,
        by: by,
        templateKey: key,
        name: details.vaccineName!,
        givenDate: given,
        brand: details.brand,
        batch: details.batch,
        vetName: details.vetName,
        clinicName: details.clinicName,
        certificateDocId: doc.id,
      );
      recorded = true;
    }
    String? policyId;
    if (trackInsurance && details.isInsurance) {
      policyId = await upsertPolicyFromDoc(pet: pet, by: by, docId: doc.id, details: details, reminderTitle: reminderTitle);
    } else {
      await setExpiryReminder(docId: doc.id, type: details.type, pet: pet, ownerId: by.uid, expiry: expiry, title: reminderTitle);
    }
    return (vaccineRecorded: recorded, policyId: policyId);
  }

  // ---------- insurance ----------

  CollectionReference<Map<String, dynamic>> get _ins => _db.collection('insurance');

  Stream<List<InsurancePolicy>> watchPetPolicies(String petId) =>
      _ins.where('petId', isEqualTo: petId).snapshots().map((s) => [for (final d in s.docs) InsurancePolicy(d.id, d.data())]);

  Stream<InsurancePolicy?> watchPolicy(String id) =>
      _ins.doc(id).snapshots().map((d) => d.exists ? InsurancePolicy(d.id, d.data()!) : null);

  Future<String> upsertPolicyFromDoc({required Pet pet, required AppUser by, required String docId, required ExtractedDetails details, required String reminderTitle}) async {
    final same = await _ins.where('petId', isEqualTo: pet.id).get();
    final existing = same.docs.where((d) => d.data()['policyNo'] == details.policyNo).firstOrNull;
    final data = {
      'petId': pet.id,
      'ownerId': by.uid,
      'provider': details.insurer ?? '',
      'policyNo': details.policyNo ?? '',
      'cover': details.cover ?? 0,
      'premium': details.premium ?? 0,
      'start': details.coverStart,
      'renewal': details.expiry,
      'docId': docId,
    };
    return savePolicy(existing?.id, data, pet: pet, reminderTitle: reminderTitle);
  }

  Future<String> savePolicy(String? id, Map<String, dynamic> data, {required Pet pet, required String reminderTitle}) async {
    late final String policyId;
    if (id == null) {
      final ref = await _ins.add({...data, 'claims': <Map<String, dynamic>>[], 'createdAt': DateTime.now()});
      policyId = ref.id;
    } else {
      await _ins.doc(id).update(data);
      policyId = id;
    }
    // Renewal reminder 14 days before, linked to the policy.
    await _deleteReminders('policyId', policyId);
    final renewal = data['renewal'] as DateTime?;
    final at = renewal == null ? null : expiryReminderAt(renewal, DateTime.now());
    if (at != null) {
      await _db.collection('reminders').add({
        'ownerId': data['ownerId'],
        'petId': pet.id,
        'type': 'insurance',
        'title': reminderTitle,
        'at': at,
        'repeat': 'none',
        'done': false,
        'policyId': policyId,
      });
    }
    return policyId;
  }

  Future<void> deletePolicy(String id) async {
    await _ins.doc(id).delete();
    await _deleteReminders('policyId', id);
  }

  /// Adds or replaces one claim (matched by id).
  Future<void> saveClaim(InsurancePolicy p, Map<String, dynamic> claim) async {
    final list = [for (final c in p.claims) c.raw];
    final i = list.indexWhere((c) => c['id'] == claim['id']);
    if (i >= 0) {
      list[i] = claim;
    } else {
      list.add(claim);
    }
    await _ins.doc(p.id).update({'claims': list});
  }

  Future<void> deleteClaim(InsurancePolicy p, String claimId) async {
    await _ins.doc(p.id).update({'claims': [for (final c in p.claims) if (c.id != claimId) c.raw]});
  }

  // ---------- share links ----------

  CollectionReference<Map<String, dynamic>> get _links => _db.collection('shareLinks');

  Stream<List<ShareLink>> watchMyLinks(String uid) => _links
      .where('ownerId', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) ShareLink(d.id, d.data())]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  /// Creates a view-only link. The token is the document id; the PIN is
  /// stored only as a salted hash.
  Future<String> createLink({
    required AppUser owner,
    required Pet pet,
    required String kind,
    List<String> docIds = const [],
    String? albumName,
    DateTime? expiresAt,
    String? pin,
  }) async {
    final token = newShareToken();
    await _links.doc(token).set({
      'ownerId': owner.uid,
      'ownerName': owner.firstName,
      'petId': pet.id,
      'petName': pet.name,
      'kind': kind,
      'docIds': docIds,
      'albumName': albumName,
      'expiresAt': expiresAt,
      'pinHash': pin == null || pin.isEmpty ? null : hashPin(pin),
      'revoked': false,
      'accessLog': <Map<String, dynamic>>[],
      'createdAt': DateTime.now(),
    });
    return token;
  }

  Future<void> revokeLink(String id) => _links.doc(id).update({'revoked': true, 'revokedAt': DateTime.now()});
}

final vaultRepositoryProvider = Provider<VaultRepository>((ref) => VaultRepository(
      ref.watch(firestoreProvider),
      ref.watch(storageServiceProvider),
      ref.watch(healthRepositoryProvider),
    ));

final petDocsProvider = StreamProvider.family<List<VaultDoc>, String>((ref, petId) => ref.watch(vaultRepositoryProvider).watchPetDocs(petId));
final docProvider = StreamProvider.family<VaultDoc?, String>((ref, id) => ref.watch(vaultRepositoryProvider).watchDoc(id));

/// Merges several loading lists into one.
AsyncValue<List<T>> mergeAsyncLists<T>(Iterable<AsyncValue<List<T>>> values) {
  final out = <T>[];
  for (final v in values) {
    if (v.hasError) return AsyncError<List<T>>(v.error!, v.stackTrace ?? StackTrace.current);
    if (!v.hasValue) return AsyncLoading<List<T>>();
    out.addAll(v.value!);
  }
  return AsyncData(out);
}

/// Documents for every pet the person cares for (archived pets included:
/// their records stay safe).
final myDocsProvider = Provider<AsyncValue<List<VaultDoc>>>((ref) {
  final pets = ref.watch(myPetsProvider);
  if (!pets.hasValue) return const AsyncLoading();
  return mergeAsyncLists([for (final p in pets.value!) ref.watch(petDocsProvider(p.id))]);
});

final petPoliciesProvider = StreamProvider.family<List<InsurancePolicy>, String>((ref, petId) => ref.watch(vaultRepositoryProvider).watchPetPolicies(petId));
final policyProvider = StreamProvider.family<InsurancePolicy?, String>((ref, id) => ref.watch(vaultRepositoryProvider).watchPolicy(id));

final myPoliciesProvider = Provider<AsyncValue<List<InsurancePolicy>>>((ref) {
  final pets = ref.watch(myPetsProvider);
  if (!pets.hasValue) return const AsyncLoading();
  return mergeAsyncLists([for (final p in pets.value!) ref.watch(petPoliciesProvider(p.id))]);
});

final myShareLinksProvider = StreamProvider<List<ShareLink>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(vaultRepositoryProvider).watchMyLinks(u.uid);
});

/// Storage used by the signed-in person against their plan's limit.
final storageUsageProvider = Provider<StorageUsage?>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return null;
  final docs = ref.watch(myDocsProvider).value;
  final pets = ref.watch(myPetsProvider).value ?? const <Pet>[];
  final album = mergeAsyncLists([for (final p in pets) ref.watch(petAlbumProvider(p.id))]).value;
  if (docs == null || album == null) return null;
  final gb = (ref.watch(planLimitsProvider)['storageGb'] as num?) ?? 1;
  return computeUsage(
    docSizes: docs.where((d) => d.ownerId == u.uid).map((d) => d.sizeBytes),
    albumSizes: album.where((i) => (i.byUid ?? i.ownerId) == u.uid).map((i) => i.sizeBytes),
    limitGb: gb,
  );
});
