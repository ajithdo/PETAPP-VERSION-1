import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../data/support_repository.dart';
import '../domain/support.dart';
import 'admin_complaints.dart' show TicketCard;
import 'support_labels.dart';
import 'ticket_thread.dart';

/// Where help lives: /me/help for pet parents, /help for partners (the
/// owner area is closed to partner accounts).
String helpBase(AppUser? user) => user == null || user.role == UserRole.owner ? '/me/help' : '/help';

/// Help and complaints (spec 10): quick answers, raising a ticket and the
/// person's tickets with replies from the support team.
class HelpListScreen extends ConsumerWidget {
  const HelpListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final base = helpBase(ref.watch(currentUserProvider));
    return Scaffold(
      appBar: AppBar(title: Text(l.helpAndComplaints)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('$base/new'),
        icon: const Icon(Icons.add_comment_rounded),
        label: Text(l.hpRaise),
      ),
      body: const HelpListBody(),
    );
  }
}

/// The help page body; [embedded] in the partner portal it has its own
/// "Raise a complaint" button instead of the floating one.
class HelpListBody extends ConsumerWidget {
  const HelpListBody({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final tickets = ref.watch(myTicketsProvider);
    final base = helpBase(user);
    final faqs = <(String, String)>[
      (l.hpFaqRefundQ, l.hpFaqRefundA),
      (l.hpFaqCancelQ, l.hpFaqCancelA),
      (l.hpFaqUrgentQ, l.hpFaqUrgentA),
      (l.hpFaqDataQ, l.hpFaqDataA),
    ];
    return PageBody(maxWidth: 800, children: [
      const SizedBox(height: Space.md),
      PawCard(
        color: context.paw.primaryContainer,
        child: Row(children: [
          Icon(Icons.support_agent_rounded, size: 40, color: context.colors.primary),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.hpIntroTitle, style: context.text.titleMedium),
              const SizedBox(height: 2),
              Text(user?.isPlus == true ? l.hpIntroPlus : l.hpIntroBody, style: context.text.bodyMedium),
            ]),
          ),
        ]),
      ),
      if (embedded) ...[
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.hpRaise, icon: Icons.add_comment_rounded, onPressed: () => context.push('$base/new')),
      ],
      SectionHeader(l.hpYourTickets),
      AsyncView<List<Ticket>>(
        value: tickets,
        onRetry: () => ref.invalidate(myTicketsProvider),
        loading: const Skeleton(height: 96),
        data: (list) => list.isEmpty
            ? PawCard(child: Text(l.hpNoTickets))
            : Column(children: [
                for (final t in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: TicketCard(ticket: t, adminView: false, onTap: () => context.push('$base/${t.id}')),
                  ),
              ]),
      ),
      SectionHeader(l.hpQuickAnswers),
      PawCard(
        padding: const EdgeInsets.symmetric(horizontal: Space.sm),
        child: Column(children: [
          for (final (q, a) in faqs)
            ExpansionTile(
              shape: const Border(),
              title: Text(q, style: context.text.titleSmall),
              childrenPadding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(a)],
            ),
        ]),
      ),
      SizedBox(height: embedded ? Space.md : 72),
    ]);
  }
}

/// Something a ticket can be about: a booking, order or chat.
class HelpLink {
  const HelpLink(this.type, this.id, this.label, this.at);
  final String type;
  final String id;
  final String label;
  final DateTime at;
}

/// The person's recent bookings and orders, newest first (for the picker).
final _recentLinksProvider = FutureProvider<List<HelpLink>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const [];
  final db = ref.watch(firestoreProvider);
  final owner = user.role == UserRole.owner;
  final bookings = await (owner
          ? db.collection('bookings').where('ownerId', isEqualTo: user.uid)
          : db.collection('bookings').where('partnerUids', arrayContains: user.uid))
      .get();
  final orders = await (owner
          ? db.collection('orders').where('ownerId', isEqualTo: user.uid)
          : db.collection('orders').where('sellerUids', arrayContains: user.uid))
      .get();
  final links = <HelpLink>[
    for (final d in bookings.docs) HelpLink('booking', d.id, _bookingLabel(d.data()), parseDate(d.data()['start']) ?? DateTime(2000)),
    for (final d in orders.docs) HelpLink('order', d.id, _orderLabel(d.id, d.data()), parseDate(d.data()['createdAt']) ?? DateTime(2000)),
  ]..sort((a, b) => b.at.compareTo(a.at));
  return links.take(12).toList();
});

String _bookingLabel(Map<String, dynamic> b) => [b['serviceName'], b['providerName'], if (b['petName'] != null) b['petName']].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
String _orderLabel(String id, Map<String, dynamic> o) => '${o['sellerName'] ?? ''} · ₹${o['total'] ?? 0} · #${id.length > 6 ? id.substring(id.length - 6).toUpperCase() : id}';

/// One linked item, looked up from the link in the address.
final _linkFromRouteProvider = FutureProvider.family<HelpLink?, String>((ref, key) async {
  final i = key.indexOf('/');
  final type = key.substring(0, i), id = key.substring(i + 1);
  final db = ref.watch(firestoreProvider);
  switch (type) {
    case 'booking':
      final d = await db.collection('bookings').doc(id).get();
      return d.exists ? HelpLink('booking', id, _bookingLabel(d.data()!), parseDate(d.data()!['start']) ?? DateTime.now()) : null;
    case 'order':
      final d = await db.collection('orders').doc(id).get();
      return d.exists ? HelpLink('order', id, _orderLabel(id, d.data()!), parseDate(d.data()!['createdAt']) ?? DateTime.now()) : null;
    case 'chat':
      final d = await db.collection('conversations').doc(id).get();
      if (!d.exists) return null;
      final c = d.data()!;
      final me = ref.read(currentUserProvider);
      final other = me?.role == UserRole.owner ? c['providerName'] : c['ownerName'];
      return HelpLink('chat', id, '${other ?? ''}', parseDate(c['updatedAt'] ?? c['createdAt']) ?? DateTime.now());
  }
  return null;
});

