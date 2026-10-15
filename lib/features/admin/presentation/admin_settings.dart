import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../health/presentation/health_labels.dart';
import '../../pets/domain/breeds.dart';
import '../../plans/domain/plan_rules.dart';
import '../../shop/domain/shop_models.dart';
import '../data/admin_repository.dart';
import 'admin_inputs.dart';

/// Plans and settings (spec 8 and 10): every number the app uses is stored
/// in config/app, so changes reach the app straight away without an update.
class AdminSettings extends ConsumerWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final cfgAsync = ref.watch(appSettingsDocProvider);
    return AsyncView<Map<String, dynamic>>(
      value: cfgAsync,
      data: (cfg) {
        final prices = PlanPrices.fromConfig(cfg);
        final commission = (cfg['commission'] as Map?) ?? const {};
        final shop = (cfg['shop'] as Map?) ?? const {};
        final byType = (commission['bookingTypePercent'] as Map?) ?? const {};
        final updated = parseDate(cfg['updatedAt']);
        num n(Map m, String k, num d) => (m[k] as num?) ?? d;
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          InfoNote(updated == null ? l.admSettingsNote : '${l.admSettingsNote} ${l.admLastChanged(Fmt.dateTime(updated, context.lang))}'),
          SectionHeader(l.admPlanPrices),
          _Group(children: [
            _NumRow(label: l.admPlusMonthly, value: prices.monthly, path: 'plans.plusMonthly', what: 'plans', prefix: '₹', max: 9999),
            _NumRow(label: l.admPlusYearly, value: prices.yearly, path: 'plans.plusYearly', what: 'plans', prefix: '₹', max: 99999),
            _NumRow(label: l.admTrialDays, value: prices.trialDays, path: 'plans.trialDays', what: 'plans', suffix: l.admDaysUnit, max: 90),
          ]),
          SectionHeader(l.admPlanLimits),
          _LimitsTable(cfg: cfg),
          SectionHeader(l.admBookingCommission),
          _Group(children: [
            _NumRow(label: l.admDefaultRate, value: n(commission, 'bookingPercent', 10), path: 'commission.bookingPercent', what: 'commission', suffix: '%', max: 50),
            for (final t in const ['clinic', 'groomer', 'trainer', 'boarder', 'walker'])
              _NumRow(
                label: _kindLabel(context, t),
                value: byType[t] as num?,
                path: 'commission.bookingTypePercent.$t',
                what: 'commission',
                suffix: '%',
                max: 50,
                emptyMeansDefault: true,
              ),
          ]),
          Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(l.admProviderRateNote, style: context.text.bodySmall)),
          SectionHeader(l.admShopMoney),
          _Group(children: [
            _NumRow(label: l.admFoodMargin, value: n(commission, 'foodMarginPercent', 8), path: 'commission.foodMarginPercent', what: 'commission', suffix: '%', max: 50),
            _NumRow(label: l.admOtherMargin, value: n(commission, 'otherMarginPercent', 15), path: 'commission.otherMarginPercent', what: 'commission', suffix: '%', max: 50),
            _NumRow(label: l.admVideoDiscount, value: n(commission, 'videoDiscountPercent', 10), path: 'commission.videoDiscountPercent', what: 'commission', suffix: '%', max: 100),
            _NumRow(label: l.admDeliveryFee, value: n(shop, 'deliveryFee', 49), path: 'shop.deliveryFee', what: 'shop', prefix: '₹', max: 999),
            _NumRow(label: l.admFreeDeliveryFree, value: n(shop, 'freeDeliveryAbove', 999), path: 'shop.freeDeliveryAbove', what: 'shop', prefix: '₹', max: 99999),
            _NumRow(label: l.admFreeDeliveryPlus, value: n(commission, 'freeDeliveryAbove', 499), path: 'commission.freeDeliveryAbove', what: 'shop', prefix: '₹', max: 99999),
          ]),
          SectionHeader(l.admFeatureFlags),
          _Flags(cfg: cfg),
          SectionHeader(l.admReferrals),
          _Group(children: [
            _NumRow(label: l.admReferralReward, value: ((cfg['referral'] as Map?)?['reward'] as num?) ?? 100, path: 'referral.reward', what: 'referral', prefix: '₹', max: 5000),
          ]),
          SectionHeader(l.admCoupons, action: l.admNewCoupon, onAction: () => editCoupon(context, ref, null)),
          const _CouponList(),
          SectionHeader(l.admVaccineSchedules),
          Text(l.admVaccineNote, style: context.text.bodySmall),
          const SizedBox(height: Space.sm),
          _VaccineCard(species: Species.dog, cfg: cfg),
          const SizedBox(height: Space.md),
          _VaccineCard(species: Species.cat, cfg: cfg),
          SectionHeader(l.admContentReview),
          Text(l.admContentReviewNote, style: context.text.bodySmall),
          const SizedBox(height: Space.sm),
          _ContentReview(cfg: cfg),
          const SizedBox(height: Space.xl),
        ]);
      },
    );
  }

  static String _kindLabel(BuildContext context, String t) {
    final l = context.l10n;
    return switch (t) {
      'clinic' => l.admRateClinic,
      'groomer' => l.admRateGroomer,
      'trainer' => l.admRateTrainer,
      'boarder' => l.admRateBoarder,
      _ => l.admRateWalker,
    };
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => PawCard(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
        child: Column(children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            children[i],
          ],
        ]),
      );
}

