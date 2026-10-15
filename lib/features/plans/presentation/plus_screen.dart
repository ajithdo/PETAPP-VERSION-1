import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/plan_repository.dart';
import '../domain/plan_rules.dart';

/// PawSetu Plus (spec 8): Free and Plus side by side, the 7-day free trial,
/// a demo purchase (monthly or yearly) and auto-renew.
class PlusScreen extends ConsumerStatefulWidget {
  const PlusScreen({super.key});

  @override
  ConsumerState<PlusScreen> createState() => _PlusScreenState();
}

class _PlusScreenState extends ConsumerState<PlusScreen> {
  bool _yearly = true;
  bool _busy = false;

  Future<void> _trial(AppUser user, PlanPrices prices) async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      await ref.read(planRepositoryProvider).startTrial(user, prices);
      if (!mounted) return;
      await showDemoDialog(context, title: l.plusTrialStartedTitle, body: l.plusTrialStartedBody(prices.trialDays, Fmt.date(trialEnd(DateTime.now(), prices), context.lang)));
    } catch (_) {
      if (mounted) showToast(context, l.plusTrialUsed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _buy(AppUser user, PlanPrices prices) async {
    final l = context.l10n;
    final amount = _yearly ? prices.yearly : prices.monthly;
    final outcome = await ref.read(paymentServiceProvider).pay(context, amount: amount, description: _yearly ? l.plusPayYearly : l.plusPayMonthly);
    if (!mounted) return;
    switch (outcome) {
      case PaymentOutcome.success:
        setState(() => _busy = true);
        try {
          final renews = await ref.read(planRepositoryProvider).buy(user, prices, yearly: _yearly);
          if (!mounted) return;
          await showDemoDialog(context, title: l.plusWelcomeTitle, body: l.plusWelcomeBody(Fmt.date(renews, context.lang)));
        } catch (_) {
          if (mounted) showToast(context, l.errorTitle);
        } finally {
          if (mounted) setState(() => _busy = false);
        }
      case PaymentOutcome.failure:
        showToast(context, l.paymentFailed);
      case PaymentOutcome.pending:
        showToast(context, l.paymentPendingNote);
      case PaymentOutcome.cancelled:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final prices = ref.watch(planPricesProvider);
    final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
    if (user == null) return const Scaffold(body: SkeletonList());
    final now = DateTime.now();
    final plan = user.effectivePlan;
    final canTrial = canStartTrial(plan: plan, trialUsedAt: user.trialUsedAt);
    return Scaffold(
      appBar: AppBar(title: Text(l.pawsetuPlus)),
      body: PageBody(maxWidth: 800, children: [
        const SizedBox(height: Space.md),
        _StatusCard(user: user, now: now),
        const SizedBox(height: Space.lg),
        _Comparison(cfg: cfg),
        if (plan != 'plus') ...[
          SectionHeader(plan == 'trial' ? l.plusKeepAfterTrial : l.plusChoosePlan),
          _PeriodChoice(prices: prices, yearly: _yearly, onChanged: (y) => setState(() => _yearly = y)),
          const SizedBox(height: Space.md),
          PrimaryButton(
            label: l.plusBuy(Fmt.inr(_yearly ? prices.yearly : prices.monthly, context.lang)),
            icon: Icons.workspace_premium_rounded,
            loading: _busy,
            onPressed: () => _buy(user, prices),
          ),
          if (plan == 'trial')
            Padding(
              padding: const EdgeInsets.only(top: Space.xs),
              child: Text(l.plusStartsAfterTrial(Fmt.date(user.trialEndsAt ?? now, context.lang)), style: context.text.bodySmall, textAlign: TextAlign.center),
            ),
          if (canTrial) ...[
            const SizedBox(height: Space.sm),
            SecondaryButton(label: l.plusStartTrial(prices.trialDays), icon: Icons.celebration_rounded, onPressed: _busy ? null : () => _trial(user, prices)),
            Padding(
              padding: const EdgeInsets.only(top: Space.xs),
              child: Text(l.plusTrialNote(prices.trialDays), style: context.text.bodySmall, textAlign: TextAlign.center),
            ),
          ],
        ],
        if (plan == 'plus') ...[
          const SizedBox(height: Space.md),
          PawCard(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.plusAutoRenew),
              subtitle: Text(user.autoRenew
                  ? l.plusAutoRenewOn(Fmt.date(user.planRenewsAt ?? now, context.lang))
                  : l.plusAutoRenewOff(Fmt.date(user.planRenewsAt ?? now, context.lang))),
              value: user.autoRenew,
              onChanged: (v) => ref.read(planRepositoryProvider).setAutoRenew(user, v),
            ),
          ),
        ],
        const SizedBox(height: Space.md),
        DemoBanner(l.plusDemoNote),
        const SizedBox(height: Space.xl),
      ]),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.user, required this.now});
  final AppUser user;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final plan = user.effectivePlan;
    final (title, body) = switch (plan) {
      'trial' => (l.plusOnTrial(daysLeft(user.trialEndsAt, now)), l.plusTrialEnds(Fmt.date(user.trialEndsAt ?? now, context.lang))),
      'plus' => (
          l.plusYouHavePlus,
          user.autoRenew ? l.plusRenewsOn(Fmt.date(user.planRenewsAt ?? now, context.lang)) : l.plusEndsOn(Fmt.date(user.planRenewsAt ?? now, context.lang)),
        ),
      _ => (l.plusYouAreFree, l.plusFreeBody),
    };
    final plus = plan != 'free';
    return PawCard(
      color: plus ? context.paw.accent.withValues(alpha: 0.12) : null,
      borderColor: plus ? context.paw.accent : null,
      child: Row(children: [
        Icon(plus ? Icons.workspace_premium_rounded : Icons.pets_rounded, size: 40, color: plus ? context.paw.accent : context.colors.primary),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: context.text.titleMedium),
            const SizedBox(height: 2),
            Text(body, style: context.text.bodyMedium),
          ]),
        ),
      ]),
    );
  }
}

