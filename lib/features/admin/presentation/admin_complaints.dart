import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/presentation/booking_labels.dart' show bookingStatus;
import '../../partner/presentation/partner_shell.dart' show roleLabel;
import '../../shop/presentation/shop_labels.dart' show orderStatusInfo;
import '../data/admin_repository.dart';
import '../data/support_repository.dart';
import '../domain/support.dart';
import 'admin_inputs.dart';
import 'support_labels.dart';
import 'ticket_thread.dart';

/// Complaints and support tickets (spec 10): from pet parents and partners,
/// linked to a booking, order or chat; status, assign, reply and demo refunds.
class AdminComplaints extends ConsumerStatefulWidget {
  const AdminComplaints({super.key});

  @override
  ConsumerState<AdminComplaints> createState() => _AdminComplaintsState();
}

class _AdminComplaintsState extends ConsumerState<AdminComplaints> {
  String _status = 'active';
  String _from = 'all';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tickets = ref.watch(adminTicketsProvider);
    return AsyncView<List<Ticket>>(
      value: tickets,
      onRetry: () => ref.invalidate(adminTicketsProvider),
      data: (all) {
        final shown = all.where((t) {
          final s = switch (_status) {
            'active' => t.status != 'resolved',
            'all' => true,
            _ => t.status == _status,
          };
          final f = switch (_from) {
            'owners' => t.role == 'owner',
            'partners' => t.role != 'owner',
            _ => true,
          };
          return s && f;
        }).toList();
        final waiting = all.where((t) => t.status != 'resolved' && !t.awaitingUser).length;
        return PageBody(maxWidth: 900, children: [
          const SizedBox(height: Space.md),
          ResponsiveGrid(minItemWidth: 160, spacing: Space.sm, children: [
            StatTile(label: l.hpStatusOpen, value: '${all.where((t) => t.status == 'open').length}', icon: Icons.mark_email_unread_rounded, color: context.paw.warning),
            StatTile(label: l.hpStatusInProgress, value: '${all.where((t) => t.status == 'in_progress').length}', icon: Icons.pending_rounded),
            StatTile(label: l.admNeedsReply, value: '$waiting', icon: Icons.reply_rounded, color: waiting > 0 ? context.paw.error : null),
            StatTile(label: l.hpStatusResolved, value: '${all.where((t) => t.status == 'resolved').length}', icon: Icons.check_circle_rounded, color: context.paw.success),
          ]),
          const SizedBox(height: Space.md),
          ChoiceRow<String>(
            options: const ['active', 'open', 'in_progress', 'resolved', 'all'],
            selected: _status,
            label: (s) => switch (s) {
              'active' => l.admNotResolved,
              'all' => l.admAllKinds,
              _ => ticketStatusLabel(context, s),
            },
            onSelected: (s) => setState(() => _status = s),
          ),
          const SizedBox(height: Space.sm),
          ChoiceRow<String>(
            options: const ['all', 'owners', 'partners'],
            selected: _from,
            label: (f) => switch (f) {
              'owners' => l.admFilterOwners,
              'partners' => l.admFilterPartners,
              _ => l.admEveryone,
            },
            onSelected: (f) => setState(() => _from = f),
          ),
          const SizedBox(height: Space.md),
          if (shown.isEmpty) EmptyState(title: l.admNoTickets, compact: true),
          for (final t in shown)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: TicketCard(ticket: t, adminView: true, onTap: () => context.go('/admin/complaints/${t.id}')),
            ),
        ]);
      },
    );
  }
}

