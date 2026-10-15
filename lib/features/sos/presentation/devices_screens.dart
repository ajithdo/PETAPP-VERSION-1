import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/demo/seed/seed_places.dart' show areas;
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../routine/data/routine_repository.dart';
import '../../routine/domain/routine.dart';
import '../data/device_provider.dart';
import '../data/device_repository.dart';
import '../domain/devices.dart';
import 'safety_labels.dart';

/// Me → Connected devices (spec 7.13).
class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final devices = ref.watch(myDevicesProvider);
    final pets = {for (final p in ref.watch(activePetsProvider)) p.id: p};
    return Scaffold(
      appBar: AppBar(title: Text(l.connectedDevices)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/me/devices/add'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.devAdd),
      ),
      body: AsyncView<List<Device>>(
        value: devices,
        data: (list) => PageBody(maxWidth: 760, children: [
          const SizedBox(height: Space.md),
          if (ref.watch(appConfigProvider).isDemo) ...[DemoBanner(l.devDemoNote), const SizedBox(height: Space.md)],
          if (list.isEmpty)
            EmptyState(title: l.devNoneTitle, message: l.devNoneBody, actionLabel: l.devAdd, onAction: () => context.push('/me/devices/add'))
          else
            for (final d in list)
              Padding(
                padding: const EdgeInsets.only(bottom: Space.md),
                child: _DeviceTile(device: d, pet: pets[d.petId]),
              ),
          const SizedBox(height: 96),
        ]),
      ),
    );
  }
}

class _DeviceTile extends ConsumerWidget {
  const _DeviceTile({required this.device, required this.pet});
  final Device device;
  final Pet? pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final snap = ref.watch(deviceProviderProvider).read(device);
    final line = _summaryLine(context, device, snap);
    final out = device.type == DeviceType.gpsCollar && device.lastInside == false;
    return PawCard(
      onTap: () => context.push('/me/devices/${device.id}'),
      borderColor: out ? context.paw.sos : null,
      child: Row(children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: context.colors.primaryContainer,
          child: Icon(deviceIcon(device.type), color: context.colors.primary),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(device.name, style: context.text.titleMedium),
            Text('${pet?.name ?? ''} · ${deviceTypeLabel(l, device.type)}', style: context.text.bodySmall),
            const SizedBox(height: Space.xs),
            Text(line, style: context.text.bodyMedium?.copyWith(color: out ? context.paw.sos : null, fontWeight: out ? FontWeight.w700 : null)),
          ]),
        ),
        Column(children: [
          Icon(_batteryIcon(snap.battery), color: snap.battery < 20 ? context.paw.error : context.paw.success),
          Text('${snap.battery}%', style: context.text.labelSmall),
        ]),
      ]),
    );
  }
}

IconData _batteryIcon(int b) => b < 20 ? Icons.battery_alert_rounded : (b < 60 ? Icons.battery_4_bar_rounded : Icons.battery_full_rounded);

String _summaryLine(BuildContext context, Device d, DeviceSnapshot s) {
  final l = context.l10n;
  return switch (d.type) {
    DeviceType.gpsCollar => s.fix == null
        ? l.devConnected
        : (s.fix!.inside ? l.devInsideZone(s.fix!.metersFromHome.round()) : l.devOutsideZone(s.fix!.metersFromHome.round())),
    DeviceType.activityTracker => l.devStepsToday(Fmt.number(s.today?.steps ?? 0, context.lang)),
    DeviceType.feeder => s.feeder?.next == null ? l.devConnected : l.devNextMeal(Fmt.time(s.feeder!.next!, context.lang)),
    DeviceType.fountain => l.devWaterLevel(s.fountain?.waterPct ?? 0),
    DeviceType.camera => l.devCameraReady,
    DeviceType.litterBox => l.devLitterVisits(s.litter?.visitsToday ?? 0),
  };
}

// ---------------------------------------------------------------------------
// Pairing: type → pet → search → name (and safe zone for collars).
// ---------------------------------------------------------------------------

class PairDeviceScreen extends ConsumerStatefulWidget {
  const PairDeviceScreen({super.key});

