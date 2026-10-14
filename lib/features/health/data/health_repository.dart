import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../pets/domain/pet.dart';
import '../domain/medicine_schedule.dart';
import '../domain/vaccine_schedule.dart';

class Medicine {
  Medicine(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get petId => raw['petId'] as String;
  String get name => (raw['name'] as String?) ?? '';
  String get dose => (raw['dose'] as String?) ?? '';
  String get unit => (raw['unit'] as String?) ?? '';
  String get frequency => (raw['frequency'] as String?) ?? 'once';
  List<String> get times => ((raw['times'] as List?) ?? const ['09:00']).cast<String>();
  bool get withFood => (raw['withFood'] as bool?) ?? false;
  int? get stock => (raw['stock'] as num?)?.toInt();
  int get refillAt => (raw['refillAt'] as num?)?.toInt() ?? 5;
  bool get active => (raw['active'] as bool?) ?? true;
  DateTime get start => parseDate(raw['startDate']) ?? DateTime.now();
  DateTime? get end => parseDate(raw['endDate']);
  MedicinePlan get plan => MedicinePlan(
        frequency: frequency,
        times: times,
        start: start,
        end: end,
        everyHours: (raw['everyHours'] as num?)?.toInt(),
        weekdays: ((raw['weekdays'] as List?) ?? const []).cast<int>(),
      );
  bool get lowStock => stock != null && stock! <= refillAt;
}

class HealthEvent {
  HealthEvent(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get petId => raw['petId'] as String;
  String get type => (raw['type'] as String?) ?? 'custom';
  DateTime get date => parseDate(raw['date']) ?? DateTime.now();
  DateTime? get nextDue => parseDate(raw['nextDue']);
  String get title => (raw['title'] as String?) ?? '';
  String? get notes => raw['notes'] as String?;
  int get severity => (raw['severity'] as num?)?.toInt() ?? 1;
  String? get symptom => raw['symptom'] as String?;
  String? get clinicName => raw['clinicName'] as String?;
  String? get diagnosis => raw['diagnosis'] as String?;
  List<String> get photos => ((raw['photos'] as List?) ?? const []).cast<String>();
}

class Reminder {
  Reminder(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String? get petId => raw['petId'] as String?;
  String get title => (raw['title'] as String?) ?? '';
  String get type => (raw['type'] as String?) ?? 'custom';
  DateTime get at => parseDate(raw['at']) ?? DateTime.now();
  String get repeat => (raw['repeat'] as String?) ?? 'none';
  bool get done => (raw['done'] as bool?) ?? false;
}

VaccineRecord _vaccine(String id, Map<String, dynamic> d) => VaccineRecord(
      id: id,
      key: (d['templateKey'] as String?) ?? 'other',
      name: (d['name'] as String?) ?? '',
      givenDate: parseDate(d['givenDate']) ?? DateTime.now(),
      brand: d['brand'] as String?,
      batch: d['batch'] as String?,
      vetName: d['vetName'] as String?,
      clinicName: d['clinicName'] as String?,
      certificateDocId: d['certificateDocId'] as String?,
    );

class HealthRepository {
  HealthRepository(this._db);
  final FirebaseFirestore _db;

  Stream<List<VaccineRecord>> watchVaccines(String petId) => _db
      .collection('vaccinations')
      .where('petId', isEqualTo: petId)
      .snapshots()
      .map((s) => [for (final d in s.docs) _vaccine(d.id, d.data())]..sort((a, b) => b.givenDate.compareTo(a.givenDate)));

