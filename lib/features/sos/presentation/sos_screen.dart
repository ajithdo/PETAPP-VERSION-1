import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/demo/seed/seed_places.dart' show areas;
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/places_repository.dart';
import '../../booking/presentation/place_finder_screen.dart' show pickArea, searchOriginProvider;
import '../../health/presentation/health_report.dart' show MedicalSummaryCard;
import '../../pets/data/pets_repository.dart';
import '../data/sos_repository.dart';
import '../domain/sos_rules.dart';

/// Emergency SOS (spec 7.12), opened after holding the red button for
/// 2 seconds: exactly two big options, then the pet's medical summary and
/// first aid. Works on weak internet with the clinics saved on the device.
class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key, this.petId});
  final String? petId;

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

enum _Open { none, call, address }

class _SosScreenState extends ConsumerState<SosScreen> {
  SosSpot? _spot;
  bool _locating = true;
  bool _logged = false;
  bool _savedOnce = false;
  String? _petId;
  _Open _open = _Open.call;
  bool _slow = false;
  Timer? _slowTimer;

  @override
  void initState() {
    super.initState();
    _petId = widget.petId;
    _slowTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _slow = true);
    });
    _locate();
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    super.dispose();
  }

  Future<SosSpot?> _gps() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm != LocationPermission.always && perm != LocationPermission.whileInUse) return null;
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 8)),
      );
      return SosSpot(lat: p.latitude, lng: p.longitude, source: SosSource.gps, at: DateTime.now());
    } catch (_) {
      return null;
    }
  }

  Future<SosSpot?> _osLastKnown() async {
    if (kIsWeb) return null;
    try {
      final p = await Geolocator.getLastKnownPosition();
      return p == null ? null : SosSpot(lat: p.latitude, lng: p.longitude, source: SosSource.lastKnown, at: p.timestamp);
    } catch (_) {
      return null;
    }
  }

  SosSpot _chosen() {
    final o = ref.read(searchOriginProvider);
    if (!o.fromGps) return SosSpot(lat: o.lat, lng: o.lng, source: SosSource.chosen, label: o.label);
    final city = ref.read(currentUserProvider)?.city;
    final a = areas.values.firstWhere((a) => a.city == city, orElse: () => areas['banjara']!);
    return SosSpot(lat: a.lat, lng: a.lng, source: SosSource.chosen, label: '${a.name}, ${a.city}');
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    final repo = ref.read(sosRepositoryProvider);
    final gps = await _gps();
    final saved = repo.lastKnown();
    final os = await _osLastKnown();
    final last = [saved, os].whereType<SosSpot>().fold<SosSpot?>(null, (a, b) => a == null || (b.at ?? DateTime(0)).isAfter(a.at ?? DateTime(0)) ? b : a);
    if (!mounted) return;
    final spot = pickSosSpot(gps: gps, lastKnown: last, chosen: _chosen(), now: DateTime.now());
    if (gps != null) unawaited(repo.rememberSpot(gps.lat, gps.lng));
    setState(() {
      _spot = spot;
      _locating = false;
    });
    final user = ref.read(currentUserProvider);
    if (!_logged && user != null) {
      _logged = true;
      unawaited(repo.logActivation(uid: user.uid, petId: _petId ?? ref.read(selectedPetProvider)?.id, spot: spot).catchError((_) {}));
    }
  }

  Future<void> _changeArea() async {
    await pickArea(context, ref);
    if (!mounted) return;
    final o = ref.read(searchOriginProvider);
    setState(() => _spot = SosSpot(lat: o.lat, lng: o.lng, source: SosSource.chosen, label: o.label));
  }

  Future<void> _call(SosClinic c) async {
    HapticFeedback.mediumImpact();
    if (ref.read(appConfigProvider).isDemo) {
      await showDemoDialog(context, title: context.l10n.demoTitle, body: context.l10n.sosDemoCall(c.callNumber));
      return;
    }
    await launchUrl(Uri.parse('tel:${c.callNumber.replaceAll(' ', '')}'));
  }

  /// Live clinics when they arrive; otherwise the ones saved on the device.
  ({List<SosClinic> list, DateTime? savedAt}) _clinics() {
    final live = ref.watch(clinicsProvider);
    final spot = _spot;
    if (live.hasValue && live.value!.isNotEmpty) {
      final list = [
        for (final p in live.value!)
          SosClinic(
            id: p.id,
            name: p.name,
            address: p.address,
            area: p.area,
            city: p.city,
            lat: p.lat,
            lng: p.lng,
            phone: p.phone,
            emergencyPhone: p.emergencyPhone,
            is24x7: p.is24x7,
            hours: p.hours,
          ),
      ];
      if (!_savedOnce && spot != null) {
        _savedOnce = true;
        unawaited(ref.read(sosRepositoryProvider).saveClinics(clinicsToSave(list, lat: spot.lat, lng: spot.lng)));
      }
      return (list: list, savedAt: null);
    }
    if (live.hasError || _slow) {
      final saved = ref.read(sosRepositoryProvider).savedClinics();
      if (saved != null) return (list: saved.clinics, savedAt: saved.at);
    }
    return (list: const [], savedAt: null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final spot = _spot;
    final pets = ref.watch(activePetsProvider);
    final petId = _petId ?? ref.watch(selectedPetProvider)?.id ?? (pets.isEmpty ? null : pets.first.id);
    final clinics = _clinics();
    final ranked = spot == null ? const <RankedClinic>[] : rankSosClinics(clinics.list, lat: spot.lat, lng: spot.lng, now: DateTime.now());
    final nearest = ranked.isEmpty ? null : ranked.first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.paw.sos,
        foregroundColor: context.paw.onSos,
        title: Text(l.sosTitle),
        leading: IconButton(
          tooltip: l.close,
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: PageBody(maxWidth: 640, children: [
        const SizedBox(height: Space.md),
        _LocationLine(spot: spot, locating: _locating, onChange: _changeArea, onRetry: _locate),
        if (clinics.savedAt != null) ...[
          const SizedBox(height: Space.sm),
          InfoNote(l.sosSavedClinics(Fmt.dateTime(clinics.savedAt!, context.lang)), icon: Icons.wifi_off_rounded, tone: ChipTone.warning),
        ],
        const SizedBox(height: Space.lg),
        _BigOption(
          icon: Icons.call_rounded,
          title: l.sosCallNearest,
          subtitle: nearest == null ? l.sosFinding : '${nearest.clinic.name} · ${Fmt.km(nearest.km)}',
          filled: true,
          expanded: _open == _Open.call,
          onTap: () => setState(() => _open = _open == _Open.call ? _Open.none : _Open.call),
        ),
        if (_open == _Open.call) ...[
          const SizedBox(height: Space.sm),
          if (ranked.isEmpty)
            _locating || spot == null ? const SkeletonList(count: 3, itemHeight: 64) : EmptyState(title: l.sosNoClinics, compact: true)
          else
            PawCard(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Column(children: [
                for (final r in ranked.take(6)) _ClinicCallTile(r: r, onCall: () => _call(r.clinic)),
              ]),
            ),
        ],
        const SizedBox(height: Space.md),
        _BigOption(
          icon: Icons.near_me_rounded,
          title: l.sosGetAddress,
          subtitle: nearest == null ? l.sosFinding : nearest.clinic.fullAddress,
          filled: false,
          expanded: _open == _Open.address,
          onTap: () => setState(() => _open = _open == _Open.address ? _Open.none : _Open.address),
        ),
        if (_open == _Open.address && nearest != null && spot != null) ...[
          const SizedBox(height: Space.sm),
          _AddressCard(r: nearest, spot: spot),
        ],
        const SizedBox(height: Space.xl),
        SectionHeader(l.sosShowVet),
        if (pets.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
              for (final p in pets) ChoiceChip(label: Text(p.name), selected: p.id == petId, onSelected: (_) => setState(() => _petId = p.id)),
            ]),
          ),
        if (petId != null) MedicalSummaryCard(petId: petId) else EmptyState(title: l.noPetsTitle, compact: true),
        const SizedBox(height: Space.lg),
        PawCard(
          onTap: () => context.push('/first-aid'),
          child: Row(children: [
            Icon(Icons.medical_services_rounded, color: context.paw.sos, size: 32),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.firstAidTitle, style: context.text.titleMedium),
                Text(l.firstAidOfflineHint, style: context.text.bodySmall),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}

class _LocationLine extends StatelessWidget {
  const _LocationLine({required this.spot, required this.locating, required this.onChange, required this.onRetry});
  final SosSpot? spot;
  final bool locating;
  final VoidCallback onChange;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = spot;
    final text = locating || s == null
        ? l.sosLocating
        : switch (s.source) {
            SosSource.gps => l.sosUsingGps,
            SosSource.lastKnown => l.sosUsingLastKnown(Fmt.time(s.at ?? DateTime.now(), context.lang)),
            SosSource.chosen => l.sosUsingArea(s.label),
          };
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
      child: Row(children: [
        locating
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
            : Icon(s?.source == SosSource.gps ? Icons.my_location_rounded : Icons.location_off_rounded,
                color: s?.source == SosSource.gps ? context.paw.success : context.paw.warning),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(text, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            if (!locating && s != null && s.source != SosSource.gps) Text(l.sosLocationOffHint, style: context.text.bodySmall),
          ]),
        ),
        if (!locating) ...[
          if (s?.source != SosSource.gps) IconButton(tooltip: l.sosTryLocation, icon: const Icon(Icons.refresh_rounded), onPressed: onRetry),
          TextButton(onPressed: onChange, child: Text(l.sosChangeArea)),
        ],
      ]),
    );
  }
}

