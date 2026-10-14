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
import '../data/places_repository.dart';
import '../domain/booking_rules.dart';
import 'booking_labels.dart';

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
            icon: Icon(_map ? Icons.view_list_rounded : Icons.map_rounded),
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
                      decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: l.searchByNameOrArea),
                    ),
                    const SizedBox(height: Space.sm),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ActionChip(
                            avatar: Icon(origin.fromGps ? Icons.my_location_rounded : Icons.place_rounded, size: 18),
                            label: Text(origin.label),
                            onPressed: () => pickArea(context, ref),
                          ),
                          const SizedBox(width: Space.sm),
                          ActionChip(
                            avatar: const Icon(Icons.gps_fixed_rounded, size: 18),
                            label: Text(l.useMyLocation),
                            onPressed: () => useMyLocation(context, ref),
                          ),
                          const SizedBox(width: Space.sm),
                          ActionChip(
                            avatar: Badge.count(count: _f.count, isLabelVisible: _f.count > 0, child: const Icon(Icons.tune_rounded, size: 18)),
                            label: Text(l.filters),
                            onPressed: _openFilters,
                          ),
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
                            child: Chip(avatar: const Icon(Icons.sort_rounded, size: 18), label: Text(l.sortBy)),
                          ),
                          if (_isClinic) ...[
                            const SizedBox(width: Space.sm),
                            FilterChip(label: Text(l.open24x7), selected: _f.emergency, onSelected: (v) => setState(() => _f.emergency = v)),
                            const SizedBox(width: Space.sm),
                            FilterChip(label: Text(l.openNow), selected: _f.openNow, onSelected: (v) => setState(() => _f.openNow = v)),
                          ],
                        ],
                      ),
                    ),
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
                        child: PawMap(
                          center: LatLng(origin.lat, origin.lng),
                          zoom: 12,
                          markers: [
                            dotMarker(LatLng(origin.lat, origin.lng), context.paw.accent),
                            for (final e in list)
                              Marker(
                                point: LatLng(e.$1.lat, e.$1.lng),
                                width: 44,
                                height: 44,
                                child: GestureDetector(
                                  onTap: () => _preview(e.$1, e.$2),
                                  child: Semantics(
                                    button: true,
                                    label: e.$1.name,
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 44,
                                      color: e.$1.is24x7 ? context.paw.sos : context.colors.primary,
                                      shadows: const [Shadow(blurRadius: 4, color: Colors.black26)],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(context.gutter, 0, context.gutter, context.gutter),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: Space.sm),
                            child: Text(l.resultsCount(list.length), style: context.text.bodySmall),
                          ),
                          for (final e in list)
                            Padding(
                              padding: const EdgeInsets.only(bottom: Space.md),
                              child: PlaceCard(place: e.$1, km: e.$2),
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
        child: PlaceCard(place: p, km: km),
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

class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place, this.km});
  final Place place;
  final double? km;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = place;
    final open = isOpenNow(p.hours, DateTime.now());
    return PawCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push('/book/place/${p.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 92, height: 112, child: SeedArt(seed: 'seed:${p.kind == 'clinic' ? 'clinic' : 'provider'}:${p.photoSeed}')),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text([p.area, if (km != null) Fmt.km(km!)].join(' · '), style: context.text.bodySmall),
                  const SizedBox(height: Space.xs),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (p.reviewCount > 0) StatusChip('★ ${p.rating.toStringAsFixed(1)} (${p.reviewCount})', tone: ChipTone.accent),
                      StatusChip(open ? l.openNowChip : l.closedChip, tone: open ? ChipTone.success : ChipTone.neutral),
                      if (p.is24x7) StatusChip(l.open24x7, tone: ChipTone.error, icon: Icons.emergency_rounded),
                      if (p.kind == 'clinic') StatusChip(l.feeFrom(Fmt.inr(p.fee)), tone: ChipTone.info),
                      if (p.kind != 'clinic' && p.services.isNotEmpty)
                        StatusChip(l.feeFrom(Fmt.inr(p.services.map((s) => s.price).reduce((a, b) => a < b ? a : b))), tone: ChipTone.info),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