/// Raise a complaint or question, optionally about a booking, order or chat.
class NewTicketScreen extends ConsumerStatefulWidget {
  const NewTicketScreen({super.key, this.linkType, this.linkId});
  final String? linkType;
  final String? linkId;

  @override
  ConsumerState<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends ConsumerState<NewTicketScreen> {
  final _subject = TextEditingController();
  final _body = TextEditingController();
  String _topic = 'other';
  HelpLink? _picked;
  bool _none = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.linkType == 'order' || widget.linkType == 'booking') _topic = 'refund';
    if (widget.linkType == 'chat') _topic = 'behaviour';
  }

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send(AppUser user, HelpLink? link) async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final id = await ref.read(supportRepositoryProvider).create(
            user: user,
            topic: _topic,
            subject: _subject.text.trim().isEmpty ? ticketTopicLabel(context, _topic) : _subject.text.trim(),
            body: _body.text.trim(),
            linkType: link?.type ?? 'other',
            linkId: link?.id,
            linkLabel: link?.label ?? '',
          );
      if (!mounted) return;
      showToast(context, l.hpSent);
      context.pushReplacement('${helpBase(user)}/$id');
    } catch (_) {
      if (mounted) showToast(context, l.msgSendFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Scaffold(body: SkeletonList());
    final fromRoute = widget.linkType != null && widget.linkId != null;
    final routeLink = fromRoute ? ref.watch(_linkFromRouteProvider('${widget.linkType}/${widget.linkId}')).value : null;
    final recent = fromRoute ? const <HelpLink>[] : (ref.watch(_recentLinksProvider).value ?? const <HelpLink>[]);
    final link = fromRoute ? routeLink : (_none ? null : _picked);
    final ok = _body.text.trim().length >= 10;
    return Scaffold(
      appBar: AppBar(title: Text(l.hpRaise)),
      body: PageBody(maxWidth: 700, children: [
        const SizedBox(height: Space.md),
        Text(l.hpAbout, style: context.text.titleSmall),
        const SizedBox(height: Space.xs),
        if (fromRoute)
          PawCard(
            padding: const EdgeInsets.all(Space.md),
            child: Row(children: [
              Icon(linkTypeIcon(widget.linkType!), color: context.colors.primary),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(linkTypeLabel(context, widget.linkType!), style: context.text.titleSmall),
                  Text(routeLink?.label ?? '…', style: context.text.bodySmall),
                ]),
              ),
            ]),
          )
        else
          DropdownButtonFormField<String>(
            initialValue: _none ? 'none' : _picked == null ? null : '${_picked!.type}/${_picked!.id}',
            isExpanded: true,
            hint: Text(l.hpPickItem),
            items: [
              for (final r in recent)
                DropdownMenuItem(
                  value: '${r.type}/${r.id}',
                  child: Text('${linkTypeLabel(context, r.type)}: ${r.label}', maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              DropdownMenuItem(value: 'none', child: Text(l.hpSomethingElse)),
            ],
            onChanged: (v) => setState(() {
              _none = v == 'none';
              _picked = _none ? null : recent.where((r) => '${r.type}/${r.id}' == v).firstOrNull;
              if (_picked != null && _topic == 'other') _topic = 'refund';
            }),
          ),
        const SizedBox(height: Space.md),
        Text(l.hpTopic, style: context.text.titleSmall),
        const SizedBox(height: Space.xs),
        ChoiceRow<String>(
          options: ticketTopics,
          selected: _topic,
          label: (t) => ticketTopicLabel(context, t),
          onSelected: (t) => setState(() => _topic = t),
        ),
        const SizedBox(height: Space.md),
        PawTextField(label: l.hpSubject, controller: _subject, hint: ticketTopicLabel(context, _topic)),
        const SizedBox(height: Space.sm),
        PawTextField(label: l.hpDetails, controller: _body, maxLines: 5, helper: l.hpDetailsHelp, onChanged: (_) => setState(() {})),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.hpSend, icon: Icons.send_rounded, loading: _busy, onPressed: ok ? () => _send(user, link) : null),
        const SizedBox(height: Space.sm),
        Text(user.isPlus ? l.hpReplyTimePlus : l.hpReplyTime, style: context.text.bodySmall, textAlign: TextAlign.center),
      ]),
    );
  }
}

/// One ticket with the support team's replies.
class TicketScreen extends ConsumerWidget {
  const TicketScreen({super.key, required this.ticketId});
  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ticket = ref.watch(ticketProvider(ticketId));
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.hpTicketTitle)),
      body: AsyncView<Ticket?>(
        value: ticket,
        data: (t) {
          if (t == null || user == null || t.uid != user.uid) return EmptyState(title: l.admTicketMissing);
          return PageBody(maxWidth: 800, children: [
            const SizedBox(height: Space.md),
            PawCard(child: TicketSummary(ticket: t)),
            SectionHeader(l.admConversation),
            TicketThread(ticket: t, adminView: false),
            const SizedBox(height: Space.sm),
            if (t.status == 'resolved') InfoNote(l.hpResolvedNote, tone: ChipTone.success),
            const SizedBox(height: Space.sm),
            TicketComposer(
              hint: t.status == 'resolved' ? l.hpReopenHint : l.hpWriteReply,
              onSend: (text) async {
                await ref.read(supportRepositoryProvider).reply(user, t, text);
                if (context.mounted) showToast(context, l.hpSent);
              },
            ),
          ]);
        },
      ),
    );
  }
}
