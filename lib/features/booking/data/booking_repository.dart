import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/utils/format.dart';
import '../../pets/domain/pet.dart';
import '../domain/booking_rules.dart';
import 'places_repository.dart';

class Booking {
  Booking(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get ownerId => raw['ownerId'] as String;
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  String get petId => raw['petId'] as String;
  String get petName => (raw['petName'] as String?) ?? '';
  String get petSpecies => (raw['petSpecies'] as String?) ?? 'dog';
  String get kind => (raw['kind'] as String?) ?? 'clinic';
  String get providerId => raw['providerId'] as String;
  String get providerName => (raw['providerName'] as String?) ?? '';
  String? get vetId => raw['vetId'] as String?;
  String? get vetName => raw['vetName'] as String?;
  String get serviceId => (raw['serviceId'] as String?) ?? '';
  DateTime get start => parseDate(raw['start']) ?? DateTime.now();
  DateTime get end => parseDate(raw['end']) ?? start.add(const Duration(minutes: 30));
  String get mode => (raw['mode'] as String?) ?? 'instant';

  /// pending, suggested, confirmed, in_progress, completed, cancelled, declined, expired
  String get status => (raw['status'] as String?) ?? 'pending';
  List<DateTime> get proposedTimes => [for (final t in (raw['proposedTimes'] as List?) ?? const []) parseDate(t)!];
  DateTime? get suggestedTime => parseDate(raw['suggestedTime']);
  DateTime? get respondBy => parseDate(raw['respondBy']);
  String get paymentOption => (raw['paymentOption'] as String?) ?? 'at_clinic';
  String get paymentStatus => (raw['paymentStatus'] as String?) ?? 'unpaid';
  int get price => (raw['price'] as num?)?.toInt() ?? 0;
  int get travelFee => (raw['travelFee'] as num?)?.toInt() ?? 0;
  int get platformFee => (raw['platformFee'] as num?)?.toInt() ?? 0;
  int get discount => (raw['discount'] as num?)?.toInt() ?? 0;
  int get total => (raw['total'] as num?)?.toInt() ?? price;
  int get commission => (raw['commission'] as num?)?.toInt() ?? 0;
  int get payout => (raw['payout'] as num?)?.toInt() ?? 0;
  int get refund => (raw['refund'] as num?)?.toInt() ?? 0;
  bool get homeVisit => (raw['homeVisit'] as bool?) ?? false;
  String? get notes => raw['notes'] as String?;
  List<String> get partnerUids => ((raw['partnerUids'] as List?) ?? const []).cast<String>();
  bool get reviewed => (raw['reviewed'] as bool?) ?? false;
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.now();
  List<Map<String, dynamic>> get updates => [for (final u in (raw['updates'] as List?) ?? const []) (u as Map).cast<String, dynamic>()];
  List<({double lat, double lng})> get walkRoute => [
    for (final p in (raw['walkRoute'] as List?) ?? const []) (lat: ((p as Map)['lat'] as num).toDouble(), lng: (p['lng'] as num).toDouble()),
  ];
  bool get isActive => const ['pending', 'suggested', 'confirmed', 'in_progress'].contains(status);
  bool get isUpcoming => (status == 'confirmed' || status == 'in_progress') && end.isAfter(DateTime.now());
}

class BookingRepository {
  BookingRepository(this._db, {this.functions});
  final FirebaseFirestore _db;

  /// Set when a real Firebase backend runs: bookings are then created and
  /// priced by the createBooking Cloud Function.
  final FirebaseFunctions? functions;
  CollectionReference<Map<String, dynamic>> get _col => _db.collection('bookings');