/// Free vs Plus, read from config/app so admin changes show straight away.
class _Comparison extends StatelessWidget {
  const _Comparison({required this.cfg});
  final Map<String, dynamic> cfg;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final limits = (cfg['limits'] as Map?) ?? const {};
    final free = (limits['free'] as Map?) ?? const {};
    final plus = (limits['plus'] as Map?) ?? const {};
    final commission = (cfg['commission'] as Map?) ?? const {};
    final shop = (cfg['shop'] as Map?) ?? const {};
    String count(Object? v) => isUnlimited(v as num?) ? l.admUnlimited : Fmt.number(v ?? 0, context.lang);
    String secs(Object? v) {
      final s = (v as num?)?.toInt() ?? 0;
      return s >= 60 ? l.plusMinutes((s / 60).round()) : l.plusSeconds(s);
    }

    final rows = <(IconData, String, String, String)>[
      (Icons.pets_rounded, l.plusRowPets, count(free['pets']), count(plus['pets'])),
      (Icons.family_restroom_rounded, l.plusRowFamily, count(free['family']), count(plus['family'])),
      (Icons.videocam_rounded, l.plusRowVideo, '–', l.plusYes),
      (Icons.chat_rounded, l.plusRowTeleVet, l.plusPerMonth(count(free['teleVetPerMonth'])), isUnlimited(plus['teleVetPerMonth'] as num?) ? l.admUnlimited : l.plusPerMonth(count(plus['teleVetPerMonth']))),
      (Icons.short_text_rounded, l.plusRowMessages, l.plusMessagesWords(count(free['teleVetMessages']), count(free['teleVetWords'])),
          l.plusMessagesWords(count(plus['teleVetMessages']), count(plus['teleVetWords']))),
      (Icons.auto_awesome_rounded, l.plusRowAi, l.plusPerMonth(count(free['aiQuestions'])), count(plus['aiQuestions'])),
      (Icons.cloud_rounded, l.plusRowStorage, '${free['storageGb'] ?? 1} GB', '${plus['storageGb'] ?? 25} GB'),
      (Icons.movie_rounded, l.plusRowVideoLength, secs(free['videoSeconds']), secs(plus['videoSeconds'])),
      (Icons.local_offer_rounded, l.plusRowVideoDiscount, '–', '${commission['videoDiscountPercent'] ?? 10}%'),
      (Icons.local_shipping_rounded, l.plusRowDelivery, l.plusAbove(Fmt.inr((shop['freeDeliveryAbove'] as num?) ?? 999, context.lang)),
          l.plusAbove(Fmt.inr((commission['freeDeliveryAbove'] as num?) ?? 499, context.lang))),
      (Icons.support_agent_rounded, l.plusRowSupport, l.plusStandard, l.plusPriority),
    ];
    return PawCard(
      padding: const EdgeInsets.all(Space.md),
      child: Column(children: [
        Row(children: [
          const Expanded(child: SizedBox()),
          SizedBox(width: 88, child: Text(l.planFree, style: context.text.labelLarge, textAlign: TextAlign.center)),
          SizedBox(width: 88, child: Text(l.planPlus, style: context.text.labelLarge?.copyWith(color: context.paw.accent), textAlign: TextAlign.center)),
        ]),
        const Divider(),
        for (final (icon, label, f, p) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Icon(icon, size: 20, color: context.colors.primary),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(label, style: context.text.bodyMedium)),
              SizedBox(width: 88, child: Text(f, style: context.text.bodySmall, textAlign: TextAlign.center)),
              SizedBox(width: 88, child: Text(p, style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
            ]),
          ),
      ]),
    );
  }
}