  Future<void> recordVaccine({
    required Pet pet,
    required AppUser by,
    required String templateKey,
    required String name,
    required DateTime givenDate,
    String? brand,
    String? batch,
    String? vetName,
    String? clinicName,
    String? certificateUrl,
    // A certificate already in the vault (Phase 7 auto-read) is linked, not copied.
    String? certificateDocId,
  }) async {
    String? docId = certificateDocId;
    if (docId == null && certificateUrl != null) {
      // Saved into the documents collection the vault (Phase 7) uses.
      final doc = await _db.collection('documents').add({
        'ownerId': pet.ownerId,
        'petId': pet.id,
        'type': 'vaccination',
        'title': '$name certificate',
        'tags': ['vaccine'],
        'url': certificateUrl,
        'contentType': 'image/jpeg',
        'createdAt': DateTime.now(),
      });
      docId = doc.id;
    }
    await _db.collection('vaccinations').add({
      'petId': pet.id,
      'templateKey': templateKey,
      'name': name,
      'givenDate': givenDate,
      'brand': brand,
      'batch': batch,
      'vetName': vetName,
      'clinicName': clinicName,
      'certificateDocId': docId,
      'byUid': by.uid,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> deleteVaccine(String id) => _db.collection('vaccinations').doc(id).delete();

  Stream<List<Medicine>> watchMedicines(String petId) => _db
      .collection('medicines')
      .where('petId', isEqualTo: petId)
      .snapshots()
      .map((s) => [for (final d in s.docs) Medicine(d.id, d.data())]);

  Future<void> saveMedicine(String? id, Map<String, dynamic> data) async {
    if (id == null) {
      await _db.collection('medicines').add({...data, 'active': true, 'createdAt': DateTime.now()});
    } else {
      await _db.collection('medicines').doc(id).update(data);
    }
  }

  Future<void> deleteMedicine(String id) => _db.collection('medicines').doc(id).update({'active': false});

  /// Given / Skip / Snooze for one dose. Given reduces stock.
  Future<void> logDose({required Medicine med, required String status, required DateTime dose, required AppUser by, required String petName}) async {
    await _db.collection('medicineLogs').add({
      'medicineId': med.id,
      'petId': med.petId,
      'dose': dose,
      'at': DateTime.now(),
      'status': status,
      'byUid': by.uid,
      'byName': by.name,
    });
    if (status == 'given') {
      if (med.stock != null) {
        await _db.collection('medicines').doc(med.id).update({'stock': FieldValue.increment(-1)});
      }
      await _db.collection('activity').add({
        'petId': med.petId,
        'actorId': by.uid,
        'actorName': by.name,
        'type': 'medicine_given',
        'detail': med.name,
        'createdAt': DateTime.now(),
      });
    }
  }

  Stream<List<Map<String, dynamic>>> watchDoseLogs(String petId) => _db
      .collection('medicineLogs')
      .where('petId', isEqualTo: petId)
      .snapshots()
      .map((s) => [for (final d in s.docs) d.data()]);

  Stream<List<HealthEvent>> watchEvents(String petId) => _db
      .collection('healthEvents')
      .where('petId', isEqualTo: petId)
      .snapshots()
      .map((s) => [for (final d in s.docs) HealthEvent(d.id, d.data())]..sort((a, b) => b.date.compareTo(a.date)));

  Future<void> addEvent(Map<String, dynamic> data) =>
      _db.collection('healthEvents').add({...data, 'createdAt': DateTime.now()});
  Future<void> deleteEvent(String id) => _db.collection('healthEvents').doc(id).delete();

  Stream<List<Reminder>> watchReminders(String uid) => _db
      .collection('reminders')
      .where('ownerId', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) Reminder(d.id, d.data())]..sort((a, b) => a.at.compareTo(b.at)));

  Future<void> addReminder(Map<String, dynamic> data) => _db.collection('reminders').add(data);
  Future<void> updateReminder(String id, Map<String, dynamic> data) => _db.collection('reminders').doc(id).update(data);
  Future<void> deleteReminder(String id) => _db.collection('reminders').doc(id).delete();
}

final healthRepositoryProvider = Provider<HealthRepository>((ref) => HealthRepository(ref.watch(firestoreProvider)));

final vaccinesProvider = StreamProvider.family<List<VaccineRecord>, String>(
    (ref, petId) => ref.watch(healthRepositoryProvider).watchVaccines(petId));
final medicinesProvider = StreamProvider.family<List<Medicine>, String>(
    (ref, petId) => ref.watch(healthRepositoryProvider).watchMedicines(petId).map((l) => l.where((m) => m.active).toList()));
final healthEventsProvider = StreamProvider.family<List<HealthEvent>, String>(
    (ref, petId) => ref.watch(healthRepositoryProvider).watchEvents(petId));
final doseLogsProvider = StreamProvider.family<List<Map<String, dynamic>>, String>(
    (ref, petId) => ref.watch(healthRepositoryProvider).watchDoseLogs(petId));
final remindersProvider = StreamProvider<List<Reminder>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(healthRepositoryProvider).watchReminders(u.uid);
});

/// Everything that is due for a pet, merged and sorted: vaccines, doses,
/// deworming, flea/tick and custom reminders. Used by Home "Next up",
/// the Health tab and the reminder engine.
class DueItem {
  const DueItem({required this.petId, required this.kind, required this.title, required this.at, required this.status, this.refId});
  final String petId;

