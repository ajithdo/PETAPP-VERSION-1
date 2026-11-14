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
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../data/plan_repository.dart';
import '../domain/plan_rules.dart';
import '../../../core/theme/ph.dart';

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

  /// Monthly or yearly from the next renewal (nothing is charged today).
  Future<void> _switchPeriod(AppUser user, PlanPrices prices, {required bool yearly}) async {
    final l = context.l10n;
    final lang = context.lang;
    final price = yearly ? l.plusPriceYear(Fmt.inr(prices.yearly, lang)) : l.plusPriceMonth(Fmt.inr(prices.monthly, lang));
    final ok = await confirmAction(
      context,
      title: yearly ? l.plusSwitchYearly : l.plusSwitchMonthly,
      body: l.plusSwitchBody(Fmt.date(user.planRenewsAt ?? DateTime.now(), lang), price),
      danger: false,
    );
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(planRepositoryProvider).setPeriod(user, yearly: yearly);
      if (mounted) showToast(context, l.plusSwitched);
    } catch (_) {
      if (mounted) showToast(context, l.errorTitle);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// "Cancel plan" turns renewal off: Plus stays till the paid period ends.
  Future<void> _cancel(AppUser user) async {
    final l = context.l10n;
    final ok = await confirmAction(
      context,
      title: l.plusCancelTitle,
      body: l.plusAutoRenewOff(Fmt.date(user.planRenewsAt ?? DateTime.now(), context.lang)),
      confirmLabel: l.plusCancelPlan,
    );
    if (ok) await ref.read(planRepositoryProvider).setAutoRenew(user, false);
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
    final lang = context.lang;
    final renews = user.planRenewsAt ?? now;
    final yearlyNow = user.planPeriod != 'monthly';
    final priceYear = l.plusPriceYear(Fmt.inr(prices.yearly, lang));
    final priceMonth = l.plusPriceMonth(Fmt.inr(prices.monthly, lang));

    // What sits beside the comparison table on a wide screen and above it
    // on a phone: your plan, how it renews (or how to get it), the trial.
    final side = <Widget>[
      _StatusCard(user: user, now: now, prices: prices),
      if (plan == 'plus')
        PawPanel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            MergeSemantics(
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.plusAutoRenew, style: context.text.labelLarge),
                    Text(
                      user.autoRenew ? l.plusNextPayment(Fmt.inr(yearlyNow ? prices.yearly : prices.monthly, lang), Fmt.date(renews, lang)) : l.plusAutoRenewOff(Fmt.date(renews, lang)),
                      style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
                    ),
                  ]),
                ),
                const SizedBox(width: Space.md),
                Switch(value: user.autoRenew, onChanged: (v) => ref.read(planRepositoryProvider).setAutoRenew(user, v)),
              ]),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: Space.md), child: Divider(height: Strokes.hairline)),
            Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.md, runSpacing: Space.sm, children: [
              SegText(items: [priceMonth, priceYear], index: yearlyNow ? 1 : 0, onChanged: _busy ? null : (i) => _switchPeriod(user, prices, yearly: i == 1)),
              if (user.autoRenew) TextLink(l.plusCancelPlan, onTap: () => _cancel(user)),
            ]),
          ]),
        )
      else ...[
        SecHead(plan == 'trial' ? l.plusKeepAfterTrial : l.plusChoosePlan),
        _PeriodChoice(prices: prices, yearly: _yearly, onChanged: (y) => setState(() => _yearly = y)),
        PawButton(
          label: l.plusBuy(Fmt.inr(_yearly ? prices.yearly : prices.monthly, lang)),
          icon: Ph.crownSimple,
          size: BtnSize.large,
          block: true,
          onPressed: _busy ? null : () => _buy(user, prices),
        ),
        if (plan == 'trial') Text(l.plusStartsAfterTrial(Fmt.date(user.trialEndsAt ?? now, lang)), style: context.text.bodySmall, textAlign: TextAlign.center),
      ],
      DemoBanner(l.plusDemoNote),
      PawPanel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const PawTile(icon: Ph.gift, tone: Tone.gold),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.plusNewHere(prices.trialDays), style: context.text.labelLarge),
                Text(canTrial ? l.plusTrialNote(prices.trialDays) : l.plusNewHereBody, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
              ]),
            ),
          ]),
          if (canTrial) ...[
            const SizedBox(height: Space.md),
            PawButton(label: l.plusStartTrial(prices.trialDays), icon: Ph.confetti, kind: BtnKind.soft, size: BtnSize.regular, block: true, onPressed: _busy ? null : () => _trial(user, prices)),
          ],
        ]),
      ),
    ];
    Widget stack(List<Widget> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, w) in items.indexed) ...[if (i > 0) const SizedBox(height: Space.md), w],
          ],
        );
    return Scaffold(
      appBar: AppBar(title: Text(l.pawsetuPlus)),
      body: LayoutBuilder(builder: (context, box) {
        final wide = box.maxWidth >= Space.readingWidth;
        return PageBody(maxWidth: wide ? Space.maxContentWidth : Space.formWidth, children: [
          const SizedBox(height: Space.sm),
          if (wide)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 5, child: stack(side)),
              const SizedBox(width: Space.md),
              Expanded(flex: 7, child: _Comparison(cfg: cfg)),
            ])
          else ...[
            stack(side),
            const SizedBox(height: Space.md),
            _Comparison(cfg: cfg),
          ],
          const SizedBox(height: Space.xl),
        ]);
      }),
    );
  }
}