/// One ticket in a list (admin panel and the person's help list).
class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket, required this.adminView, required this.onTap});
  final Ticket ticket;
  final bool adminView;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = ticket;
    final last = t.messages.isEmpty ? null : t.messages.last;
    final needsAdmin = t.status != 'resolved' && !t.awaitingUser;
    return PawCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Space.md),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(child: Icon(linkTypeIcon(t.linkType), size: 20)),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.subject, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text(
              [
                if (adminView) t.name,
                if (adminView) roleLabel(context, UserRole.parse(t.role)),
                ticketTopicLabel(context, t.topic),
                Fmt.dateShort(t.updatedAt, context.lang),
              ].join(' · '),
              style: context.text.bodySmall,
            ),
            if (last != null)
              Text(
                '${last.fromAdmin ? l.hpSupportTeam : last.byName}: ${last.text}',
                style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
              StatusChip(ticketStatusLabel(context, t.status), tone: ticketStatusTone(t.status)),
              if (adminView && needsAdmin) StatusChip(l.admNeedsReply, tone: ChipTone.error, icon: Icons.reply_rounded),
              if (!adminView && t.awaitingUser) StatusChip(l.hpNewReply, tone: ChipTone.info, icon: Icons.mark_chat_unread_rounded),
              if (t.refund != null) StatusChip(l.hpRefunded(Fmt.inr((t.refund!['amount'] as num?) ?? 0, context.lang)), tone: ChipTone.success),
            ]),
          ]),
        ),
        const Icon(Icons.chevron_right_rounded),
      ]),
    );
  }
}

/// The booking or order a ticket is about (null for chats and "other").
final ticketLinkProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, key) async {
  final parts = key.split('/');
  if (parts.length != 2 || parts[1].isEmpty) return null;
  final col = switch (parts[0]) { 'booking' => 'bookings', 'order' => 'orders', 'chat' => 'conversations', _ => null };
  if (col == null) return null;
  final d = await ref.watch(firestoreProvider).collection(col).doc(parts[1]).get();
  return d.exists ? {...d.data()!, 'id': d.id} : null;
});

/// Full ticket page for support: details, the linked booking or order,
/// status, assignee, a demo refund and the reply thread.
class AdminTicketScreen extends ConsumerStatefulWidget {
  const AdminTicketScreen({super.key, required this.ticketId});
  final String ticketId;

  @override
  ConsumerState<AdminTicketScreen> createState() => _AdminTicketScreenState();
}

class _AdminTicketScreenState extends ConsumerState<AdminTicketScreen> {
  bool _resolveAfter = false;

