import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../assistant/data/assistant_repository.dart';
import '../../booking/data/places_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../data/chat_models.dart';
import '../data/chat_repository.dart';
import '../domain/chat_rules.dart';
import 'chat_screen.dart';
import 'chat_widgets.dart';

/// Width from which the inbox and the open chat sit side by side.
const splitViewWidth = 900.0;

/// '/messages' and '/messages/:id'. Phones show the inbox or one chat;
/// wide screens show both side by side.
class MessagesHome extends ConsumerWidget {
  const MessagesHome({super.key, this.selectedId});
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final wide = context.width >= splitViewWidth;
    final user = ref.watch(currentUserProvider);
    final owner = user?.role == UserRole.owner;
    if (!wide) {
      if (selectedId != null) return ChatScreen(conversationId: selectedId!);
      return Scaffold(
        appBar: AppBar(title: Text(l.messages)),
        body: InboxPane(showAssistant: owner, onOpen: (id) => context.push('/messages/$id')),
        floatingActionButton: owner
            ? FloatingActionButton.extended(
                onPressed: () => context.push('/televet'),
                icon: const Icon(Icons.video_call_rounded),
                label: Text(l.qaAskVet),
              )
            : null,
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.messages)),
      body: Row(children: [
        SizedBox(
          width: 380,
          child: InboxPane(
            selectedId: selectedId,
            showAssistant: owner,
            onOpen: (id) => selectedId == null ? context.push('/messages/$id') : context.replace('/messages/$id'),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: selectedId == null
              ? EmptyState(title: l.msgPickChat, message: l.msgPickChatHint, scene: Scene.chat)
              : ChatScreen(key: ValueKey(selectedId), conversationId: selectedId!, embedded: true),
        ),
      ]),
    );
  }
}

/// Conversation list with search (names, pets and message text), filters
/// and the Ask PawSetu entry.
class InboxPane extends ConsumerStatefulWidget {
  const InboxPane({super.key, required this.onOpen, this.selectedId, this.showAssistant = true});
  final ValueChanged<String> onOpen;
  final String? selectedId;
  final bool showAssistant;

  @override
  ConsumerState<InboxPane> createState() => _InboxPaneState();
}

class _InboxPaneState extends ConsumerState<InboxPane> {
  final _q = TextEditingController();
  String _filter = 'all';
  List<ChatMessage> _hits = const [];
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _q.dispose();
    super.dispose();
  }

  void _onQuery(List<Conversation> convs) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final q = _q.text.trim();
      final hits = await ref.read(chatRepositoryProvider).searchMessages([for (final c in convs) c.id], q);
      if (mounted && q == _q.text.trim()) setState(() => _hits = hits);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = ref.watch(currentUserProvider);
    final inbox = ref.watch(inboxProvider);
    if (me == null) return const SizedBox.shrink();
    final q = _q.text.trim();
    return AsyncView<List<Conversation>>(
      value: inbox,
      data: (all) {
        final list = all.where((c) {
          final pass = switch (_filter) {
            'unread' => c.unreadFor(me.uid) > 0,
            'televet' => c.isTeleVet,
            'enquiry' => c.isEnquiry,
            _ => true,
          };
          return pass && matchesSearch(q, [c.titleFor(me.uid), c.petName, c.lastMessage, c.providerName, c.ownerName]);
        }).toList();
        final byId = {for (final c in all) c.id: c};
        final hits = q.length >= 2 ? _hits.where((m) => byId.containsKey(m.conversationId)).take(20).toList() : const <ChatMessage>[];
        final filters = [
          ('all', l.filterAll),
          ('unread', l.filterUnread),
          ('televet', l.teleVet),
          if (me.role != UserRole.owner) ('enquiry', l.msgEnquiries),
        ];
        return Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter, Space.xs),
            child: TextField(
              controller: _q,
              onChanged: (_) => _onQuery(all),
              decoration: InputDecoration(
                hintText: l.msgSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: q.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.msgClearSearch,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _q.clear();
                          _onQuery(all);
                        },
                      ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                isDense: true,
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.xs),
              children: [
                for (final f in filters)
                  Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: ChoiceChip(label: Text(f.$2), selected: _filter == f.$1, onSelected: (_) => setState(() => _filter = f.$1)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                if (widget.showAssistant && _filter == 'all' && q.isEmpty) const _AskPawSetuTile(),
                if (list.isEmpty && hits.isEmpty)
                  EmptyState(
                    compact: true,
                    scene: q.isEmpty ? Scene.chat : Scene.search,
                    title: q.isEmpty ? (_filter == 'all' ? l.msgEmptyTitle : l.msgEmptyFilter) : l.msgNoResults(q),
                    message: q.isEmpty && _filter == 'all' ? (me.role == UserRole.owner ? l.msgEmptyBody : l.msgEmptyPartnerBody) : null,
                    actionLabel: me.role == UserRole.owner && q.isEmpty && _filter == 'all' ? l.qaAskVet : null,
                    onAction: () => context.push('/televet'),
                  ),
                for (final c in list)
                  ConversationTile(conversation: c, me: me, selected: c.id == widget.selectedId, onTap: () => widget.onOpen(c.id)),
                if (hits.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.gutter),
                    child: SectionHeader(l.msgFoundInMessages, padding: const EdgeInsets.only(top: Space.lg, bottom: Space.xs)),
                  ),
                  for (final m in hits)
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: context.gutter),
                      leading: const Icon(Icons.chat_bubble_outline_rounded),
                      title: Text(byId[m.conversationId]!.titleFor(me.uid), maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(m.type == 'pdf' ? (m.fileName ?? '') : m.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text(chatTime(m.createdAt, context.lang), style: context.text.labelSmall),
                      onTap: () => widget.onOpen(m.conversationId),
                    ),
                ],
              ],
            ),
          ),
        ]);
      },
    );
  }
}

