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
import '../../health/data/health_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import '../data/sos_repository.dart';
import '../domain/sos_rules.dart';
import '../../../core/theme/ph.dart';

/// Emergency SOS (spec 7.12), opened after holding the red button for
/// 2 seconds: one red card that calls the nearest clinic, its address and
/// map, then the pet's medical summary and first aid. Works on weak internet with the clinics saved on the device.
class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key, this.petId});
  final String? petId;

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  SosSpot? _spot;
  bool _locating = true;
  bool _logged = false;
  bool _savedOnce = false;
  String? _petId;
  bool _slow = false;
  bool _userChose = false;
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

  /// Shows clinics straight away from the last known place or the chosen
  /// area, then switches to GPS if it answers within 10 seconds. A location
  /// prompt nobody answers must never hold up SOS.
  Future<void> _locate() async {
    setState(() => _locating = true);
    final repo = ref.read(sosRepositoryProvider);
    final saved = repo.lastKnown();
    final os = await _osLastKnown().timeout(const Duration(seconds: 2), onTimeout: () => null);
    final last = [saved, os].whereType<SosSpot>().fold<SosSpot?>(null, (a, b) => a == null || (b.at ?? DateTime(0)).isAfter(a.at ?? DateTime(0)) ? b : a);
    if (!mounted) return;
    if (_spot == null || _spot!.source != SosSource.chosen) {
      setState(() => _spot = pickSosSpot(lastKnown: last, chosen: _chosen(), now: DateTime.now()));
    }
    final gps = await _gps().timeout(const Duration(seconds: 10), onTimeout: () => null);
    if (!mounted) return;
    if (gps != null) unawaited(repo.rememberSpot(gps.lat, gps.lng));
    setState(() {
      if (gps != null && !_userChose) _spot = gps;
      _locating = false;
    });
    final user = ref.read(currentUserProvider);
    if (!_logged && user != null && _spot != null) {
      _logged = true;
      unawaited(repo.logActivation(uid: user.uid, petId: _petId ?? ref.read(selectedPetProvider)?.id, spot: _spot!).catchError((_) {}));
    }
  }

  Future<void> _changeArea() async {
    await pickArea(context, ref);
    if (!mounted) return;
    final o = ref.read(searchOriginProvider);
    setState(() {
      _userChose = true;
      _spot = SosSpot(lat: o.lat, lng: o.lng, source: SosSource.chosen, label: o.label);
    });
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

    final paw = context.paw;
    final demo = ref.watch(appConfigProvider).isDemo;
    String state(RankedClinic r) => r.clinic.is24x7 ? l.open24x7 : (r.open ? l.openNow : l.closedNow);
    // UI Design 6: one red card that calls the nearest clinic, the next
    // clinics as rows, the nearest clinic's address with its map, the pet's
    // facts for the vet, and first aid.
    final callCard = Container(
      padding: const EdgeInsets.all(Space.lg + Space.xxs),
      decoration: BoxDecoration(
        color: paw.sos,
        borderRadius: BorderRadius.circular(Radii.xxl),
        boxShadow: [BoxShadow(color: paw.sos.withValues(alpha: Opacities.faded), blurRadius: Space.x3l - Space.sm, spreadRadius: -(Space.xl - Space.xs), offset: const Offset(0, Space.lg + Space.xxs))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Container(
            width: Sizes.quickCircle,
            height: Sizes.quickCircle,
            decoration: BoxDecoration(color: paw.onSos, shape: BoxShape.circle),
            child: Icon(Ph.phoneCallFill, size: IconSizes.action, color: paw.sos),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Semantics(header: true, child: Text(l.sosCallNearest, style: context.text.headlineMedium?.copyWith(color: paw.onSos))),
              Text(
                nearest == null ? l.sosFinding : [nearest.clinic.name, Fmt.km(nearest.km), state(nearest).toLowerCase()].join(', '),
                style: context.text.bodyMedium?.copyWith(color: paw.onSos),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: Space.lg),
        Semantics(
          button: true,
          enabled: nearest != null,
          label: nearest == null ? l.sosCallNearest : l.sosCallClinic(nearest.clinic.name),
          excludeSemantics: true,
          child: Material(
            color: paw.onSos,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: nearest == null ? null : () => _call(nearest.clinic),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: TapTarget.easy),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Ph.phoneFill, size: IconSizes.md, color: paw.error),
                  const SizedBox(width: Space.sm),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(nearest == null ? l.sosFinding : l.sosCallNumber(nearest.clinic.callNumber), maxLines: 1, style: context.text.titleSmall?.copyWith(color: paw.error)),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
    final others = ranked.skip(1).take(5).toList();
    final Widget otherClinics = ranked.isEmpty
        ? (_locating || spot == null ? const SkeletonList(count: 2, itemHeight: Sizes.listRow) : EmptyState(title: l.sosNoClinics, compact: true))
        : others.isEmpty
            ? const SizedBox.shrink()
            : PawPanel(
                padding: PawPanel.listPadding,
                child: PawList(children: [
                  for (final r in others)
                    PawItem(
                      title: r.clinic.name,
                      subWidget: Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.xs + Space.xxs, runSpacing: Space.xxs, children: [
                        PawTag(state(r), kind: r.clinic.is24x7 || r.open ? TagKind.green : TagKind.neutral),
                        Text('${r.clinic.area}, ${Fmt.km(r.km)}', style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
                      ]),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          tooltip: l.mapView,
                          onPressed: () => openDirections(r.clinic.lat, r.clinic.lng, label: r.clinic.name),
                          style: IconButton.styleFrom(
                            shape: CircleBorder(side: BorderSide(color: context.tint.line2, width: Strokes.strong)),
                            minimumSize: const Size.square(Sizes.topControl),
                            fixedSize: const Size.square(Sizes.topControl),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(Ph.navigationArrow, size: IconSizes.md, color: paw.textPrimary),
                        ),
                        const SizedBox(width: Space.sm),
                        PawButton(label: l.call, semanticLabel: l.sosCallClinic(r.clinic.name), icon: Ph.phoneFill, kind: BtnKind.ink, onPressed: () => _call(r.clinic)),
                      ]),
                    ),
                ]),
              );
    final left = <Widget>[
      callCard,
      const SizedBox(height: Space.lg),
      otherClinics,
      if (demo && nearest != null) ...[
        const SizedBox(height: Space.lg),
        InfoNote(l.sosDemoCall(nearest.clinic.callNumber), icon: Ph.flask, tone: ChipTone.accent),
      ],
    ];
    final pet = petId == null ? null : pets.where((p) => p.id == petId).firstOrNull;
    final right = <Widget>[
      if (nearest != null && spot != null) _AddressCard(r: nearest, spot: spot),
      if (nearest != null && spot != null) const SizedBox(height: Space.lg),
      if (pet != null) _VetCard(pet: pet, pets: pets, onPick: (id) => setState(() => _petId = id)) else EmptyState(title: l.noPetsTitle, compact: true),
      const SizedBox(height: Space.lg),
      PawPanel(
        onTap: () => context.push('/first-aid'),
        semanticLabel: l.firstAidTitle,
        child: Row(children: [
          const PawTile(icon: Ph.firstAidKit, tone: Tone.red),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.firstAidTitle, style: context.text.labelLarge),
              Text(l.firstAidOfflineHint, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            ]),
          ),
          const SizedBox(width: Space.md),
          const Chev(),
        ]),
      ),
    ];
    final wide = context.screenSize == ScreenSize.desktop;
    Widget col(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
    return Scaffold(
      body: SafeArea(
        child: PageBody(maxWidth: wide ? Space.maxContentWidth : Sizes.sheetMaxWidth, children: [
          const SizedBox(height: Space.sm),
          Row(children: [
            PawIconButton(icon: Ph.x, tooltip: l.close, onPressed: () => context.canPop() ? context.pop() : context.go('/home')),
            const SizedBox(width: Space.md),
            Expanded(child: Semantics(header: true, child: Text(l.sosTitle, style: context.text.headlineMedium, maxLines: 2, overflow: TextOverflow.ellipsis))),
          ]),
          const SizedBox(height: Space.lg),
          _LocationLine(spot: spot, locating: _locating, onChange: _changeArea, onRetry: _locate),
          if (clinics.savedAt != null) ...[
            const SizedBox(height: Space.sm),
            InfoNote(l.sosSavedClinics(Fmt.dateTime(clinics.savedAt!, context.lang)), icon: Ph.wifiSlash, tone: ChipTone.warning),
          ],
          const SizedBox(height: Space.lg),
          if (wide)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 7, child: col(left)),
              const SizedBox(width: Space.xl),
              Expanded(flex: 5, child: col(right)),
            ])
          else ...[
            ...left,
            const SizedBox(height: Sizes.sectionGap),
            ...right,
          ],
          const SizedBox(height: Space.xxl),
        ]),
      ),
    );
  }
}

