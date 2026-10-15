import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/converters.dart';
import '../../../core/demo/seed/seed_places.dart' show Area, areas, cities;
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/breeds.dart';
import '../../pets/presentation/pet_labels.dart';
import '../data/lost_repository.dart';

/// The public page behind a pet's QR tag (spec 7.14). Anyone can open it,
/// signed in or not. The family's phone number is never shown: messages
/// and locations are relayed to them.
class PublicLostScreen extends ConsumerStatefulWidget {
  const PublicLostScreen({super.key, required this.token});
  final String token;

  @override
  ConsumerState<PublicLostScreen> createState() => _PublicLostScreenState();
}

class _PublicLostScreenState extends ConsumerState<PublicLostScreen> {
  LostPageView? _view;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    setState(() => _failed = false);
    try {
      final v = await ref.read(lostPageServiceProvider).open(widget.token);
      if (mounted) setState(() => _view = v);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _result(LostPageStatus s, String okMessage) {
    final l = context.l10n;
    switch (s) {
      case LostPageStatus.ok:
        showDemoAwareToast(context, ref, okMessage);
      case LostPageStatus.tooMany:
        showToast(context, l.finderTooMany);
      case LostPageStatus.notFound:
        showToast(context, l.lostTagInactive);
    }
  }

  Future<void> _contact(LostPageView v) async {
    final l = context.l10n;
    final form = await showPawSheet<({String message, String name, String phone})>(context, builder: (ctx) => _ContactForm(petName: v.name));
    if (form == null || !mounted) return;
    final s = await ref.read(lostPageServiceProvider).contact(widget.token, message: form.message, name: form.name, phone: form.phone);
    if (mounted) _result(s, l.finderSent(v.name));
  }

  Future<void> _shareLocation(LostPageView v) async {
    final l = context.l10n;
    double? lat, lng;
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
        final p = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(timeLimit: Duration(seconds: 8)));
        lat = p.latitude;
        lng = p.longitude;
      }
    } catch (_) {}
    if (!mounted) return;
    var area = '';
    var note = '';
    if (lat == null) {
      // Location is off: let the finder pick the area and add a landmark.
      final picked = await showPawSheet<({Area area, String note})>(context, builder: (ctx) => const _AreaForm());
      if (picked == null || !mounted) return;
      area = '${picked.area.name}, ${picked.area.city}';
      note = picked.note;
      lat = picked.area.lat;
      lng = picked.area.lng;
    }
    final s = await ref.read(lostPageServiceProvider).shareLocation(widget.token, lat: lat, lng: lng, area: area, note: note);
    if (mounted) _result(s, l.finderLocationSent(v.name));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = _view;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.gutter),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Align(alignment: AlignmentDirectional.centerStart, child: PawSetuLogo(size: 40, withName: true)),
                  const SizedBox(height: Space.lg),
                  if (_failed)
                    ErrorState(onRetry: _open)
                  else if (v == null)
                    const SkeletonList(count: 3)
                  else if (v.status != LostPageStatus.ok)
                    EmptyState(title: l.lostTagInactive, message: l.lostTagInactiveHint, scene: Scene.lost)
                  else ...[
                    if (ref.watch(appConfigProvider).isDemo) ...[DemoBanner(l.finderDemoNote), const SizedBox(height: Space.md)],
                    _PetHeader(view: v),
                    const SizedBox(height: Space.lg),
                    PrimaryButton(label: l.finderContact, icon: Icons.forum_rounded, onPressed: () => _contact(v)),
                    const SizedBox(height: Space.sm),
                    SecondaryButton(label: l.finderShareLocation, icon: Icons.my_location_rounded, onPressed: () => _shareLocation(v)),
                    const SizedBox(height: Space.lg),
                    InfoNote(l.finderPrivacy, icon: Icons.lock_rounded),
                    const SizedBox(height: Space.md),
                    InfoNote(l.finderTips, icon: Icons.tips_and_updates_rounded, tone: ChipTone.success),
                  ],
                  const SizedBox(height: Space.xl),
                  Center(child: TextButton(onPressed: () => context.go('/splash'), child: Text(l.vaultGetPawSetu))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A toast that adds "(Demo)" context when relays go to the Demo Outbox.
void showDemoAwareToast(BuildContext context, WidgetRef ref, String message) {
  final demo = ref.read(appConfigProvider).isDemo;
  showToast(context, demo ? '$message ${context.l10n.finderDemoSuffix}' : message);
}

class _PetHeader extends StatelessWidget {
  const _PetHeader({required this.view});
  final LostPageView view;

  String _breed(String lang) {
    final p = view.pet;
    final id = p['breedId'] as String?;
    if (id == mixedBreedId) return switch (lang) { 'hi' => 'मिश्रित / देसी', 'te' => 'మిశ్రమ / దేశీ', _ => 'Mixed / Indie' };
    return breedById[id]?.name(lang) ?? (p['breedOther'] as String?) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = view.pet;
    final lost = view.lost;
    final since = parseDate(lost?['since']);
    final facts = [speciesLabel(context, view.species), _breed(context.lang), if (p['gender'] != null) genderLabel(context, p['gender'] as String?)]
        .where((s) => s.isNotEmpty)
        .join(' · ');
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (lost != null)
        Container(
          padding: const EdgeInsets.all(Space.lg),
          decoration: BoxDecoration(color: context.paw.sos, borderRadius: BorderRadius.circular(Radii.card)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.finderLostHeadline(view.name), style: context.text.headlineSmall?.copyWith(color: context.paw.onSos, fontWeight: FontWeight.w900)),
            const SizedBox(height: Space.xs),
            Text(l.finderLastSeen((lost['area'] as String?) ?? '', since == null ? '' : Fmt.dateTime(since, context.lang)),
                style: context.text.bodyLarge?.copyWith(color: context.paw.onSos)),
            if (((lost['note'] as String?) ?? '').isNotEmpty) ...[
              const SizedBox(height: Space.xs),
              Text(lost['note'] as String, style: context.text.bodyMedium?.copyWith(color: context.paw.onSos)),
            ],
          ]),
        ),
      const SizedBox(height: Space.lg),
      Center(child: PetAvatar(species: view.species, colorTag: p['colorTag'] as String?, photoUrl: p['photoUrl'] as String?, size: 140)),
      const SizedBox(height: Space.md),
      Text(lost != null ? l.finderHelloLost(view.name) : l.finderHello(view.name), textAlign: TextAlign.center, style: context.text.headlineSmall),
      const SizedBox(height: Space.xs),
      Text(facts, textAlign: TextAlign.center, style: context.text.bodyMedium),
      if (((p['markings'] as String?) ?? '').isNotEmpty)
        Text(p['markings'] as String, textAlign: TextAlign.center, style: context.text.bodySmall),
      const SizedBox(height: Space.sm),
      Text(lost != null ? l.finderLostAsk : l.finderAsk, textAlign: TextAlign.center, style: context.text.bodyLarge),
    ]);
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm({required this.petName});
  final String petName;

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  late final _message = TextEditingController(text: context.l10n.finderMessageStart(widget.petName));
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Text(l.finderContact, style: context.text.titleLarge),
      const SizedBox(height: Space.xs),
      Text(l.finderContactHint, style: context.text.bodySmall),
      const SizedBox(height: Space.md),
      PawTextField(label: l.finderMessageLabel, controller: _message, maxLines: 4),
      const SizedBox(height: Space.sm),
      PawTextField(label: l.finderYourName, controller: _name),
      const SizedBox(height: Space.sm),
      PawTextField(label: l.finderYourPhone, controller: _phone, keyboardType: TextInputType.phone, helper: l.finderPhoneHelper),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.finderSend,
        icon: Icons.send_rounded,
        onPressed: () {
          if (_message.text.trim().isEmpty) return;
          Navigator.pop(context, (message: _message.text.trim(), name: _name.text.trim(), phone: _phone.text.trim()));
        },
      ),
    ]);
  }
}

class _AreaForm extends StatefulWidget {
  const _AreaForm();

  @override
  State<_AreaForm> createState() => _AreaFormState();
}

class _AreaFormState extends State<_AreaForm> {
  Area? _area;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Text(l.finderWhereSeen, style: context.text.titleLarge),
      const SizedBox(height: Space.xs),
      Text(l.finderLocationOff, style: context.text.bodySmall),
      const SizedBox(height: Space.md),
      DropdownButtonFormField<Area>(
        initialValue: _area,
        isExpanded: true,
        decoration: InputDecoration(labelText: l.chooseArea),
        items: [
          for (final c in cities)
            for (final a in areas.values.where((a) => a.city == c)) DropdownMenuItem(value: a, child: Text('${a.name}, ${a.city}')),
        ],
        onChanged: (a) => setState(() => _area = a),
      ),
      const SizedBox(height: Space.sm),
      PawTextField(label: l.finderLandmark, hint: l.finderLandmarkHint, controller: _note),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.finderSend,
        icon: Icons.send_rounded,
        onPressed: _area == null ? null : () => Navigator.pop(context, (area: _area!, note: _note.text.trim())),
      ),
    ]);
  }
}