class _PeriodChoice extends StatelessWidget {
  const _PeriodChoice({required this.prices, required this.yearly, required this.onChanged});
  final PlanPrices prices;
  final bool yearly;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget option(bool y) {
      final selected = y == yearly;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          child: PawCard(
            onTap: () => onChanged(y),
            borderColor: selected ? context.colors.primary : null,
            color: selected ? context.paw.primaryContainer : null,
            padding: const EdgeInsets.all(Space.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: context.colors.primary, size: 20),
                const SizedBox(width: Space.xs),
                Expanded(child: Text(y ? l.plusYearly : l.plusMonthly, style: context.text.titleSmall)),
              ]),
              const SizedBox(height: Space.xs),
              Text(Fmt.inr(y ? prices.yearly : prices.monthly, context.lang), style: context.text.headlineSmall),
              Text(y ? l.plusPerYear : l.plusPerMonthPrice, style: context.text.bodySmall),
              if (y && prices.yearlySavingPercent > 0) ...[
                const SizedBox(height: Space.xs),
                StatusChip(l.plusSave(prices.yearlySavingPercent), tone: ChipTone.success),
              ],
            ]),
          ),
        ),
      );
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [option(false), const SizedBox(width: Space.sm), option(true)]);
  }
}

// ---------------------------------------------------------------- refer a friend

final _myRewardCouponsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref
      .watch(firestoreProvider)
      .collection('coupons')
      .where('forUid', isEqualTo: u.uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) {...d.data(), 'id': d.id}]);
});

final _myReferralsProvider = StreamProvider<int>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(0);
  return ref.watch(firestoreProvider).collection('referrals').where('referrerId', isEqualTo: u.uid).snapshots().map((s) => s.docs.length);
});

/// Refer a friend (spec 7.14): share your code; both get a shop coupon
/// when the friend enters it.
class ReferScreen extends ConsumerStatefulWidget {
  const ReferScreen({super.key});

