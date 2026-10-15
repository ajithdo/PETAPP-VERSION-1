import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/admin_repository.dart';
import '../domain/support.dart';
import 'support_labels.dart';

String reportReasonLabel(BuildContext context, String reason) {
  final l = context.l10n;
  return switch (reason) {
    'spam' => l.msgReasonSpam,
    'abuse' => l.msgReasonAbuse,
    'payment' => l.msgReasonPayment,
    'fake' => l.msgReasonFake,
    _ => l.msgReasonOther,
  };
}

// ---------------------------------------------------------------- moderation

/// Moderation (spec 10): reported reviews, chats and content.
class AdminModeration extends ConsumerStatefulWidget {
  const AdminModeration({super.key});

  @override
  ConsumerState<AdminModeration> createState() => _AdminModerationState();
}

class _AdminModerationState extends ConsumerState<AdminModeration> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final reports = ref.watch(adminReportsProvider);
    return AsyncView<List<Report>>(
      value: reports,
      onRetry: () => ref.invalidate(adminReportsProvider),
      data: (all) {
        final shown = all.where((r) => (r.status == 'open') == _open).toList();
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          ChoiceRow<bool>(
            options: const [true, false],
            selected: _open,
            label: (o) => o ? l.admReportsOpen(all.where((r) => r.status == 'open').length) : l.admReportsClosed,
            onSelected: (o) => setState(() => _open = o),
          ),
          const SizedBox(height: Space.md),
          if (shown.isEmpty) EmptyState(title: _open ? l.admNoReports : l.admNothingHere, compact: true),
          for (final r in shown) Padding(padding: const EdgeInsets.only(bottom: Space.md), child: _ReportCard(report: r)),
        ]);
      },
    );
  }
}

class _ReportCard extends ConsumerWidget {
  const _ReportCard({required this.report});
  final Report report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final r = report;
    Future<void> act(String action) async {
      final admin = ref.read(currentUserProvider);
      if (admin == null) return;
      await ref.read(adminRepositoryProvider).resolveReport(admin, r, action);
      if (!context.mounted) return;
      showToast(context, switch (action) {
        'hide' => l.admReviewHidden,
        'restore' => l.admReviewRestored,
        'handled' => l.admReportHandled,
        _ => l.admReportDismissed,
      });
    }

    final resolvedAt = parseDate(r.raw['resolvedAt']);
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Icon(r.type == 'review' ? Icons.star_half_rounded : (r.type == 'chat' ? Icons.chat_rounded : Icons.flag_rounded), color: context.paw.warning),
          Text(reportTypeLabel(context, r.type), style: context.text.titleSmall),
          StatusChip(reportReasonLabel(context, r.reason), tone: ChipTone.warning),
        ]),
        if (r.targetTitle.isNotEmpty) ...[const SizedBox(height: Space.xs), Text(r.targetTitle, style: context.text.bodyMedium)],
        if (r.excerpt.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: Space.sm),
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(color: context.colors.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
            child: Text('“${r.excerpt}”', style: context.text.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
          ),
        if (r.details.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.admReporterSays(r.details), style: context.text.bodySmall)),
        const SizedBox(height: Space.xs),
        Text(
          [
            l.admReportedBy(r.reporterName.isEmpty ? '–' : r.reporterName),
            Fmt.dateTime(r.createdAt, context.lang),
            if (resolvedAt != null) l.admClosedOn(Fmt.date(resolvedAt, context.lang)),
          ].join(' · '),
          style: context.text.bodySmall,
        ),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, alignment: WrapAlignment.end, children: [
          if (r.status == 'open' && r.type == 'review')
            PrimaryButton(label: l.admHideReview, icon: Icons.visibility_off_rounded, expand: false, onPressed: () => act('hide')),
          if (r.status == 'open' && r.type != 'review')
            PrimaryButton(label: l.admMarkHandled, icon: Icons.task_alt_rounded, expand: false, onPressed: () => act('handled')),
          if (r.status == 'open') SecondaryButton(label: l.admDismiss, icon: Icons.close_rounded, expand: false, onPressed: () => act('dismiss')),
          if (r.status == 'actioned' && r.type == 'review')
            SecondaryButton(label: l.admRestoreReview, icon: Icons.visibility_rounded, expand: false, onPressed: () => act('restore')),
        ]),
      ]),
    );
  }
}

// ---------------------------------------------------------------- Demo Outbox

/// Demo Outbox (spec 10): every simulated SMS, WhatsApp, email and push.
class AdminOutbox extends ConsumerStatefulWidget {
  const AdminOutbox({super.key});

  @override
  ConsumerState<AdminOutbox> createState() => _AdminOutboxState();
}

