import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../assistant/data/assistant_repository.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../data/consultation.dart';
import '../data/televet_repository.dart';
import '../domain/televet_rules.dart';
import '../../../core/theme/ph.dart';

/// Tele-vet limits for the signed-in user (from config/app).
final myTeleVetLimitsProvider = Provider<TeleVetLimits>((ref) {
  final u = ref.watch(currentUserProvider);
  return TeleVetLimits.fromPlan(ref.watch(planLimitsProvider), plus: u?.isPlus ?? false);
});

/// Whether the user already agreed to the tele-vet consent.
final teleVetConsentProvider = StreamProvider<bool>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(false);
  return ref
      .watch(firestoreProvider)
      .collection('users')
      .doc(u.uid)
      .snapshots()
      .map((d) => ((d.data()?['consents'] as Map?)?['televet']) != null);
});

/// '/televet': start a consultation, see the plan allowance, continue an
/// open chat, past consultations and prescriptions, and Ask PawSetu.
class TeleVetHomeScreen extends ConsumerWidget {
  const TeleVetHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Scaffold(body: SkeletonList());
    if (user.role != UserRole.owner) {
      return Scaffold(
        appBar: AppBar(title: Text(l.teleVet)),
        body: EmptyState(
          title: l.tvPartnerHere,
          scene: Scene.chat,
          actionLabel: l.pTeleVetQueue,
          onAction: () => context.go('/partner/televet'),
        ),
      );
    }
    final mine = ref.watch(myConsultationsProvider);
    final limits = ref.watch(myTeleVetLimitsProvider);
    final now = DateTime.now();
    final all = mine.value ?? const <Consultation>[];
    final used = consultationsThisMonth(all.map((c) => c.createdAt), now);
    final block = canStartConsultation(usedThisMonth: used, limits: limits, video: false);
    final open = all.where((c) => !c.isEnded).toList();
    final past = all.where((c) => c.isEnded).toList();
    final ai = ref.watch(assistantAllowanceProvider);

    final vets = ref.watch(teleVetsProvider).value ?? const <Map<String, dynamic>>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(l.teleVet),
        actions: [Padding(padding: const EdgeInsets.only(right: Space.md), child: SosButton(onActivate: () => openSos(context, ref)))],
      ),
      body: AsyncView<List<Consultation>>(
        value: mine,
        data: (_) => PageBody(maxWidth: Space.readingWidth, children: [
          const SizedBox(height: Space.sm),
          // UI Design 6: a dark kaapi hero with the main action in marigold.
          Builder(builder: (context) {
            final paw = context.paw;
            void start() {
              if (block == StartBlock.monthlyLimit) {
                showPlusPrompt(context, title: l.tvMonthlyUsedTitle, body: l.tvMonthlyUsed(Fmt.date(nextMonthStart(now), context.lang)));
                return;
              }
              context.push('/televet/new');
            }

            // Up to three vets' initials, overlapping, and how many are on.
            String ini(Map<String, dynamic> v) => initials(((v['name'] as String?) ?? '').replaceFirst(RegExp(r'^Dr\.?\s*'), ''));
            return Container(
              padding: const EdgeInsets.all(Space.lg + Space.xxs),
              decoration: BoxDecoration(color: paw.band, borderRadius: BorderRadius.circular(Radii.xxl)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Semantics(header: true, child: Text(l.tvHomeTitle, style: context.text.headlineMedium?.copyWith(color: paw.onBand))),
                      const SizedBox(height: Space.sm),
                      Text(l.tvHomeBody, style: context.text.bodyMedium?.copyWith(color: paw.onBandMuted)),
                    ]),
                  ),
                  const SizedBox(width: Space.md),
                  const PawTile(icon: Ph.videoCameraFill, tone: Tone.marigold, size: Sizes.tileLg),
                ]),
                if (vets.isNotEmpty) ...[
                  const SizedBox(height: Space.lg),
                  Row(children: [
                    SizedBox(
                      width: Space.xxl + Space.xs + (vets.take(3).length - 1) * Space.xl,
                      height: Space.xxl + Space.xs,
                      child: Stack(children: [
                        for (final (i, v) in vets.take(3).indexed)
                          Positioned(
                            left: i * Space.xl,
                            child: Container(
                              width: Space.xxl + Space.xs,
                              height: Space.xxl + Space.xs,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: i.isOdd ? context.tint.paper3 : paw.marigold, shape: BoxShape.circle, border: Border.all(color: paw.band, width: Strokes.focus)),
                              child: Text(ini(v), style: context.text.labelSmall?.copyWith(color: paw.onMarigold, fontFamily: FontFamilies.heading, fontWeight: FontWeight.w700)),
                            ),
                          ),
                      ]),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(child: Text(l.bookVetsOnline(vets.length), style: context.text.bodySmall?.copyWith(color: paw.onBandMuted))),
                  ]),
                ],
                const SizedBox(height: Space.lg),
                Row(children: [
                  Expanded(child: PawButton(label: l.tvChatNow, icon: Ph.chatCircleDots, size: BtnSize.regular, block: true, onPressed: start)),
                  const SizedBox(width: Space.md),
                  Expanded(
                    child: PawButton(
                      label: l.tvBookVideo,
                      icon: Ph.calendarPlus,
                      kind: BtnKind.ghostDark,
                      size: BtnSize.regular,
                      block: true,
                      onPressed: () => limits.video ? start() : showPlusPrompt(context, title: l.tvPlusPromptTitle, body: l.plusPerkVideo),
                    ),
                  ),
                ]),
              ]),
            );
          }),
          const SizedBox(height: Space.lg + Space.xs),
          _AllowanceCard(limits: limits, used: used, plus: user.isPlus),
          if (open.isNotEmpty) ...[
            const SizedBox(height: Space.xl),
            SecHead(l.tvOpenConsults),
            for (final (i, c) in open.indexed) Padding(padding: EdgeInsets.only(top: i == 0 ? 0 : Space.md), child: ConsultCard(consultation: c)),
          ],
          const SizedBox(height: Space.lg),
          PawPanel(
            onTap: () => context.push('/ask'),
            semanticLabel: l.aiTitle,
            child: Row(children: [
              const PawTile(icon: Ph.sparkle, tone: Tone.ink),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.aiTitle, style: context.text.labelLarge),
                  Text(ai.unlimited ? l.aiTileHintPlus : l.aiTileHint(ai.left), style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
                ]),
              ),
              const SizedBox(width: Space.md),
              const Chev(),
            ]),
          ),
          if (past.isNotEmpty) ...[
            const SizedBox(height: Space.xl),
            SecHead(l.tvPastConsults),
            for (final (i, c) in past.take(10).indexed) Padding(padding: EdgeInsets.only(top: i == 0 ? 0 : Space.md), child: ConsultCard(consultation: c)),
          ],
          const SizedBox(height: Space.lg + Space.xs),
          InkWell(
            borderRadius: BorderRadius.circular(Radii.lg),
            onTap: () => openSos(context, ref),
            child: InfoNote(l.tvEmergencyNote, icon: Ph.asterisk, tone: ChipTone.error),
          ),
        ]),
      ),
    );
  }
}

