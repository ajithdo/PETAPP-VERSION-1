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

    return Scaffold(
      appBar: AppBar(title: Text(l.teleVet)),
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
                  Container(
                    width: Sizes.thumb,
                    height: Sizes.thumb,
                    decoration: BoxDecoration(color: paw.marigold, borderRadius: BorderRadius.circular(Radii.lg)),
                    child: Icon(Icons.video_call_rounded, color: paw.onMarigold, size: IconSizes.xl),
                  ),
                ]),
                const SizedBox(height: Space.lg),
                FilledButton.icon(
                  onPressed: start,
                  style: FilledButton.styleFrom(backgroundColor: paw.marigold, foregroundColor: paw.onMarigold, iconColor: paw.onMarigold),
                  icon: const Icon(Icons.chat_outlined),
                  label: Text(l.tvStart),
                ),
              ]),
            );
          }),
          const SizedBox(height: Space.md),
          _AllowanceCard(limits: limits, used: used, plus: user.isPlus),
          if (open.isNotEmpty) ...[
            SectionHeader(l.tvOpenConsults),
            for (final c in open) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ConsultCard(consultation: c)),
          ],
          const SizedBox(height: Space.md),
          PawCard(
            onTap: () => context.push('/ask'),
            child: Row(children: [
              Container(
                width: TapTarget.min - Space.xxs,
                height: TapTarget.min - Space.xxs,
                decoration: BoxDecoration(color: context.paw.textPrimary, borderRadius: BorderRadius.circular(Radii.md)),
                child: Icon(Icons.auto_awesome_outlined, color: context.paw.background),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.aiTitle, style: context.text.titleSmall),
                  Text(ai.unlimited ? l.aiTileHintPlus : l.aiTileHint(ai.left), style: context.text.bodySmall),
                ]),
              ),
              const Icon(Icons.chevron_right_outlined),
            ]),
          ),
          if (past.isNotEmpty) ...[
            SectionHeader(l.tvPastConsults),
            for (final c in past.take(10)) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ConsultCard(consultation: c)),
          ],
          const SizedBox(height: Space.lg),
          PawCard(
            color: context.paw.sos.withValues(alpha: Opacities.highlight),
            borderColor: context.paw.sos.withValues(alpha: Opacities.muted),
            padding: const EdgeInsets.all(Space.md),
            child: Row(children: [
              Icon(Icons.emergency_outlined, color: context.paw.sos),
              const SizedBox(width: Space.md),
              Expanded(child: Text(l.tvEmergencyNote, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary))),
              TextButton(onPressed: () => openSos(context, ref), child: Text(l.sosTitle, style: TextStyle(color: context.paw.sos))),
            ]),
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
    // UI Design 6: the plan's allowances as four small tiles.
    final paw = context.paw;
    Widget tile(IconData icon, String text) => Container(
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(border: Border.all(color: paw.outline), borderRadius: BorderRadius.circular(Radii.lg)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: IconSizes.lg, color: paw.accent),
            const SizedBox(height: Space.sm),
            Text(text, style: context.text.labelMedium),
          ]),
        );
    final cols = MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 1 : 2;
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text(plus ? l.tvPlanPlus : l.tvPlanFree, style: context.text.titleMedium)),
          StatusChip(plus ? l.planPlus : l.tvFreeChip, tone: plus ? ChipTone.accent : ChipTone.neutral, icon: plus ? Icons.workspace_premium_outlined : null),
        ]),
        const SizedBox(height: Space.md),
        TileGrid(columns: cols, spacing: Space.sm, children: [
          tile(Icons.event_repeat_outlined, limits.unlimitedPerMonth ? l.tvLineUnlimited : l.tvLinePerMonth(limits.perMonth, used)),
          tile(Icons.chat_bubble_outlined, l.tvLineMessages(limits.messages, limits.words)),
          tile(Icons.schedule_outlined, l.tvLineHours(limits.hours)),
          tile(limits.video ? Icons.videocam_outlined : Icons.videocam_off_outlined, limits.video ? l.tvLineVideo : l.tvLineNoVideo),
        ]),
        if (reached) ...[
          const SizedBox(height: Space.md),
          InfoNote(l.tvMonthlyUsed(Fmt.date(nextMonthStart(DateTime.now()), context.lang)), tone: ChipTone.warning, icon: Icons.hourglass_bottom_outlined),
        ],
        if (!plus) ...[
          const SizedBox(height: Space.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => showPlusPrompt(context, title: l.tvPlusPromptTitle, body: l.plusPerkVideo),
              icon: const Icon(Icons.workspace_premium_outlined),
              label: Text(l.seePlus),
            ),
          ),
        ],
      ]),
    );
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
    return PawCard(
      onTap: () => context.push(partnerView ? '/partner/consult/${c.id}' : '/messages/${c.conversationId}'),
      padding: const EdgeInsets.all(Space.md),
      child: Row(children: [
        PetAvatar(species: c.petSpecies, colorTag: c.pet.colorTag, photoUrl: c.pet.photoUrl, size: Sizes.avatarMd),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${c.petName} · $who', style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              [Fmt.dateTime(c.createdAt, context.lang), c.isVideo ? l.tvModeVideo : l.tvModeChat].join(' · '),
              style: context.text.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (c.problem.isNotEmpty)
              Text(c.problem, style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          ]),
        ),
        const SizedBox(width: Space.sm),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          StatusChip(status, tone: tone),
          if (c.prescriptionId != null) ...[
            const SizedBox(height: Space.xs),
            Icon(Icons.receipt_long_outlined, size: IconSizes.chip, color: context.colors.primary, semanticLabel: l.rxTitle),
          ],
        ]),
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
      (Icons.medical_services_outlined, l.tvConsent1),
      (Icons.badge_outlined, l.tvConsent2),
      (Icons.local_hospital_outlined, l.tvConsent3),
      (Icons.emergency_outlined, l.tvConsent4),
      (Icons.receipt_long_outlined, l.tvConsent5),
      (Icons.shield_outlined, l.tvConsent6),
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
