import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/data/converters.dart';
import '../../../core/demo/seed/seed_places.dart' show Area, areas, cities;
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/document_preview.dart';
import '../../../core/widgets/paw_map.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import '../data/lost_repository.dart';
import '../domain/lost_rules.dart';

/// Address of the pet's public page, as printed on the tag.
String petTagUrl(String token) {
  if (kIsWeb) {
    final b = Uri.base;
    return lostPageUrl(token, webBase: '${b.origin}${b.path}');
  }
  return lostPageUrl(token);
}

DateTime? _lostSince(Pet p) => parseDate(p.lost?['since']);

/// Me → Lost pet mode and QR tag: every pet, its tag and lost status.
class LostHomeScreen extends ConsumerWidget {
  const LostHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.lostPetMode)),
      body: PageBody(maxWidth: 760, children: [
        const SizedBox(height: Space.md),
        InfoNote(l.lostIntro, icon: Icons.qr_code_2_rounded),
        const SizedBox(height: Space.lg),
        if (pets.isEmpty)
          EmptyState(title: l.noPetsTitle, scene: Scene.lost, compact: true)
        else
          for (final p in pets)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.md),
              child: PawCard(
                onTap: () => context.push('/me/lost/${p.id}'),
                borderColor: p.lost != null ? context.paw.sos : null,
                child: Row(children: [
                  PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 52),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: context.text.titleMedium),
                      const SizedBox(height: Space.xs),
                      p.lost != null
                          ? StatusChip(l.lostSinceShort(Fmt.dateTime(_lostSince(p) ?? DateTime.now(), context.lang)), tone: ChipTone.error, icon: Icons.travel_explore_rounded)
                          : StatusChip(l.lostSafeAtHome, tone: ChipTone.success, icon: Icons.home_rounded),
                    ]),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ]),
              ),
            ),
      ]),
    );
  }
}

/// One pet: QR tag, mark as lost, sightings, poster and "Found".
class PetLostScreen extends ConsumerWidget {
  const PetLostScreen({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pet = ref.watch(petProvider(petId)).value;
    if (pet == null) return const Scaffold(body: SkeletonList());
    final reportId = pet.lost?['reportId'] as String?;
    final report = reportId == null ? null : ref.watch(lostReportProvider(reportId)).value;
    final lost = pet.lost != null;
    return Scaffold(
      appBar: AppBar(title: Text(l.lostPetTitle(pet.name))),
      body: PageBody(maxWidth: 720, children: [
        const SizedBox(height: Space.md),
        if (lost) ...[
          _LostBanner(pet: pet, report: report),
          const SizedBox(height: Space.md),
          if (report != null) _Sightings(report: report),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.lostMakePoster, icon: Icons.picture_as_pdf_rounded, onPressed: () => _openPoster(context, ref, pet)),
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.lostShareLink, icon: Icons.share_rounded, onPressed: () => _sharePage(context, ref, pet)),
          const SizedBox(height: Space.sm),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: context.paw.success, minimumSize: const Size.fromHeight(52)),
            onPressed: reportId == null ? null : () => _found(context, ref, pet, reportId),
            icon: const Icon(Icons.favorite_rounded),
            label: Text(l.lostMarkFound(pet.name)),
          ),
          const SizedBox(height: Space.xl),
        ] else ...[
          PawCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(l.lostIfMissing(pet.name), style: context.text.titleMedium),
              const SizedBox(height: Space.xs),
              Text(l.lostIfMissingBody, style: context.text.bodyMedium),
              const SizedBox(height: Space.md),
              PrimaryButton(label: l.lostMarkLost(pet.name), icon: Icons.campaign_rounded, danger: true, onPressed: () => showMarkLostSheet(context, ref, pet)),
            ]),
          ),
          const SizedBox(height: Space.lg),
        ],
        SectionHeader(l.qrTag),
        _QrCard(pet: pet),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}