/// One editable number saved to a dotted config path.
class _NumRow extends ConsumerWidget {
  const _NumRow({
    required this.label,
    required this.value,
    required this.path,
    required this.what,
    this.prefix,
    this.suffix,
    this.max = 100000,
    this.emptyMeansDefault = false,
  });
  final String label;
  final num? value;
  final String path;
  final String what;
  final String? prefix;
  final String? suffix;
  final int max;
  final bool emptyMeansDefault;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final shown = value == null ? l.admUsesDefault : '${prefix ?? ''}${Fmt.number(value!, context.lang)}${suffix == null ? '' : ' $suffix'}';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(shown, style: context.text.titleSmall?.copyWith(color: value == null ? context.paw.textSecondary : null)),
        const SizedBox(width: Space.xs),
        const Icon(Icons.edit_rounded, size: 18),
      ]),
      onTap: () async {
        final v = await askNumber(context,
            title: label, initial: value?.toInt(), suffix: suffix ?? prefix, max: max, allowEmpty: emptyMeansDefault, helper: emptyMeansDefault ? l.admEmptyDefault : null);
        final admin = ref.read(currentUserProvider);
        if (v == null || admin == null) return;
        await ref.read(adminRepositoryProvider).updateConfig(admin, {path: v < 0 ? FieldValue.delete() : v}, what: what);
        if (context.mounted) showToast(context, l.admSavedLive);
      },
    );
  }
}

/// Free and Plus limits side by side (spec 8).
class _LimitsTable extends ConsumerWidget {
  const _LimitsTable({required this.cfg});
  final Map<String, dynamic> cfg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final limits = (cfg['limits'] as Map?) ?? const {};
    final free = (limits['free'] as Map?) ?? const {};
    final plus = (limits['plus'] as Map?) ?? const {};
    final rows = <(String, String, String?)>[
      ('pets', l.admLimitPets, null),
      ('family', l.admLimitFamily, null),
      ('teleVetPerMonth', l.admLimitTeleVet, null),
      ('teleVetMessages', l.admLimitMessages, null),
      ('teleVetWords', l.admLimitWords, null),
      ('teleVetHours', l.admLimitHours, l.admHoursUnit),
      ('aiQuestions', l.admLimitAi, null),
      ('storageGb', l.admLimitStorage, 'GB'),
      ('videoSeconds', l.admLimitVideo, l.admSecondsUnit),
    ];
    Widget cell(String plan, String key, String label, num? v, String? unit) => SizedBox(
          width: 92,
          child: TextButton(
            onPressed: () async {
              final x = await askNumber(context, title: '$label · ${plan == 'free' ? l.planFree : l.planPlus}', initial: v?.toInt(), suffix: unit, max: 100000);
              final admin = ref.read(currentUserProvider);
              if (x == null || x < 0 || admin == null) return;
              await ref.read(adminRepositoryProvider).updateConfig(admin, {'limits.$plan.$key': x}, what: 'limits');
              if (context.mounted) showToast(context, l.admSavedLive);
            },
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(v == null ? '–' : (v >= 999 ? l.admUnlimited : Fmt.number(v, context.lang)), textAlign: TextAlign.center, maxLines: 1),
            ),
          ),
        );
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      child: Column(children: [
        Row(children: [
          Expanded(child: Text(l.admLimit, style: context.text.labelLarge)),
          SizedBox(width: 92, child: Text(l.planFree, style: context.text.labelLarge, textAlign: TextAlign.center)),
          SizedBox(width: 92, child: Text(l.planPlus, style: context.text.labelLarge?.copyWith(color: context.paw.accent), textAlign: TextAlign.center)),
        ]),
        const Divider(),
        for (final (key, label, unit) in rows)
          Row(children: [
            Expanded(child: Text(unit == null ? label : '$label ($unit)', style: context.text.bodyMedium)),
            cell('free', key, label, free[key] as num?, unit),
            cell('plus', key, label, plus[key] as num?, unit),
          ]),
        const SizedBox(height: Space.xs),
        Text(l.admUnlimitedNote, style: context.text.bodySmall),
      ]),
    );
  }
}

