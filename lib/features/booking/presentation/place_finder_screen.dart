import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show Marker;
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
import '../../routine/domain/routine.dart';
import '../data/booking_repository.dart';
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'booking_labels.dart';
import 'booking_slots.dart';
import '../../../core/theme/ph.dart';

/// Where the user is searching from: GPS, or a chosen city and area.
class SearchOrigin {
  const SearchOrigin(this.lat, this.lng, this.label, {this.fromGps = false});
  final double lat;
  final double lng;
  final String label;
  final bool fromGps;
}

final searchOriginProvider = NotifierProvider<_OriginNotifier, SearchOrigin>(_OriginNotifier.new);

class _OriginNotifier extends Notifier<SearchOrigin> {
  @override
  SearchOrigin build() {
    final city = ref.watch(currentUserProvider)?.city;
    final a = areas.values.firstWhere((a) => a.city == city, orElse: () => areas['banjara']!);
    return SearchOrigin(a.lat, a.lng, '${a.name}, ${a.city}');
  }

  void set(SearchOrigin o) => state = o;
}

/// Asks for location with a one-line reason first; falls back to a chosen
/// city and area (spec 7.5).
Future<bool> useMyLocation(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  try {
    if (!await Geolocator.isLocationServiceEnabled()) throw 'off';
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      if (!context.mounted) return false;
      final go = await confirmAction(context, title: l.locationWhyTitle, body: l.locationWhyClinics, confirmLabel: l.continueLabel, danger: false);
      if (!go) return false;
      perm = await Geolocator.requestPermission();
    }
    if (perm != LocationPermission.always && perm != LocationPermission.whileInUse) throw 'denied';
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 10)),
    );
    ref.read(searchOriginProvider.notifier).set(SearchOrigin(pos.latitude, pos.longitude, l.nearYou, fromGps: true));
    return true;
  } catch (_) {
    if (context.mounted) showToast(context, l.locationFallback);
    return false;
  }
}

Future<void> pickArea(BuildContext context, WidgetRef ref) async {
  final chosen = await showPawSheet<Area>(
    context,
    builder: (ctx) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(ctx.l10n.chooseArea, style: ctx.text.titleMedium),
          const SizedBox(height: Space.md),
          for (final city in cities) ...[
            Padding(
              padding: const EdgeInsets.only(top: Space.sm),
              child: Text(city, style: ctx.text.titleSmall),
            ),
            Wrap(
              spacing: Space.sm,
              children: [for (final a in areas.values.where((a) => a.city == city)) ActionChip(label: Text(a.name), onPressed: () => Navigator.pop(ctx, a))],
            ),
          ],
        ],
      );
    },
  );
  if (chosen != null) ref.read(searchOriginProvider.notifier).set(SearchOrigin(chosen.lat, chosen.lng, '${chosen.name}, ${chosen.city}'));
}

class Filters {
  Filters({
    this.distanceKm = 25,
    this.openNow = false,
    this.emergency = false,
    this.rating4 = false,
    this.species,
    this.service,
    this.maxFee,
    this.teleVet = false,
    this.language,
    this.sort = 'nearest',
  });
  double distanceKm;
  bool openNow;
  bool emergency;
  bool rating4;
  String? species;
  String? service;
  int? maxFee;
  bool teleVet;
  String? language;
  String sort;

  int get count =>
      [distanceKm != 25, openNow, emergency, rating4, species != null, service != null, maxFee != null, teleVet, language != null].where((x) => x).length;
}

class PlaceFinderScreen extends ConsumerStatefulWidget {
  const PlaceFinderScreen({super.key, required this.kind, this.startOnMap = false});
  final String kind;
  final bool startOnMap;
  @override
  ConsumerState<PlaceFinderScreen> createState() => _PlaceFinderScreenState();
}

class _PlaceFinderScreenState extends ConsumerState<PlaceFinderScreen> {
  late bool _map = widget.startOnMap;
  final Filters _f = Filters();
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _isClinic => widget.kind == 'clinic';