class _LostBanner extends StatelessWidget {
  const _LostBanner({required this.pet, required this.report});
  final Pet pet;
  final LostReport? report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final since = report?.since ?? _lostSince(pet) ?? DateTime.now();
    final area = report?.area ?? (pet.lost?['area'] as String?) ?? '';
    final note = report?.note ?? (pet.lost?['note'] as String?) ?? '';
    return PawCard(
      color: context.paw.sos.withValues(alpha: 0.08),
      borderColor: context.paw.sos,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.travel_explore_rounded, color: context.paw.sos, size: 32),
          const SizedBox(width: Space.md),
          Expanded(child: Text(l.lostBannerTitle(pet.name), style: context.text.titleLarge?.copyWith(color: context.paw.sos))),
        ]),
        const SizedBox(height: Space.sm),
        Text(l.lostBannerBody(Fmt.dateTime(since, context.lang), area), style: context.text.bodyLarge),
        if (note.isNotEmpty) ...[const SizedBox(height: Space.xs), Text(note, style: context.text.bodyMedium)],
        if (report != null && report!.alert) ...[
          const SizedBox(height: Space.sm),
          Text(l.lostAlertsSent(report!.alertsSent), style: context.text.bodySmall),
        ],
      ]),
    );
  }
}

class _Sightings extends StatelessWidget {
  const _Sightings({required this.report});
  final LostReport report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = report.sightings;
    final pts = [for (final x in s) if (x.lat != null && x.lng != null) LatLng(x.lat!, x.lng!)];
    final home = report.lat == null ? null : LatLng(report.lat!, report.lng!);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(l.lostSightings),
      if (s.isEmpty)
        InfoNote(l.lostNoSightings, icon: Icons.visibility_rounded)
      else ...[
        if (pts.isNotEmpty || home != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.card),
            child: SizedBox(
              height: 200,
              child: PawMap(
                center: pts.isNotEmpty ? pts.first : home!,
                zoom: 14,
                fitPoints: [...pts, ?home],
                markers: [
                  if (home != null) pinMarker(home, color: context.paw.sos, icon: Icons.home_rounded),
                  for (final p in pts) pinMarker(p, color: context.colors.primary, icon: Icons.visibility_rounded),
                ],
              ),
            ),
          ),
        const SizedBox(height: Space.sm),
        PawCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(children: [
            for (final x in s)
              ListTile(
                leading: const Icon(Icons.visibility_rounded),
                title: Text([if (x.area.isNotEmpty) x.area, if (x.note.isNotEmpty) x.note].join(' · ').ifEmpty(l.lostSightingNoDetails)),
                subtitle: Text([Fmt.dateTime(x.at, context.lang), if (x.name.isNotEmpty) x.name].join(' · ')),
                trailing: x.lat == null
                    ? null
                    : IconButton(tooltip: l.directions, icon: const Icon(Icons.directions_rounded), onPressed: () => openDirections(x.lat!, x.lng!)),
              ),
          ]),
        ),
      ],
    ]);
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}

class _QrCard extends ConsumerStatefulWidget {
  const _QrCard({required this.pet});
  final Pet pet;

  @override
  ConsumerState<_QrCard> createState() => _QrCardState();
}

class _QrCardState extends ConsumerState<_QrCard> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final t = await ref.read(lostRepositoryProvider).ensureQrToken(widget.pet);
    if (mounted) setState(() => _token = t);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final token = _token;
    if (token == null) return const Skeleton(height: 220);
    final url = petTagUrl(token);
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Radii.card)),
            child: QrImageView(data: url, size: 180, backgroundColor: Colors.white, semanticsLabel: l.qrForPet(widget.pet.name)),
          ),
        ),
        const SizedBox(height: Space.md),
        Text(l.qrTagHint(widget.pet.name), style: context.text.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: Space.sm),
        SelectableText(url, textAlign: TextAlign.center, style: context.text.bodySmall),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.qrPrintTags, icon: Icons.print_rounded, onPressed: () => _openTags(context, widget.pet, url)),
        const SizedBox(height: Space.sm),
        Row(children: [
          Expanded(
            child: SecondaryButton(
              label: l.copyLink,
              icon: Icons.copy_rounded,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (context.mounted) showToast(context, l.copied);
              },
            ),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: SecondaryButton(label: l.qrOpenPage, icon: Icons.open_in_new_rounded, onPressed: () => context.push('/lost/$token')),
          ),
        ]),
      ]),
    );
  }
}

Future<void> _sharePage(BuildContext context, WidgetRef ref, Pet pet) async {
  final l = context.l10n;
  final token = await ref.read(lostRepositoryProvider).ensureQrToken(pet);
  final area = (pet.lost?['area'] as String?) ?? '';
  final text = l.lostShareText(pet.name, area, petTagUrl(token));
  try {
    await SharePlus.instance.share(ShareParams(text: text));
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) showToast(context, l.copied);
  }
}