/// Where the clinics are counted from, in one quiet line: the place, and a
/// link to change it. Tapping the icon tries the phone's location again.
class _LocationLine extends StatelessWidget {
  const _LocationLine({required this.spot, required this.locating, required this.onChange, required this.onRetry});
  final SosSpot? spot;
  final bool locating;
  final VoidCallback onChange;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final s = spot;
    final text = s == null
        ? l.sosLocating
        : locating && s.source != SosSource.gps
            ? (s.source == SosSource.chosen ? l.sosLocatingNear(s.label) : l.sosLocatingLastKnown)
            : switch (s.source) {
                SosSource.gps => l.sosUsingGps,
                SosSource.lastKnown => l.sosUsingLastKnown(Fmt.time(s.at ?? DateTime.now(), context.lang)),
                SosSource.chosen => l.sosUsingArea(s.label),
              };
    final gps = s?.source == SosSource.gps;
    return Row(children: [
      if (locating)
        const SizedBox(width: IconSizes.md, height: IconSizes.md, child: CircularProgressIndicator(strokeWidth: Strokes.spinner))
      else
        Tooltip(
          message: gps ? '' : l.sosTryLocation,
          child: InkResponse(
            onTap: gps ? null : onRetry,
            radius: IconSizes.lg,
            child: Icon(gps ? Ph.crosshair : Ph.gpsSlash, size: IconSizes.md, color: gps ? paw.success : paw.textSecondary),
          ),
        ),
      const SizedBox(width: Space.md),
      Expanded(child: Text(text, style: context.text.bodySmall?.copyWith(color: paw.textSecondary))),
      if (!locating) ...[const SizedBox(width: Space.md), TextLink(l.sosChangeArea, onTap: onChange)],
    ]);
  }
}