/// Your plan. Plus and the trial are a marigold membership card.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.user, required this.now, required this.prices});
  final AppUser user;
  final DateTime now;
  final PlanPrices prices;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final plan = user.effectivePlan;
    final paw = context.paw;
    if (plan == 'free') {
      return PawPanel(
        child: Row(children: [
          const PawTile(icon: Ph.pawPrint, size: Sizes.tileLg),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.plusYouAreFree, style: context.text.titleMedium),
              const SizedBox(height: Space.xxs),
              Text(l.plusFreeBody, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            ]),
          ),
        ]),
      );
    }
    final trial = plan == 'trial';
    final ink = paw.onMarigold;
    final soft = ink.withValues(alpha: Opacities.onDarkMuted);
    final until = (trial ? user.trialEndsAt : user.planRenewsAt) ?? now;
    final yearly = user.planPeriod != 'monthly';
    Widget fact(String label, String value, {bool end = false}) => Column(
          crossAxisAlignment: end ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(label, style: context.text.labelSmall?.copyWith(color: soft, fontWeight: FontWeight.w500)),
            Text(value, style: context.text.labelLarge?.copyWith(color: ink), textAlign: end ? TextAlign.end : TextAlign.start),
          ],
        );
    return Container(
      decoration: BoxDecoration(
        color: paw.marigold,
        borderRadius: BorderRadius.circular(Radii.xxl),
        boxShadow: [BoxShadow(color: paw.marigold.withValues(alpha: Opacities.muted), blurRadius: Space.xxl, spreadRadius: -Space.md, offset: const Offset(0, Space.lg))],
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: _CardRings(color: ink.withValues(alpha: Opacities.chip), halo: paw.surface.withValues(alpha: Opacities.tint)),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg + Space.xs),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const PawSetuLogo(size: IconSizes.xl - Space.xxs),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(l.pawsetuPlus, style: context.text.labelLarge?.copyWith(color: ink))),
              Icon(Ph.crownSimpleFill, color: ink),
            ]),
            const SizedBox(height: Space.lg + Space.xs),
            Text(trial ? l.plusOnTrial(daysLeft(user.trialEndsAt, now)) : l.plusYouHaveShort, style: context.text.displaySmall?.copyWith(color: ink)),
            const SizedBox(height: Space.xs),
            Text(
              user.createdAt == null || user.name.isEmpty ? user.name : l.plusMemberSince(user.name, Fmt.monthYearShort(user.createdAt!, lang)),
              style: context.text.bodyMedium?.copyWith(color: soft),
            ),
            Padding(
              padding: const EdgeInsets.only(top: Space.lg, bottom: Space.md),
              child: Divider(color: ink.withValues(alpha: Opacities.tintStrong), height: Strokes.hairline),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: fact(trial || !user.autoRenew ? l.plusEndsOnLabel : l.plusRenewsOnLabel, Fmt.date(until, lang))),
              if (!trial && user.planPeriod != null) ...[
                const SizedBox(width: Space.md),
                Flexible(
                  child: fact(yearly ? l.plusYearlyPlan : l.plusMonthlyPlan, yearly ? l.plusPriceYear(Fmt.inr(prices.yearly, lang)) : l.plusPriceMonth(Fmt.inr(prices.monthly, lang)), end: true),
                ),
              ],
            ]),
          ]),
        ),
      ),
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
      (Ph.pawPrint, l.plusRowPets, count(free['pets']), count(plus['pets'])),
      (Ph.usersThree, l.plusRowFamily, count(free['family']), count(plus['family'])),
      (Ph.videoCamera, l.plusRowVideo, '', l.plusYes),
      (Ph.chatCircleDots, l.plusRowTeleVet, l.plusPerMonth(count(free['teleVetPerMonth'])), isUnlimited(plus['teleVetPerMonth'] as num?) ? l.admUnlimited : l.plusPerMonth(count(plus['teleVetPerMonth']))),
      (Ph.textAlignLeft, l.plusRowMessages, l.plusMessagesWords(count(free['teleVetMessages']), count(free['teleVetWords'])),
          l.plusMessagesWords(count(plus['teleVetMessages']), count(plus['teleVetWords']))),
      (Ph.sparkle, l.plusRowAi, l.plusPerMonth(count(free['aiQuestions'])), count(plus['aiQuestions'])),
      (Ph.cloud, l.plusRowStorage, '${free['storageGb'] ?? 1} GB', '${plus['storageGb'] ?? 25} GB'),
      (Ph.filmStrip, l.plusRowVideoLength, secs(free['videoSeconds']), secs(plus['videoSeconds'])),
      (Ph.tag, l.plusRowVideoDiscount, '', '${commission['videoDiscountPercent'] ?? 10}%'),
      (Ph.truck, l.plusRowDelivery, l.plusAbove(Fmt.inr((shop['freeDeliveryAbove'] as num?) ?? 999, context.lang)),
          l.plusAbove(Fmt.inr((commission['freeDeliveryAbove'] as num?) ?? 499, context.lang))),
      (Ph.headset, l.plusRowSupport, l.plusStandard, l.plusPriority),
    ];
    // The Plus column sits on a marigold wash so the eye reads down it.
    final paw = context.paw;
    final wash = paw.accentContainer;
    final line = BorderSide(color: paw.outline);
    final cell = context.text.bodySmall;
    Widget head(String t, {Color? color, TextAlign align = TextAlign.center}) =>
        Text(t, style: context.text.labelSmall?.copyWith(color: color ?? paw.textSecondary, fontWeight: FontWeight.w600), textAlign: align);
    return PawCard(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.lg),
      child: Column(children: [
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: Space.md), child: head(l.plusWhatYouGet, align: TextAlign.start))),
            SizedBox(width: Sizes.planColumn, child: Padding(padding: const EdgeInsets.symmetric(vertical: Space.md), child: head(l.planFree))),
            Container(
              width: Sizes.planColumn,
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              decoration: BoxDecoration(color: wash, borderRadius: const BorderRadius.vertical(top: Radius.circular(Radii.md))),
              child: Text(l.planPlus, style: context.text.labelLarge?.copyWith(color: paw.onAccentContainer), textAlign: TextAlign.center),
            ),
          ]),
        ),
        for (var i = 0; i < rows.length; i++)
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Space.md - Space.xxs),
                  decoration: BoxDecoration(border: Border(top: line)),
                  child: Row(children: [
                    Icon(rows[i].$1, size: IconSizes.sm + Space.xxs, color: paw.textSecondary),
                    const SizedBox(width: Space.sm),
                    Expanded(child: Text(rows[i].$2, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: context.text.labelLarge?.fontSize))),
                  ]),
                ),
              ),
              Container(
                width: Sizes.planColumn,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: Space.md - Space.xxs, horizontal: Space.xs),
                decoration: BoxDecoration(border: Border(top: line)),
                child: rows[i].$3.isEmpty
                    ? Text(l.plusNo, style: cell?.copyWith(color: context.tint.ink3), textAlign: TextAlign.center)
                    : Text(rows[i].$3, style: cell?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center),
              ),
              Container(
                width: Sizes.planColumn,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: Space.md - Space.xxs, horizontal: Space.xs),
                decoration: BoxDecoration(
                  color: wash,
                  border: Border(top: BorderSide(color: paw.outline.withValues(alpha: Opacities.half))),
                  borderRadius: i == rows.length - 1 ? const BorderRadius.vertical(bottom: Radius.circular(Radii.md)) : null,
                ),
                child: Text(rows[i].$4, style: cell?.copyWith(fontWeight: FontWeight.w700, color: paw.textPrimary), textAlign: TextAlign.center),
              ),
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
      final paw = context.paw;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          inMutuallyExclusiveGroup: true,
          child: Material(
            color: selected ? paw.accentContainer : paw.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.lg),
              side: BorderSide(color: selected ? paw.textPrimary : context.tint.line2, width: Strokes.strong),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(Radii.lg),
              onTap: () => onChanged(y),
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(y ? l.plusYearly : l.plusMonthly, style: context.text.labelLarge)),
                    Icon(selected ? Ph.radioButtonFill : Ph.circle, color: selected ? paw.textPrimary : paw.controlBorder, size: IconSizes.md),
                  ]),
                  const SizedBox(height: Space.xs),
                  Text(Fmt.inr(y ? prices.yearly : prices.monthly, context.lang), style: context.text.headlineSmall),
                  Text(y ? l.plusPerYear : l.plusPerMonthPrice, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
                  if (y && prices.yearlySavingPercent > 0) ...[
                    const SizedBox(height: Space.sm),
                    PawTag(l.plusSave(prices.yearlySavingPercent), kind: TagKind.green),
                  ],
                ]),
              ),
            ),
          ),
        ),
      );
    }

    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [option(false), const SizedBox(width: Space.sm), option(true)]));
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
          : PageBody(maxWidth: Space.formWidth, children: [
              const SizedBox(height: Space.md),
              PawCard(
                color: context.paw.primaryContainer,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Icon(Ph.gift, size: IconSizes.xxxl, color: context.colors.primary),
                  const SizedBox(height: Space.sm),
                  Text(l.referHeadline(Fmt.inr(reward, context.lang)), style: context.text.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: Space.xs),
                  Text(l.referBody(Fmt.inr(reward, context.lang)), style: context.text.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: Space.md),
                  if (code != null) ...[
                    Text(l.referYourCode, style: context.text.labelLarge, textAlign: TextAlign.center),
                    const SizedBox(height: Space.xs),
                    Text(code, style: context.textX.mono.copyWith(fontSize: context.text.headlineMedium?.fontSize, letterSpacing: Tracking.code, fontWeight: FontWeight.w700, color: context.paw.textPrimary), textAlign: TextAlign.center),
                    const SizedBox(height: Space.sm),
                    Wrap(alignment: WrapAlignment.center, spacing: Space.sm, runSpacing: Space.sm, children: [
                      SecondaryButton(
                        label: l.copy,
                        icon: Ph.copy,
                        expand: false,
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: code));
                          if (context.mounted) showToast(context, l.copied);
                        },
                      ),
                      PrimaryButton(
                        label: l.share,
                        icon: Ph.shareNetwork,
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
                        const Icon(Ph.tag),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('${c['id']}', style: context.textX.mono.copyWith(letterSpacing: Tracking.id, fontWeight: FontWeight.w700, color: context.paw.textPrimary)),
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

/// A hairline ring with a soft halo in the corner of the Plus card.
class _CardRings extends CustomPainter {
  _CardRings({required this.color, required this.halo});
  final Color color;
  final Color halo;

  @override
  void paint(Canvas canvas, Size size) {
    const r = Sizes.print * 0.63; // a 12rem circle, 3rem off the corner
    final c = Offset(size.width + Space.xxl - r, r - Space.xxl);
    canvas.drawCircle(c, r + Space.lg, Paint()..style = PaintingStyle.stroke..strokeWidth = Space.xl..color = halo);
    canvas.drawCircle(c, r, Paint()..style = PaintingStyle.stroke..strokeWidth = Strokes.strong..color = color);
  }

  @override
  bool shouldRepaint(_CardRings o) => o.color != color || o.halo != halo;
}