Future<void> _found(BuildContext context, WidgetRef ref, Pet pet, String reportId) async {
  final l = context.l10n;
  final ok = await confirmAction(context, title: l.lostFoundConfirmTitle(pet.name), body: l.lostFoundConfirmBody, confirmLabel: l.lostFoundConfirm, danger: false);
  if (!ok || !context.mounted) return;
  final user = ref.read(currentUserProvider);
  if (user == null) return;
  await ref.read(lostRepositoryProvider).markFound(pet: pet, by: user, reportId: reportId);
  if (context.mounted) showToast(context, l.lostWelcomeHome(pet.name));
}

/// "Mark as lost": where and when the pet was last seen, a note, and the
/// opt-in alert to people within 5 km.
Future<void> showMarkLostSheet(BuildContext context, WidgetRef ref, Pet pet) async {
  final user = ref.read(currentUserProvider);
  if (user == null) return;
  final home = areas.values.firstWhere((a) => a.city == user.city, orElse: () => areas['banjara']!);
  final result = await showPawSheet<_LostForm>(context, builder: (ctx) => _MarkLostForm(pet: pet, start: home));
  if (result == null || !context.mounted) return;
  final sent = await ref.read(lostRepositoryProvider).markLost(
        pet: pet,
        by: user,
        since: result.since,
        area: result.area,
        lat: result.lat,
        lng: result.lng,
        note: result.note,
        alert: result.alert,
      );
  if (!context.mounted) return;
  final l = context.l10n;
  if (result.alert && ref.read(appConfigProvider).isDemo) {
    await showDemoDialog(context, title: l.demoTitle, body: l.lostDemoAlert(sent, result.area));
  } else {
    showToast(context, l.lostMarked(pet.name));
  }
}

class _LostForm {
  const _LostForm(this.since, this.area, this.lat, this.lng, this.note, this.alert);
  final DateTime since;
  final String area;
  final double lat;
  final double lng;
  final String note;
  final bool alert;
}

class _MarkLostForm extends StatefulWidget {
  const _MarkLostForm({required this.pet, required this.start});
  final Pet pet;
  final Area start;

  @override
  State<_MarkLostForm> createState() => _MarkLostFormState();
}

class _MarkLostFormState extends State<_MarkLostForm> {
  late Area _area = widget.start;
  ({double lat, double lng})? _gps;
  bool _locating = false;
  int _when = 0; // 0 just now, 1 an hour ago, 2 this morning, 3 yesterday
  bool _alert = true;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  DateTime _since() {
    final now = DateTime.now();
    return switch (_when) {
      1 => now.subtract(const Duration(hours: 1)),
      2 => DateTime(now.year, now.month, now.day, 8),
      3 => DateTime(now.year, now.month, now.day - 1, 18),
      _ => now,
    };
  }

  Future<void> _useGps() async {
    setState(() => _locating = true);
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
        final p = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(timeLimit: Duration(seconds: 8)));
        _gps = (lat: p.latitude, lng: p.longitude);
      }
    } catch (_) {
      if (mounted) showToast(context, context.l10n.locationFallback);
    }
    if (mounted) setState(() => _locating = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final whenLabels = [l.lostWhenNow, l.lostWhenHour, l.lostWhenMorning, l.lostWhenYesterday];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Text(l.lostMarkLost(widget.pet.name), style: context.text.titleLarge),
      const SizedBox(height: Space.md),
      Text(l.lostWhereSeen, style: context.text.labelLarge),
      const SizedBox(height: Space.xs),
      if (_gps != null)
        StatusChip(l.lostUsingGps, tone: ChipTone.success, icon: Icons.my_location_rounded)
      else
        DropdownButtonFormField<Area>(
          initialValue: _area,
          isExpanded: true,
          decoration: InputDecoration(labelText: l.chooseArea),
          items: [
            for (final c in cities)
              for (final a in areas.values.where((a) => a.city == c)) DropdownMenuItem(value: a, child: Text('${a.name}, ${a.city}')),
          ],
          onChanged: (a) => setState(() => _area = a ?? _area),
        ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: _locating ? null : (_gps == null ? _useGps : () => setState(() => _gps = null)),
          icon: _locating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location_rounded),
          label: Text(_gps == null ? l.useMyLocation : l.chooseArea),
        ),
      ),
      const SizedBox(height: Space.sm),
      Text(l.lostWhenSeen, style: context.text.labelLarge),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
        for (var i = 0; i < whenLabels.length; i++) ChoiceChip(label: Text(whenLabels[i]), selected: _when == i, onSelected: (_) => setState(() => _when = i)),
      ]),
      const SizedBox(height: Space.md),
      PawTextField(label: l.lostNoteLabel, hint: l.lostNoteHint, controller: _note, maxLines: 2),
      const SizedBox(height: Space.sm),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: _alert,
        onChanged: (v) => setState(() => _alert = v),
        title: Text(l.lostAlertNearby),
        subtitle: Text(l.lostAlertNearbyHint),
      ),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.lostMarkLostConfirm,
        icon: Icons.campaign_rounded,
        danger: true,
        onPressed: () => Navigator.pop(
          context,
          _LostForm(
            _since(),
            _gps == null ? _area.name : l.lostNearMe,
            _gps?.lat ?? _area.lat,
            _gps?.lng ?? _area.lng,
            _note.text.trim(),
            _alert,
          ),
        ),
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Printable PDFs: QR tags and the lost poster.
// ---------------------------------------------------------------------------