class _AskPawSetuTile extends ConsumerWidget {
  const _AskPawSetuTile();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final a = ref.watch(assistantAllowanceProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(context.gutter, Space.xs, context.gutter, Space.sm),
      child: PawCard(
        onTap: () => context.push('/ask'),
        color: context.paw.primaryContainer.withValues(alpha: 0.6),
        padding: const EdgeInsets.all(Space.md),
        child: Row(children: [
          CircleAvatar(backgroundColor: context.colors.primary, child: Icon(Icons.auto_awesome_rounded, color: context.colors.onPrimary)),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.aiTitle, style: context.text.titleSmall),
              Text(a.unlimited ? l.aiTileHintPlus : l.aiTileHint(a.left), style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded),
        ]),
      ),
    );
  }
}

/// One row in the inbox.
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation, required this.me, required this.onTap, this.selected = false});
  final Conversation conversation;
  final AppUser me;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = conversation;
    final unread = c.unreadFor(me.uid);
    final mine = c.lastSenderId == me.uid;
    final (IconData? icon, String text) = switch (c.lastType) {
      'photo' => (Icons.photo_rounded, l.msgPreviewPhoto),
      'voice' => (Icons.mic_rounded, l.msgPreviewVoice),
      'pdf' => (Icons.picture_as_pdf_rounded, c.lastMessage.isEmpty ? l.msgPreviewPdf : c.lastMessage),
      'prescription' => (Icons.receipt_long_rounded, l.rxSentPreview),
      'system' => (null, c.lastMessage.isEmpty ? l.msgNoMessagesYet : c.lastMessage),
      _ => (null, c.lastMessage),
    };
    final title = c.isTeleVet && c.providerName.isEmpty && me.uid == c.ownerId ? l.tvFindingVetShort : c.titleFor(me.uid);
    final bold = unread > 0;
    return Semantics(
      button: true,
      selected: selected,
      label: [title, if (unread > 0) l.msgUnreadCount(unread)].join(', '),
      child: Material(
        color: selected ? context.paw.primaryContainer.withValues(alpha: 0.5) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.md),
            child: Row(children: [
              ConversationAvatar(conversation: c, viewerUid: me.uid),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(
                      child: Text(title,
                          style: context.text.titleSmall?.copyWith(fontWeight: bold ? FontWeight.w800 : FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: Space.sm),
                    Text(chatTime(c.lastAt, context.lang),
                        style: context.text.labelSmall?.copyWith(color: bold ? context.colors.primary : null, fontWeight: bold ? FontWeight.w700 : null)),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    if (c.isTeleVet) ...[StatusChip(l.teleVet, tone: ChipTone.accent), const SizedBox(width: 6)],
                    if (c.isEnquiry) ...[StatusChip(l.msgEnquiry, tone: ChipTone.info), const SizedBox(width: 6)],
                    if (icon != null) ...[Icon(icon, size: 16, color: context.paw.textSecondary), const SizedBox(width: 4)],
                    Expanded(
                      child: Text(
                        [if (mine && c.lastType != 'system') l.msgYouPrefix, if (c.petName.isNotEmpty && me.uid != c.ownerId) c.petName, text]
                            .where((s) => s.isNotEmpty)
                            .join(' · '),
                        style: context.text.bodySmall?.copyWith(color: bold ? context.paw.textPrimary : null),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (c.mutedFor(me.uid)) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.notifications_off_rounded, size: 16, color: context.paw.textSecondary, semanticLabel: l.msgMuted),
                    ],
                    if (unread > 0) ...[
                      const SizedBox(width: 6),
                      Badge.count(count: unread, backgroundColor: context.colors.primary, textColor: context.colors.onPrimary),
                    ],
                  ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// `/messages/new?booking=<id>` (or `?place=<id>` for an enquiry): finds or
/// creates the conversation, then opens it.
class NewConversationScreen extends ConsumerStatefulWidget {
  const NewConversationScreen({super.key, this.bookingId, this.placeId});
  final String? bookingId;
  final String? placeId;

  @override
  ConsumerState<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends ConsumerState<NewConversationScreen> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    setState(() => _failed = false);
    final me = ref.read(currentUserProvider);
    if (me == null) return;
    final repo = ref.read(chatRepositoryProvider);
    try {
      String id;
      if (widget.bookingId != null) {
        id = await repo.openForBooking(widget.bookingId!, me);
      } else if (widget.placeId != null) {
        final place = await ref.read(placesRepositoryProvider).watchPlace(widget.placeId!).first;
        if (place == null) throw StateError('place not found');
        final pet = ref.read(selectedPetProvider);
        id = await repo.openEnquiry(
          me: me,
          placeId: place.id,
          placeName: place.name,
          kind: place.kind,
          placeUid: place.ownerUid,
          placePhone: place.phone,
          petId: pet?.id,
          petName: pet?.name,
          petSpecies: pet?.species,
        );
      } else {
        throw StateError('nothing to open');
      }
      if (mounted) context.replace('/messages/$id');
    } catch (e) {
      debugPrint('Open conversation failed: $e');
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.messages)),
      body: _failed
          ? ErrorState(onRetry: _open)
          : Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const CircularProgressIndicator(),
                const SizedBox(height: Space.md),
                Text(l.msgOpening),
              ]),
            ),
    );
  }
}

/// Partner portal "Chat inbox" section: list + open chat side by side on
/// wide screens; on phones a chat opens full screen.
class PartnerChatSection extends ConsumerStatefulWidget {
  const PartnerChatSection({super.key});
  @override
  ConsumerState<PartnerChatSection> createState() => _PartnerChatSectionState();
}

class _PartnerChatSectionState extends ConsumerState<PartnerChatSection> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return LayoutBuilder(builder: (context, box) {
      if (box.maxWidth < 760) {
        return InboxPane(showAssistant: false, onOpen: (id) => context.push('/messages/$id'));
      }
      return Row(children: [
        SizedBox(
          width: 360,
          child: InboxPane(showAssistant: false, selectedId: _selected, onOpen: (id) => setState(() => _selected = id)),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selected == null
              ? EmptyState(title: l.msgPickChat, message: l.msgPickChatHintPartner, scene: Scene.chat)
              : ChatScreen(key: ValueKey(_selected), conversationId: _selected!, embedded: true),
        ),
      ]);
    });
  }
}
