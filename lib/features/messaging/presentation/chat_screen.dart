import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show helpBase;
import '../../televet/data/consultation.dart';
import '../../televet/data/televet_repository.dart';
import '../../televet/presentation/televet_bar.dart';
import '../data/chat_models.dart';
import '../data/chat_repository.dart';
import '../domain/chat_rules.dart';
import 'chat_view.dart';
import 'chat_widgets.dart';

/// One conversation: header with typing status, masked call, search, mute,
/// report, block and "Get help", then the messages (spec 7.8).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId, this.embedded = false});
  final String conversationId;

  /// Shown inside the inbox split view (wide screens).
  final bool embedded;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _searching = false;
  final _search = TextEditingController();

  @override
  void didUpdateWidget(covariant ChatScreen old) {
    super.didUpdateWidget(old);
    if (old.conversationId != widget.conversationId) {
      _searching = false;
      _search.clear();
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = ref.watch(currentUserProvider);
    final conv = ref.watch(conversationProvider(widget.conversationId));
    final c = conv.value;
    if (me == null) return const SizedBox.shrink();
    if (c == null) {
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: !widget.embedded),
        body: conv.isLoading ? const SkeletonList(count: 3) : EmptyState(title: l.msgNotFound, scene: Scene.chat),
      );
    }
    final consult = c.isTeleVet ? consultationOf(ref, c) : null;
    final msgs = ref.watch(messagesProvider(c.id)).value ?? const <ChatMessage>[];
    final q = _search.text.trim();
    final hits = q.length < 2 ? 0 : msgs.where((m) => matchesSearch(q, [m.text, m.fileName])).length;
    return Scaffold(
      appBar: _searching ? _searchBar(context, hits) : _header(context, c, consult, me),
      body: Column(children: [
        if (consult != null) TeleVetBar(consultation: consult, me: me),
        Expanded(child: ChatView(conversationId: c.id, highlight: _searching ? q : null)),
      ]),
    );
  }

  PreferredSizeWidget _searchBar(BuildContext context, int hits) {
    final l = context.l10n;
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        tooltip: l.msgClose,
        icon: const Icon(Icons.close_rounded),
        onPressed: () => setState(() {
          _searching = false;
          _search.clear();
        }),
      ),
      title: TextField(
        controller: _search,
        autofocus: true,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(hintText: l.msgSearchInChat, border: InputBorder.none, filled: false),
      ),
      actions: [
        if (_search.text.trim().length >= 2)
          Padding(
            padding: const EdgeInsets.only(right: Space.lg),
            child: Center(child: Text(l.msgMatches(hits), style: context.text.labelMedium)),
          ),
      ],
    );
  }

  PreferredSizeWidget _header(BuildContext context, Conversation c, Consultation? consult, AppUser me) {
    final l = context.l10n;
    final now = DateTime.now();
    final typing = c.typingOther(me.uid, now, typingIsFresh);
    final title = c.isTeleVet && c.providerName.isEmpty && me.uid == c.ownerId ? l.tvFindingVetShort : c.titleFor(me.uid);
    final sub = typing != null
        ? l.msgTypingShort
        : [
            if (c.petName.isNotEmpty) c.petName,
            if (c.isTeleVet) l.teleVet else if (c.isEnquiry) l.msgEnquiry,
            if (me.uid != c.ownerId && c.providerName.isNotEmpty && !c.isTeleVet) c.providerName,
          ].join(' · ');
    final muted = c.mutedFor(me.uid);
    final blockedByMe = c.blockedBy.contains(me.uid);
    return AppBar(
      automaticallyImplyLeading: !widget.embedded,
      titleSpacing: widget.embedded ? Space.lg : 0,
      title: Semantics(
        button: true,
        label: l.msgChatInfo,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _info(context, c, me),
          child: Row(children: [
            ConversationAvatar(conversation: c, viewerUid: me.uid, size: 40),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(title, style: context.text.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  sub,
                  style: context.text.bodySmall?.copyWith(color: typing != null ? context.colors.primary : null, fontWeight: typing != null ? FontWeight.w700 : null),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            if (muted) Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.notifications_off_rounded, size: 18, color: context.paw.textSecondary)),
          ]),
        ),
      ),
      actions: [
        IconButton(tooltip: l.msgCallMasked, icon: const Icon(Icons.call_rounded), onPressed: () => _call(context, c, me)),
        PopupMenuButton<String>(
          tooltip: l.msgMore,
          onSelected: (v) => _menu(context, v, c, consult, me),
          itemBuilder: (_) => [
            PopupMenuItem(value: 'search', child: ListTile(leading: const Icon(Icons.search_rounded), title: Text(l.msgSearchInChat))),
            PopupMenuItem(
              value: 'mute',
              child: ListTile(
                leading: Icon(muted ? Icons.notifications_active_rounded : Icons.notifications_off_rounded),
                title: Text(muted ? l.msgUnmute : l.msgMute),
              ),
            ),
            if (c.bookingId != null)
              PopupMenuItem(value: 'booking', child: ListTile(leading: const Icon(Icons.event_note_rounded), title: Text(l.bookingDetails))),
            if (consult != null && me.role == UserRole.vet)
              PopupMenuItem(value: 'vettools', child: ListTile(leading: const Icon(Icons.medical_information_rounded), title: Text(l.tvOpenVetTools))),
            PopupMenuItem(value: 'report', child: ListTile(leading: const Icon(Icons.flag_rounded), title: Text(l.msgReport))),
            PopupMenuItem(
              value: 'block',
              child: ListTile(leading: const Icon(Icons.block_rounded), title: Text(blockedByMe ? l.msgUnblock : l.msgBlock)),
            ),
            PopupMenuItem(value: 'help', child: ListTile(leading: const Icon(Icons.support_agent_rounded), title: Text(l.msgGetHelp))),
          ],
        ),
      ],
    );
  }

  Future<void> _menu(BuildContext context, String v, Conversation c, Consultation? consult, AppUser me) async {
    final l = context.l10n;
    final repo = ref.read(chatRepositoryProvider);
    switch (v) {
      case 'search':
        setState(() => _searching = true);
      case 'mute':
        final mute = !c.mutedFor(me.uid);
        await repo.setMuted(c, me.uid, mute);
        if (context.mounted) showToast(context, mute ? l.msgMutedToast : l.msgUnmutedToast);
      case 'booking':
        context.push(me.uid == c.ownerId ? '/book/bookings/${c.bookingId}' : '/partner/booking/${c.bookingId}');
      case 'vettools':
        context.push('/partner/consult/${consult!.id}');
      case 'report':
        await _report(context, c, me);
      case 'block':
        if (c.blockedBy.contains(me.uid)) {
          await repo.unblock(c, me.uid);
          if (context.mounted) showToast(context, l.msgUnblockedToast);
          return;
        }
        final ok = await confirmAction(context, title: l.msgBlockTitle(c.titleFor(me.uid)), body: l.msgBlockBody, confirmLabel: l.msgBlock);
        if (ok) {
          await repo.block(c, me.uid);
          if (context.mounted) showToast(context, l.msgBlockedToast);
        }
      case 'help':
        context.push('${helpBase(me)}/new?conversation=${c.id}');
    }
  }

  /// Calls go through a masked relay number: neither side sees the other's
  /// real number. The demo never dials.
  Future<void> _call(BuildContext context, Conversation c, AppUser me) async {
    final l = context.l10n;
    final other = me.uid == c.ownerId ? c.providerPhone : c.ownerPhone;
    final masked = maskedPhone(other ?? '+91 90000 000${c.id.length % 90 + 10}');
    if (ref.read(appConfigProvider).isDemo) {
      await showDemoDialog(context, title: l.demoTitle, body: l.msgMaskedCallDemo(c.titleFor(me.uid), masked));
      return;
    }
    await showDemoDialog(context, title: l.msgCallMasked, body: l.msgMaskedCallLive);
  }

  Future<void> _report(BuildContext context, Conversation c, AppUser me) async {
    final l = context.l10n;
    var reason = 'spam';
    final details = TextEditingController();
    final reasons = {
      'spam': l.msgReasonSpam,
      'abuse': l.msgReasonAbuse,
      'payment': l.msgReasonPayment,
      'fake': l.msgReasonFake,
      'other': l.msgReasonOther,
    };
    final ok = await showPawSheet<bool>(context, builder: (ctx) {
      return StatefulBuilder(builder: (ctx, set) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.msgReportTitle, style: ctx.text.titleMedium),
          const SizedBox(height: Space.xs),
          Text(l.msgReportHint, style: ctx.text.bodySmall),
          const SizedBox(height: Space.md),
          RadioGroup<String>(
            groupValue: reason,
            onChanged: (v) => set(() => reason = v ?? reason),
            child: Column(children: [
              for (final e in reasons.entries) RadioListTile<String>(value: e.key, title: Text(e.value), contentPadding: EdgeInsets.zero),
            ]),
          ),
          PawTextField(label: l.msgReportDetails, controller: details, maxLines: 3),
          PrimaryButton(label: l.msgReportSend, icon: Icons.flag_rounded, onPressed: () => Navigator.pop(ctx, true)),
        ]);
      });
    });
    if (ok == true) {
      await ref.read(chatRepositoryProvider).report(c, me, reason, details.text.trim());
      if (context.mounted) showToast(context, l.msgReportedToast);
    }
    details.dispose();
  }

  void _info(BuildContext context, Conversation c, AppUser me) {
    final l = context.l10n;
    showPawSheet<void>(context, builder: (ctx) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.msgChatInfo, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        for (final p in c.participantIds)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: ctx.paw.primaryContainer,
              child: Icon(p == c.ownerId ? Icons.person_rounded : Icons.storefront_rounded, color: ctx.colors.primary),
            ),
            title: Text(p == me.uid ? l.msgYou(c.nameOf(p)) : c.nameOf(p)),
            subtitle: Text(maskedPhone(p == c.ownerId ? c.ownerPhone : c.providerPhone)),
          ),
        if (c.petName.isNotEmpty)
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.pets_rounded), title: Text(c.petName)),
        const SizedBox(height: Space.sm),
        InfoNote(l.msgMaskedInfo, icon: Icons.shield_rounded),
      ]);
    });
  }
}
