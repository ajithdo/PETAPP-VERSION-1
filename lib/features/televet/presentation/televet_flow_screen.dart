import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../assistant/domain/assistant_engine.dart';
import '../../assistant/presentation/assistant_labels.dart';
import '../../booking/presentation/booking_labels.dart';
import '../../health/data/health_repository.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../pets/presentation/pet_labels.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../data/televet_repository.dart';
import '../domain/televet_rules.dart';
import 'televet_home_screen.dart';

/// Tele-vet start (spec 7.7) in three short steps: pet → problem (+ photos)
/// → "Chat now", "Video now" (Plus) or a chosen vet and time.
class TeleVetFlowScreen extends ConsumerStatefulWidget {
  const TeleVetFlowScreen({super.key, this.petId});
  final String? petId;
  @override
  ConsumerState<TeleVetFlowScreen> createState() => _TeleVetFlowScreenState();
}

class _TeleVetFlowScreenState extends ConsumerState<TeleVetFlowScreen> {
  int _step = 0;
  String? _petId;
  final _problem = TextEditingController();
  final _photos = <String>[];

  /// chat_now, video_now or choose
  String _how = 'chat_now';
  String _chooseMode = 'chat';
  String? _vetId;
  DateTime? _time;
  bool _busy = false;
  bool _ignoreRedFlag = false;

  @override
  void initState() {
    super.initState();
    _petId = widget.petId;
  }

  @override
  void dispose() {
    _problem.dispose();
    super.dispose();
  }