  @override
  ConsumerState<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends ConsumerState<ReferScreen> {
  final _code = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _redeem(AppUser user, int reward) async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final coupon = await ref.read(planRepositoryProvider).redeemReferral(user, _code.text, reward: reward);
      if (!mounted) return;
      if (coupon == null) {
        showToast(context, l.referInvalid);
      } else {
        _code.clear();
        await showDemoDialog(context, title: l.referDoneTitle, body: l.referDoneBody(Fmt.inr(reward, context.lang), coupon));
      }
    } catch (_) {
      if (mounted) showToast(context, l.referInvalid);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final cfg = ref.watch(appSettingsDocProvider).value ?? const {};
    final on = ((cfg['flags'] as Map?)?['referrals']) != false;
    final reward = (((cfg['referral'] as Map?)?['reward']) as num?)?.toInt() ?? 100;
    if (user == null) return const Scaffold(body: SkeletonList());
    final code = user.referralCode;
    final coupons = ref.watch(_myRewardCouponsProvider).value ?? const [];
    final referred = ref.watch(_myReferralsProvider).value ?? 0;
    return Scaffold(
      appBar: AppBar(title: Text(l.referTitle)),
      body: !on
          ? EmptyState(title: l.referPaused)
          : PageBody(maxWidth: 700, children: [
              const SizedBox(height: Space.md),
              PawCard(
                color: context.paw.primaryContainer,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Icon(Icons.card_giftcard_rounded, size: 40, color: context.colors.primary),
                  const SizedBox(height: Space.sm),
                  Text(l.referHeadline(Fmt.inr(reward, context.lang)), style: context.text.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: Space.xs),
                  Text(l.referBody(Fmt.inr(reward, context.lang)), style: context.text.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: Space.md),
                  if (code != null) ...[
                    Text(l.referYourCode, style: context.text.labelLarge, textAlign: TextAlign.center),
                    const SizedBox(height: Space.xs),
                    SelectableText(code, style: context.text.headlineMedium?.copyWith(letterSpacing: 4, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                    const SizedBox(height: Space.sm),
                    Wrap(alignment: WrapAlignment.center, spacing: Space.sm, runSpacing: Space.sm, children: [
                      SecondaryButton(
                        label: l.copy,
                        icon: Icons.copy_rounded,
                        expand: false,
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: code));
                          if (context.mounted) showToast(context, l.copied);
                        },
                      ),
                      PrimaryButton(
                        label: l.share,
                        icon: Icons.share_rounded,
                        expand: false,
                        onPressed: () => SharePlus.instance.share(ShareParams(text: l.referShareText(code, Fmt.inr(reward, context.lang)))),
                      ),
                    ]),
                  ],
                ]),
              ),
              const SizedBox(height: Space.sm),
              Text(l.referFriendsJoined(referred), style: context.text.bodySmall, textAlign: TextAlign.center),
              SectionHeader(l.referHaveCode),
              PawTextField(
                label: l.referEnterCode,
                controller: _code,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')), LengthLimitingTextInputFormatter(10)],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: Space.sm),
              PrimaryButton(
                label: l.referApply,
                loading: _busy,
                onPressed: referralCodeLooksValid(_code.text) ? () => _redeem(user, reward) : null,
              ),
              if (coupons.isNotEmpty) ...[
                SectionHeader(l.referYourRewards),
                for (final c in coupons)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: PawCard(
                      padding: const EdgeInsets.all(Space.md),
                      child: Row(children: [
                        const Icon(Icons.local_offer_rounded),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            SelectableText('${c['id']}', style: context.text.titleSmall?.copyWith(letterSpacing: 1)),
                            Text(
                              l.referCouponLine(
                                Fmt.inr((c['flat'] as num?) ?? 0, context.lang),
                                Fmt.inr((c['minOrder'] as num?) ?? 0, context.lang),
                                Fmt.date(parseDate(c['validTill']) ?? DateTime.now(), context.lang),
                              ),
                              style: context.text.bodySmall,
                            ),
                          ]),
                        ),
                        if (((c['uses'] as num?) ?? 0) >= ((c['maxUses'] as num?) ?? 1)) StatusChip(l.referUsed),
                      ]),
                    ),
                  ),
              ],
              const SizedBox(height: Space.md),
              DemoBanner(l.referDemoNote),
            ]),
    );
  }
}
