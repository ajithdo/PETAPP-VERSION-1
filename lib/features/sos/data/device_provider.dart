import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers.dart';
import '../domain/devices.dart';

/// A device found while pairing, not yet linked to a pet.
class FoundDevice {
  const FoundDevice({required this.type, required this.vendor, required this.model, required this.serial});
  final DeviceType type;
  final String vendor;
  final String model;
  final String serial;
}

/// One reading of a paired device. Only the parts for its type are set.
class DeviceSnapshot {
  const DeviceSnapshot({required this.at, required this.battery, this.fix, this.today, this.feeder, this.fountain, this.litter});
  final DateTime at;
  final int battery;
  final CollarFix? fix;
  final ActivityDay? today;
  final FeederState? feeder;
  final FountainState? fountain;
  final LitterState? litter;
}

enum DeviceCommand { feedNow, locate, snapshot, demoLeaveZone, demoReturnHome }

/// Where device data comes from (spec 7.13). Version 1 uses
/// [DemoDeviceProvider]. A real vendor gets its own class: cloud vendors send
/// readings to a Cloud Functions webhook that writes devices/{id}.data, and
/// Bluetooth devices are read on the phone. See docs/DECISIONS.md, Phase 9.
abstract class DeviceProvider {
  /// Looks for devices of [type]: nearby over Bluetooth, or on the vendor
  /// account the person signs in to.
  Future<List<FoundDevice>> scan(DeviceType type);

  /// Live readings for a paired device.
  Stream<DeviceSnapshot> watch(Device device);

  /// The latest reading, without waiting.
  DeviceSnapshot read(Device device);

  Future<void> command(Device device, DeviceCommand command);
}

/// Demo devices: readings are worked out from the clock, so they move along
/// believably and every family member sees the same numbers.
class DemoDeviceProvider implements DeviceProvider {
  DemoDeviceProvider({this.every = const Duration(seconds: 3)});
  final Duration every;

  /// When the demo "walk out of the safe zone" started, per device.
  static final _walkOut = <String, DateTime>{};
  static final _changes = StreamController<String>.broadcast();

  static const _models = <DeviceType, (String vendor, String model)>{
    DeviceType.gpsCollar: ('PawTrail Demo', 'GPS Collar G2'),
    DeviceType.activityTracker: ('FitTail Demo', 'Activity Tag A1'),
    DeviceType.feeder: ('FeedWell Demo', 'Smart Feeder 4L'),
    DeviceType.fountain: ('AquaPaw Demo', 'Fountain 2L'),
    DeviceType.camera: ('PetEye Demo', 'Treat Camera C1'),
    DeviceType.litterBox: ('CleanPaws Demo', 'Smart Litter L1'),
  };

  @override
  Future<List<FoundDevice>> scan(DeviceType type) async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    final m = _models[type]!;
    final n = DateTime.now().millisecondsSinceEpoch % 9000 + 1000;
    return [FoundDevice(type: type, vendor: m.$1, model: m.$2, serial: 'DEMO-$n')];
  }

  @override
  DeviceSnapshot read(Device d) {
    final now = DateTime.now();
    return DeviceSnapshot(
      at: now,
      battery: demoBattery(d, now),
      fix: d.type == DeviceType.gpsCollar ? demoCollarFix(d, now, walkOutAt: _walkOut[d.id]) : null,
      today: d.type == DeviceType.gpsCollar || d.type == DeviceType.activityTracker ? demoActivity(d, now, now) : null,
      feeder: d.type == DeviceType.feeder ? demoFeeder(d, now, dailyGrams: (d.data['dailyGrams'] as num?)?.toInt() ?? 120) : null,
      fountain: d.type == DeviceType.fountain ? demoFountain(d, now) : null,
      litter: d.type == DeviceType.litterBox ? demoLitter(d, now) : null,
    );
  }

  @override
  Stream<DeviceSnapshot> watch(Device d) async* {
    yield read(d);
    final ticks = Stream<String>.periodic(every, (_) => d.id);
    await for (final _ in StreamGroupLite.merge([ticks, _changes.stream.where((id) => id == d.id)])) {
      yield read(d);
    }
  }

  @override
  Future<void> command(Device d, DeviceCommand c) async {
    switch (c) {
      case DeviceCommand.demoLeaveZone:
        _walkOut[d.id] = DateTime.now();
      case DeviceCommand.demoReturnHome:
        _walkOut.remove(d.id);
      case DeviceCommand.feedNow || DeviceCommand.locate || DeviceCommand.snapshot:
        await Future<void>.delayed(const Duration(milliseconds: 600));
    }
    _changes.add(d.id);
  }
}

/// Version 2 plugs real vendors in here. Until then live mode explains that
/// devices are not connected yet.
class LiveDeviceProvider implements DeviceProvider {
  @override
  Future<List<FoundDevice>> scan(DeviceType type) => throw UnsupportedError('devices-live');

  @override
  DeviceSnapshot read(Device device) => DeviceSnapshot(at: DateTime.now(), battery: device.battery);

  @override
  Stream<DeviceSnapshot> watch(Device device) => Stream.value(read(device));

  @override
  Future<void> command(Device device, DeviceCommand command) async {}
}

/// Tiny merge helper (avoids adding the async package for one call).
class StreamGroupLite {
  static Stream<T> merge<T>(List<Stream<T>> streams) {
    late StreamController<T> c;
    final subs = <StreamSubscription<T>>[];
    c = StreamController<T>(
      onListen: () {
        for (final s in streams) {
          subs.add(s.listen(c.add, onError: c.addError));
        }
      },
      onCancel: () async {
        for (final s in subs) {
          await s.cancel();
        }
      },
    );
    return c.stream;
  }
}

final deviceProviderProvider = Provider<DeviceProvider>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.serviceMode('devices') == AppMode.demo ? DemoDeviceProvider() : LiveDeviceProvider();
});