/// The pet's facts a vet asks for first, on the dark band: who the pet is,
/// allergies, medicines and the rabies vaccine, with the full medical card
/// one tap away. With more than one pet, pills choose which.
class _VetCard extends ConsumerWidget {
  const _VetCard({required this.pet, required this.pets, required this.onPick});
  final Pet pet;
  final List<Pet> pets;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final meds = ref.watch(medicinesProvider(pet.id)).value ?? const <Medicine>[];
    final rabies = (ref.watch(vaccinesProvider(pet.id)).value ?? const []).where((v) => v.key.startsWith('rabies')).toList();
    final who = [
      pet.breedName(context.lang).isEmpty ? speciesLabel(context, pet.species) : pet.breedName(context.lang),
      petAgeLabel(context, pet),
      if (pet.weightKg != null) Fmt.weight(pet.weightKg!, grams: pet.isBird),
    ].where((x) => x.isNotEmpty).join(', ');
    return Container(
      padding: const EdgeInsets.all(Space.lg + Space.xxs),
      decoration: BoxDecoration(color: paw.band, borderRadius: BorderRadius.circular(Radii.card)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Semantics(header: true, child: Text(l.sosShowVet, style: context.text.labelLarge?.copyWith(color: paw.onBand))),
        if (pets.length > 1) ...[
          const SizedBox(height: Space.md),
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final p in pets)
              Semantics(
                button: true,
                selected: p.id == pet.id,
                label: p.name,
                excludeSemantics: true,
                child: Material(
                  color: p.id == pet.id ? paw.marigold : paw.marigold.withValues(alpha: 0),
                  shape: StadiumBorder(side: BorderSide(color: p.id == pet.id ? paw.marigold : context.tint.bandLine)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onPick(p.id),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: Sizes.topControl),
                      child: Padding(
                        padding: const EdgeInsets.only(left: Space.xs + Space.xxs, right: Space.md + Space.xxs),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.pillArch * Sizes.archAspect, ring: false),
                          const SizedBox(width: Space.sm),
                          Text(p.name, style: context.text.labelLarge?.copyWith(color: p.id == pet.id ? paw.onMarigold : paw.onBand)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
        ],
        const SizedBox(height: Space.md),
        Text(who, style: context.text.bodySmall?.copyWith(color: paw.onBandMuted)),
        const SizedBox(height: Space.md),
        KvList(onDark: true, rows: [
          (l.allergies, pet.allergies.isEmpty ? l.noKnownAllergies : pet.allergies.join(', '), pet.allergies.isEmpty ? null : Tone.red),
          (l.medicines, meds.isEmpty ? l.none : meds.map((m) => m.name).join(', '), null),
          (l.rabiesVaccine, rabies.isEmpty ? l.notRecorded : l.givenOn(Fmt.date(rabies.first.givenDate, context.lang)), null),
        ]),
        const SizedBox(height: Space.md),
        Align(
          alignment: Alignment.centerLeft,
          child: PawButton(label: l.openMedicalCard, icon: Ph.identificationCard, kind: BtnKind.cream, onPressed: () => context.push('/pets/${pet.id}/card')),
        ),
      ]),
    );
  }
}