class _AllowanceCard extends StatelessWidget {
  const _AllowanceCard({required this.limits, required this.used, required this.plus});
  final TeleVetLimits limits;
  final int used;
  final bool plus;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reached = !limits.unlimitedPerMonth && used >= limits.perMonth;
    // UI Design 6: the plan's name with its tag, then the allowances as four
    // small panels: an icon, the number in bold, and what it means.
    final paw = context.paw;
    Widget tile(IconData icon, String title, String sub) => PawPanel(
          padding: const EdgeInsets.all(Space.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: IconSizes.md + Space.xxs, color: paw.accent),
            const SizedBox(height: Space.sm),
            Text(title, style: context.text.labelLarge),
            Text(sub, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          ]),
        );
    final cols = MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 1 : (context.screenSize == ScreenSize.desktop ? 4 : 2);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: Semantics(header: true, child: Text(plus ? l.tvPlanPlus : l.tvPlanFree, style: context.text.titleLarge))),
        const SizedBox(width: Space.md),
        plus ? PawTag(l.planPlus, kind: TagKind.plus, icon: Ph.crownSimpleFill) : PawTag(l.tvFreeChip),
      ]),
      const SizedBox(height: Space.md),
      TileGrid(columns: cols, children: [
        limits.unlimitedPerMonth ? tile(Ph.infinity, l.tvUnlimitedWord, l.tvConsultationsWord) : tile(Ph.repeat, l.tvPerMonthTitle(limits.perMonth), l.tvUsedSub(used)),
        tile(Ph.chatText, l.tvMessagesTitle(limits.messages), l.tvWordsSub(limits.words)),
        tile(Ph.clock, l.tvHoursTitle(limits.hours), l.tvHoursSub),
        tile(limits.video ? Ph.videoCamera : Ph.videoCameraSlash, l.tvVideoTitle, limits.video ? l.tvVideoSubPlus : l.tvVideoSubFree),
      ]),
      if (reached) ...[
        const SizedBox(height: Space.md),
        InfoNote(l.tvMonthlyUsed(Fmt.date(nextMonthStart(DateTime.now()), context.lang)), tone: ChipTone.warning, icon: Ph.hourglassLow),
      ],
      if (!plus) ...[
        const SizedBox(height: Space.md),
        Align(
          alignment: Alignment.centerLeft,
          child: PawButton(label: l.seePlus, icon: Ph.crownSimple, kind: BtnKind.soft, onPressed: () => showPlusPrompt(context, title: l.tvPlusPromptTitle, body: l.plusPerkVideo)),
        ),
      ],
    ]);
  }
}

