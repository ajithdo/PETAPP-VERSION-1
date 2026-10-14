import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/format.dart';
import 'consultation.dart';
import 'televet_repository.dart';

/// What the vet filled in on the e-prescription builder.
class PrescriptionDraft {
  const PrescriptionDraft({required this.items, this.diagnosis = '', this.notes = '', this.followUp});
  final List<PrescriptionItem> items;
  final String diagnosis;
  final String notes;
  final DateTime? followUp;
}

/// Saves an e-prescription and puts it in the pet's records (spec 7.7):
/// the `prescriptions` doc, a Health "vet visit" entry, a vault document
/// (Phase 7 lists it), a follow-up reminder and a chat message.
///
/// Standalone demo: all written here. Firebase: the vet writes the
/// prescription (rules allow vets only); the onPrescriptionCreated trigger
/// in functions/src/phase6.ts writes the owner's records.
class PrescriptionService {
  PrescriptionService(this._db, this._storage, this._backend, {required this.writesOwnerRecords});
  final FirebaseFirestore _db;
  final StorageService _storage;
  final TeleVetBackend _backend;
  final bool writesOwnerRecords;

  /// Language the pet parent reads the prescription in.
  Future<String> ownerLanguage(String ownerId) async {
    try {
      return ((await _db.collection('users').doc(ownerId).get()).data()?['language'] as String?) ?? 'en';
    } catch (_) {
      return 'en';
    }
  }

  /// Builds the stored prescription map (also used to render the PDF
  /// before saving, so preview and saved file match).
  Map<String, dynamic> buildDoc({
    required Consultation c,
    required AppUser vet,
    required Map<String, dynamic> vetDoc,
    required Map<String, dynamic>? clinic,
    required PrescriptionDraft draft,
    required Map<String, dynamic> petInfo,
    required DateTime now,
  }) =>
      {
        'consultationId': c.id,
        'petId': c.petId,
        'petName': c.petName,
        'petSpecies': c.petSpecies,
        'petInfo': petInfo,
        'ownerId': c.ownerId,
        'ownerName': c.ownerName,
        'vetId': c.vetId ?? vet.partnerId,
        'vetUid': vet.uid,
        'vetName': vetDoc['name'] ?? vet.name,
        'qualification': vetDoc['qualification'] ?? '',
        'regNo': vetDoc['regNo'] ?? '',
        'clinicId': vetDoc['clinicId'] ?? c.clinicId,
        'clinicName': vetDoc['clinicName'] ?? c.clinicName,
        'clinicAddress': clinic?['address'] ?? '',
        'clinicPhone': clinic?['phone'] ?? '',
        'items': [for (final i in draft.items) i.toMap()],
        'diagnosis': draft.diagnosis,
        'notes': draft.notes,
        'followUp': draft.followUp,
        'createdAt': now,
      };

  Future<String> issue({
    required Consultation c,
    required AppUser vet,
    required Map<String, dynamic> doc,
    required Uint8List pdf,
    required String ownerLang,
  }) async {
    final ref = _db.collection('prescriptions').doc();
    final url = await _storage.upload(pdf, path: 'users/${vet.uid}/prescriptions/${ref.id}.pdf', contentType: 'application/pdf');
    await ref.set({...doc, 'url': url, 'language': ownerLang});
    await _db.collection('consultations').doc(c.id).update({'prescriptionId': ref.id});
    if (writesOwnerRecords) await writeOwnerRecords(ref.id, {...doc, 'url': url}, ownerLang);
    await _backend.send(c, vet, type: 'prescription', prescriptionId: ref.id, text: (doc['diagnosis'] as String?) ?? '');
    return ref.id;
  }

  /// Health entry, vault document, follow-up reminder and notification
  /// for the pet parent (in their language).
  Future<void> writeOwnerRecords(String id, Map<String, dynamic> rx, String lang) async {
    final l = lookupAppLocalizations(Locale(lang));
    final now = (rx['createdAt'] as DateTime?) ?? DateTime.now();
    final vetName = rx['vetName'] as String? ?? '';
    final petName = rx['petName'] as String? ?? '';
    final items = [for (final i in (rx['items'] as List?) ?? const []) PrescriptionItem.fromMap((i as Map).cast<String, dynamic>())];
    final meds = items.map((i) => i.medicine).where((m) => m.isNotEmpty).join(', ');
    final followUp = rx['followUp'] as DateTime?;
    final link = '/prescriptions/$id';
    final docRef = _db.collection('documents').doc('doc_$id');
    await docRef.set({
      'ownerId': rx['ownerId'],
      'petId': rx['petId'],
      'type': 'prescription',
      'title': l.rxDocTitle(petName, Fmt.date(now, lang)),
      'tags': ['prescription', 'tele-vet'],
      'url': rx['url'],
      'contentType': 'application/pdf',
      'expiry': null,
      'extracted': {'vetName': vetName, 'regNo': rx['regNo'], 'date': now, 'medicines': meds},
      'prescriptionId': id,
      'consultationId': rx['consultationId'],
      'link': link,
      'createdAt': now,
    });
    await _db.collection('healthEvents').doc('he_$id').set({
      'petId': rx['petId'],
      'type': 'vet_visit',
      'date': now,
      'nextDue': followUp,
      'title': l.rxEventTitle(vetName),
      'clinicName': rx['clinicName'],
      'diagnosis': rx['diagnosis'],
      'notes': meds.isEmpty ? (rx['notes'] as String? ?? '') : l.rxEventNotes(meds),
      'prescriptionId': id,
      'consultationId': rx['consultationId'],
      'docId': docRef.id,
      'link': link,
      'source': 'televet',
      'byUid': rx['vetUid'],
      'createdAt': now,
    });
    if (followUp != null) {
      await _db.collection('reminders').add({
        'ownerId': rx['ownerId'],
        'petId': rx['petId'],
        'type': 'custom',
        'title': l.rxFollowUpReminder(petName, vetName),
        'at': DateTime(followUp.year, followUp.month, followUp.day, 10),
        'repeat': 'none',
        'channels': ['push'],
        'done': false,
        'createdAt': now,
      });
    }
    await _db.collection('notifications').add({
      'uid': rx['ownerId'],
      'title': l.ntfPrescription(vetName, petName),
      'body': meds,
      'type': 'health',
      'link': link,
      'read': false,
      'createdAt': now,
    });
  }
}

final prescriptionServiceProvider = Provider<PrescriptionService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return PrescriptionService(
    ref.watch(firestoreProvider),
    ref.watch(storageServiceProvider),
    ref.watch(teleVetBackendProvider),
    writesOwnerRecords: cfg.isStandalone,
  );
});
