import 'dart:async';
import 'dart:convert';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'seed/seed.dart';
import 'seed/seed_people.dart' show demoAccounts;

/// The standalone demo database: an in-memory Firestore seeded with the demo
/// data, saved on the device so changes survive a restart.
class DemoStore {
  DemoStore._(this.db, this._prefs);

  final FakeFirebaseFirestore db;
  final SharedPreferences _prefs;
  Timer? _timer;
  AppLifecycleListener? _lifecycle;
  int _lastHash = 0;

  /// Long history still to load after the first screen; nothing is saved
  /// until it is in, so a save never drops it.
  SeedData? _later;
  bool _resetting = false;

  static const _key = 'demo_db_v1';
  static const _seedVersionKey = 'demo_seed_version';

  static Future<DemoStore> open(SharedPreferences prefs) async {
    final store = DemoStore._(FakeFirebaseFirestore(), prefs);
    final saved = prefs.getString(_key);
    SeedData? data;
    if (saved != null && prefs.getInt(_seedVersionKey) == DemoSeed.version) {
      try {
        data = _decode(saved);
        // A saved copy without the demo accounts can't be signed in to
        // (an older reset could save one): start again from fresh data.
        if (!hasDemoAccounts(data)) {
          debugPrint('Saved demo data has no demo accounts, reseeding');
          data = null;
        }
      } catch (e) {
        debugPrint('Demo data could not be restored, reseeding: $e');
        await prefs.remove(_key);
      }
    }
    if (data == null) {
      data = DemoSeed.build(DateTime.now());
      await prefs.setInt(_seedVersionKey, DemoSeed.version);
    }
    // What the first screens need now; old routine logs and admin history
    // right after the first frame, so the app opens sooner.
    final (first, later) = splitForStartup(data, DateTime.now());
    await loadInto(store.db, first);
    store._later = later;
    SchedulerBinding.instance.addPostFrameCallback((_) => store._loadLater());
    // No copy of the database at start-up (it takes a moment on a phone):
    // the first save writes it once.
    store._lastHash = 0;
    // Saving copies the whole database, so do it now and then and whenever
    // the app goes to the background or the tab is hidden, not constantly.
    store._timer = Timer.periodic(const Duration(seconds: 20), (_) => store.save());
    store._lifecycle = AppLifecycleListener(onHide: store.save, onPause: store.save, onDetach: store.save);
    return store;
  }

  /// Collections no first screen needs (the admin dashboard fills in a
  /// moment later).
  static const _laterCollections = {'analyticsDaily', 'auditLog', 'outbox', 'payments', 'referrals', 'reports'};

  /// Splits demo data into what to load before the first frame and what can
  /// follow: routine logs older than two days and admin history.
  static (SeedData, SeedData) splitForStartup(SeedData data, DateTime now) {
    final cutoff = now.subtract(const Duration(days: 2));
    final first = <String, Map<String, Map<String, dynamic>>>{};
    final later = <String, Map<String, Map<String, dynamic>>>{};
    for (final c in data.entries) {
      for (final d in c.value.entries) {
        final at = d.value['at'];
        final defer = _laterCollections.contains(c.key) || (c.key == 'logs' && at is DateTime && at.isBefore(cutoff));
        ((defer ? later : first)[c.key] ??= {})[d.key] = d.value;
      }
    }
    return (first, later);
  }

  Future<void> _loadLater() async {
    final later = _later;
    if (later == null) return;
    await loadInto(db, later, yieldBetweenBatches: true);
    _later = null;
  }

  /// Writes seed collections into a Firestore instance in batches (about
  /// three times faster than one write at a time, which matters at start-up).
  /// With [yieldBetweenBatches] the app keeps drawing frames in between.
  static Future<void> loadInto(FakeFirebaseFirestore db, SeedData data, {bool yieldBetweenBatches = false}) async {
    var batch = db.batch();
    var n = 0;
    for (final entry in data.entries) {
      final col = db.collection(entry.key);
      for (final doc in entry.value.entries) {
        batch.set(col.doc(doc.key), doc.value);
        if (++n % 400 == 0) {
          await batch.commit();
          batch = db.batch();
          if (yieldBetweenBatches) await Future<void>.delayed(Duration.zero);
        }
      }
    }
    await batch.commit();
  }

  /// Saves the database if it changed since the last save.
  Future<void> save() async {
    if (_later != null || _resetting) return;
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

  /// Whether [data] still holds every demo account (sign-in record and
  /// profile).
  static bool hasDemoAccounts(SeedData data) => demoAccounts.every((a) =>
      (data['demoAccounts']?.containsKey(a.uid) ?? false) && (data['users']?[a.uid]?['name'] as String?)?.isNotEmpty == true);

  /// Forgets all changes: stops saving and removes the saved copy, so the
  /// next start (the app restarts itself, see `appRestartProvider`) loads
  /// fresh demo data into a new database. Clearing this database in place
  /// would cut off every screen listening to it.
  Future<void> reset() async {
    _later = null;
    _resetting = true;
    dispose();
    await _prefs.remove(_key);
  }

  void dispose() {
    _timer?.cancel();
    _lifecycle?.dispose();
  }

  static String _compact(String text) => jsonEncode(jsonDecode(text));

  static final _iso = RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3,6}Z?$');

  static SeedData _decode(String text) {
    final root = jsonDecode(text) as Map<String, dynamic>;
    return {
      for (final col in root.entries)
        col.key: {
          for (final doc in (col.value as Map<String, dynamic>).entries) doc.key: _revive(doc.value) as Map<String, dynamic>,
        },
    };
  }

  /// dump() turns dates into ISO strings; turn them back into DateTime so
  /// date ordering and range queries keep working.
  static Object? _revive(Object? v) {
    // Cheap checks first: most strings are not dates (this runs on every
    // value at start-up).
    if (v is String && v.length >= 23 && v.length <= 27 && v.codeUnitAt(4) == 0x2D && v.codeUnitAt(10) == 0x54 && _iso.hasMatch(v)) {
      return DateTime.parse(v);
    }
    if (v is Map) return v.map((k, val) => MapEntry(k as String, _revive(val)));
    if (v is List) return v.map(_revive).toList();
    return v;
  }
}