void _openTags(BuildContext context, Pet pet, String url) {
  final l = context.l10n;
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => DocumentPreviewScreen(
      title: l.qrTagsTitle(pet.name),
      fileName: 'PawSetu-QR-tag-${pet.name}.pdf',
      pages: (ctx) => [_TagsPage(pet: pet, url: url)],
    ),
  ));
}

class _TagsPage extends StatelessWidget {
  const _TagsPage({required this.pet, required this.url});
  final Pet pet;
  final String url;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget tag() => Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF0F766E), width: 1.5), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            QrImageView(data: url, size: 92, backgroundColor: Colors.white, padding: EdgeInsets.zero),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(pet.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1C2B2D))),
                const SizedBox(height: 2),
                Text(l.qrTagScanLine, style: const TextStyle(fontSize: 10, color: Color(0xFF1C2B2D))),
                const SizedBox(height: 4),
                const Text('PawSetu', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF0F766E))),
              ]),
            ),
          ]),
        );
    return A4Page(
      title: l.qrTagsTitle(pet.name),
      subtitle: l.qrTagsSubtitle,
      footer: l.qrTagsFooter,
      children: [
        const SizedBox(height: 8),
        for (var r = 0; r < 4; r++) Row(children: [Expanded(child: tag()), Expanded(child: tag())]),
      ],
    );
  }
}

void _openPoster(BuildContext context, WidgetRef ref, Pet pet) async {
  final l = context.l10n;
  final token = await ref.read(lostRepositoryProvider).ensureQrToken(pet);
  if (!context.mounted) return;
  final url = petTagUrl(token);
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => DocumentPreviewScreen(
      title: l.posterTitle(pet.name),
      fileName: 'PawSetu-lost-${pet.name}.pdf',
      pages: (ctx) => [_PosterPage(pet: pet, url: url, lang: ctx.lang)],
    ),
  ));
}

class _PosterPage extends StatelessWidget {
  const _PosterPage({required this.pet, required this.url, required this.lang});
  final Pet pet;
  final String url;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const ink = Color(0xFF1C2B2D);
    const red = Color(0xFFC62828);
    final since = _lostSince(pet);
    final area = (pet.lost?['area'] as String?) ?? '';
    final note = (pet.lost?['note'] as String?) ?? '';
    final facts = [
      speciesLabel(context, pet.species),
      if (pet.breedName(lang).isNotEmpty) pet.breedName(lang),
      if (petAgeLabel(context, pet).isNotEmpty) petAgeLabel(context, pet),
      if (pet.gender != null) genderLabel(context, pet.gender),
    ].join(' · ');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(l.posterHeadline(speciesLabel(context, pet.species)).toUpperCase(),
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 2)),
        ),
        const SizedBox(height: 18),
        Center(child: PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 200)),
        const SizedBox(height: 14),
        Text(pet.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: ink)),
        Text(facts, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: ink)),
        if ((pet.markings ?? '').isNotEmpty) Text(pet.markings!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: ink)),
        const SizedBox(height: 14),
        Text(l.posterLastSeen(area, since == null ? '' : Fmt.dateTime(since, lang)),
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: ink)),
        if (note.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Text(note, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: ink))),
        const Spacer(),
        Row(children: [
          QrImageView(data: url, size: 130, backgroundColor: Colors.white, padding: EdgeInsets.zero),
          const SizedBox(width: 18),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(l.posterScan, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
              const SizedBox(height: 4),
              Text(l.posterScanBody, style: const TextStyle(fontSize: 12, color: ink)),
              const SizedBox(height: 6),
              Text(url, style: const TextStyle(fontSize: 9, color: Color(0xFF5B6B6E))),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        const Text('PawSetu', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F766E))),
      ]),
    );
  }
}
