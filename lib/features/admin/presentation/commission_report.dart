import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/data/converters.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/admin_repository.dart';
import '../domain/admin_rules.dart';

DateTime _date(Object? v) => parseDate(v) ?? DateTime.fromMillisecondsSinceEpoch(0);

/// Monthly commission report (spec 8 and 10): booking commission and shop
/// margin per partner, PawSetu Plus payments and demo refunds, with a CSV
/// download.
class CommissionReportScreen extends ConsumerStatefulWidget {
  const CommissionReportScreen({super.key});

  @override
  ConsumerState<CommissionReportScreen> createState() => _CommissionReportScreenState();
}

class _CommissionReportScreenState extends ConsumerState<CommissionReportScreen> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.lang;
    final bookings = ref.watch(adminCollectionProvider('bookings'));
    final orders = ref.watch(adminCollectionProvider('orders'));
    final payments = ref.watch(adminCollectionProvider('payments'));
    final now = DateTime.now();
    final months = [for (var i = 0; i < 6; i++) DateTime(now.year, now.month - i)];
    final ready = bookings.hasValue && orders.hasValue && payments.hasValue;
    final report = ready
        ? commissionReport(bookings: bookings.value!, orders: orders.value!, payments: payments.value!, month: _month, date: _date)
        : null;
    String kindLabel(String k) => k == 'shop' ? l.admKindShop : l.admKindBooking;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.admCommissionReport),
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/admin')),
        actions: [
          if (report != null)
            IconButton(
              tooltip: l.admDownloadCsv,
              icon: const Icon(Icons.download_rounded),
              onPressed: () {
                final csv = report.toCsv([l.admColPartner, l.admColType, l.admColCount, l.admColGross, l.admColCommission, l.admColPayout], kindLabel);
                final name = 'pawsetu-commission-${_month.year}-${_month.month.toString().padLeft(2, '0')}.csv';
                SharePlus.instance.share(ShareParams(
                  files: [XFile.fromData(Uint8List.fromList(utf8.encode(csv)), mimeType: 'text/csv', name: name)],
                  fileNameOverrides: [name],
                  subject: l.admCommissionReport,
                ));
              },
            ),
        ],
      ),
      body: report == null
          ? const SkeletonList()
          : PageBody(maxWidth: 1000, children: [
              const SizedBox(height: Space.md),
              ChoiceRow<DateTime>(
                options: months,
                selected: _month,
                label: (m) => Fmt.monthYear(m, lang),
                onSelected: (m) => setState(() => _month = m),
              ),
              const SizedBox(height: Space.md),
              ResponsiveGrid(minItemWidth: 170, spacing: Space.sm, children: [
                StatTile(label: l.admBookingCommissionShort, value: Fmt.inr(report.bookingCommission, lang), icon: Icons.event_available_rounded),
                StatTile(label: l.admShopMargin, value: Fmt.inr(report.shopMargin, lang), icon: Icons.shopping_bag_rounded),
                StatTile(label: l.admPlusRevenue, value: Fmt.inr(report.plusRevenue, lang), icon: Icons.workspace_premium_rounded, color: context.paw.accent),
                StatTile(label: l.admRefunds, value: Fmt.inr(report.refunds, lang), icon: Icons.undo_rounded, color: context.paw.warning),
                StatTile(label: l.admPlatformTotal, value: Fmt.inr(report.platformTotal, lang), icon: Icons.account_balance_wallet_rounded, color: context.paw.success),
              ]),
              const SizedBox(height: Space.sm),
              InfoNote(l.admReportDemoNote),
              SectionHeader(l.admByPartner),
              if (report.lines.isEmpty) EmptyState(title: l.admNoNumbers, compact: true),
              for (final line in report.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: PawCard(
                    padding: const EdgeInsets.all(Space.md),
                    child: Row(children: [
                      Icon(line.kind == 'shop' ? Icons.storefront_rounded : Icons.local_hospital_rounded, color: context.colors.primary),
                      const SizedBox(width: Space.md),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(line.name.isEmpty ? '–' : line.name, style: context.text.titleSmall),
                          Text(
                            '${kindLabel(line.kind)} · ${l.admLineCount(line.count)} · ${l.admColGross}: ${Fmt.inr(line.gross, lang)} · ${l.admColPayout}: ${Fmt.inr(line.payout, lang)}',
                            style: context.text.bodySmall,
                          ),
                        ]),
                      ),
                      const SizedBox(width: Space.sm),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(Fmt.inr(line.commission, lang), style: context.text.titleSmall?.copyWith(color: context.paw.success)),
                        Text(l.admColCommission, style: context.text.labelSmall),
                      ]),
                    ]),
                  ),
                ),
            ]),
    );
  }
}