class _Flags extends ConsumerWidget {
  const _Flags({required this.cfg});
  final Map<String, dynamic> cfg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final flags = (cfg['flags'] as Map?) ?? const {};
    final items = <(String, String, String)>[
      ('aiAssistant', l.admFlagAi, l.admFlagAiHint),
      ('smartDevices', l.admFlagDevices, l.admFlagDevicesHint),
      ('lostPetAlerts', l.admFlagLost, l.admFlagLostHint),
      ('referrals', l.admFlagReferrals, l.admFlagReferralsHint),
    ];
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
      child: Column(children: [
        for (final (key, title, hint) in items)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title),
            subtitle: Text(hint),
            value: flags[key] != false,
            onChanged: (v) async {
              final admin = ref.read(currentUserProvider);
              if (admin == null) return;
              await ref.read(adminRepositoryProvider).updateConfig(admin, {'flags.$key': v}, what: 'flags');
            },
          ),
      ]),
    );
  }
}

// ---------------------------------------------------------------- coupons

class _CouponList extends ConsumerWidget {
  const _CouponList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final coupons = ref.watch(adminCollectionProvider('coupons')).value ?? const <Map<String, dynamic>>[];
    // Referral rewards are personal coupons; the list shows the shared ones.
    final list = [for (final m in coupons) if (m['forUid'] == null) Coupon(m['id'] as String, m)]..sort((a, b) => a.code.compareTo(b.code));
    final personal = coupons.length - list.length;
    final now = DateTime.now();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final c in list)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
            onTap: () => editCoupon(context, ref, c),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: Space.sm, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    Text(c.code, style: context.text.titleSmall?.copyWith(letterSpacing: 1)),
                    if (c.validTill != null && c.validTill!.isBefore(now)) StatusChip(l.couponExpired, tone: ChipTone.error),
                  ]),
                  Text(c.description, style: context.text.bodySmall),
                  Text(
                    [
                      c.percent != null ? l.admCouponPercent(c.percent!, Fmt.inr(c.maxDiscount ?? 0, context.lang)) : l.admCouponFlat(Fmt.inr(c.flat ?? 0, context.lang)),
                      l.admCouponMin(Fmt.inr(c.minOrder, context.lang)),
                      if (c.validTill != null) l.admCouponTill(Fmt.date(c.validTill!, context.lang)),
                      l.admCouponUses(c.uses, c.maxUses ?? 0),
                    ].join(' · '),
                    style: context.text.bodySmall,
                  ),
                ]),
              ),
              Semantics(
                label: l.admCouponActive,
                child: Switch(
                  value: c.active,
                  onChanged: (v) async {
                    final admin = ref.read(currentUserProvider);
                    if (admin == null) return;
                    await ref.read(adminRepositoryProvider).saveCoupon(admin, c.code, {'active': v}, isNew: false);
                  },
                ),
              ),
            ]),
          ),
        ),
      if (personal > 0) Text(l.admPersonalCoupons(personal), style: context.text.bodySmall),
    ]);
  }
}