  /// vaccine, medicine, deworming, flea_tick, reminder, refill
  final String kind;
  final String title;
  final DateTime? at;
  final DoseStatus status;
  final String? refId;
}

List<DueItem> dueItemsFor({
  required Pet pet,
  required List<VaccineRecord> vaccines,
  required List<Medicine> medicines,
  required List<HealthEvent> events,
  required List<Reminder> reminders,
  required List<Map<String, dynamic>> doseLogs,
  required DateTime now,
}) {
  final items = <DueItem>[];
  final s = buildSchedule(species: pet.speciesEnum, birthday: pet.birthday, records: vaccines, now: now);
  for (final i in s.items) {
    if (i.status == DoseStatus.overdue || i.status == DoseStatus.dueSoon || i.status == DoseStatus.upcoming) {
      items.add(DueItem(petId: pet.id, kind: 'vaccine', title: i.template.name, at: i.due, status: i.status, refId: i.template.key));
    }
  }
  final today = DateTime(now.year, now.month, now.day);
  for (final m in medicines) {
    final next = nextDose(m.plan, now.subtract(const Duration(hours: 2)));
    if (next != null) {
      final logged = doseLogs.any((d) => d['medicineId'] == m.id && parseDate(d['dose']) == next);
      if (!logged) {
        items.add(DueItem(
          petId: pet.id,
          kind: 'medicine',
          title: m.name,
          at: next,
          status: next.isBefore(now) ? DoseStatus.overdue : (next.isBefore(today.add(const Duration(days: 1))) ? DoseStatus.dueSoon : DoseStatus.upcoming),
          refId: m.id,
        ));
      }
    }
    if (m.lowStock) {
      items.add(DueItem(petId: pet.id, kind: 'refill', title: m.name, at: null, status: DoseStatus.dueSoon, refId: m.id));
    }
  }
  if (pet.species == 'dog' || pet.species == 'cat') {
    DateTime? last(String type) {
      final e = events.where((e) => e.type == type).toList();
      return e.isEmpty ? null : e.first.date;
    }
    final dw = nextDeworming(pet.birthday, last('deworming'), now);
    final ft = nextFleaTick(last('flea_tick'), now);
    DoseStatus st(DateTime d) => d.isBefore(today)
        ? DoseStatus.overdue
        : (d.isBefore(today.add(const Duration(days: 7))) ? DoseStatus.dueSoon : DoseStatus.upcoming);
    items.add(DueItem(petId: pet.id, kind: 'deworming', title: 'deworming', at: dw, status: st(dw)));
    items.add(DueItem(petId: pet.id, kind: 'flea_tick', title: 'flea_tick', at: ft, status: st(ft)));
  }
  for (final r in reminders.where((r) => r.petId == pet.id && !r.done)) {
    items.add(DueItem(
      petId: pet.id,
      kind: 'reminder',
      title: r.title,
      at: r.at,
      status: r.at.isBefore(now) ? DoseStatus.overdue : (r.at.isBefore(today.add(const Duration(days: 7))) ? DoseStatus.dueSoon : DoseStatus.upcoming),
      refId: r.id,
    ));
  }
  int rank(DoseStatus s) => switch (s) { DoseStatus.overdue => 0, DoseStatus.dueSoon => 1, _ => 2 };
  items.sort((a, b) {
    final r = rank(a.status).compareTo(rank(b.status));
    if (r != 0) return r;
    return (a.at ?? now).compareTo(b.at ?? now);
  });
  return items;
}

/// Due items for one pet, live.
final petDueProvider = Provider.family<AsyncValue<List<DueItem>>, Pet>((ref, pet) {
  final v = ref.watch(vaccinesProvider(pet.id));
  final m = ref.watch(medicinesProvider(pet.id));
  final e = ref.watch(healthEventsProvider(pet.id));
  final d = ref.watch(doseLogsProvider(pet.id));
  final r = ref.watch(remindersProvider);
  if (v.isLoading || m.isLoading || e.isLoading) return const AsyncLoading();
  return AsyncData(dueItemsFor(
    pet: pet,
    vaccines: v.value ?? const [],
    medicines: m.value ?? const [],
    events: e.value ?? const [],
    reminders: r.value ?? const [],
    doseLogs: d.value ?? const [],
    now: DateTime.now(),
  ));
});