  bool get _video => _how == 'video_now' || (_how == 'choose' && _chooseMode == 'video');

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final pets = ref.watch(activePetsProvider).where((p) => p.canCare(user.uid)).toList();
    _petId ??= pets.where((p) => p.id == ref.read(selectedPetProvider)?.id).firstOrNull?.id ?? pets.firstOrNull?.id;
    final pet = pets.where((p) => p.id == _petId).firstOrNull;
    final titles = [l.tvStepPet, l.tvStepProblem, l.tvStepHow];
    final canNext = switch (_step) {
      0 => pet != null,
      1 => countWords(_problem.text) >= 2,
      _ => _how != 'choose' || _vetId != null,
    };
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (did, _) {
        if (!did) setState(() => _step--);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.tvStart)),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Semantics(
                      label: l.stepOf(_step + 1, 3),
                      child: LinearProgressIndicator(value: (_step + 1) / 3, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(height: Space.sm),
                    Text('${l.stepOf(_step + 1, 3)} · ${titles[_step]}', style: context.text.titleMedium),
                  ]),
                ),
              ),
            ),
            Expanded(
              child: pets.isEmpty
                  ? EmptyState(title: l.tvNoPet, actionLabel: l.addPet, onAction: () => context.push('/pets/new'))
                  : PageBody(maxWidth: 720, children: [
                      const SizedBox(height: Space.md),
                      if (_step == 0) ..._petStep(context, pets),
                      if (_step == 1 && pet != null) ..._problemStep(context, pet),
                      if (_step == 2 && pet != null) ..._howStep(context, user, pet),
                    ]),
            ),
            if (pets.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(context.gutter),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Row(children: [
                    if (_step > 0) ...[
                      Expanded(child: SecondaryButton(label: l.back, onPressed: () => setState(() => _step--))),
                      const SizedBox(width: Space.md),
                    ],
                    Expanded(
                      flex: 2,
                      child: _step < 2
                          ? PrimaryButton(label: l.next, onPressed: canNext ? () => setState(() => _step++) : null)
                          : _confirmButton(context, user, pet!, canNext),
                    ),
                  ]),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _petStep(BuildContext context, List<Pet> pets) {
    final l = context.l10n;
    return [
      Text(l.tvWhichPet, style: context.text.bodyLarge),
      const SizedBox(height: Space.md),
      for (final p in pets)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            onTap: () => setState(() => _petId = p.id),
            borderColor: p.id == _petId ? context.colors.primary : null,
            semanticLabel: p.name,
            padding: const EdgeInsets.all(Space.md),
            child: Row(children: [
              PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 48),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: context.text.titleSmall),
                  Text([speciesLabel(context, p.species), p.breedName(context.lang), petAgeLabel(context, p)].where((s) => s.isNotEmpty).join(' · '),
                      style: context.text.bodySmall),
                ]),
              ),
              Icon(p.id == _petId ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: context.colors.primary),
            ]),
          ),
        ),
    ];
  }

  List<Widget> _problemStep(BuildContext context, Pet pet) {
    final l = context.l10n;
    final flag = detectRedFlag(_problem.text);
    return [
      Text(l.tvDescribe(pet.name), style: context.text.bodyLarge),
      const SizedBox(height: Space.md),
      TextField(
        controller: _problem,
        minLines: 4,
        maxLines: 8,
        onChanged: (_) => setState(() {}),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: l.tvDescribeHint, alignLabelWithHint: true),
      ),
      if (flag != null && !_ignoreRedFlag) ...[
        const SizedBox(height: Space.md),
        PawCard(
          borderColor: context.paw.sos,
          color: context.paw.sos.withValues(alpha: 0.07),
          padding: const EdgeInsets.all(Space.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Icon(Icons.emergency_rounded, color: context.paw.sos),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(l.aiRedFlagTitle, style: context.text.titleSmall)),
            ]),
            const SizedBox(height: Space.xs),
            Text(l.aiRedFlagBody(redFlagLabel(context, flag)), style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary)),
            const SizedBox(height: Space.sm),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: context.paw.sos, foregroundColor: context.paw.onSos),
              onPressed: () => openSos(context, ref),
              icon: const Icon(Icons.emergency_rounded),
              label: Text(l.sosGetHelp),
            ),
            TextButton(onPressed: () => setState(() => _ignoreRedFlag = true), child: Text(l.tvContinueToVet)),
          ]),
        ),
      ],
      const SizedBox(height: Space.md),
      Text(l.tvAddPhotos, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (final p in _photos)
          Stack(children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: MediaImage(url: p, width: 84, height: 84)),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton.filledTonal(
                tooltip: l.remove,
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => _photos.remove(p)),
                icon: const Icon(Icons.close_rounded, size: 16),
              ),
            ),
          ]),
        if (_photos.length < 4)
          SizedBox(
            width: 84,
            height: 84,
            child: OutlinedButton(
              onPressed: _addPhoto,
              style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
              child: Semantics(label: l.addPhoto, child: const Icon(Icons.add_a_photo_rounded)),
            ),
          ),
      ]),
      const SizedBox(height: Space.md),
      InfoNote(l.tvPhotosHint),
    ];
  }

  Future<void> _addPhoto() async {
    final user = ref.read(currentUserProvider)!;
    final source = await showPawSheet<ImageSource>(context, builder: (ctx) {
      final l = ctx.l10n;
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ListTile(leading: const Icon(Icons.photo_library_rounded), title: Text(l.chooseFromGallery), onTap: () => Navigator.pop(ctx, ImageSource.gallery)),
        ListTile(leading: const Icon(Icons.photo_camera_rounded), title: Text(l.takePhoto), onTap: () => Navigator.pop(ctx, ImageSource.camera)),
      ]);
    });
    if (source == null || !mounted) return;
    final pick = await pickImage(context, source);
    if (pick == null) return;
    final url = await ref.read(storageServiceProvider).upload(pick.bytes, path: 'users/${user.uid}/televet/${DateTime.now().millisecondsSinceEpoch}_${pick.name}', contentType: 'image/jpeg');
    if (mounted) setState(() => _photos.add(url));
  }

  List<Widget> _howStep(BuildContext context, AppUser user, Pet pet) {
    final l = context.l10n;
    final vets = ref.watch(teleVetsProvider);
    final limits = ref.watch(myTeleVetLimitsProvider);
    final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
    final discount = ((cfg['commission'] as Map?)?['videoDiscountPercent'] as num?) ?? 10;
    final list = vets.value ?? const <Map<String, dynamic>>[];
    final nextVet = list.firstOrNull;
    final chosen = list.where((v) => v['id'] == _vetId).firstOrNull;
    final feeVet = _how == 'choose' ? chosen : nextVet;
    final price = priceTeleVet(
      video: _video,
      videoFee: (feeVet?['videoFee'] as num?)?.toInt() ?? 399,
      plus: user.isPlus,
      discountPercent: discount,
      commissionPercent: 0,
    );

    Widget option(String key, IconData icon, String title, String sub, {bool locked = false}) => Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            onTap: () {
              if (locked) {
                showPlusPrompt(context, title: l.tvVideoPlusTitle, body: l.plusPerkVideo);
                return;
              }
              setState(() => _how = key);
            },
            borderColor: _how == key ? context.colors.primary : null,
            semanticLabel: title,
            padding: const EdgeInsets.all(Space.md),
            child: Row(children: [
              CircleAvatar(backgroundColor: context.paw.primaryContainer, child: Icon(icon, color: context.colors.primary)),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: context.text.titleSmall),
                  Text(sub, style: context.text.bodySmall),
                ]),
              ),
              if (locked)
                StatusChip(l.planPlus, tone: ChipTone.accent, icon: Icons.lock_rounded)
              else
                Icon(_how == key ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: context.colors.primary),
            ]),
          ),
        );

    final now = DateTime.now();
    final firstSlot = DateTime(now.year, now.month, now.day, now.hour, now.minute < 30 ? 30 : 60).add(const Duration(minutes: 30));
    final slots = [for (var i = 0; i < 8; i++) firstSlot.add(Duration(minutes: 30 * i))];

    return [
      option('chat_now', Icons.chat_rounded, l.tvChatNow, l.tvChatNowHint),
      option('video_now', Icons.videocam_rounded, l.tvVideoNow, user.isPlus ? l.tvVideoNowHint : l.tvVideoPlusOnly, locked: !limits.video),
      option('choose', Icons.person_search_rounded, l.tvChooseVet, l.tvChooseVetHint),
      if (_how == 'choose') ...[
        const SizedBox(height: Space.sm),
        if (limits.video)
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'chat', icon: const Icon(Icons.chat_rounded), label: Text(l.tvModeChat)),
              ButtonSegment(value: 'video', icon: const Icon(Icons.videocam_rounded), label: Text(l.tvModeVideo)),
            ],
            selected: {_chooseMode},
            onSelectionChanged: (s) => setState(() => _chooseMode = s.first),
          ),
        const SizedBox(height: Space.md),
        AsyncView<List<Map<String, dynamic>>>(
          value: vets,
          loading: const Skeleton(height: 120, radius: Radii.card),
          data: (vs) => Column(children: [
            for (final v in vs.take(8))
              Padding(
                padding: const EdgeInsets.only(bottom: Space.sm),
                child: PawCard(
                  onTap: () => setState(() => _vetId = v['id'] as String),
                  borderColor: _vetId == v['id'] ? context.colors.primary : null,
                  semanticLabel: v['name'] as String?,
                  padding: const EdgeInsets.all(Space.md),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: context.paw.accent.withValues(alpha: 0.25),
                      child: Text(((v['name'] as String?) ?? 'V').replaceAll('Dr. ', '').characters.first, style: context.text.titleMedium),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(v['name'] as String? ?? '', style: context.text.titleSmall),
                        Text(
                          [v['qualification'], v['clinicName'], v['city']].whereType<String>().join(' · '),
                          style: context.text.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          [
                            '★ ${((v['rating'] as num?) ?? 4.5).toStringAsFixed(1)}',
                            ((v['languages'] as List?) ?? const []).map((c) => languageShort(c as String)).join(', '),
                            if (limits.video) l.tvVideoFee(Fmt.inr((v['videoFee'] as num?) ?? 399)),
                          ].join(' · '),
                          style: context.text.labelSmall,
                        ),
                      ]),
                    ),
                    Icon(_vetId == v['id'] ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: context.colors.primary),
                  ]),
                ),
              ),
          ]),
        ),
        const SizedBox(height: Space.sm),
        Text(l.tvWhen, style: context.text.titleSmall),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          ChoiceChip(label: Text(l.tvNow), selected: _time == null, onSelected: (_) => setState(() => _time = null)),
          for (final s in slots)
            ChoiceChip(
              label: Text(Fmt.sameDay(s, now) ? Fmt.time(s, context.lang) : '${l.tvTomorrow} ${Fmt.time(s, context.lang)}'),
              selected: _time == s,
              onSelected: (_) => setState(() => _time = s),
            ),
        ]),
      ],
      const SizedBox(height: Space.md),
      PawCard(
        color: context.colors.surfaceContainerLow,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.tvSummary, style: context.text.titleSmall),
          const SizedBox(height: Space.sm),
          _row(context, l.tvSummaryPet, pet.name),
          _row(context, l.tvSummaryType, _video ? l.tvModeVideo : l.tvModeChat),
          _row(context, l.tvSummaryVet, _how == 'choose' ? (chosen?['name'] as String? ?? '–') : l.tvNextAvailable),
          if (_how == 'choose') _row(context, l.tvWhen, _time == null ? l.tvNow : Fmt.dateTime(_time!, context.lang)),
          const Divider(height: Space.lg),
          if (price.total == 0)
            _row(context, l.tvFee, l.tvIncluded, bold: true)
          else ...[
            _row(context, l.tvVideoFeeLabel, Fmt.inr(price.fee)),
            if (price.discount > 0) _row(context, l.tvPlusDiscount(discount.toInt()), '− ${Fmt.inr(price.discount)}'),
            _row(context, l.totalToPay, Fmt.inr(price.total), bold: true),
          ],
        ]),
      ),
      const SizedBox(height: Space.sm),
      Text(l.tvChatRules(limits.messages, limits.words, limits.hours), style: context.text.bodySmall),
      if (ref.watch(appConfigProvider).isDemo && price.total > 0) ...[const SizedBox(height: Space.sm), DemoBanner(l.demoPaymentNote)],
    ];
  }

  Widget _row(BuildContext context, String k, String v, {bool bold = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Expanded(child: Text(k, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary))),
          Flexible(child: Text(v, textAlign: TextAlign.end, style: bold ? context.text.titleSmall : context.text.bodyMedium)),
        ]),
      );

  Widget _confirmButton(BuildContext context, AppUser user, Pet pet, bool canNext) {
    final l = context.l10n;
    final vets = ref.watch(teleVetsProvider).value ?? const <Map<String, dynamic>>[];
    final feeVet = _how == 'choose' ? vets.where((v) => v['id'] == _vetId).firstOrNull : vets.firstOrNull;
    final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
    final discount = ((cfg['commission'] as Map?)?['videoDiscountPercent'] as num?) ?? 10;
    final price = priceTeleVet(video: _video, videoFee: (feeVet?['videoFee'] as num?)?.toInt() ?? 399, plus: user.isPlus, discountPercent: discount, commissionPercent: 0);
    final label = price.total > 0 ? l.tvPayAndStart(Fmt.inr(price.total)) : (_video ? l.tvStartVideo : l.tvStartChat);
    return PrimaryButton(label: label, loading: _busy, onPressed: canNext ? () => _confirm(user, pet, price, feeVet) : null);
  }

  Future<void> _confirm(AppUser user, Pet pet, TeleVetPrice price, Map<String, dynamic>? feeVet) async {
    final l = context.l10n;
    // 1. Consent before the first consultation.
    final consented = ref.read(teleVetConsentProvider).value ?? false;
    if (!consented) {
      final ok = await context.push<bool>('/televet/consent');
      if (ok != true || !mounted) return;
    }
    setState(() => _busy = true);
    try {
      // 2. Pay the video fee (demo sheet: no money moves).
      if (price.total > 0) {
        final outcome = await ref.read(paymentServiceProvider).pay(context, amount: price.total, description: l.tvPayDescription(pet.name));
        if (!mounted) return;
        if (outcome != PaymentOutcome.success) {
          if (outcome == PaymentOutcome.failure) showToast(context, l.paymentFailed);
          return;
        }
      }
      // 3. Start (limits are checked again by the backend).
      final meds = ref.read(medicinesProvider(pet.id)).value ?? const <Medicine>[];
      final id = await ref.read(teleVetBackendProvider).start(StartConsultRequest(
            owner: user,
            pet: pet,
            problem: _problem.text.trim(),
            photos: List.of(_photos),
            mode: _video ? 'video' : 'chat',
            vetId: _how == 'choose' ? _vetId : (_how == 'video_now' ? (feeVet?['id'] as String?) : null),
            scheduledAt: _how == 'choose' ? _time : null,
            redFlag: detectRedFlag(_problem.text),
            medicines: [for (final m in meds) {'name': m.name, 'dose': m.dose, 'unit': m.unit, 'frequency': m.frequency}],
          ));
      if (!mounted) return;
      final router = GoRouter.of(context);
      final callNow = _video && (_how == 'video_now' || _time == null);
      router.replace('/messages/tv_$id');
      if (callNow) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        router.push('/televet/call/$id');
      }
    } on TeleVetStartException catch (e) {
      if (!mounted) return;
      if (e.block == StartBlock.monthlyLimit) {
        await showPlusPrompt(context, title: l.tvMonthlyUsedTitle, body: l.tvMonthlyUsed(Fmt.date(nextMonthStart(DateTime.now()), context.lang)));
      } else {
        await showPlusPrompt(context, title: l.tvVideoPlusTitle, body: l.plusPerkVideo);
      }
    } catch (e) {
      debugPrint('Start consultation failed: $e');
      if (mounted) showToast(context, l.errorBody);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
