import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/domain/routine.dart';
import '../domain/devices.dart';
import 'device_provider.dart';
import 'safety_notify.dart';

/// Paired devices (devices collection) and what they feed into the app:
/// safe-zone alerts and activity in the routine tracker.
class DeviceRepository {
  DeviceRepository(this._db, this._notifier, this._routine, {required this.standalone});
  final FirebaseFirestore _db;
  final SafetyNotifier _notifier;
  final RoutineRepository _routine;

  /// With Firebase the onDeviceUpdated function sends safe-zone alerts.
  final bool standalone;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('devices');

  static Device _device(DocumentSnapshot<Map<String, dynamic>> d) {
    final raw = Map<String, dynamic>.from(d.data() ?? const {});
    raw['pairedAt'] = parseDate(raw['pairedAt']);
    return Device(d.id, raw);
  }

  Stream<List<Device>> watchForPets(List<String> petIds) {
    if (petIds.isEmpty) return Stream.value(const []);
    return _col.where('petId', whereIn: petIds.take(30).toList()).snapshots().map((s) {
      final list = [for (final d in s.docs) _device(d)];
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    });
  }

  Stream<Device?> watch(String id) => _col.doc(id).snapshots().map((d) => d.exists ? _device(d) : null);

  Future<String> pair({required Pet pet, required AppUser by, required FoundDevice found, required String name, SafeZone? zone}) async {
    final ref = _col.doc();
    await ref.set({
      'ownerId': pet.ownerId,
      'petId': pet.id,
      'type': deviceTypeIds[found.type],
      'name': name,
      'vendor': found.vendor,
      'model': found.model,
      'serial': found.serial,
      'status': 'connected',
      'battery': 100,
      'data': <String, dynamic>{},
      'safeZone': zone?.toMap(),
      'pairedAt': DateTime.now(),
      'pairedBy': by.uid,
    });
    return ref.id;
  }

  Future<void> rename(String id, String name) => _col.doc(id).update({'name': name});

  Future<void> setSafeZone(String id, SafeZone zone) => _col.doc(id).update({'safeZone': zone.toMap(), 'data.inside': null});

  Future<void> remove(String id) => _col.doc(id).delete();

  /// Records the collar's latest safe-zone state. Leaving the zone alerts
  /// everyone who looks after the pet (in their own language, plus a push
  /// and an SMS in the Demo Outbox); coming back sends a calmer note.
  /// Returns true when an alert went out.
  Future<bool> recordZone({required Device device, required Pet pet, required CollarFix fix}) async {
    final was = device.lastInside;
    if (was == fix.inside) return false;
    await _col.doc(device.id).update({
      'data.inside': fix.inside,
      'data.lat': fix.lat,
      'data.lng': fix.lng,
      'data.metersFromHome': fix.metersFromHome.round(),
      'data.at': fix.at,
    });
    final alert = shouldAlertLeftZone(wasInside: was, isInside: fix.inside);
    if (!standalone) return alert;
    final metres = fix.metersFromHome.round();
    if (alert) {
      await _notifier.notify(pet.memberIds,
          title: (l) => l.zoneLeftTitle(pet.name),
          body: (l) => l.zoneLeftBody(device.name, metres),
          type: 'device',
          link: '/me/devices/${device.id}',
          sms: true);
    } else if (was == false) {
      await _notifier.notify(pet.memberIds, title: (l) => l.zoneBackTitle(pet.name), type: 'device', link: '/me/devices/${device.id}');
    }
    return alert;
  }

  /// Writes the device's walks and play sessions into the routine tracker,
  /// once each. Returns how many new logs were added.
  Future<int> syncActivity({required Device device, required Pet pet, required AppUser by, required ActivityDay day}) async {
    var added = 0;
    for (final s in day.sessions) {
      final existing = await _db.collection('logs').doc(s.id).get();
      if (existing.exists) continue;
      await _routine.addLog(
        id: s.id,
        pet: pet,
        by: by,
        type: s.kind == 'walk' ? LogType.walk : LogType.play,
        at: s.start,
        data: {
          'durationMin': s.minutes,
          if (s.kind == 'walk') 'distanceKm': s.km,
          'steps': s.steps,
          'source': 'device',
          'deviceId': device.id,
          'deviceName': device.name,
        },
      );
      added++;
    }
    if (added > 0) await _col.doc(device.id).update({'data.lastSync': DateTime.now()});
    return added;
  }
}

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return DeviceRepository(
    db,
    SafetyNotifier(db, ref.watch(messagingServiceProvider)),
    ref.watch(routineRepositoryProvider),
    standalone: ref.watch(appConfigProvider).isStandalone,
  );
});

/// Devices for every pet the signed-in person looks after.
final myDevicesProvider = StreamProvider<List<Device>>((ref) {
  final pets = ref.watch(myPetsProvider).value ?? const <Pet>[];
  return ref.watch(deviceRepositoryProvider).watchForPets([for (final p in pets) if (!p.archived) p.id]);
});

final deviceProvider = StreamProvider.family<Device?, String>((ref, id) => ref.watch(deviceRepositoryProvider).watch(id));