  Stream<List<Booking>> watchOwner(String uid) => _col
      .where('ownerId', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) Booking(d.id, d.data())]..sort((a, b) => b.start.compareTo(a.start)));

  Stream<List<Booking>> watchPartner(String uid) => _col
      .where('partnerUids', arrayContains: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) Booking(d.id, d.data())]..sort((a, b) => a.start.compareTo(b.start)));

  Stream<List<Booking>> watchProvider(String providerId) =>
      _col.where('providerId', isEqualTo: providerId).snapshots().map((s) => [for (final d in s.docs) Booking(d.id, d.data())]);

  Stream<Booking?> watchOne(String id) => _col.doc(id).snapshots().map((d) => d.exists ? Booking(d.id, d.data()!) : null);

  Future<AppLocalizations> _lang(String uid) async {
    final u = await _db.collection('users').doc(uid).get();
    return lookupAppLocalizations(Locale((u.data()?['language'] as String?) ?? 'en'));
  }

  Future<void> _notify(String uid, String Function(AppLocalizations l) title, String link) async {
    final l = await _lang(uid);
    await _db.collection('notifications').add({
      'uid': uid,
      'title': title(l),
      'body': '',
      'type': 'bookings',
      'link': link,
      'read': false,
      'createdAt': DateTime.now(),
    });
  }

  Future<List<String>> _partnerUids(Place place, String? vetId) async {
    final out = <String>{};
    if (place.ownerUid != null) out.add(place.ownerUid!);
    if (vetId != null) {
      final v = await _db.collection('vets').doc(vetId).get();
      final uid = v.data()?['uid'] as String?;
      if (uid != null) out.add(uid);
    }
    return out.toList();
  }

  /// Creates a booking. Instant bookings are confirmed straight away;
  /// request bookings wait for the provider (default 2 hours).
  Future<String> create({
    required AppUser owner,
    required Pet pet,
    required Place place,
    required PlaceService service,
    required String serviceName,
    String? vetId,
    String? vetName,
    required DateTime start,
    List<DateTime> proposedTimes = const [],
    required String paymentOption,
    required bool paidOnline,
    required bool homeVisit,
    String? notes,
    List<String> photos = const [],
    required num commissionPercent,
    num discountPercent = 0,
    String? packageId,
  }) async {
    final fns = functions;
    if (fns != null) {
      final res = await fns.httpsCallable('createBooking').call<Map<String, dynamic>>({
        'placeId': place.id,
        'serviceId': service.id,
        'petId': pet.id,
        'vetId': vetId,
        'start': start.toUtc().toIso8601String(),
        'proposedTimes': [for (final t in proposedTimes) t.toUtc().toIso8601String()],
        'paymentOption': paymentOption,
        'paidOnline': paidOnline,
        'homeVisit': homeVisit,
        'notes': notes,
        'photos': photos,
      });
      final id = res.data['id'] as String;
      final total = service.price + (homeVisit ? place.homeVisitFee : 0);
      if (paidOnline) await _expense(owner.uid, pet.id, place.kind, total, id, serviceName, start);
      final partners = await _partnerUids(place, vetId);
      for (final uid in partners) {
        await _notify(uid, (l) => service.mode == 'instant' ? l.ntfNewBooking(pet.name, Fmt.dateTime(start, l.localeName)) : l.ntfNewRequest(pet.name), '/partner/requests');
      }
      return id;
    }
    final p = priceBooking(
      servicePrice: service.price,
      homeVisit: homeVisit,
      travelFee: place.homeVisitFee,
      commissionPercent: commissionPercent,
      discountPercent: discountPercent,
    );
    final instant = service.mode == 'instant';
    final now = DateTime.now();
    final ref = _col.doc();
    final partners = await _partnerUids(place, vetId);
    await ref.set({
      'ownerId': owner.uid,
      'ownerName': owner.name,
      'petId': pet.id,
      'petName': pet.name,
      'petSpecies': pet.species,
      'kind': place.kind,
      'providerId': place.id,
      'providerName': place.name,
      'providerPhone': place.phone,
      'providerAddress': place.address,
      'vetId': vetId,
      'vetName': vetName,
      'serviceId': service.id,
      'serviceName': serviceName,
      'start': start,
      'end': start.add(Duration(minutes: service.durationMin)),
      'mode': service.mode,
      'status': instant ? 'confirmed' : 'pending',
      'proposedTimes': instant ? <DateTime>[] : (proposedTimes.isEmpty ? [start] : proposedTimes),
      'respondBy': instant ? null : now.add(Duration(hours: place.requestWindowHours)),
      'paymentOption': paymentOption,
      'paymentStatus': paidOnline ? 'paid' : 'pay_at_visit',
      'price': p.service,
      'travelFee': p.travelFee,
      'platformFee': p.platformFee,
      'discount': p.discount,
      'total': p.total,
      'commission': p.commission,
      'payout': p.payout,
      'packageId': packageId,
      'homeVisit': homeVisit,
      'notes': notes,
      'photos': photos,
      'partnerUids': partners,
      'reviewed': false,
      'updates': <Map<String, dynamic>>[],
      'createdAt': now,
    });
    if (paidOnline) await _expense(owner.uid, pet.id, place.kind, p.total, ref.id, serviceName, start);
    for (final uid in partners) {
      await _notify(uid, (l) => instant ? l.ntfNewBooking(pet.name, Fmt.dateTime(start, l.localeName)) : l.ntfNewRequest(pet.name), '/partner/requests');
    }
    return ref.id;
  }

  Future<void> _expense(String uid, String petId, String kind, int amount, String bookingId, String note, DateTime date) =>
      _db.collection('expenses').doc('exp_$bookingId').set({
        'ownerId': uid,
        'petId': petId,
        'category': kind == 'clinic'
            ? 'vet'
            : (kind == 'groomer' ? 'grooming' : (kind == 'trainer' ? 'training' : (kind == 'boarder' ? 'boarding' : 'walking'))),
        'amount': amount,
        'date': date,
        'note': note,
        'source': 'booking',
        'sourceId': bookingId,
      });

  Future<void> accept(Booking b, DateTime at) async {
    await _col.doc(b.id).update({'status': 'confirmed', 'start': at, 'end': at.add(b.end.difference(b.start)), 'respondBy': null});
    await _notify(b.ownerId, (l) => l.ntfAccepted(b.providerName, Fmt.dateTime(at, l.localeName)), '/book/bookings/${b.id}');
  }

  Future<void> decline(Booking b) async {
    await _col.doc(b.id).update({'status': 'declined', 'refund': b.paymentStatus == 'paid' ? b.total : 0});
    await _db.collection('expenses').doc('exp_${b.id}').delete();
    await _notify(b.ownerId, (l) => l.ntfDeclined(b.providerName), '/book/bookings/${b.id}');
  }

  Future<void> suggest(Booking b, DateTime at) async {
    await _col.doc(b.id).update({'status': 'suggested', 'suggestedTime': at});
    await _notify(b.ownerId, (l) => l.ntfSuggested(b.providerName, Fmt.dateTime(at, l.localeName)), '/book/bookings/${b.id}');
  }

  Future<void> acceptSuggestion(Booking b) async {
    final at = b.suggestedTime!;
    await _col.doc(b.id).update({'status': 'confirmed', 'start': at, 'end': at.add(b.end.difference(b.start))});
    for (final uid in b.partnerUids) {
      await _notify(uid, (l) => l.ntfNewBooking(b.petName, Fmt.dateTime(at, l.localeName)), '/partner/calendar');
    }
  }

  Future<int> cancel(Booking b, {required int cancellationHours, required bool byOwner}) async {
    final refund = b.paymentStatus == 'paid' ? refundAmount(paid: b.total, start: b.start, now: DateTime.now(), cancellationHours: cancellationHours) : 0;
    await _col.doc(b.id).update({'status': 'cancelled', 'refund': refund, 'cancelledBy': byOwner ? 'owner' : 'partner'});
    if (refund > 0) {
      await _db.collection('expenses').doc('exp_${b.id}').update({'amount': b.total - refund});
    } else if (b.paymentStatus != 'paid') {
      await _db.collection('expenses').doc('exp_${b.id}').delete();
    }
    final targets = byOwner ? b.partnerUids : [b.ownerId];
    for (final uid in targets) {
      await _notify(uid, (l) => l.ntfCancelled(b.petName, Fmt.dateTime(b.start, l.localeName)), byOwner ? '/partner/calendar' : '/book/bookings/${b.id}');
    }
    return refund;
  }

  Future<void> reschedule(Booking b, DateTime at) async {
    await _col.doc(b.id).update({'start': at, 'end': at.add(b.end.difference(b.start))});
    for (final uid in b.partnerUids) {
      await _notify(uid, (l) => l.ntfRescheduled(b.petName, Fmt.dateTime(at, l.localeName)), '/partner/calendar');
    }
  }

  Future<void> setStatus(Booking b, String status) async {
    await _col.doc(b.id).update({'status': status});
    if (status == 'completed') {
      if (b.paymentStatus != 'paid') {
        await _expense(b.ownerId, b.petId, b.kind, b.total, b.id, (b.raw['serviceName'] as String?) ?? '', b.start);
        await _col.doc(b.id).update({'paymentStatus': 'paid'});
      }
      await _notify(b.ownerId, (l) => l.ntfCompleted(b.petName, b.providerName), '/book/bookings/${b.id}');
    }
  }

  Future<void> addUpdate(Booking b, String text, String? photoUrl) async {
    await _col.doc(b.id).update({
      'updates': FieldValue.arrayUnion([
        {'at': DateTime.now(), 'text': text, 'photoUrl': photoUrl},
      ]),
    });
    await _notify(b.ownerId, (l) => l.ntfUpdate(b.providerName, b.petName), '/book/bookings/${b.id}');
  }

  /// Requests not answered in time are cancelled and the owner is told.
  Future<void> expireStale(List<Booking> list) async {
    final now = DateTime.now();
    for (final b in list.where((b) => b.status == 'pending' && b.respondBy != null && now.isAfter(b.respondBy!))) {
      await _col.doc(b.id).update({'status': 'expired', 'refund': b.paymentStatus == 'paid' ? b.total : 0});
      await _notify(b.ownerId, (l) => l.ntfExpired(b.providerName), '/book/bookings/${b.id}');
    }
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepository(
    ref.watch(firestoreProvider),
    functions: ref.watch(appConfigProvider).usesFirebase ? FirebaseFunctions.instanceFor(region: 'asia-south1') : null,
  ),
);

final myBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.watchOwner(u.uid).map((l) {
    repo.expireStale(l);
    return l;
  });
});

final partnerBookingsProvider = StreamProvider<List<Booking>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.watchPartner(u.uid).map((l) {
    repo.expireStale(l);
    return l;
  });
});

final providerBookingsProvider = StreamProvider.family<List<Booking>, String>((ref, id) => ref.watch(bookingRepositoryProvider).watchProvider(id));

final bookingProvider = StreamProvider.family<Booking?, String>((ref, id) => ref.watch(bookingRepositoryProvider).watchOne(id));
