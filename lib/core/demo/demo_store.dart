import 'dart:async';
import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'seed/seed.dart';

/// The standalone demo database: an in-memory Firestore seeded with the demo
/// data, saved on the device so changes survive a restart.
class DemoStore {
  DemoStore._(this.db, this._prefs);

  final FakeFirebaseFirestore db;
  final SharedPreferences _prefs;
  Timer? _timer;
  int _lastHash = 0;

  static const _key = 'demo_db_v1';
  static const _seedVersionKey = 'demo_seed_version';

  static Future<DemoStore> open(SharedPreferences prefs) async {
    final store = DemoStore._(FakeFirebaseFirestore(), prefs);
    final saved = prefs.getString(_key);
    final savedVersion = prefs.getInt(_seedVersionKey);
    if (saved != null && savedVersion == DemoSeed.version) {
      try {
        await store._restore(saved);
      } catch (e) {
        debugPrint('Demo data could not be restored, reseeding: $e');
        await store.reset();
      }
    } else {
      await store._seed();
    }
    store._lastHash = store.db.dump().hashCode;
    store._timer = Timer.periodic(const Duration(seconds: 4), (_) => store.save());
    return store;
  }

  Future<void> _seed() async {
    final data = DemoSeed.build(DateTime.now());
    await loadInto(db, data);
    await _prefs.setInt(_seedVersionKey, DemoSeed.version);
  }

  /// Writes seed collections into a Firestore instance in batches.
  static Future<void> loadInto(
      FakeFirebaseFirestore db, Map<String, Map<String, Map<String, dynamic>>> data) async {
    for (final entry in data.entries) {
      final col = db.collection(entry.key);
      for (final doc in entry.value.entries) {
        await col.doc(doc.key).set(doc.value);
      }
    }
  }

  /// Saves the database if it changed since the last save.
  Future<void> save() async {
    final text = db.dump();
    final h = text.hashCode;
    if (h == _lastHash) return;
    _lastHash = h;
    try {
      await _prefs.setString(_key, _compact(text));
    } catch (e) {
      debugPrint('Demo data save failed: $e');
    }
  }

  /// Wipes all changes and loads fresh demo data.
  Future<void> reset() async {
    await db.clearPersistence();
    await _prefs.remove(_key);
    await _seed();
    _lastHash = db.dump().hashCode;
  }

  void dispose() => _timer?.cancel();

  static String _compact(String text) => jsonEncode(jsonDecode(text));

  static final _iso = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3,6}Z?$');

  Future<void> _restore(String text) async {
    final root = jsonDecode(text) as Map<String, dynamic>;
    for (final col in root.entries) {
      final docs = col.value as Map<String, dynamic>;
      for (final doc in docs.entries) {
        await db.collection(col.key).doc(doc.key).set(
              _revive(doc.value) as Map<String, dynamic>,
            );
      }
    }
  }

  /// dump() turns dates into ISO strings; turn them back into DateTime so
  /// date ordering and range queries keep working.
  static Object? _revive(Object? v) {
    if (v is String && _iso.hasMatch(v)) return DateTime.parse(v);
    if (v is Map) return v.map((k, val) => MapEntry(k as String, _revive(val)));
    if (v is List) return v.map(_revive).toList();
    return v;
  }
}