  List<(Place, double)> _apply(List<Place> all, SearchOrigin o) {
    final now = DateTime.now();
    final q = _search.text.trim().toLowerCase();
    var list = [for (final p in all) (p, distanceKm(o.lat, o.lng, p.lat, p.lng))].where((e) {
      final p = e.$1;
      if (e.$2 > _f.distanceKm) return false;
      if (q.isNotEmpty && !p.name.toLowerCase().contains(q) && !p.area.toLowerCase().contains(q)) return false;
      if (_f.openNow && !isOpenNow(p.hours, now)) return false;
      if (_f.emergency && !p.is24x7) return false;
      if (_f.rating4 && p.rating < 4) return false;
      if (_f.species != null && !p.species.contains(_f.species)) return false;
      if (_f.service != null && p.service(_f.service!) == null) return false;
      if (_f.maxFee != null && p.fee > _f.maxFee!) return false;
      if (_f.teleVet && !p.teleVet) return false;
      if (_f.language != null && !p.languages.contains(_f.language)) return false;
      return true;
    }).toList();
    int earliestSlotMinutes(Place p) {
      for (var d = 0; d < 7; d++) {
        final day = DateTime(now.year, now.month, now.day + d);
        final s = generateSlots(
          hours: p.hours,
          day: day,
          slotMinutes: p.slotMinutes,
          bufferMinutes: p.bufferMinutes,
          capacity: p.capacity,
          holidays: p.holidays,
          now: now,
        );
        final free = s.where((x) => x.available).firstOrNull;
        if (free != null) return free.start.difference(now).inMinutes;
      }
      return 99999;
    }

    switch (_f.sort) {
      case 'rating':
        list.sort((a, b) => b.$1.rating.compareTo(a.$1.rating));
      case 'fee':
        list.sort((a, b) => a.$1.fee.compareTo(b.$1.fee));
      case 'slot':
        list.sort((a, b) => earliestSlotMinutes(a.$1).compareTo(earliestSlotMinutes(b.$1)));
      default:
        list.sort((a, b) => a.$2.compareTo(b.$2));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final origin = ref.watch(searchOriginProvider);
    final data = _isClinic ? ref.watch(clinicsProvider) : ref.watch(providersOfTypeProvider(widget.kind));
    return Scaffold(
      appBar: AppBar(
        title: Text(_isClinic ? l.findAVet : kindLabel(context, widget.kind)),
        actions: [
          IconButton(
            tooltip: _map ? l.listView : l.mapView,
            icon: Icon(_map ? Ph.listBullets : Ph.mapTrifold),
            onPressed: () => setState(() => _map = !_map),
          ),
        ],
      ),
      body: AsyncView(
        value: data,
        data: (all) {
          final list = _apply(all, origin);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, Space.sm),
                child: Column(
                  children: [
                    TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: searchPillDecoration(context, hint: l.searchByNameOrArea),
                    ),
                    const SizedBox(height: Space.md),
                    // Where: the area, or the phone's own location.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(children: [
                        PawChip(label: origin.label, icon: origin.fromGps ? Ph.crosshair : Ph.mapPin, onTap: () => pickArea(context, ref)),
                        const SizedBox(width: Space.sm),
                        PawChip(label: l.useMyLocation, icon: Ph.crosshair, onTap: () => useMyLocation(context, ref)),
                      ]),
                    ),
                    const SizedBox(height: Space.sm),
                    // Which: filters, the order, and the two quick switches.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(children: [
                        PawChip(label: _f.count > 0 ? '${l.filters} (${_f.count})' : l.filters, icon: Ph.slidersHorizontal, onTap: _openFilters),
                        const SizedBox(width: Space.sm),
                        PopupMenuButton<String>(
                          tooltip: l.sortBy,
                          initialValue: _f.sort,
                          onSelected: (v) => setState(() => _f.sort = v),
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 'nearest', child: Text(l.sortNearest)),
                            PopupMenuItem(value: 'rating', child: Text(l.sortRating)),
                            PopupMenuItem(value: 'slot', child: Text(l.sortSlot)),
                            PopupMenuItem(value: 'fee', child: Text(l.sortFee)),
                          ],
                          child: IgnorePointer(
                            child: PawChip(
                              label: switch (_f.sort) { 'rating' => l.sortRating, 'slot' => l.sortSlot, 'fee' => l.sortFee, _ => l.sortNearest },
                              icon: Ph.sortAscending,
                            ),
                          ),
                        ),
                        if (_isClinic) ...[
                          const SizedBox(width: Space.sm),
                          PawChip(label: l.openNow, selected: _f.openNow, onTap: () => setState(() => _f.openNow = !_f.openNow)),
                          const SizedBox(width: Space.sm),
                          PawChip(label: l.open24x7, selected: _f.emergency, onTap: () => setState(() => _f.emergency = !_f.emergency)),
                        ],
                      ]),
                    ),
                    const SizedBox(height: Space.lg),
                    Row(children: [
                      Expanded(
                        child: Text(
                          _isClinic ? l.clinicsWithin(list.length, _f.distanceKm.toInt()) : l.placesWithin(list.length, _f.distanceKm.toInt()),
                          style: context.text.labelLarge,
                        ),
                      ),
                      const SizedBox(width: Space.md),
                      SegIcons(
                        items: [(Ph.list, l.listView), (Ph.mapTrifold, l.mapView)],
                        index: _map ? 1 : 0,
                        onChanged: (i) => setState(() => _map = i == 1),
                      ),
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? EmptyState(
                        scene: Scene.search,
                        title: l.noResultsTitle,
                        message: l.noResultsBody,
                        actionLabel: l.clearFilters,
                        onAction: () => setState(() {
                          _f
                            ..distanceKm = 25
                            ..openNow = false
                            ..emergency = false
                            ..rating4 = false
                            ..species = null
                            ..service = null
                            ..maxFee = null
                            ..teleVet = false
                            ..language = null;
                          _search.clear();
                        }),
                      )
                    : _map
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, context.gutter),
                        // Desktop (UI Design 2 vet map): the list beside the map.
                        child: Builder(builder: (context) {
                          final map = ClipRRect(
                            borderRadius: BorderRadius.circular(Radii.card),
                            child: PawMap(
                          center: LatLng(origin.lat, origin.lng),
                          zoom: 12,
                          markers: [
                            dotMarker(LatLng(origin.lat, origin.lng), context.paw.accent),
                            for (final e in list)
                              Marker(
                                point: LatLng(e.$1.lat, e.$1.lng),
                                width: Sizes.mapPin,
                                height: Sizes.mapPin,
                                child: GestureDetector(
                                  onTap: () => _preview(e.$1, e.$2),
                                  child: Semantics(
                                    button: true,
                                    label: e.$1.name,
                                    child: Icon(
                                      Ph.mapPinFill,
                                      size: Sizes.mapPin,
                                      color: e.$1.is24x7 ? context.paw.sos : context.paw.brand,
                                      shadows: [Shadow(blurRadius: Space.xs, color: context.paw.ink.withValues(alpha: Opacities.border))],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                          );
                          if (context.screenSize != ScreenSize.desktop) return map;
                          return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            Expanded(child: map),
                            const SizedBox(width: Space.lg),
                            SizedBox(
                              width: Sizes.listPane,
                              child: ListView(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: Space.sm),
                                  child: Text(l.resultsCount(list.length), style: context.text.titleSmall),
                                ),
                                for (final e in list)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: Space.sm),
                                    child: PlaceCard(place: e.$1, km: e.$2, compact: true),
                                  ),
                              ]),
                            ),
                          ]);
                        }),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, context.gutter),
                        children: [
                          // A drawn map on phones invites a tap to the real one.
                          if (context.isPhone)
                            Padding(
                              padding: const EdgeInsets.only(bottom: Space.md),
                              child: Semantics(
                                button: true,
                                label: l.mapView,
                                excludeSemantics: true,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(Radii.lg),
                                  onTap: () => setState(() => _map = true),
                                  child: ClipRRect(borderRadius: BorderRadius.circular(Radii.lg), child: const MapSketch(height: Sizes.mapSketch + Space.sm)),
                                ),
                              ),
                            ),
                          // One column on phones, 2 or 3 on wider screens.
                          ResponsiveGrid(
                            minItemWidth: Sizes.placeCardMinWidth,
                            spacing: Space.lg,
                            children: [for (final (i, e) in list.indexed) PlaceCard(place: e.$1, km: e.$2, primary: i == 0)],
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _preview(Place p, double km) {
    showPawSheet<void>(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(bottom: Space.md),
        child: PlaceCard(place: p, km: km, compact: true),
      ),
    );
  }

  Future<void> _openFilters() async {
    final l = context.l10n;
    await showPawSheet<void>(
      context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, set) {
            void upd(VoidCallback f) {
              set(f);
              setState(() {});
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.filters, style: ctx.text.titleMedium),
                const SizedBox(height: Space.md),
                Text(l.distance, style: ctx.text.titleSmall),
                Wrap(
                  spacing: Space.sm,
                  children: [
                    for (final d in const [1.0, 3.0, 5.0, 10.0, 25.0])
                      ChoiceChip(label: Text('${d.toInt()} km'), selected: _f.distanceKm == d, onSelected: (_) => upd(() => _f.distanceKm = d)),
                  ],
                ),
                SwitchListTile(contentPadding: EdgeInsets.zero, value: _f.openNow, onChanged: (v) => upd(() => _f.openNow = v), title: Text(l.openNow)),
                if (_isClinic)
                  SwitchListTile(contentPadding: EdgeInsets.zero, value: _f.emergency, onChanged: (v) => upd(() => _f.emergency = v), title: Text(l.open24x7)),
                SwitchListTile(contentPadding: EdgeInsets.zero, value: _f.rating4, onChanged: (v) => upd(() => _f.rating4 = v), title: Text(l.rating4plus)),
                if (_isClinic)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _f.teleVet,
                    onChanged: (v) => upd(() => _f.teleVet = v),
                    title: Text(l.teleVetAvailable),
                  ),
                Text(l.speciesTreated, style: ctx.text.titleSmall),
                Wrap(
                  spacing: Space.sm,
                  children: [
                    for (final s in const ['dog', 'cat', 'bird', 'rabbit'])
                      FilterChip(
                        label: Text(switch (s) {
                          'cat' => l.speciesCat,
                          'bird' => l.speciesBird,
                          'rabbit' => l.speciesRabbit,
                          _ => l.speciesDog,
                        }),
                        selected: _f.species == s,
                        onSelected: (v) => upd(() => _f.species = v ? s : null),
                      ),
                  ],
                ),
                if (_isClinic) ...[
                  const SizedBox(height: Space.sm),
                  Text(l.services, style: ctx.text.titleSmall),
                  Wrap(
                    spacing: Space.sm,
                    children: [
                      for (final s in const ['vaccination', 'surgery', 'dental', 'lab_tests', 'xray_ultrasound', 'grooming', 'boarding', 'home_visit'])
                        FilterChip(label: Text(serviceLabel(ctx, s)), selected: _f.service == s, onSelected: (v) => upd(() => _f.service = v ? s : null)),
                    ],
                  ),
                  const SizedBox(height: Space.sm),
                  Text(l.consultationFee, style: ctx.text.titleSmall),
                  Wrap(
                    spacing: Space.sm,
                    children: [
                      for (final f in const [400, 600, 900])
                        ChoiceChip(label: Text(l.upTo(Fmt.inr(f))), selected: _f.maxFee == f, onSelected: (v) => upd(() => _f.maxFee = v ? f : null)),
                    ],
                  ),
                ],
                const SizedBox(height: Space.sm),
                Text(l.languagesSpoken, style: ctx.text.titleSmall),
                Wrap(
                  spacing: Space.sm,
                  children: [
                    for (final c in const ['en', 'hi', 'te'])
                      FilterChip(label: Text(languageShort(c)), selected: _f.language == c, onSelected: (v) => upd(() => _f.language = v ? c : null)),
                  ],
                ),
                const SizedBox(height: Space.lg),
                PrimaryButton(label: l.showResults, onPressed: () => Navigator.pop(ctx)),
              ],
            );
          },
        );
      },
    );
  }
}

