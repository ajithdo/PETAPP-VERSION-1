import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers.dart';
import '../domain/sos_rules.dart';

/// SOS activations (sosLogs, for admin analytics), the clinics saved on the
/// device for weak internet, and the last location we knew.
class SosRepository {
  SosRepository(this._db, this._prefs);
  final FirebaseFirestore _db;
  final SharedPreferences _prefs;

  static const _clinicsKey = 'sos.savedClinics';
  static const _spotKey = 'sos.lastKnown';

  /// Logs one activation (spec 7.12): time, pet, location and its source.
  Future<void> logActivation({required String uid, String? petId, required SosSpot spot}) async {
    await _db.collection('sosLogs').add({
      'uid': uid,
      'petId': petId,
      'at': DateTime.now(),
      'lat': double.parse(spot.lat.toStringAsFixed(3)),
      'lng': double.parse(spot.lng.toStringAsFixed(3)),
      'area': spot.label,
      'source': sosSourceId(spot.source),
    });
  }

  ({List<SosClinic> clinics, DateTime at})? savedClinics() => decodeSavedClinics(_prefs.getString(_clinicsKey));

  Future<void> saveClinics(List<SosClinic> clinics) async {
    if (clinics.isEmpty) return;
    await _prefs.setString(_clinicsKey, encodeSavedClinics(clinics, DateTime.now()));
  }

  SosSpot? lastKnown() => decodeSpot(_prefs.getString(_spotKey));

  /// Remembers a GPS fix for the next SOS (used when location is off).
  Future<void> rememberSpot(double lat, double lng) =>
      _prefs.setString(_spotKey, encodeSpot(SosSpot(lat: lat, lng: lng, source: SosSource.lastKnown, at: DateTime.now())));
}

final sosRepositoryProvider = Provider<SosRepository>((ref) => SosRepository(ref.watch(firestoreProvider), ref.watch(prefsProvider)));
