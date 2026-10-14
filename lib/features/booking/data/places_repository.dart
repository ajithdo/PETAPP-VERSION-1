import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';

/// A bookable partner: a vet clinic or a groomer, trainer, boarder/sitter
/// or walker. Clinics and providers share this shape.
class Place {
  Place(this.id, this.kind, this.raw);
  final String id;

  /// clinic, groomer, trainer, boarder, walker
  final String kind;
  final Map<String, dynamic> raw;

  String get collection => kind == 'clinic' ? 'clinics' : 'providers';
  String get name => (raw['name'] as String?) ?? '';
  String get city => (raw['city'] as String?) ?? '';
  String get area => (raw['area'] as String?) ?? '';
  String get address => (raw['address'] as String?) ?? '';
  double get lat => (raw['lat'] as num?)?.toDouble() ?? 0;
  double get lng => (raw['lng'] as num?)?.toDouble() ?? 0;
  String get phone => (raw['phone'] as String?) ?? '';
  String? get emergencyPhone => raw['emergencyPhone'] as String?;
  double get rating => (raw['rating'] as num?)?.toDouble() ?? 0;
  int get reviewCount => (raw['reviewCount'] as num?)?.toInt() ?? 0;
  List<String> get species => ((raw['species'] as List?) ?? const []).cast<String>();
  List<String> get languages => ((raw['languages'] as List?) ?? const []).cast<String>();
  bool get is24x7 => (raw['is24x7'] as bool?) ?? false;
  bool get teleVet => (raw['teleVet'] as bool?) ?? false;
  int get fee => (raw['consultationFee'] as num?)?.toInt() ?? (services.isEmpty ? 0 : services.first.price);
  Map<String, dynamic> get hours => (raw['hours'] as Map?)?.cast<String, dynamic>() ?? const {};
  int get slotMinutes => (raw['slotMinutes'] as num?)?.toInt() ?? 30;
  int get bufferMinutes => (raw['bufferMinutes'] as num?)?.toInt() ?? 0;
  int get capacity => (raw['capacityPerSlot'] as num?)?.toInt() ?? 1;
  int get cancellationHours => (raw['cancellationHours'] as num?)?.toInt() ?? 4;
  int get requestWindowHours => (raw['requestWindowHours'] as num?)?.toInt() ?? 2;
  List<DateTime> get holidays => [for (final h in (raw['holidays'] as List?) ?? const []) parseDate(h)!];
  List<({DateTime start, DateTime end})> get blocks => [
    for (final b in (raw['blocks'] as List?) ?? const []) (start: parseDate((b as Map)['start'])!, end: parseDate(b['end'])!),
  ];
  bool get homeVisit => kind == 'clinic' ? ((raw['homeVisitRadiusKm'] as num?) ?? 0) > 0 : ((raw['homeVisit'] as bool?) ?? false);
  int get homeVisitFee => ((kind == 'clinic' ? raw['homeVisitFee'] : raw['travelFee']) as num?)?.toInt() ?? 0;
  int get radiusKm => ((kind == 'clinic' ? raw['homeVisitRadiusKm'] : raw['radiusKm']) as num?)?.toInt() ?? 0;
  bool get atCentre => kind == 'clinic' || ((raw['atCentre'] as bool?) ?? true);
  List<String> get vetIds => ((raw['vetIds'] as List?) ?? const []).cast<String>();
  String get status => (raw['status'] as String?) ?? 'approved';
  String? get ownerUid => (raw['ownerUid'] ?? raw['uid']) as String?;
  int get photoSeed => (raw['photoSeed'] as num?)?.toInt() ?? id.hashCode % 6;
  String? get about => raw['about'] as String?;
  bool get enquiriesEnabled => (raw['enquiriesEnabled'] as bool?) ?? true;
  List<PlaceService> get services => [for (final s in (raw['services'] as List?) ?? const []) PlaceService((s as Map).cast<String, dynamic>())];
  List<Map<String, dynamic>> get packages => [for (final p in (raw['packages'] as List?) ?? const []) (p as Map).cast<String, dynamic>()];
  PlaceService? service(String id) => services.where((s) => s.id == id).firstOrNull;
}

class PlaceService {
  PlaceService(this.raw);
  final Map<String, dynamic> raw;
  String get id => raw['id'] as String;
  int get price => (raw['price'] as num?)?.toInt() ?? 0;
  int get durationMin => (raw['durationMin'] as num?)?.toInt() ?? 30;

  /// instant or request
  String get mode => (raw['mode'] as String?) ?? 'instant';
  List<String> get payments => ((raw['payments'] as List?) ?? const ['online']).cast<String>();
}

