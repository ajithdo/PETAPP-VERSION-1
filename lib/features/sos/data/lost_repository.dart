import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../pets/domain/pet.dart';
import '../domain/lost_rules.dart';
import 'safety_notify.dart';

class LostReport {
  LostReport(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get petId => (raw['petId'] as String?) ?? '';
  String get status => (raw['status'] as String?) ?? 'lost';
  bool get isLost => status == 'lost';
  DateTime get since => parseDate(raw['since']) ?? DateTime.now();
  DateTime? get foundAt => parseDate(raw['foundAt']);
  String get area => (raw['area'] as String?) ?? '';
  double? get lat => (raw['lat'] as num?)?.toDouble();
  double? get lng => (raw['lng'] as num?)?.toDouble();
  String get note => (raw['note'] as String?) ?? '';
  bool get alert => (raw['alert'] as bool?) ?? false;
  int get alertsSent => (raw['alertsSent'] as num?)?.toInt() ?? 0;
  List<Sighting> get sightings => [
        for (final s in (raw['sightings'] as List?) ?? const []) Sighting.fromMap(s as Map, (v) => parseDate(v) ?? DateTime.now()),
      ]..sort((a, b) => b.at.compareTo(a.at));
}

/// The owner's side of lost pet mode: QR tag, mark as lost, found.
class LostRepository {
  LostRepository(this._db, this._notifier, {required this.standalone});
  final FirebaseFirestore _db;
  final SafetyNotifier _notifier;

  /// In the standalone demo the app sends the alerts itself; with Firebase
  /// the onLostReportWritten function does (functions/src/phase9.ts).
  final bool standalone;

  /// The pet's tag id, creating a new hard-to-guess one if needed.
  Future<String> ensureQrToken(Pet pet) async {
    // New pets get qr_<random document id>; seeded pets get a random tag.
    // Anything shorter (or missing) is replaced with a fresh random tag.
    final t = pet.qrToken;
    if (t != null && t.length >= 16) return t;
    final token = newQrToken();
    await _db.collection('pets').doc(pet.id).update({'qrToken': token});
    return token;
  }

  Stream<LostReport?> watchReport(String id) =>
      _db.collection('lostReports').doc(id).snapshots().map((d) => d.exists ? LostReport(d.id, d.data()!) : null);

  /// Marks the pet lost. Returns how many people nearby were alerted.
  Future<int> markLost({
    required Pet pet,
    required AppUser by,
    required DateTime since,
    required String area,
    required double lat,
    required double lng,
    required String note,
    required bool alert,
  }) async {
    final token = await ensureQrToken(pet);
    final ref = _db.collection('lostReports').doc();
    await ref.set({
      'petId': pet.id,
      'ownerId': pet.ownerId,
      'petName': pet.name,
      'species': pet.species,
      'qrToken': token,
      'status': 'lost',
      'since': since,
      'area': area,
      'lat': lat,
      'lng': lng,
      'note': note,
      'alert': alert,
      'alertsSent': 0,
      'sightings': <Map<String, dynamic>>[],
      'createdBy': by.uid,
      'createdAt': DateTime.now(),
    });
    await _db.collection('pets').doc(pet.id).update({
      'lost': {'since': since, 'area': area, 'lat': lat, 'lng': lng, 'note': note, 'reportId': ref.id},
    });
    if (!standalone) return 0;

    final family = pet.memberIds.where((u) => u != by.uid);
    await _notifier.notify(family,
        title: (l) => l.lostFamilyTitle(pet.name), body: (l) => l.lostFamilyBody(by.firstName, area), type: 'lost', link: '/me/lost/${pet.id}');
    if (!alert) return 0;
    final users = await _db.collection('users').get();
    final uids = nearbyAlertUids(
      [
        for (final u in users.docs)
          (
            uid: u.id,
            lat: (u.data()['homeLat'] as num?)?.toDouble(),
            lng: (u.data()['homeLng'] as num?)?.toDouble(),
            optIn: ((u.data()['consents'] as Map?)?['lostPetAlerts'] as bool?) ?? false,
          ),
      ],
      lat: lat,
      lng: lng,
      except: {...pet.memberIds, by.uid},
    );
    await _notifier.notify(uids,
        title: (l) => l.lostNearbyTitle(pet.name), body: (l) => l.lostNearbyBody(area), type: 'lost', link: '/lost/$token');
    await ref.update({'alertsSent': uids.length});
    return uids.length;
  }

  Future<void> markFound({required Pet pet, required AppUser by, required String reportId}) async {
    await _db.collection('lostReports').doc(reportId).update({'status': 'found', 'foundAt': DateTime.now()});
    await _db.collection('pets').doc(pet.id).update({'lost': null});
    if (!standalone) return;
    await _notifier.notify(pet.memberIds.where((u) => u != by.uid),
        title: (l) => l.lostFoundTitle(pet.name), type: 'lost', link: '/pets/${pet.id}');
  }
}

final lostRepositoryProvider = Provider<LostRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return LostRepository(db, SafetyNotifier(db, ref.watch(messagingServiceProvider)), standalone: ref.watch(appConfigProvider).isStandalone);
});

final lostReportProvider = StreamProvider.family<LostReport?, String>((ref, id) => ref.watch(lostRepositoryProvider).watchReport(id));

// ---------------------------------------------------------------------------
// The public page someone sees after scanning the tag.
// ---------------------------------------------------------------------------

enum LostPageStatus { ok, notFound, tooMany }

class LostPageView {
  const LostPageView({required this.status, this.pet = const {}, this.petId});
  final LostPageStatus status;

  /// publicPetView(): name, species, breed, colour, photo, markings, lost.
  final Map<String, dynamic> pet;
  final String? petId;