/// A consultation in a list (owner side).
class ConsultCard extends StatelessWidget {
  const ConsultCard({super.key, required this.consultation, this.partnerView = false});
  final Consultation consultation;
  final bool partnerView;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = consultation;
    final (String status, ChipTone tone) = switch (c.status) {
      'queued' => (l.tvStatusQueuedShort, ChipTone.warning),
      'active' => (l.tvStatusActiveShort, ChipTone.success),
      _ => (l.tvStatusEndedShort, ChipTone.neutral),
    };
    final who = partnerView ? c.ownerName : (c.vetName.isEmpty ? l.tvFindingVetShort : c.vetName);
    final paw = context.paw;
    void open() => context.push(partnerView ? '/partner/consult/${c.id}' : '/messages/${c.conversationId}');
    // UI Design 6: the pet's arch, who is talking to whom with the state as
    // a tag, when and how, the problem in two lines, then what to do next.
    return PawCard(
      onTap: open,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PetAvatar(species: c.petSpecies, colorTag: c.pet.colorTag, photoUrl: c.pet.photoUrl, size: Sizes.tile * Sizes.archAspect, ring: false),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.sm, runSpacing: Space.xxs, children: [
              Text(partnerView ? '${c.petName} · $who' : l.tvPetWithVet(c.petName, who), style: context.text.labelLarge),
              StatusChip(status, tone: tone),
            ]),
            Text(
              [Fmt.dateTime(c.createdAt, context.lang), c.isVideo ? l.tvModeVideo : l.tvModeChat].join('. '),
              style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
            ),
            if (c.problem.isNotEmpty) ...[
              const SizedBox(height: Space.xs),
              Text(c.problem, style: context.text.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: Space.md),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.md, runSpacing: Space.sm, children: [
              if (!c.isEnded) ...[
                PawButton(label: l.tvOpenChat, icon: Ph.chatCircleDots, kind: BtnKind.ink, onPressed: open),
                if (!partnerView) Text(l.tvMessagesLeft(c.messagesLeft), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              ] else ...[
                if (c.prescriptionId != null)
                  PawButton(label: l.tvPrescriptionWord, icon: Ph.fileText, kind: BtnKind.soft, onPressed: () => context.push('/prescriptions/${c.prescriptionId}')),
                PawButton(label: l.tvOpenChat, icon: Ph.chatCircleDots, kind: BtnKind.soft, onPressed: open),
              ],
            ]),
          ]),
        ),
      ]),
    );
  }
}

/// '/televet/consent': shown once before the first consultation (spec 7.7).
class TeleVetConsentScreen extends ConsumerStatefulWidget {
  const TeleVetConsentScreen({super.key});
  @override
  ConsumerState<TeleVetConsentScreen> createState() => _TeleVetConsentScreenState();
}

class _TeleVetConsentScreenState extends ConsumerState<TeleVetConsentScreen> {
  bool _agree = false;
  bool _busy = false;

  Future<void> _accept() async {
    final u = ref.read(currentUserProvider);
    if (u == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(firestoreProvider).collection('users').doc(u.uid).update({'consents.televet': DateTime.now()});
      if (mounted) context.pop(true);
    } catch (e) {
      debugPrint('Consent save failed: $e');
      if (mounted) {
        setState(() => _busy = false);
        showToast(context, context.l10n.errorBody);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final points = [
      (Ph.firstAidKit, l.tvConsent1),
      (Ph.identificationCard, l.tvConsent2),
      (Ph.firstAid, l.tvConsent3),
      (Ph.asterisk, l.tvConsent4),
      (Ph.receipt, l.tvConsent5),
      (Ph.shield, l.tvConsent6),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.tvConsentTitle)),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageBody(maxWidth: Space.formWidth, children: [
              const SizedBox(height: Space.sm),
              Text(l.tvConsentIntro, style: context.text.bodyLarge),
              const SizedBox(height: Space.md),
              for (final p in points)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.md),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(p.$1, color: context.colors.primary),
                    const SizedBox(width: Space.md),
                    Expanded(child: Text(p.$2, style: context.text.bodyMedium)),
                  ]),
                ),
              const SizedBox(height: Space.sm),
              CheckboxListTile(
                value: _agree,
                onChanged: (v) => setState(() => _agree = v ?? false),
                title: Text(l.tvConsentAgree),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(context.gutter),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Space.formWidth),
              child: PrimaryButton(label: l.tvConsentContinue, loading: _busy, onPressed: _agree ? _accept : null),
            ),
          ),
        ]),
      ),
    );
  }
}