/// A clinic or provider in a list (UI Design 2): the picture on top with "open"
/// and distance badges, then the name and rating, the next free slot, the
/// price and a Book button. [compact] is the smaller side-by-side card used
/// in the map preview.
class PlaceCard extends ConsumerWidget {
  const PlaceCard({super.key, required this.place, this.km, this.compact = false, this.primary = false});
  final Place place;
  final double? km;
  final bool compact;

  /// The first result: its Book button is the marigold one.
  final bool primary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = place;
    final paw = context.paw;
    final open = isOpenNow(p.hours, DateTime.now());
    final fee = p.kind == 'clinic' || p.services.isEmpty ? p.fee : p.services.map((s) => s.price).reduce((a, b) => a < b ? a : b);
    final seed = p.artSeed;
    // Rating as plain text with a marigold star (one chip per row at most).
    final rating = p.reviewCount > 0
        ? Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Ph.starFill, size: IconSizes.sm, color: paw.accent),
            const SizedBox(width: Space.xxs),
            Text(p.rating.toStringAsFixed(1), style: context.text.labelLarge),
            Text(' (${p.reviewCount})', style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          ])
        : null;
    void openPlace() => context.push('/book/place/${p.id}');
    if (compact) {
      return PawCard(
        padding: EdgeInsets.zero,
        onTap: openPlace,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: Sizes.placePhotoWidth, height: Sizes.placePhotoHeight, child: SeedArt(seed: seed)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: Space.xxs),
                Text([p.area, if (km != null) Fmt.km(km!)].join(' · '), style: context.text.bodySmall),
                const SizedBox(height: Space.xs),
                Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  ?rating,
                  // One chip: 24x7 says more than "Open now". Never red.
                  p.is24x7
                      ? StatusChip(l.open24x7, tone: ChipTone.success, icon: Ph.clockFill)
                      : StatusChip(open ? l.openNowChip : l.closedChip, tone: open ? ChipTone.success : ChipTone.neutral),
                ]),
              ]),
            ),
          ),
        ]),
      );
    }
    final next = nextFreeSlot(p, ref.watch(providerBookingsProvider(p.id)).value ?? const [], DateTime.now());
    // UI Design 6: the place's photo as a rounded tile beside its name,
    // area, status and rating; under a dashed rule, the next free slot, the
    // fee and a small Book button.
    final status = p.is24x7
        ? StatusChip(l.open24x7, tone: ChipTone.success, icon: Ph.clockFill)
        : StatusChip(open ? l.openNowChip : l.closedChip, tone: open ? ChipTone.success : ChipTone.neutral, icon: open ? Ph.circleFill : null);
    Widget fact(String label, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          Text(value, style: context.text.labelLarge),
        ]);
    return PawCard(
      onTap: openPlace,
      padding: const EdgeInsets.all(Space.md + Space.xxs),
      semanticLabel: [p.name, p.area, if (km != null) l.sosAway(Fmt.km(km!)), if (p.reviewCount > 0) '${p.rating.toStringAsFixed(1)} ★'].join(', '),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            child: SizedBox(width: Sizes.thumbXl, height: Sizes.thumbXl, child: SeedArt(seed: seed)),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text([p.area, if (km != null) Fmt.km(km!)].join(', '), style: context.text.bodySmall?.copyWith(color: paw.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: Space.xs),
              Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [status, ?rating]),
            ]),
          ),
        ]),
        const SizedBox(height: Space.md),
        const DashedRule(),
        const SizedBox(height: Space.md),
        Row(children: [
          if (next != null) Expanded(flex: 5, child: fact(l.nextFreeSlot, slotLabel(context, next))),
          if (next != null) const SizedBox(width: Space.md),
          Expanded(flex: 4, child: fact(p.kind == 'clinic' ? l.feeWord : l.feeFrom('').trim(), Fmt.inr(fee))),
          const SizedBox(width: Space.md),
          // One marigold button on the page (the first result); the rest
          // are outlined.
          PawButton(label: l.bookWord, kind: primary ? BtnKind.primary : BtnKind.line, onPressed: openPlace),
        ]),
      ]),
    );
  }
}