class _AdminOutboxState extends ConsumerState<AdminOutbox> {
  String? _channel;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final outbox = ref.watch(adminOutboxProvider);
    return AsyncView<List<Map<String, dynamic>>>(
      value: outbox,
      onRetry: () => ref.invalidate(adminOutboxProvider),
      data: (all) {
        final q = _q.trim().toLowerCase();
        final shown = all.where((m) {
          if (_channel != null && m['channel'] != _channel) return false;
          if (q.isEmpty) return true;
          return [m['to'], m['subject'], m['body'], m['type']].whereType<String>().any((s) => s.toLowerCase().contains(q));
        }).toList();
        final counts = <String, int>{};
        for (final m in all) {
          counts['${m['channel']}'] = (counts['${m['channel']}'] ?? 0) + 1;
        }
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          InfoNote(l.demoOutboxNote, icon: Icons.science_rounded, tone: ChipTone.accent),
          const SizedBox(height: Space.md),
          PawTextField(label: l.admSearchOutbox, prefixIcon: Icons.search_rounded, onChanged: (v) => setState(() => _q = v)),
          const SizedBox(height: Space.sm),
          ChoiceRow<String?>(
            options: const [null, 'push', 'sms', 'whatsapp', 'email'],
            selected: _channel,
            label: (c) => c == null ? l.admAllCount(all.length) : '${outboxChannelLabel(context, c)} (${counts[c] ?? 0})',
            icons: (c) => c == null ? Icons.all_inbox_rounded : outboxChannelIcon(c),
            onSelected: (c) => setState(() => _channel = c),
          ),
          const SizedBox(height: Space.md),
          if (shown.isEmpty) EmptyState(title: l.admNothingHere, compact: true),
          for (final m in shown.take(150)) _OutboxTile(msg: m),
        ]);
      },
    );
  }
}

class _OutboxTile extends StatelessWidget {
  const _OutboxTile({required this.msg});
  final Map<String, dynamic> msg;

  @override
  Widget build(BuildContext context) {
    final channel = '${msg['channel']}';
    final at = parseDate(msg['createdAt']);
    final subject = msg['subject'] as String?;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.all(Space.md),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(radius: 18, child: Icon(outboxChannelIcon(channel), size: 18)),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${outboxChannelLabel(context, channel)} → ${msg['to'] ?? ''}', style: context.text.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
              if (at != null) Text(Fmt.dateTime(at, context.lang), style: context.text.labelSmall),
              if (subject != null && subject.isNotEmpty) Text(subject, style: context.text.titleSmall),
              Text('${msg['body'] ?? ''}', style: context.text.bodySmall, maxLines: 4, overflow: TextOverflow.ellipsis),
              if (msg['type'] is String) Padding(padding: const EdgeInsets.only(top: 4), child: StatusChip('${msg['type']}')),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------- audit log

/// Audit log (spec 10): who changed what in the admin panel, and when.
class AdminAudit extends ConsumerStatefulWidget {
  const AdminAudit({super.key});

  @override
  ConsumerState<AdminAudit> createState() => _AdminAuditState();
}

class _AdminAuditState extends ConsumerState<AdminAudit> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final audit = ref.watch(adminAuditProvider);
    return AsyncView<List<Map<String, dynamic>>>(
      value: audit,
      onRetry: () => ref.invalidate(adminAuditProvider),
      data: (all) {
        final q = _q.trim().toLowerCase();
        final shown = q.isEmpty
            ? all
            : all.where((e) => '${e['actorName']} ${e['action']} ${auditActionLabel(context, '${e['action']}')} ${e['targetId']} ${e['details']}'.toLowerCase().contains(q)).toList();
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          InfoNote(l.admAuditNote),
          const SizedBox(height: Space.md),
          PawTextField(label: l.admSearchAudit, prefixIcon: Icons.search_rounded, onChanged: (v) => setState(() => _q = v)),
          const SizedBox(height: Space.md),
          if (shown.isEmpty) EmptyState(title: l.admNothingHere, compact: true),
          for (final e in shown) _AuditTile(entry: e),
        ]);
      },
    );
  }
}

class _AuditTile extends StatelessWidget {
  const _AuditTile({required this.entry});
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final at = parseDate(entry['createdAt']);
    final details = (entry['details'] as Map?) ?? const {};
    final detailText = [
      for (final d in details.entries)
        if (d.value != null && '${d.value}'.isNotEmpty) '${d.key}: ${d.value is Map ? (d.value as Map).entries.map((e) => '${e.key}=${e.value}').join(', ') : d.value}',
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.all(Space.md),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(radius: 18, child: Icon(Icons.history_rounded, size: 18)),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(auditActionLabel(context, '${entry['action']}'), style: context.text.titleSmall),
              Text([entry['actorName'] ?? '', entry['targetId'] ?? ''].where((x) => '$x'.isNotEmpty).join(' · '), style: context.text.bodySmall),
              if (detailText.isNotEmpty) Text(detailText, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis),
              if (at != null) Text(Fmt.dateTime(at, context.lang), style: context.text.labelSmall),
            ]),
          ),
        ]),
      ),
    );
  }
}