  AppUser get _admin => ref.read(currentUserProvider)!;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ticket = ref.watch(ticketProvider(widget.ticketId));
    return Scaffold(
      appBar: AppBar(
        title: Text(l.admTicketTitle),
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/admin/complaints')),
      ),
      body: AsyncView<Ticket?>(
        value: ticket,
        data: (t) {
          if (t == null) return EmptyState(title: l.admTicketMissing);
          final repo = ref.read(adminRepositoryProvider);
          final admins = [
            for (final u in ref.watch(adminUsersProvider).value ?? const <Map<String, dynamic>>[])
              if (u['role'] == 'admin') (u['name'] as String?) ?? '',
          ];
          return PageBody(maxWidth: 900, children: [
            const SizedBox(height: Space.md),
            PawCard(child: TicketSummary(ticket: t, showPerson: true)),
            const SizedBox(height: Space.md),
            if (t.linkType != 'other' && t.linkId != null) _LinkedItem(ticket: t),
            const SizedBox(height: Space.md),
            PawCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(l.status, style: context.text.titleSmall),
                const SizedBox(height: Space.xs),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<String>(
                    segments: [for (final s in ticketStatuses) ButtonSegment(value: s, label: Text(ticketStatusLabel(context, s)))],
                    selected: {t.status},
                    onSelectionChanged: (s) => repo.setTicketStatus(_admin, t, s.first),
                  ),
                ),
                const SizedBox(height: Space.md),
                Text(l.admAssignee, style: context.text.titleSmall),
                const SizedBox(height: Space.xs),
                DropdownButtonFormField<String>(
                  initialValue: admins.contains(t.assignee) ? t.assignee : null,
                  isExpanded: true,
                  hint: Text(l.admUnassigned),
                  items: [for (final a in admins) DropdownMenuItem(value: a, child: Text(a))],
                  onChanged: (a) {
                    if (a != null) repo.assignTicket(_admin, t, a);
                  },
                ),
              ]),
            ),
            SectionHeader(l.admConversation),
            TicketThread(ticket: t, adminView: true),
            const SizedBox(height: Space.sm),
            TicketComposer(
              hint: l.admReplyHint(t.name.split(' ').first),
              onSend: (text) async {
                await repo.replyToTicket(_admin, t, text, newStatus: _resolveAfter ? 'resolved' : null);
                if (!context.mounted) return;
                showToast(context, l.admReplySent(t.name.split(' ').first));
                setState(() => _resolveAfter = false);
              },
              extra: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _resolveAfter,
                onChanged: (v) => setState(() => _resolveAfter = v ?? false),
                title: Text(l.admResolveAfter),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _LinkedItem extends ConsumerWidget {
  const _LinkedItem({required this.ticket});
  final Ticket ticket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = ticket;
    final link = ref.watch(ticketLinkProvider('${t.linkType}/${t.linkId}'));
    return AsyncView<Map<String, dynamic>?>(
      value: link,
      loading: const Skeleton(height: 96),
      data: (d) {
        if (d == null) return InfoNote(l.admLinkMissing(linkTypeLabel(context, t.linkType)));
        final paid = (d['total'] as num?)?.toInt() ?? 0;
        final when = parseDate(d['start'] ?? d['createdAt']);
        final title = switch (t.linkType) {
          'booking' => '${d['serviceName'] ?? ''} · ${d['providerName'] ?? ''}',
          'order' => l.admOrderLine(((d['items'] as List?) ?? const []).length, (d['sellerName'] as String?) ?? ''),
          _ => t.linkLabel,
        };
        final refund = t.refund;
        return PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Icon(linkTypeIcon(t.linkType), color: context.colors.primary),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(linkTypeLabel(context, t.linkType), style: context.text.titleSmall)),
              if (d['status'] is String) _linkStatus(context, t.linkType, d['status'] as String),
            ]),
            const SizedBox(height: Space.xs),
            Text(title, style: context.text.bodyMedium),
            Text(
              [
                if (when != null) Fmt.dateTime(when, context.lang),
                if (t.linkType != 'chat') l.admTotal(Fmt.inr(paid, context.lang)),
                '#${t.linkId}',
              ].join(' · '),
              style: context.text.bodySmall,
            ),
            if (t.linkType == 'booking' || t.linkType == 'order') ...[
              const SizedBox(height: Space.md),
              if (refund != null)
                InfoNote(
                  l.admRefundDone(Fmt.inr((refund['amount'] as num?) ?? 0, context.lang), Fmt.date(parseDate(refund['at']) ?? DateTime.now(), context.lang)),
                  tone: ChipTone.success,
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: SecondaryButton(
                    label: l.admRefundButton,
                    icon: Icons.currency_rupee_rounded,
                    expand: false,
                    onPressed: paid <= 0 ? null : () => _refund(context, ref, paid),
                  ),
                ),
            ],
          ]),
        );
      },
    );
  }

  Future<void> _refund(BuildContext context, WidgetRef ref, int paid) async {
    final l = context.l10n;
    final v = await askNumber(context, title: l.admRefundAmount, initial: paid, suffix: '₹', max: paid, helper: l.admRefundMax(Fmt.inr(paid, context.lang)));
    if (v == null || v <= 0 || !context.mounted) return;
    final amount = ticketRefundAmount(v, paid: paid);
    final ok = await confirmAction(context, title: l.admRefundConfirm(Fmt.inr(amount, context.lang), ticket.name), confirmLabel: l.admRefundButton, danger: false);
    if (!ok || !context.mounted) return;
    final admin = ref.read(currentUserProvider)!;
    await ref.read(adminRepositoryProvider).refundTicket(admin, ticket, amount);
    if (!context.mounted) return;
    await showDemoDialog(context, title: l.admRefundDemoTitle, body: l.admRefundDemoBody(Fmt.inr(amount, context.lang), ticket.name));
  }
}

Widget _linkStatus(BuildContext context, String type, String status) {
  if (type == 'booking') {
    final (label, tone) = bookingStatus(context, status);
    return StatusChip(label, tone: tone);
  }
  if (type == 'order') {
    final (label, tone, icon) = orderStatusInfo(context, status);
    return StatusChip(label, tone: tone, icon: icon);
  }
  return const SizedBox.shrink();
}
