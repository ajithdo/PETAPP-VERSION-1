import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/demo/seed/seed_places.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/routine_repository.dart';
import '../domain/routine.dart';
import 'heat_card.dart';
import 'quick_log_sheet.dart';

enum _WalkState { ready, tracking, paused, finished }

/// GPS walk tracker (spec 7.3): start, pause, stop; distance, duration and
/// pace; the route on OpenStreetMap. On phones it keeps tracking in the
/// background with a visible notification. The website offers manual entry
/// and a demo walk.
class WalkTrackerScreen extends ConsumerStatefulWidget {
  const WalkTrackerScreen({super.key, required this.petId});
  final String petId;
  @override
  ConsumerState<WalkTrackerScreen> createState() => _WalkTrackerScreenState();
}

class _WalkTrackerScreenState extends ConsumerState<WalkTrackerScreen> {
  _WalkState _state = _WalkState.ready;
  final _points = <LatLng>[];
  final _map = MapController();
  StreamSubscription<Position>? _gps;
  Timer? _sim;
  Timer? _clock;
  Duration _elapsed = Duration.zero;
  DateTime? _startedAt;
  bool _simulated = false;
  bool _saving = false;
  LatLng? _center;

  @override
  void dispose() {
    _gps?.cancel();
    _sim?.cancel();
    _clock?.cancel();
    super.dispose();
  }

  double get _km => routeKm([for (final p in _points) (lat: p.latitude, lng: p.longitude)]);

  LatLng _homeCenter() {
    final city = ref.read(currentUserProvider)?.city;
    final a = areas.values.firstWhere((a) => a.city == city, orElse: () => areas['banjara']!);
    return LatLng(a.lat, a.lng);
  }

  void _startClock() {
    _clock?.cancel();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      // The demo walk advances its own clock (fast-forward).
      if (_state == _WalkState.tracking && !_simulated) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _start({bool simulate = false}) async {
    final l = context.l10n;
    _startedAt ??= DateTime.now();
    if (!simulate && !kIsWeb) {
      final ok = await _askLocation();
      if (!ok) {
        if (!mounted) return;
        final useDemo = await confirmAction(context,
            title: l.locationOffTitle, body: l.locationOffBody, confirmLabel: l.useDemoWalk, danger: false);
        if (!useDemo) return;
        simulate = true;
      }
    }
    if (kIsWeb) simulate = true;
    HapticFeedback.mediumImpact();
    setState(() {
      _state = _WalkState.tracking;
      _simulated = simulate;
    });
    _startClock();
    if (simulate) {
      _runSimulation();
    } else {
      _listenGps();
    }
  }

  Future<bool> _askLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      if (!mounted) return false;
      // One-line reason first (spec 14).
      final go = await confirmAction(context,
          title: context.l10n.locationWhyTitle, body: context.l10n.locationWhyWalk, confirmLabel: context.l10n.continueLabel, danger: false);
      if (!go) return false;
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.always || perm == LocationPermission.whileInUse;
  }