class _BigOption extends StatelessWidget {
  const _BigOption({required this.icon, required this.title, required this.subtitle, required this.filled, required this.expanded, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.paw;
    final fg = filled ? p.onSos : p.sos;
    return Semantics(
      button: true,
      expanded: expanded,
      child: Material(
        color: filled ? p.sos : context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.card), side: BorderSide(color: p.sos, width: 2)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 96),
            child: Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Row(children: [
                Icon(icon, size: 40, color: fg),
                const SizedBox(width: Space.lg),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(title, style: context.text.titleLarge?.copyWith(color: fg, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodyMedium?.copyWith(color: fg)),
                  ]),
                ),
                Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: fg),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClinicCallTile extends StatelessWidget {
  const _ClinicCallTile({required this.r, required this.onCall});
  final RankedClinic r;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = r.clinic;
    return ListTile(
      onTap: onCall,
      minVerticalPadding: Space.md,
      title: Text(c.name, style: context.text.titleSmall),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: Space.xs),
        child: Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text(Fmt.km(r.km), style: context.text.bodySmall),
          StatusChip(c.is24x7 ? l.open24x7 : (r.open ? l.openNow : l.closedNow), tone: r.open ? ChipTone.success : ChipTone.neutral),
        ]),
      ),
      trailing: IconButton.filled(
        tooltip: l.sosCallClinic(c.name),
        style: IconButton.styleFrom(backgroundColor: context.paw.sos, foregroundColor: context.paw.onSos, minimumSize: const Size(48, 48)),
        icon: const Icon(Icons.call_rounded),
        onPressed: onCall,
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.r, required this.spot});
  final RankedClinic r;
  final SosSpot spot;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = r.clinic;
    final text = '${c.name}\n${c.fullAddress}\n${c.callNumber}';
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(c.name, style: context.text.titleMedium),
        const SizedBox(height: Space.xs),
        SelectableText(c.fullAddress, style: context.text.bodyMedium),
        const SizedBox(height: Space.xs),
        Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Text(l.sosAway(Fmt.km(r.km)), style: context.text.bodySmall),
          StatusChip(c.is24x7 ? l.open24x7 : (r.open ? l.openNow : l.closedNow), tone: r.open ? ChipTone.success : ChipTone.neutral),
        ]),
        const SizedBox(height: Space.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.card),
          child: SizedBox(
            height: 180,
            child: PawMap(
              center: LatLng(c.lat, c.lng),
              zoom: 13,
              interactive: false,
              fitPoints: [LatLng(c.lat, c.lng), LatLng(spot.lat, spot.lng)],
              markers: [
                pinMarker(LatLng(c.lat, c.lng), color: context.paw.sos, icon: Icons.local_hospital_rounded),
                dotMarker(LatLng(spot.lat, spot.lng), context.colors.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.openInMaps, icon: Icons.directions_rounded, onPressed: () => openDirections(c.lat, c.lng, label: c.name)),
        const SizedBox(height: Space.sm),
        Row(children: [
          Expanded(
            child: SecondaryButton(
              label: l.copy,
              icon: Icons.copy_rounded,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));
                if (context.mounted) showToast(context, l.copied);
              },
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: SecondaryButton(
              label: l.share,
              icon: Icons.share_rounded,
              onPressed: () async {
                try {
                  await SharePlus.instance.share(ShareParams(text: text));
                } catch (_) {
                  await Clipboard.setData(ClipboardData(text: text));
                  if (context.mounted) showToast(context, l.copied);
                }
              },
            ),
          ),
        ]),
      ]),
    );
  }
}