Future<void> editCoupon(BuildContext context, WidgetRef ref, Coupon? c) async {
  final code = TextEditingController(text: c?.code ?? '');
  final desc = TextEditingController(text: c?.description ?? '');
  final value = TextEditingController(text: '${c?.percent ?? c?.flat ?? 10}');
  final maxDisc = TextEditingController(text: '${c?.maxDiscount ?? 200}');
  final minOrder = TextEditingController(text: '${c?.minOrder ?? 499}');
  final maxUses = TextEditingController(text: '${c?.maxUses ?? 1000}');
  var percent = c == null || c.percent != null;
  var till = c?.validTill ?? DateTime.now().add(const Duration(days: 30));
  final saved = await showPawSheet<bool>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, setSheet) {
      final codeOk = RegExp(r'^[A-Z0-9]{4,16}$').hasMatch(code.text.trim().toUpperCase());
      final v = int.tryParse(value.text.trim());
      final ok = codeOk && v != null && v > 0 && (!percent || v <= 90) && int.tryParse(minOrder.text.trim()) != null && int.tryParse(maxUses.text.trim()) != null;
      final digits = [FilteringTextInputFormatter.digitsOnly];
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(c == null ? l.admNewCoupon : c.code, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        if (c == null) ...[
          PawTextField(label: l.couponCode, controller: code, helper: l.admCouponCodeHelp, onChanged: (_) => setSheet(() {})),
          const SizedBox(height: Space.sm),
        ],
        PawTextField(label: l.admCouponDescription, controller: desc, onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.sm),
        ChoiceRow<bool>(
          options: const [true, false],
          selected: percent,
          label: (p) => p ? l.admCouponTypePercent : l.admCouponTypeFlat,
          onSelected: (p) => setSheet(() => percent = p),
        ),
        const SizedBox(height: Space.sm),
        PawTextField(label: percent ? l.admCouponPercentOff : l.admCouponAmountOff, controller: value, keyboardType: TextInputType.number, inputFormatters: digits, suffix: Text(percent ? '%' : '₹'), onChanged: (_) => setSheet(() {})),
        if (percent) ...[
          const SizedBox(height: Space.sm),
          PawTextField(label: l.admCouponMaxDiscount, controller: maxDisc, keyboardType: TextInputType.number, inputFormatters: digits, suffix: const Text('₹'), onChanged: (_) => setSheet(() {})),
        ],
        const SizedBox(height: Space.sm),
        PawTextField(label: l.admCouponMinOrder, controller: minOrder, keyboardType: TextInputType.number, inputFormatters: digits, suffix: const Text('₹'), onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.sm),
        PawTextField(label: l.admCouponMaxUses, controller: maxUses, keyboardType: TextInputType.number, inputFormatters: digits, onChanged: (_) => setSheet(() {})),
        const SizedBox(height: Space.sm),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.event_rounded),
          title: Text(l.admCouponValidTill),
          subtitle: Text(Fmt.date(till, ctx.lang)),
          onTap: () async {
            final d = await showDatePicker(context: ctx, initialDate: till, firstDate: DateTime.now().subtract(const Duration(days: 1)), lastDate: DateTime.now().add(const Duration(days: 730)));
            if (d != null) setSheet(() => till = DateTime(d.year, d.month, d.day, 23, 59));
          },
        ),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.save, onPressed: ok ? () => Navigator.pop(ctx, true) : null),
        const SizedBox(height: Space.sm),
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
      ]);
    });
  });
  final admin = ref.read(currentUserProvider);
  if (saved != true || admin == null) return;
  final v = int.parse(value.text.trim());
  final fields = <String, dynamic>{
    'description': desc.text.trim(),
    'percent': percent ? v : FieldValue.delete(),
    'flat': percent ? FieldValue.delete() : v,
    'maxDiscount': percent ? int.tryParse(maxDisc.text.trim()) ?? 0 : FieldValue.delete(),
    'minOrder': int.parse(minOrder.text.trim()),
    'maxUses': int.parse(maxUses.text.trim()),
    'validTill': till,
  };
  final repo = ref.read(adminRepositoryProvider);
  if (c == null) {
    fields.removeWhere((k, v) => v is FieldValue);
    await repo.saveCoupon(admin, code.text.trim().toUpperCase(), {...fields, 'active': true}, isNew: true);
  } else {
    await repo.saveCoupon(admin, c.code, fields, isNew: false);
  }
}

// ---------------------------------------------------------------- vaccines