/// The nearest clinic's address with a map, and ways to take it elsewhere:
/// open in Maps, copy, share.
class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.r, required this.spot});
  final RankedClinic r;
  final SosSpot spot;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final c = r.clinic;
    final text = '${c.name}\n${c.fullAddress}\n${c.callNumber}';
    Future<void> copy() async {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) showToast(context, l.copied);
    }

    return PawCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, Space.md),
          child: Row(children: [
            Container(
              width: Sizes.quickCircle,
              height: Sizes.quickCircle,
              decoration: BoxDecoration(color: paw.textPrimary, shape: BoxShape.circle),
              child: Icon(Ph.navigationArrowFill, size: IconSizes.action - Space.xxs, color: paw.background),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Semantics(header: true, child: Text(l.sosGetAddress, style: context.text.titleLarge)),
                SelectableText('${c.name}, ${c.fullAddress}', style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              ]),
            ),
          ]),
        ),
        SizedBox(
          height: Sizes.skeletonCard,
          child: PawMap(
            center: LatLng(c.lat, c.lng),
            zoom: 13,
            interactive: false,
            fitPoints: [LatLng(c.lat, c.lng), LatLng(spot.lat, spot.lng)],
            markers: [
              pinMarker(LatLng(c.lat, c.lng), color: paw.marigold, icon: Ph.firstAid),
              dotMarker(LatLng(spot.lat, spot.lng), context.tint.sky),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.lg),
          child: Row(children: [
            Expanded(
              child: PawButton(label: l.openInMaps, icon: Ph.arrowSquareOut, kind: BtnKind.ink, size: BtnSize.regular, block: true, onPressed: () => openDirections(c.lat, c.lng, label: c.name)),
            ),
            const SizedBox(width: Space.sm),
            RoundButton(icon: Ph.copy, tooltip: l.copy, onPressed: copy),
            const SizedBox(width: Space.sm),
            RoundButton(
              icon: Ph.shareNetwork,
              tooltip: l.share,
              onPressed: () async {
                try {
                  await SharePlus.instance.share(ShareParams(text: text));
                } catch (_) {
                  await copy();
                }
              },
            ),
          ]),
        ),
      ]),
    );
  }
}