class Vet {
  Vet(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get name => (raw['name'] as String?) ?? '';
  String get qualification => (raw['qualification'] as String?) ?? '';
  String get regNo => (raw['regNo'] as String?) ?? '';
  String get clinicId => (raw['clinicId'] as String?) ?? '';
  String get clinicName => (raw['clinicName'] as String?) ?? '';
  String? get uid => raw['uid'] as String?;
  int get experienceYears => (raw['experienceYears'] as num?)?.toInt() ?? 0;
  bool get teleVet => (raw['teleVet'] as bool?) ?? false;
  int get videoFee => (raw['videoFee'] as num?)?.toInt() ?? 399;
  double get rating => (raw['rating'] as num?)?.toDouble() ?? 0;
  List<String> get languages => ((raw['languages'] as List?) ?? const []).cast<String>();
  List<String> get species => ((raw['species'] as List?) ?? const []).cast<String>();
}

class Review {
  Review(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  int get rating => (raw['rating'] as num?)?.toInt() ?? 5;
  String get text => (raw['text'] as String?) ?? '';
  String? get reply => raw['reply'] as String?;
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.now();
  String get status => (raw['status'] as String?) ?? 'visible';
  String get targetId => (raw['targetId'] as String?) ?? '';
}

class PlacesRepository {
  PlacesRepository(this._db);
  final FirebaseFirestore _db;

  Stream<List<Place>> watchClinics() =>
      _db.collection('clinics').where('status', isEqualTo: 'approved').snapshots().map((s) => [for (final d in s.docs) Place(d.id, 'clinic', d.data())]);

  Stream<List<Place>> watchProviders(String type) => _db
      .collection('providers')
      .where('type', isEqualTo: type)
      .where('status', isEqualTo: 'approved')
      .snapshots()
      .map((s) => [for (final d in s.docs) Place(d.id, type, d.data())]);

  Stream<Place?> watchPlace(String id) {
    final isClinic = id.startsWith('clinic');
    return _db.collection(isClinic ? 'clinics' : 'providers').doc(id).snapshots().map((d) {
      if (!d.exists) return null;
      return Place(d.id, isClinic ? 'clinic' : (d.data()!['type'] as String? ?? 'groomer'), d.data()!);
    });
  }

  Stream<List<Vet>> watchVets(String clinicId) =>
      _db.collection('vets').where('clinicId', isEqualTo: clinicId).snapshots().map((s) => [for (final d in s.docs) Vet(d.id, d.data())]);

  Stream<List<Review>> watchReviews(String targetId) => _db
      .collection('reviews')
      .where('targetId', isEqualTo: targetId)
      .snapshots()
      .map(
        (s) => [for (final d in s.docs) Review(d.id, d.data())].where((r) => r.status != 'hidden').toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );

  Future<void> updatePlace(Place p, Map<String, dynamic> fields) => _db.collection(p.collection).doc(p.id).update(fields);

  /// Verified review after a completed booking; updates the average rating.
  Future<void> addReview({
    required Place place,
    required String bookingId,
    required String ownerId,
    required String ownerName,
    required int rating,
    required String text,
  }) async {
    await _db.collection('reviews').add({
      'targetType': place.kind == 'clinic' ? 'clinic' : 'provider',
      'targetId': place.id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'bookingId': bookingId,
      'rating': rating,
      'text': text,
      'status': 'visible',
      'createdAt': DateTime.now(),
    });
    final n = place.reviewCount + 1;
    final avg = ((place.rating * place.reviewCount + rating) / n);
    await updatePlace(place, {'rating': double.parse(avg.toStringAsFixed(1)), 'reviewCount': n});
    await _db.collection('bookings').doc(bookingId).update({'reviewed': true});
  }

  Future<void> replyToReview(String reviewId, String reply) => _db.collection('reviews').doc(reviewId).update({'reply': reply, 'replyAt': DateTime.now()});
}

final placesRepositoryProvider = Provider<PlacesRepository>((ref) => PlacesRepository(ref.watch(firestoreProvider)));
final clinicsProvider = StreamProvider<List<Place>>((ref) => ref.watch(placesRepositoryProvider).watchClinics());
final providersOfTypeProvider = StreamProvider.family<List<Place>, String>((ref, t) => ref.watch(placesRepositoryProvider).watchProviders(t));
final placeProvider = StreamProvider.family<Place?, String>((ref, id) => ref.watch(placesRepositoryProvider).watchPlace(id));
final vetsProvider = StreamProvider.family<List<Vet>, String>((ref, id) => ref.watch(placesRepositoryProvider).watchVets(id));
final reviewsProvider = StreamProvider.family<List<Review>, String>((ref, id) => ref.watch(placesRepositoryProvider).watchReviews(id));