  void _listenGps() {
    final l = context.l10n;
    final LocationSettings settings = switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
          intervalDuration: const Duration(seconds: 3),
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationTitle: l.walkNotificationTitle,
            notificationText: l.walkNotificationText,
            enableWakeLock: true,
            setOngoing: true,
          ),
        ),
      TargetPlatform.iOS => AppleSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
          activityType: ActivityType.fitness,
          allowBackgroundLocationUpdates: true,
          showBackgroundLocationIndicator: true,
          pauseLocationUpdatesAutomatically: false,
        ),
      _ => const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    };
    _gps = Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      if (_state != _WalkState.tracking) return;
      // Ignore very inaccurate fixes.
      if (pos.accuracy > 40) return;
      _addPoint(LatLng(pos.latitude, pos.longitude));
    });
  }

  /// Demo walk: follows a loop near home in fast-forward. Each tick moves
  /// about 15 m and adds 10 seconds, a relaxed 5-6 km/h dog-walking pace.
  void _runSimulation() {
    final c = _points.isNotEmpty ? _points.last : _homeCenter();
    final loop = demoLoopRoute(c.latitude, c.longitude, seed: DateTime.now().second, km: 2.4, points: 160);
    var i = 0;
    _sim?.cancel();
    _sim = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_state != _WalkState.tracking) return;
      if (i >= loop.length) i = 0;
      _elapsed += const Duration(seconds: 10);
      _addPoint(LatLng(loop[i].lat, loop[i].lng));
      i++;
    });
  }

  void _addPoint(LatLng p) {
    setState(() {
      _points.add(p);
      _center = p;
    });
    try {
      _map.move(p, _map.camera.zoom);
    } catch (_) {}
  }

  void _pause() {
    HapticFeedback.selectionClick();
    setState(() => _state = _WalkState.paused);
  }

  void _resume() {
    HapticFeedback.selectionClick();
    setState(() => _state = _WalkState.tracking);
  }

  void _stop() {
    HapticFeedback.heavyImpact();
    _gps?.cancel();
    _sim?.cancel();
    _clock?.cancel();
    setState(() => _state = _WalkState.finished);
  }

  Future<void> _save(Pet pet) async {
    setState(() => _saving = true);
    final user = ref.read(currentUserProvider)!;
    await ref.read(routineRepositoryProvider).addLog(
      pet: pet,
      by: user,
      type: LogType.walk,
      at: _startedAt ?? DateTime.now(),
      data: {
        'distanceKm': double.parse(_km.toStringAsFixed(2)),
        'durationMin': (_elapsed.inSeconds / 60).ceil(),
        'route': [for (final p in _points) {'lat': p.latitude, 'lng': p.longitude}],
        'source': _simulated ? 'demo' : 'gps',
      },
    );
    if (mounted) {
      showToast(context, context.l10n.walkSaved(pet.name, Fmt.km(_km)));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pet = ref.watch(petProvider(widget.petId)).value;
    if (pet == null) return const Scaffold(body: SkeletonList());
    final center = _center ?? _homeCenter();
    final pace = paceMinPerKm(_km, _elapsed);
    return PopScope(
      canPop: _state == _WalkState.ready || _state == _WalkState.finished,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await confirmAction(context, title: l.walkLeaveTitle, body: l.walkLeaveBody, confirmLabel: l.discardWalk);
        if (leave && context.mounted) {
          _stop();
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.walkWith(pet.name))),
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.gutter),
                child: Stack(children: [
                  PawMap(
                    controller: _map,
                    center: center,
                    zoom: 16,
                    routes: [if (_points.length > 1) _points],
                    markers: [if (_points.isNotEmpty) dotMarker(_points.last, context.colors.primary)],
                    fitPoints: _state == _WalkState.finished ? _points : null,
                  ),
                  if (_simulated)
                    Positioned(top: Space.sm, left: Space.sm, right: Space.sm, child: DemoBanner(l.demoWalkBanner)),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.gutter),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(children: [
                  if (_state == _WalkState.ready) ...[
                    HeatCard(pet: pet, compact: true),
                    const SizedBox(height: Space.md),
                  ],
                  Row(children: [
                    Expanded(child: _Stat(label: l.distance, value: Fmt.km(_km))),
                    Expanded(child: _Stat(label: l.duration, value: Fmt.duration(_elapsed))),
                    Expanded(child: _Stat(label: l.pace, value: pace == null ? '–' : l.paceValue(pace.toStringAsFixed(1)))),
                  ]),
                  const SizedBox(height: Space.lg),
                  ..._controls(context, pet),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _controls(BuildContext context, Pet pet) {
    final l = context.l10n;
    switch (_state) {
      case _WalkState.ready:
        return [
          if (!kIsWeb) PrimaryButton(label: l.startWalk, icon: Icons.play_arrow_rounded, onPressed: () => _start()),
          if (kIsWeb) ...[
            InfoNote(l.walkWebNote),
            const SizedBox(height: Space.md),
            PrimaryButton(
              label: l.enterWalkManually,
              icon: Icons.edit_rounded,
              onPressed: () async {
                await showLogDetails(context, ref, pet, LogType.walk);
                if (context.mounted) context.pop();
              },
            ),
          ],
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.startDemoWalk, icon: Icons.science_rounded, onPressed: () => _start(simulate: true)),
        ];
      case _WalkState.tracking:
        return [
          Row(children: [
            Expanded(child: SecondaryButton(label: l.pause, icon: Icons.pause_rounded, onPressed: _pause)),
            const SizedBox(width: Space.md),
            Expanded(child: PrimaryButton(label: l.stop, icon: Icons.stop_rounded, danger: true, onPressed: _stop)),
          ]),
        ];
      case _WalkState.paused:
        return [
          Row(children: [
            Expanded(child: SecondaryButton(label: l.resume, icon: Icons.play_arrow_rounded, onPressed: _resume)),
            const SizedBox(width: Space.md),
            Expanded(child: PrimaryButton(label: l.stop, icon: Icons.stop_rounded, danger: true, onPressed: _stop)),
          ]),
        ];
      case _WalkState.finished:
        return [
          PrimaryButton(label: l.saveWalk, loading: _saving, icon: Icons.check_rounded, onPressed: () => _save(pet)),
          const SizedBox(height: Space.sm),
          TextButton(
            onPressed: () async {
              final ok = await confirmAction(context, title: l.discardWalk);
              if (ok && context.mounted) context.pop();
            },
            child: Text(l.discardWalk),
          ),
        ];
    }
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $value',
      excludeSemantics: true,
      child: Column(children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, maxLines: 1, style: context.text.headlineSmall?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
        ),
        Text(label, style: context.text.bodySmall),
      ]),
    );
  }
}

/// Read-only map of a saved walk.
class WalkRouteView extends StatelessWidget {
  const WalkRouteView({super.key, required this.log, this.height = 220});
  final RoutineLog log;
  final double height;

  @override
  Widget build(BuildContext context) {
    final pts = [for (final p in log.route) LatLng(p.lat, p.lng)];
    if (pts.length < 2) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      child: PawMap(
        center: pts.first,
        routes: [pts],
        markers: [dotMarker(pts.first, context.paw.success), dotMarker(pts.last, context.paw.error)],
        fitPoints: pts,
        interactive: false,
      ),
    );
  }
}
