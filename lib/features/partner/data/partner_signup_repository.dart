import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/demo/seed/seed_places.dart';
import '../../../core/providers.dart';

/// Business types a partner can sign up as, with the role they get once
/// approved.
const partnerKinds = ['clinic', 'groomer', 'trainer', 'boarder', 'walker', 'seller'];

String roleForKind(String kind) => switch (kind) {
      'clinic' => 'clinic_admin',
      _ => kind,
    };

class PartnerApplication {
  const PartnerApplication({
    required this.kind,
    required this.businessName,
    required this.areaKey,
    required this.phone,
    required this.address,
    required this.kycDocs,
    this.vcRegNo,
  });
  final String kind;
  final String businessName;
  final String areaKey;
  final String phone;
  final String address;
  final List<String> kycDocs;
  final String? vcRegNo;
}

/// Writes a partner application: the business listing (status "pending",
/// hidden from owners until an admin approves it in Phase 10) and an
/// application record for the admin queue.
class PartnerSignupRepository {
  PartnerSignupRepository(this._db, {required this.demo});
  final FirebaseFirestore _db;
  final bool demo;

  Future<String> submit(String uid, String language, PartnerApplication a) async {
    final area = areas[a.areaKey]!;
    final now = DateTime.now();
    final suffix = uid.length > 8 ? uid.substring(uid.length - 8) : uid;
    final common = <String, dynamic>{
      'name': a.businessName.trim(),
      'city': area.city,
      'area': area.name,
      'address': a.address.trim().isEmpty ? '${area.name}, ${area.city} ${area.pin}' : a.address.trim(),
      'pin': area.pin,
      'lat': area.lat,
      'lng': area.lng,
      'phone': a.phone.trim(),
      'status': 'pending',
      'rating': 0,
      'reviewCount': 0,
      'languages': {'en', language}.toList(),
      'kycDocs': a.kycDocs,
      'createdAt': now,
    };
    final String collection;
    final String id;
    final Map<String, dynamic> doc;
    switch (a.kind) {
      case 'clinic':
        collection = 'clinics';
        id = 'clinic_new_$suffix';
        doc = {
          ...common,
          'ownerUid': uid,
          'vcRegNo': a.vcRegNo,
          'is24x7': false,
          'emergencyPhone': null,
          'hours': standardHours(false),
          'species': ['dog', 'cat'],
          'services': [
            for (final s in ['consultation', 'vaccination'])
              {'id': s, 'price': s == 'consultation' ? 500 : 650, 'durationMin': s == 'consultation' ? 20 : 30, 'mode': 'instant', 'payments': ['online', 'at_clinic']},
          ],
          'consultationFee': 500,
          'teleVet': false,
          'vetIds': <String>[],
          'photoSeed': now.second % 6,
          'slotMinutes': 20,
          'bufferMinutes': 5,
          'capacityPerSlot': 1,
          'holidays': <DateTime>[],
          'cancellationHours': 4,
          'homeVisitRadiusKm': 0,
          'homeVisitFee': 0,
          'requestWindowHours': 2,
          'enquiriesEnabled': true,
        };
      case 'seller':
        collection = 'sellers';
        id = 'seller_new_$suffix';
        doc = {...common, 'uid': uid, 'gstin': null, 'returnPolicy': '7-day easy returns on unopened items'};
      default:
        collection = 'providers';
        id = 'prov_new_$suffix';
        doc = {
          ...common,
          'type': a.kind,
          'uid': uid,
          'species': a.kind == 'walker' || a.kind == 'trainer' ? ['dog'] : ['dog', 'cat'],
          'services': switch (a.kind) {
            'groomer' => [
                {'id': 'bath_brush', 'price': 799, 'durationMin': 60, 'mode': 'request', 'payments': ['online', 'at_clinic']},
              ],
            'trainer' => [
                {'id': 'obedience', 'price': 1500, 'durationMin': 60, 'mode': 'request', 'payments': ['online']},
              ],
            'boarder' => [
                {'id': 'boarding_night', 'price': 900, 'durationMin': 1440, 'mode': 'request', 'payments': ['online']},
              ],
            _ => [
                {'id': 'walk_30', 'price': 199, 'durationMin': 30, 'mode': 'request', 'payments': ['online']},
              ],
          },
          'packages': <Map<String, dynamic>>[],
          'homeVisit': a.kind != 'boarder',
          'atCentre': a.kind != 'walker',
          'radiusKm': 5,
          'travelFee': a.kind == 'walker' ? 0 : 150,
          'hours': standardHours(false),
          'slotMinutes': 30,
          'bufferMinutes': 10,
          'capacityPerSlot': 1,
          'holidays': <DateTime>[],
          'cancellationHours': 6,
          'requestWindowHours': 2,
          'enquiriesEnabled': true,
          'photoSeed': now.second % 6,
        };
    }
    await _db.collection(collection).doc(id).set(doc);
    await _db.collection('partnerApplications').doc(uid).set({
      'uid': uid,
      'kind': a.kind,
      'role': roleForKind(a.kind),
      'placeCollection': collection,
      'placeId': id,
      'businessName': a.businessName.trim(),
      'city': area.city,
      'vcRegNo': a.vcRegNo,
      'kycDocs': a.kycDocs,
      'status': 'pending',
      'createdAt': now,
    });
    // In the demo the account switches to the partner portal straight away
    // so the pending dashboard can be explored. With a real backend the
    // role is a custom claim that only an admin sets on approval.
    if (demo) {
      await _db.collection('users').doc(uid).update({'role': roleForKind(a.kind), 'partnerId': id, 'onboarded': true});
    }
    return id;
  }
}

final partnerSignupRepositoryProvider = Provider<PartnerSignupRepository>(
  (ref) => PartnerSignupRepository(ref.watch(firestoreProvider), demo: ref.watch(appConfigProvider).isStandalone),
);