  @override
  ConsumerState<PairDeviceScreen> createState() => _PairDeviceScreenState();
}

class _PairDeviceScreenState extends ConsumerState<PairDeviceScreen> {
  DeviceType? _type;
  Pet? _pet;
  List<FoundDevice>? _found;
  bool _scanning = false;
  FoundDevice? _chosen;
  final _name = TextEditingController();
  double _radius = 300;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _found = null;
      _chosen = null;
    });
    try {
      final found = await ref.read(deviceProviderProvider).scan(_type!);
      if (mounted) setState(() => _found = found);
    } on UnsupportedError {
      if (mounted) await showDemoDialog(context, title: context.l10n.devLiveTitle, body: context.l10n.devLiveBody);
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider);
    final pet = _pet, found = _chosen;
    if (user == null || pet == null || found == null) return;
    setState(() => _saving = true);
    SafeZone? zone;
    if (found.type == DeviceType.gpsCollar) {
      final a = areas.values.firstWhere((a) => a.city == user.city, orElse: () => areas['banjara']!);
      zone = SafeZone(lat: a.lat, lng: a.lng, radiusM: _radius.round());
    }
    final id = await ref.read(deviceRepositoryProvider).pair(pet: pet, by: user, found: found, name: _name.text.trim().isEmpty ? found.model : _name.text.trim(), zone: zone);
    if (!mounted) return;
    showToast(context, context.l10n.devPaired(_name.text.trim().isEmpty ? found.model : _name.text.trim()));
    context.pushReplacement('/me/devices/$id');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    final type = _type;
    return Scaffold(
      appBar: AppBar(title: Text(l.devAdd)),
      body: PageBody(maxWidth: 760, children: [
        const SizedBox(height: Space.md),
        if (ref.watch(appConfigProvider).isDemo) ...[DemoBanner(l.devPairDemo), const SizedBox(height: Space.md)],
        SectionHeader(l.devStepType),
        ResponsiveGrid(minItemWidth: 220, spacing: Space.sm, children: [
          for (final t in DeviceType.values)
            _Choice(
              selected: _type == t,
              icon: deviceIcon(t),
              title: deviceTypeLabel(l, t),
              subtitle: deviceTypeHint(l, t),
              onTap: () => setState(() {
                _type = t;
                if (_pet != null && !deviceSuits(t, _pet!.species)) _pet = null;
                _found = null;
                _chosen = null;
              }),
            ),
        ]),
        if (type != null) ...[
          SectionHeader(l.devStepPet),
          Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
            for (final p in pets)
              ChoiceChip(
                avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 24),
                label: Text(p.name),
                selected: _pet?.id == p.id,
                onSelected: deviceSuits(type, p.species)
                    ? (_) => setState(() {
                          _pet = p;
                          _name.text = l.devDefaultName(p.name, deviceTypeLabel(l, type));
                        })
                    : null,
              ),
          ]),
          if (pets.any((p) => !deviceSuits(type, p.species))) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(l.devNotForAll, style: context.text.bodySmall)),
        ],
        if (type != null && _pet != null) ...[
          SectionHeader(l.devStepFind),
          if (_found == null)
            PrimaryButton(label: _scanning ? l.devSearching : l.devSearch, icon: Icons.bluetooth_searching_rounded, loading: _scanning, onPressed: _scanning ? null : _scan)
          else
            PawCard(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: RadioGroup<FoundDevice>(
                groupValue: _chosen,
                onChanged: (v) => setState(() => _chosen = v),
                child: Column(children: [
                  for (final f in _found!)
                    RadioListTile<FoundDevice>(
                      value: f,
                      title: Text('${f.vendor} · ${f.model}'),
                      subtitle: Text(f.serial),
                      secondary: Icon(deviceIcon(f.type)),
                    ),
                ]),
              ),
            ),
        ],
        if (_chosen != null) ...[
          SectionHeader(l.devStepName),
          PawTextField(label: l.devNameLabel, controller: _name),
          if (_chosen!.type == DeviceType.gpsCollar) ...[
            const SizedBox(height: Space.md),
            Text(l.devSafeZoneRadius(_radius.round()), style: context.text.titleSmall),
            Slider(
              value: _radius,
              min: minZoneM.toDouble(),
              max: maxZoneM.toDouble(),
              divisions: 19,
              label: '${_radius.round()} m',
              onChanged: (v) => setState(() => _radius = v),
            ),
            Text(l.devSafeZoneHint, style: context.text.bodySmall),
          ],
          const SizedBox(height: Space.lg),
          PrimaryButton(label: l.devPair, icon: Icons.link_rounded, loading: _saving, onPressed: _saving ? null : _save),
        ],
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.selected, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => PawCard(
        onTap: onTap,
        borderColor: selected ? context.colors.primary : null,
        color: selected ? context.colors.primaryContainer : null,
        semanticLabel: title,
        child: Row(children: [
          Icon(icon, color: context.colors.primary, size: 28),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: context.text.titleSmall),
              Text(subtitle, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
          if (selected) Icon(Icons.check_circle_rounded, color: context.colors.primary),
        ]),
      );
}