class _VaccineCard extends ConsumerWidget {
  const _VaccineCard({required this.species, required this.cfg});
  final Species species;
  final Map<String, dynamic> cfg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final base = species == Species.dog ? dogTemplates : catTemplates;
    final overrides = (((cfg['vaccineSchedules'] as Map?) ?? const {})[species.name] as Map?) ?? const {};
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(species == Species.dog ? l.admDogSchedule : l.admCatSchedule, style: context.text.titleSmall),
        for (final t in applyVaccineOverride(base, overrides))
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text('${t.name} · ${doseLabel(context, t.doseLabel)}'),
            subtitle: Text(
              t.optional
                  ? l.admAskVetTiming
                  : t.yearlyAfter != null
                      ? l.admEveryYears(t.everyYears)
                      : l.admWeeksRange(t.fromWeeks ?? 0, t.toWeeks ?? 0),
            ),
            trailing: t.optional ? null : Icon(overrides.containsKey(t.key) ? Icons.edit_note_rounded : Icons.edit_rounded, size: 18, color: overrides.containsKey(t.key) ? context.paw.accent : null),
            onTap: t.optional ? null : () => _edit(context, ref, t, overrides.containsKey(t.key)),
          ),
      ]),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, DoseTemplate t, bool changed) async {
    final l = context.l10n;
    final admin = ref.read(currentUserProvider);
    if (admin == null) return;
    final repo = ref.read(adminRepositoryProvider);
    final path = 'vaccineSchedules.${species.name}.${t.key}';
    if (t.yearlyAfter != null) {
      final v = await askNumber(context, title: l.admBoosterEvery(t.name), initial: t.everyYears, suffix: l.admYearsUnit, max: 5, allowEmpty: true, helper: l.admEmptyDefault);
      if (v == null || v == 0) return;
      await repo.updateConfig(admin, {path: v < 0 ? FieldValue.delete() : {'everyYears': v}}, what: 'vaccines');
      return;
    }
    final from = await askNumber(context, title: l.admFromWeek(t.name), initial: t.fromWeeks, suffix: l.admWeeksUnit, max: 104);
    if (from == null || from < 0 || !context.mounted) return;
    final to = await askNumber(context, title: l.admToWeek(t.name), initial: (t.toWeeks ?? from) < from ? from : t.toWeeks, suffix: l.admWeeksUnit, max: 104);
    if (to == null || to < from) return;
    await repo.updateConfig(admin, {path: {'from': from, 'to': to}}, what: 'vaccines');
    if (context.mounted) showToast(context, l.admSavedLive);
  }
}

// ---------------------------------------------------------------- content review

class _ContentReview extends ConsumerWidget {
  const _ContentReview({required this.cfg});
  final Map<String, dynamic> cfg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final review = (cfg['contentReview'] as Map?) ?? const {};
    final areas = <(String, String, IconData)>[
      ('firstAid', l.admAreaFirstAid, Icons.healing_rounded),
      ('toxic', l.admAreaToxic, Icons.no_food_rounded),
      ('vaccines', l.admAreaVaccines, Icons.vaccines_rounded),
    ];
    return PawCard(
      padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
      child: Column(children: [
        for (final (key, title, icon) in areas)
          Builder(builder: (context) {
            final by = (review[key] as String?) ?? '';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(icon),
              title: Text(title),
              subtitle: Text(by.isEmpty ? l.draftVetReview : l.reviewedBy(by)),
              trailing: StatusChip(by.isEmpty ? l.admDraft : l.admReviewed, tone: by.isEmpty ? ChipTone.warning : ChipTone.success),
              onTap: () => _edit(context, ref, key, title, by),
            );
          }),
      ]),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, String key, String title, String current) async {
    final ctrl = TextEditingController(text: current);
    final result = await showPawSheet<String>(context, builder: (ctx) {
      final l = ctx.l10n;
      return StatefulBuilder(builder: (ctx, setSheet) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: ctx.text.titleMedium),
            const SizedBox(height: Space.sm),
            Text(l.admReviewSheetNote, style: ctx.text.bodySmall),
            const SizedBox(height: Space.md),
            PawTextField(label: l.admReviewerName, controller: ctrl, hint: 'Dr. A. Rao, DEMO-VC-0001', onChanged: (_) => setSheet(() {})),
            const SizedBox(height: Space.md),
            PrimaryButton(label: l.admMarkReviewed, onPressed: ctrl.text.trim().isEmpty ? null : () => Navigator.pop(ctx, ctrl.text.trim())),
            if (current.isNotEmpty) ...[
              const SizedBox(height: Space.sm),
              SecondaryButton(label: l.admBackToDraft, onPressed: () => Navigator.pop(ctx, '')),
            ],
            const SizedBox(height: Space.sm),
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          ]));
    });
    final admin = ref.read(currentUserProvider);
    if (result == null || admin == null) return;
    await ref.read(adminRepositoryProvider).updateConfig(admin, {'contentReview.$key': result}, what: 'content');
  }
}
