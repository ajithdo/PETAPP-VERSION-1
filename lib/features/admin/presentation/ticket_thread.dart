import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/support.dart';
import 'support_labels.dart';

/// Messages of a help ticket as chat bubbles. The viewer's side is on the
/// right: support for the admin panel, the person for the help screens.
class TicketThread extends StatelessWidget {
  const TicketThread({super.key, required this.ticket, required this.adminView});
  final Ticket ticket;
  final bool adminView;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final m in ticket.messages)
        Builder(builder: (context) {
          final mine = m.fromAdmin == adminView;
          final bg = mine ? context.paw.primaryContainer : context.colors.surfaceContainerHighest;
          return Align(
            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                margin: const EdgeInsets.only(bottom: Space.sm),
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(mine ? 16 : 4),
                    bottomRight: Radius.circular(mine ? 4 : 16),
                  ),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    if (m.fromAdmin) ...[Icon(Icons.support_agent_rounded, size: 16, color: context.colors.primary), const SizedBox(width: 4)],
                    Flexible(
                      child: Text(m.fromAdmin ? (adminView ? m.byName : l.hpSupportTeam) : m.byName,
                          style: context.text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Text(m.text, style: context.text.bodyMedium),
                  const SizedBox(height: 2),
                  Text(Fmt.dateTime(m.at, context.lang), style: context.text.labelSmall?.copyWith(color: context.paw.textSecondary)),
                ]),
              ),
            ),
          );
        }),
    ]);
  }
}

/// Subject, status, topic and what the ticket is about.
class TicketSummary extends StatelessWidget {
  const TicketSummary({super.key, required this.ticket, this.showPerson = false});
  final Ticket ticket;
  final bool showPerson;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = ticket;
    final refund = t.refund;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(t.subject, style: context.text.titleLarge),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
        StatusChip(ticketStatusLabel(context, t.status), tone: ticketStatusTone(t.status)),
        StatusChip(ticketTopicLabel(context, t.topic)),
        if (t.linkType != 'other') StatusChip(t.linkLabel.isEmpty ? linkTypeLabel(context, t.linkType) : t.linkLabel, icon: linkTypeIcon(t.linkType)),
        if (refund != null) StatusChip(l.hpRefunded(Fmt.inr((refund['amount'] as num?) ?? 0, context.lang)), tone: ChipTone.success, icon: Icons.currency_rupee_rounded),
      ]),
      const SizedBox(height: Space.xs),
      Text(
        [
          if (showPerson) t.name,
          l.hpRaisedOn(Fmt.date(t.createdAt, context.lang)),
          if (t.assignee != null && showPerson) l.admAssignedTo(t.assignee!),
        ].join(' · '),
        style: context.text.bodySmall,
      ),
    ]);
  }
}

/// A reply box with a send button.
class TicketComposer extends StatefulWidget {
  const TicketComposer({super.key, required this.onSend, this.hint, this.extra});
  final Future<void> Function(String text) onSend;
  final String? hint;

  /// Extra controls under the box (e.g. "mark as resolved").
  final Widget? extra;

  @override
  State<TicketComposer> createState() => _TicketComposerState();
}

class _TicketComposerState extends State<TicketComposer> {
  final _ctrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _busy = true);
    try {
      await widget.onSend(text);
      _ctrl.clear();
    } catch (_) {
      if (mounted) showToast(context, context.l10n.msgSendFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      PawTextField(label: widget.hint ?? l.hpWriteReply, controller: _ctrl, maxLines: 4, onChanged: (_) => setState(() {})),
      if (widget.extra != null) widget.extra!,
      const SizedBox(height: Space.sm),
      Align(
        alignment: Alignment.centerRight,
        child: PrimaryButton(
          label: l.msgSend,
          icon: Icons.send_rounded,
          expand: false,
          loading: _busy,
          onPressed: _ctrl.text.trim().isEmpty ? null : _send,
        ),
      ),
    ]);
  }
}
