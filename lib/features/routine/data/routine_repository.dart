import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/utils/format.dart';
import '../../pets/domain/pet.dart';
import '../domain/routine.dart';

class RoutineLog {
  RoutineLog(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get petId => raw['petId'] as String;
  LogType get type => parseLogType(raw['type'] as String?);
  DateTime get at => parseDate(raw['at']) ?? DateTime.now();
  String get byUid => (raw['byUid'] as String?) ?? '';
  String get byName => (raw['byName'] as String?) ?? '';
  String? get note => raw['note'] as String?;
  String? get photoUrl => raw['photoUrl'] as String?;
  Map<String, dynamic> get data => (raw['data'] as Map?)?.cast<String, dynamic>() ?? const {};
  double get distanceKm => (data['distanceKm'] as num?)?.toDouble() ?? 0;
  int get minutes => ((data['durationMin'] ?? data['minutes']) as num?)?.toInt() ?? 0;
  int? get grams => (data['grams'] as num?)?.toInt();
  String? get mood => data['mood'] as String?;
  double? get weightKg => (data['weightKg'] as num?)?.toDouble();
  Map<String, int> get tags =>
      ((data['tags'] as Map?) ?? const {}).map((k, v) => MapEntry(k as String, (v as num).toInt()));
  List<({double lat, double lng})> get route => [
        for (final p in (data['route'] as List?) ?? const [])
          (lat: ((p as Map)['lat'] as num).toDouble(), lng: (p['lng'] as num).toDouble()),
      ];
}

class RoutineRepository {
  RoutineRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _logs => _db.collection('logs');

  /// Logs for one pet since [from], newest first.
  Stream<List<RoutineLog>> watchLogs(String petId, {required DateTime from}) => _logs
      .where('petId', isEqualTo: petId)
      .where('at', isGreaterThanOrEqualTo: from)
      .snapshots()
      .map((s) => [for (final d in s.docs) RoutineLog(d.id, d.data())]..sort((a, b) => b.at.compareTo(a.at)));

  Future<String> addLog({
    required Pet pet,
    required AppUser by,
    required LogType type,
    DateTime? at,
    String? note,
    String? photoUrl,
    Map<String, dynamic>? data,
    String? id,
  }) async {
    final log = {
      'petId': pet.id,
      'type': type.name,
      'at': at ?? DateTime.now(),
      'byUid': by.uid,
      'byName': by.name,
      if (note != null && note.isNotEmpty) 'note': note,
      'photoUrl': ?photoUrl,
      'data': ?data,
    };
    // A fixed id (device activity) makes writing the same log twice harmless.
    final ref = id == null ? await _logs.add(log) : _logs.doc(id);
    if (id != null) await ref.set(log);
    // Family feed: only the shared moments, not every glass of water.
    final feed = switch (type) {
      LogType.walk => 'walk_logged',
      LogType.meal => 'meal_logged',
      _ => null,
    };
    if (feed != null && pet.members.length > 1) {
      await _db.collection('activity').add({
        'petId': pet.id,
        'actorId': by.uid,
        'actorName': by.name,
        'type': feed,
        'detail': type == LogType.walk ? Fmt.km((data?['distanceKm'] as num?)?.toDouble() ?? 0) : null,
        'createdAt': DateTime.now(),
      });
    }
    if (type == LogType.weight && data?['weightKg'] != null) {
      await _db.collection('pets').doc(pet.id).update({'weightKg': data!['weightKg']});
    }
    return ref.id;
  }

  Future<void> updateLog(String id, Map<String, dynamic> fields) => _logs.doc(id).update(fields);
  Future<void> deleteLog(String id) => _logs.doc(id).delete();

  Future<void> updatePlan(String petId, DailyPlan plan) =>
      _db.collection('pets').doc(petId).update({'dailyPlan': plan.toJson()});
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) => RoutineRepository(ref.watch(firestoreProvider)));

/// Last 31 days of logs for a pet.
final petLogsProvider = StreamProvider.family<List<RoutineLog>, String>((ref, petId) {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, now.day - 30);
  return ref.watch(routineRepositoryProvider).watchLogs(petId, from: from);
});

/// Today's progress against the daily plan.
class TodayProgress {
  TodayProgress({required this.pet, required this.logs});
  final Pet pet;
  final List<RoutineLog> logs;

  List<RoutineLog> get today {
    final now = DateTime.now();
    return logs.where((l) => Fmt.sameDay(l.at, now)).toList();
  }

  int count(LogType t) => today.where((l) => l.type == t).length;
  int get playMinutes => today.where((l) => l.type == LogType.play).fold(0, (s, l) => s + l.minutes);

  /// (label key, done, goal) for each checklist item.
  List<(LogType, int, int)> get items => [
        if (pet.dailyPlan.walks > 0) (LogType.walk, count(LogType.walk), pet.dailyPlan.walks),
        if (pet.dailyPlan.meals > 0) (LogType.meal, count(LogType.meal), pet.dailyPlan.meals),
        if (pet.dailyPlan.playMinutes > 0) (LogType.play, playMinutes, pet.dailyPlan.playMinutes),
      ];

  double get fraction {
    if (items.isEmpty) return 0;
    final parts = items.map((i) => (i.$2 / i.$3).clamp(0.0, 1.0));
    return parts.reduce((a, b) => a + b) / items.length;
  }
}