  String get name => (pet['name'] as String?) ?? '';
  String get species => (pet['species'] as String?) ?? 'dog';
  Map<String, dynamic>? get lost => (pet['lost'] as Map?)?.cast<String, dynamic>();
  bool get isLost => lost != null;
}

abstract class LostPageService {
  Future<LostPageView> open(String token);

  /// Sends the finder's message to the family. The family's phone number
  /// stays hidden; the finder may leave theirs.
  Future<LostPageStatus> contact(String token, {required String message, String name = '', String phone = ''});

  /// Shares where the finder saw the pet.
  Future<LostPageStatus> shareLocation(String token, {double? lat, double? lng, String area = '', String note = ''});
}

/// Standalone demo: reads the local database directly.
class LocalLostPageService implements LostPageService {
  LocalLostPageService(this._db, this._notifier);
  final FirebaseFirestore _db;
  final SafetyNotifier _notifier;
  static final _relays = <String, List<DateTime>>{};

  Future<DocumentSnapshot<Map<String, dynamic>>?> _pet(String token) async {
    if (token.isEmpty) return null;
    final q = await _db.collection('pets').where('qrToken', isEqualTo: token).limit(1).get();
    if (q.docs.isEmpty || (q.docs.first.data()['archived'] as bool? ?? false)) return null;
    return q.docs.first;
  }

  @override
  Future<LostPageView> open(String token) async {
    final p = await _pet(token);
    if (p == null) return const LostPageView(status: LostPageStatus.notFound);
    return LostPageView(status: LostPageStatus.ok, pet: publicPetView(p.data()!), petId: p.id);
  }

  bool _allowed(String token) {
    final now = DateTime.now();
    final list = _relays[token] ??= [];
    if (!relayAllowed(list, now)) return false;
    list.add(now);
    return true;
  }

  List<String> _family(Map<String, dynamic> pet) => ((pet['memberIds'] as List?) ?? const []).cast<String>();

  @override
  Future<LostPageStatus> contact(String token, {required String message, String name = '', String phone = ''}) async {
    final p = await _pet(token);
    if (p == null) return LostPageStatus.notFound;
    if (!_allowed(token)) return LostPageStatus.tooMany;
    final petName = (p.data()!['name'] as String?) ?? '';
    final from = [name.trim(), phone.trim()].where((s) => s.isNotEmpty).join(', ');
    await _notifier.notify(_family(p.data()!),
        title: (l) => l.finderMessageTitle(petName),
        body: (l) => from.isEmpty ? message.trim() : '${message.trim()} (${l.finderFrom(from)})',
        type: 'lost',
        link: '/me/lost/${p.id}',
        sms: true);
    return LostPageStatus.ok;
  }

  @override
  Future<LostPageStatus> shareLocation(String token, {double? lat, double? lng, String area = '', String note = ''}) async {
    final p = await _pet(token);
    if (p == null) return LostPageStatus.notFound;
    if (!_allowed(token)) return LostPageStatus.tooMany;
    final pet = p.data()!;
    final reportId = (pet['lost'] as Map?)?['reportId'] as String?;
    final s = Sighting(at: DateTime.now(), lat: lat, lng: lng, area: area, note: note);
    if (reportId != null) {
      await _db.collection('lostReports').doc(reportId).update({
        'sightings': FieldValue.arrayUnion([s.toMap()]),
      });
    }
    final petName = (pet['name'] as String?) ?? '';
    await _notifier.notify(_family(pet),
        title: (l) => l.finderSightingTitle(petName),
        body: (l) => [if (area.isNotEmpty) area, if (lat != null && lng != null) '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}', if (note.isNotEmpty) note].join(' · '),
        type: 'lost',
        link: '/me/lost/${p.id}',
        sms: true);
    return LostPageStatus.ok;
  }
}

/// With Firebase: callables in functions/src/phase9.ts (no sign-in needed).
class FunctionsLostPageService implements LostPageService {
  FunctionsLostPageService(this._functions);
  final FirebaseFunctions _functions;

  LostPageStatus _status(Object? s) => LostPageStatus.values.firstWhere((v) => v.name == s, orElse: () => LostPageStatus.notFound);

  @override
  Future<LostPageView> open(String token) async {
    final res = await _functions.httpsCallable('openLostPage').call<Map<String, dynamic>>({'token': token});
    final d = Map<String, dynamic>.from(res.data);
    return LostPageView(status: _status(d['status']), pet: Map<String, dynamic>.from((d['pet'] as Map?) ?? const {}));
  }

  @override
  Future<LostPageStatus> contact(String token, {required String message, String name = '', String phone = ''}) async {
    final res = await _functions.httpsCallable('contactPetFamily').call<Map<String, dynamic>>({'token': token, 'message': message, 'name': name, 'phone': phone});
    return _status(Map<String, dynamic>.from(res.data)['status']);
  }

  @override
  Future<LostPageStatus> shareLocation(String token, {double? lat, double? lng, String area = '', String note = ''}) async {
    final res = await _functions.httpsCallable('shareFinderLocation').call<Map<String, dynamic>>({'token': token, 'lat': lat, 'lng': lng, 'area': area, 'note': note});
    return _status(Map<String, dynamic>.from(res.data)['status']);
  }
}

final lostPageServiceProvider = Provider<LostPageService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  final db = ref.watch(firestoreProvider);
  if (cfg.isStandalone) return LocalLostPageService(db, SafetyNotifier(db, ref.watch(messagingServiceProvider)));
  return FunctionsLostPageService(FirebaseFunctions.instanceFor(region: 'asia-south1'));
});