// ---------------------------------------------------------------------------
// One device with its live (demo) data.
// ---------------------------------------------------------------------------

class DeviceScreen extends ConsumerStatefulWidget {
  const DeviceScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  ConsumerState<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends ConsumerState<DeviceScreen> {
  StreamSubscription<DeviceSnapshot>? _sub;
  DeviceSnapshot? _snap;
  String? _watching;
  int _synced = -1;
  bool _syncing = false;
  bool _alerted = false;
  bool _recording = false;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _watch(Device d) {
    if (_watching == d.id) return;
    _watching = d.id;
    _sub?.cancel();
    _sub = ref.read(deviceProviderProvider).watch(d).listen((s) {
      if (!mounted) return;
      setState(() => _snap = s);
      _afterReading(s);
    });
  }

  Future<void> _afterReading(DeviceSnapshot s) async {
    final d = ref.read(deviceProvider(widget.deviceId)).value;
    if (d == null) return;
    final pet = ref.read(petProvider(d.petId)).value;
    final user = ref.read(currentUserProvider);
    if (pet == null || user == null) return;
    final fix = s.fix;
    if (fix != null && fix.inside != d.lastInside && !_recording) {
      _recording = true;
      try {
        final alert = await ref.read(deviceRepositoryProvider).recordZone(device: d, pet: pet, fix: fix);
        if (alert && mounted) {
          setState(() => _alerted = true);
          showToast(context, context.l10n.zoneLeftTitle(pet.name));
        }
      } finally {
        _recording = false;
      }
    }
    final day = s.today;
    if (day != null && day.sessions.length != _synced && !_syncing) {
      _syncing = true;
      try {
        final n = await ref.read(deviceRepositoryProvider).syncActivity(device: d, pet: pet, by: user, day: day);
        if (mounted) setState(() => _synced = day.sessions.length);
        if (n > 0 && mounted) showToast(context, context.l10n.devSynced(n, pet.name));
      } finally {
        _syncing = false;
      }
    }
  }

  Future<void> _command(Device d, DeviceCommand c) async {
    await ref.read(deviceProviderProvider).command(d, c);
    if (!mounted) return;
    final l = context.l10n;
    switch (c) {
      case DeviceCommand.feedNow:
        final pet = ref.read(petProvider(d.petId)).value;
        final user = ref.read(currentUserProvider);
        if (pet != null && user != null) {
          await ref.read(routineRepositoryProvider).addLog(pet: pet, by: user, type: LogType.meal, data: {'source': 'device', 'deviceId': d.id, 'grams': 20});
        }
        if (mounted) showToast(context, l.devFed(pet?.name ?? ''));
      case DeviceCommand.locate:
        showToast(context, l.devLocated);
      case DeviceCommand.snapshot:
        await showDemoDialog(context, title: l.demoTitle, body: l.devSnapshotDemo);
      case DeviceCommand.demoLeaveZone || DeviceCommand.demoReturnHome:
        if (c == DeviceCommand.demoReturnHome) setState(() => _alerted = false);
    }
  }

  Future<void> _editZone(Device d) async {
    final z = d.safeZone;
    if (z == null) return;
    var r = z.radiusM.toDouble();
    final ok = await showPawSheet<bool>(context, builder: (ctx) {
      return StatefulBuilder(builder: (ctx, set) {
        final l = ctx.l10n;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(l.devEditZone, style: ctx.text.titleLarge),
          const SizedBox(height: Space.md),
          Text(l.devSafeZoneRadius(r.round()), style: ctx.text.titleSmall),
          Slider(value: r, min: minZoneM.toDouble(), max: maxZoneM.toDouble(), divisions: 19, label: '${r.round()} m', onChanged: (v) => set(() => r = v)),
          Text(l.devSafeZoneHint, style: ctx.text.bodySmall),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.save, onPressed: () => Navigator.pop(ctx, true)),
        ]);
      });
    });
    if (ok == true) {
      await ref.read(deviceRepositoryProvider).setSafeZone(d.id, SafeZone(lat: z.lat, lng: z.lng, radiusM: r.round()));
      _watching = null; // restart the readings with the new zone
    }
  }

  Future<void> _remove(Device d) async {
    final l = context.l10n;
    final ok = await confirmAction(context, title: l.devRemoveTitle(d.name), body: l.devRemoveBody, confirmLabel: l.remove);
    if (!ok) return;
    await ref.read(deviceRepositoryProvider).remove(d.id);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = ref.watch(deviceProvider(widget.deviceId)).value;
    if (d == null) return Scaffold(appBar: AppBar(), body: const SkeletonList());
    final pet = ref.watch(petProvider(d.petId)).value;
    final latest = Device(d.id, d.raw);
    _watch(latest);
    final s = _snap ?? ref.read(deviceProviderProvider).read(latest);
    final demo = ref.watch(appConfigProvider).isDemo;
    return Scaffold(
      appBar: AppBar(title: Text(d.name)),
      body: PageBody(maxWidth: 760, children: [
        const SizedBox(height: Space.md),
        PawCard(
          child: Row(children: [
            CircleAvatar(radius: 28, backgroundColor: context.colors.primaryContainer, child: Icon(deviceIcon(d.type), color: context.colors.primary)),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${pet?.name ?? ''} · ${deviceTypeLabel(l, d.type)}', style: context.text.titleSmall),
                Text('${d.vendor} · ${d.serial}', style: context.text.bodySmall),
                const SizedBox(height: Space.xs),
                Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
                  StatusChip(l.devConnected, tone: ChipTone.success, icon: Icons.bluetooth_connected_rounded),
                  StatusChip('${s.battery}%', tone: s.battery < 20 ? ChipTone.error : ChipTone.neutral, icon: _batteryIcon(s.battery)),
                  if (demo) StatusChip(l.demoTitle, tone: ChipTone.info),
                ]),
              ]),
            ),
          ]),
        ),
        safetyGap,
        ...switch (d.type) {
          DeviceType.gpsCollar => _collar(d, pet, s, demo),
          DeviceType.activityTracker => _activity(pet, s),
          DeviceType.feeder => _feeder(d, s),
          DeviceType.fountain => _fountain(s),
          DeviceType.camera => _camera(d),
          DeviceType.litterBox => _litter(s),
        },
        const SizedBox(height: Space.xl),
        Center(
          child: TextButton.icon(
            onPressed: () => _remove(d),
            icon: Icon(Icons.link_off_rounded, color: context.paw.error),
            label: Text(l.devRemove, style: TextStyle(color: context.paw.error)),
          ),
        ),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }

  List<Widget> _collar(Device d, Pet? pet, DeviceSnapshot s, bool demo) {
    final l = context.l10n;
    final fix = s.fix;
    final z = d.safeZone;
    if (fix == null || z == null) return [InfoNote(l.devNoZone)];
    final petName = pet?.name ?? '';
    final out = !fix.inside;
    return [
      if (out || _alerted)
        PawCard(
          color: context.paw.sos.withValues(alpha: 0.1),
          borderColor: context.paw.sos,
          child: Row(children: [
            Icon(Icons.warning_rounded, color: context.paw.sos, size: 32),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(out ? l.zoneLeftTitle(petName) : l.zoneBackTitle(petName), style: context.text.titleMedium?.copyWith(color: out ? context.paw.sos : null)),
                Text(out ? l.devAlertSent : l.devBackInside, style: context.text.bodySmall),
              ]),
            ),
          ]),
        )
      else
        PawCard(
          child: Row(children: [
            Icon(Icons.verified_user_rounded, color: context.paw.success, size: 32),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.devInsideZone(fix.metersFromHome.round()), style: context.text.titleMedium)),
          ]),
        ),
      const SizedBox(height: Space.md),
      ClipRRect(
        borderRadius: BorderRadius.circular(Radii.card),
        child: SizedBox(
          height: 260,
          child: PawMap(
            center: LatLng(z.lat, z.lng),
            zoom: 15,
            fitPoints: [LatLng(z.lat, z.lng), LatLng(fix.lat, fix.lng)],
            circles: [
              CircleMarker(
                point: LatLng(z.lat, z.lng),
                radius: z.radiusM.toDouble(),
                useRadiusInMeter: true,
                color: context.paw.success.withValues(alpha: 0.12),
                borderColor: context.paw.success,
                borderStrokeWidth: 2,
              ),
            ],
            markers: [
              pinMarker(LatLng(z.lat, z.lng), color: context.colors.primary, icon: Icons.home_rounded, size: 34),
              pinMarker(LatLng(fix.lat, fix.lng), color: out ? context.paw.sos : context.paw.accent, icon: Icons.pets_rounded),
            ],
          ),
        ),
      ),
      const SizedBox(height: Space.sm),
      Text(l.devUpdated(Fmt.time(s.at, context.lang)), style: context.text.labelSmall),
      const SizedBox(height: Space.md),
      Row(children: [
        Expanded(child: SecondaryButton(label: l.devLocate, icon: Icons.my_location_rounded, onPressed: () => _command(d, DeviceCommand.locate))),
        const SizedBox(width: Space.sm),
        Expanded(child: SecondaryButton(label: l.devEditZone, icon: Icons.radar_rounded, onPressed: () => _editZone(d))),
      ]),
      if (demo) ...[
        const SizedBox(height: Space.lg),
        PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.devDemoControls, style: context.text.titleSmall),
            const SizedBox(height: Space.xs),
            Text(l.devDemoControlsHint, style: context.text.bodySmall),
            const SizedBox(height: Space.md),
            out
                ? SecondaryButton(label: l.devDemoComeHome(petName), icon: Icons.home_rounded, onPressed: () => _command(d, DeviceCommand.demoReturnHome))
                : PrimaryButton(label: l.devDemoWalkOut(petName), icon: Icons.directions_walk_rounded, danger: true, onPressed: () => _command(d, DeviceCommand.demoLeaveZone)),
          ]),
        ),
      ],
      safetyGap,
      ..._activity(pet, s),
    ];
  }

  List<Widget> _activity(Pet? pet, DeviceSnapshot s) {
    final l = context.l10n;
    final day = s.today;
    if (day == null) return const [];
    return [
      SectionHeader(l.devToday),
      PawCard(
        child: Row(children: [
          ProgressRing(
            progress: (day.activeMinutes / day.goalMinutes).clamp(0.0, 1.0),
            size: 84,
            center: Text('${day.activeMinutes}', style: context.text.titleLarge),
          ),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.devActiveMinutes(day.activeMinutes, day.goalMinutes), style: context.text.titleMedium),
              Text(l.devStepsToday(Fmt.number(day.steps, context.lang)), style: context.text.bodyMedium),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: Space.sm),
      if (day.sessions.isEmpty)
        InfoNote(l.devNoSessions)
      else
        PawCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(children: [
            for (final x in day.sessions)
              ListTile(
                leading: Icon(x.kind == 'walk' ? Icons.directions_walk_rounded : Icons.sports_baseball_rounded),
                title: Text(x.kind == 'walk' ? l.devWalkSession(x.minutes, x.km.toStringAsFixed(1)) : l.devPlaySession(x.minutes)),
                subtitle: Text(Fmt.time(x.start, context.lang)),
                trailing: Icon(Icons.check_circle_rounded, color: context.paw.success, semanticLabel: l.devInRoutine),
              ),
          ]),
        ),
      const SizedBox(height: Space.xs),
      Text(l.devFlowsToRoutine(pet?.name ?? ''), style: context.text.bodySmall),
    ];
  }

  List<Widget> _feeder(Device d, DeviceSnapshot s) {
    final l = context.l10n;
    final f = s.feeder;
    if (f == null) return const [];
    return [
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (f.next != null) Text(l.devNextMeal(Fmt.time(f.next!, context.lang)), style: context.text.titleMedium),
          const SizedBox(height: Space.sm),
          Text(l.devHopper(f.hopperPct), style: context.text.bodyMedium),
          const SizedBox(height: Space.xs),
          LinearProgressIndicator(value: f.hopperPct / 100, minHeight: 10, borderRadius: BorderRadius.circular(8)),
        ]),
      ),
      SectionHeader(l.devMealsToday),
      if (f.meals.isEmpty)
        InfoNote(l.devNoMealsYet)
      else
        PawCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(children: [
            for (final m in f.meals)
              ListTile(leading: const Icon(Icons.set_meal_rounded), title: Text(l.devMealGrams(m.grams)), subtitle: Text(Fmt.time(m.at, context.lang))),
          ]),
        ),
      const SizedBox(height: Space.md),
      PrimaryButton(label: l.devFeedNow, icon: Icons.restaurant_rounded, onPressed: () => _command(d, DeviceCommand.feedNow)),
    ];
  }

  List<Widget> _fountain(DeviceSnapshot s) {
    final l = context.l10n;
    final f = s.fountain;
    if (f == null) return const [];
    return [
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.devWaterLevel(f.waterPct), style: context.text.titleMedium),
          const SizedBox(height: Space.sm),
          LinearProgressIndicator(
            value: f.waterPct / 100,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
            color: f.refillSoon ? context.paw.warning : context.colors.primary,
          ),
          const SizedBox(height: Space.sm),
          Text(l.devFilterDays(f.filterDaysLeft), style: context.text.bodySmall),
        ]),
      ),
      if (f.refillSoon) ...[const SizedBox(height: Space.sm), InfoNote(l.devRefillSoon, icon: Icons.water_drop_rounded, tone: ChipTone.warning)],
    ];
  }

  List<Widget> _camera(Device d) {
    final l = context.l10n;
    return [
      PawCard(
        child: Column(children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(color: context.colors.surfaceContainerHighest, borderRadius: BorderRadius.circular(Radii.card)),
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.videocam_off_rounded, size: 48, color: context.paw.textSecondary),
                  const SizedBox(height: Space.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                    child: Text(l.devCameraPlaceholder, textAlign: TextAlign.center, style: context.text.bodyMedium),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.devSnapshot, icon: Icons.photo_camera_rounded, onPressed: () => _command(d, DeviceCommand.snapshot)),
        ]),
      ),
    ];
  }

  List<Widget> _litter(DeviceSnapshot s) {
    final l = context.l10n;
    final x = s.litter;
    if (x == null) return const [];
    return [
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.devLitterVisits(x.visitsToday), style: context.text.titleMedium),
          if (x.lastVisit != null) Text(l.devLastVisit(Fmt.time(x.lastVisit!, context.lang)), style: context.text.bodyMedium),
          const SizedBox(height: Space.sm),
          x.needsCleaning
              ? StatusChip(l.devCleanSoon, tone: ChipTone.warning, icon: Icons.cleaning_services_rounded)
              : StatusChip(l.devLitterClean, tone: ChipTone.success, icon: Icons.check_rounded),
        ]),
      ),
    ];
  }
}
