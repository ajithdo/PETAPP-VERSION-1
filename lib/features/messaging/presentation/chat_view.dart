import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/paging.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../assistant/domain/assistant_engine.dart';
import '../../assistant/presentation/assistant_labels.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../../televet/data/consultation.dart';
import '../../televet/data/televet_repository.dart';
import '../../televet/domain/televet_rules.dart';
import '../data/chat_models.dart';
import '../data/chat_repository.dart';
import '../domain/chat_rules.dart';
import 'attachments.dart';
import 'chat_widgets.dart';
import 'voice_note.dart';

/// Message list + composer for any conversation. Tele-vet messages go
/// through the tele-vet backend so plan limits apply (spec 7.7).
class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key, required this.conversationId, this.highlight});
  final String conversationId;
  final String? highlight;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  VoiceRecorder? _recorder;
  bool _sending = false;
  String? _redFlag;
  int _markedCount = -1;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onTyping);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onTyping);
    _ctrl.dispose();
    _focus.dispose();
    _recorder?.dispose();
    super.dispose();
  }

  void _onTyping() {
    setState(() {});
    final me = ref.read(currentUserProvider);
    if (me == null || _ctrl.text.trim().isEmpty) return;
    ref.read(chatRepositoryProvider).setTyping(widget.conversationId, me.uid, throttle: true).catchError((_) {});
  }

  void _markRead(Conversation c, List<ChatMessage> msgs, String uid) {
    final unreadMsgs = msgs.where((m) => m.senderId != uid && !m.readBy.contains(uid)).toList();
    final key = msgs.length * 1000 + unreadMsgs.length + c.unreadFor(uid);
    if (key == _markedCount || (unreadMsgs.isEmpty && c.unreadFor(uid) == 0)) return;
    _markedCount = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatRepositoryProvider).markRead(c, uid, unreadMsgs).catchError((Object e) => debugPrint('markRead: $e'));
    });
  }

  /// Sends through the right path. Returns false when a tele-vet limit
  /// stopped the message (a friendly notice was shown instead).
  Future<bool> _deliver(
    Conversation c,
    Consultation? consult,
    AppUser me, {
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
  }) async {
    if (c.isTeleVet && consult != null) {
      final check = await ref.read(teleVetBackendProvider).send(consult, me,
          type: type, text: text, url: url, fileName: fileName, sizeBytes: sizeBytes, durationSec: durationSec);
      if (!check.ok) {
        if (mounted && check.block != TeleVetBlock.empty) await showTeleVetLimitNotice(context, check, consult, me);
        return false;
      }
      return true;
    }
    await ref.read(chatRepositoryProvider).send(c, me,
        type: type, text: text, url: url, fileName: fileName, sizeBytes: sizeBytes, durationSec: durationSec);
    return true;
  }

  Future<void> _sendText(Conversation c, Consultation? consult, AppUser me) async {
    final l = context.l10n;
    final text = _ctrl.text.trim();
    if (text.isEmpty || _sending) return;
    if (looksLikePaymentDetails(text)) {
      final ok = await confirmAction(context, title: l.msgPaymentWarnTitle, body: l.msgPaymentWarnBody, confirmLabel: l.msgSendAnyway);
      if (!ok) return;
    }
    setState(() => _sending = true);
    try {
      final sent = await _deliver(c, consult, me, text: text);
      if (!sent) return;
      _ctrl.clear();
      if (maskPhoneNumbers(text).masked && mounted) showToast(context, l.msgNumberHiddenToast);
      if (c.isTeleVet && me.uid == c.ownerId) {
        final flag = detectRedFlag(text);
        if (flag != null && mounted) setState(() => _redFlag = flag);
      }
    } catch (e) {
      debugPrint('Send failed: $e');
      if (mounted) showToast(context, l.msgSendFailed);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _attach(Conversation c, Consultation? consult, AppUser me) async {
    final l = context.l10n;
    final picked = await pickChatAttachment(context);
    if (picked == null || !mounted) return;
    final (type, f) = picked;
    setState(() => _sending = true);
    try {
      final url = await ref.read(chatRepositoryProvider).upload(f.bytes, uid: me.uid, name: f.name, contentType: f.contentType);
      await _deliver(c, consult, me, type: type, url: url, fileName: type == 'pdf' ? f.name : null, sizeBytes: f.bytes.length);
    } catch (e) {
      debugPrint('Attach failed: $e');
      if (mounted) showToast(context, l.msgSendFailed);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _startRecording() async {
    final l = context.l10n;
    final rec = VoiceRecorder();
    final ok = await rec.start();
    if (!mounted) return;
    if (!ok) {
      final demo = ref.read(appConfigProvider).isDemo;
      if (!demo) {
        rec.dispose();
        showToast(context, l.msgMicUnavailable);
        return;
      }
      final useDemo = await confirmAction(context, title: l.msgMicUnavailableTitle, body: l.msgMicDemoBody, confirmLabel: l.msgRecordDemo, danger: false);
      if (!useDemo || !mounted) {
        rec.dispose();
        return;
      }
      rec.startDemo();
    }
    HapticFeedback.mediumImpact();
    setState(() => _recorder = rec);
  }

  Future<void> _finishRecording(Conversation c, Consultation? consult, AppUser me) async {
    final rec = _recorder;
    if (rec == null) return;
    setState(() {
      _recorder = null;
      _sending = true;
    });
    try {
      final out = await rec.stop();
      if (out == null) return;
      final url = await ref.read(chatRepositoryProvider).upload(out.bytes, uid: me.uid, name: 'voice.wav', contentType: 'audio/wav');
      await _deliver(c, consult, me, type: 'voice', url: url, durationSec: out.seconds, sizeBytes: out.bytes.length);
    } catch (e) {
      debugPrint('Voice note failed: $e');
      if (mounted) showToast(context, context.l10n.msgSendFailed);
    } finally {
      rec.dispose();
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _cancelRecording() async {
    final rec = _recorder;
    setState(() => _recorder = null);
    await rec?.cancel();
    rec?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = ref.watch(currentUserProvider);
    final conv = ref.watch(conversationProvider(widget.conversationId));
    final msgs = ref.watch(messagesProvider(widget.conversationId));
    if (me == null) return const SizedBox.shrink();
    return AsyncView<Conversation?>(
      value: conv,
      data: (c) {
        if (c == null) return EmptyState(title: l.msgNotFound, scene: Scene.chat);
        final consult = c.isTeleVet ? consultationOf(ref, c) : null;
        final list = msgs.value ?? const <ChatMessage>[];
        _markRead(c, list, me.uid);
        final now = DateTime.now();
        final typing = c.typingOther(me.uid, now, typingIsFresh);
        final group = c.participantIds.length > 2;
        // Newest at the bottom: build oldest → newest, then reverse.
        final limitKey = 'chat:${widget.conversationId}';
        final items = <Widget>[
          if (mayHaveMore(list.length, ref.watch(listLimitProvider(limitKey))))
            ShowMoreButton(
              label: l.showEarlierMessages,
              icon: Icons.expand_less_rounded,
              onPressed: () => ref.read(listLimitProvider(limitKey).notifier).more(),
            )
          else
            const ChatSafetyNote(),
        ];
        DateTime? lastDay;
        for (final m in list) {
          if (lastDay == null || !Fmt.sameDay(lastDay, m.createdAt)) {
            items.add(DaySeparator(day: m.createdAt));
            lastDay = m.createdAt;
          }
          items.add(MessageBubble(
            key: ValueKey(m.id),
            message: m,
            mine: m.senderId == me.uid,
            showSender: group,
            highlight: widget.highlight,
            recommendClinicId: consult?.clinicId,
          ));
        }
        if (typing != null) items.add(TypingBubble(name: c.nameOf(typing)));
        return Column(children: [
          Expanded(
            child: msgs.isLoading && list.isEmpty
                ? const SkeletonList(count: 3, itemHeight: 56)
                : ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.sm),
                    itemCount: items.length,
                    itemBuilder: (_, i) => Center(
                      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 860), child: items[items.length - 1 - i]),
                    ),
                  ),
          ),
          if (_redFlag != null) _RedFlagBanner(flag: _redFlag!, petName: c.petName, onClose: () => setState(() => _redFlag = null)),
          _composerArea(context, c, consult, me),
        ]);
      },
    );
  }

  Widget _composerArea(BuildContext context, Conversation c, Consultation? consult, AppUser me) {
    final l = context.l10n;
    Widget banner(String text, {String? action, VoidCallback? onAction, IconData icon = Icons.lock_rounded}) => _Banner(
          text: text,
          icon: icon,
          action: action,
          onAction: onAction,
        );
    if (c.blockedBy.contains(me.uid)) {
      return banner(l.msgYouBlocked, action: l.msgUnblock, onAction: () => ref.read(chatRepositoryProvider).unblock(c, me.uid), icon: Icons.block_rounded);
    }
    if (c.isBlocked) return banner(l.msgBlockedByOther, icon: Icons.block_rounded);
    final isOwner = me.uid == c.ownerId;
    if (consult != null) {
      if (consult.isEnded) return banner(l.tvEndedBanner, icon: Icons.check_circle_rounded);
      if (isOwner && consult.closedFor(DateTime.now())) {
        return banner(l.tvClosedBanner(consult.limits.hours), icon: Icons.schedule_rounded);
      }
    }
    final rec = _recorder;
    final limits = consult?.limits;
    final words = countWords(_ctrl.text);
    final counted = consult != null && isOwner;
    final over = counted && words > limits!.words;
    return Material(
      color: context.paw.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(context.gutter - 8, Space.xs, context.gutter - 8, Space.sm),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (counted && limits != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Space.sm, 0, Space.sm, Space.xs),
                    child: Semantics(
                      liveRegion: over,
                      child: Text(
                        over
                            ? l.tvWordsOver(words, limits.words)
                            : l.tvAllowanceLine(words, limits.words, consult.messagesLeft),
                        style: context.text.labelSmall?.copyWith(
                          color: over
                              ? context.paw.error
                              : allowanceLow(consult.messagesLeft, limits)
                                  ? context.paw.warning
                                  : context.paw.textSecondary,
                          fontWeight: over ? FontWeight.w700 : null,
                        ),
                      ),
                    ),
                  ),
                if (rec != null)
                  RecordingBar(recorder: rec, onCancel: _cancelRecording, onSend: () => _finishRecording(c, consult, me))
                else
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    IconButton(
                      tooltip: l.msgAttach,
                      onPressed: _sending ? null : () => _attach(c, consult, me),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        focusNode: _focus,
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: l.msgTypeHint,
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.xs),
                    if (_ctrl.text.trim().isEmpty)
                      IconButton(
                        tooltip: l.msgRecordVoice,
                        onPressed: _sending ? null : _startRecording,
                        icon: const Icon(Icons.mic_rounded),
                      )
                    else
                      IconButton.filled(
                        tooltip: l.msgSend,
                        onPressed: _sending ? null : () => _sendText(c, consult, me),
                        icon: _sending
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send_rounded),
                      ),
                  ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, required this.icon, this.action, this.onAction});
  final String text;
  final IconData icon;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.md),
          child: Row(children: [
            Icon(icon, color: context.paw.textSecondary),
            const SizedBox(width: Space.md),
            Expanded(child: Text(text, style: context.text.bodyMedium)),
            if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
          ]),
        ),
      ),
    );
  }
}

/// Shown when an owner's tele-vet message mentions a red-flag symptom.
class _RedFlagBanner extends ConsumerWidget {
  const _RedFlagBanner({required this.flag, required this.petName, required this.onClose});
  final String flag;
  final String petName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Container(
      width: double.infinity,
      color: context.paw.sos.withValues(alpha: 0.1),
      padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, Space.sm, Space.sm),
      child: Row(children: [
        Icon(Icons.emergency_rounded, color: context.paw.sos),
        const SizedBox(width: Space.sm),
        Expanded(child: Text(l.aiRedFlagShort(redFlagLabel(context, flag)), style: context.text.bodySmall?.copyWith(color: context.paw.textPrimary))),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: context.paw.sos, foregroundColor: context.paw.onSos),
          onPressed: () => openSos(context, ref),
          child: Text(l.sosTitle),
        ),
        IconButton(tooltip: l.msgClose, onPressed: onClose, icon: const Icon(Icons.close_rounded)),
      ]),
    );
  }
}

/// The friendly notice when a tele-vet limit stops a message (spec 7.7:
/// "shown gently in the chat").
Future<void> showTeleVetLimitNotice(BuildContext context, TeleVetCheck check, Consultation c, AppUser me) {
  final l = context.l10n;
  final (title, body) = switch (check.block) {
    TeleVetBlock.tooManyWords => (l.tvWordsTitle(check.maxWords), l.tvWordsBody(check.words, check.maxWords)),
    TeleVetBlock.noMessagesLeft => (l.tvNoMessagesTitle(c.limits.messages), l.tvNoMessagesBody),
    TeleVetBlock.chatClosed => (l.tvClosedTitle, l.tvClosedBanner(c.limits.hours)),
    _ => (l.tvEndedTitle, l.tvEndedBanner),
  };
  return showPawSheet<void>(context, builder: (ctx) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        CircleAvatar(
          backgroundColor: ctx.paw.accent.withValues(alpha: 0.2),
          child: Icon(check.block == TeleVetBlock.tooManyWords ? Icons.short_text_rounded : Icons.chat_bubble_outline_rounded, color: ctx.paw.onAccent),
        ),
        const SizedBox(width: Space.md),
        Expanded(child: Text(title, style: ctx.text.titleMedium)),
      ]),
      const SizedBox(height: Space.md),
      Text(body, style: ctx.text.bodyMedium),
      if (!me.isPlus) ...[
        const SizedBox(height: Space.md),
        InfoNote(l.tvPlusHint, icon: Icons.workspace_premium_rounded),
      ],
      const SizedBox(height: Space.lg),
      PrimaryButton(
        label: check.block == TeleVetBlock.tooManyWords ? l.tvEditMessage : l.ok,
        onPressed: () => Navigator.pop(ctx),
      ),
      if (check.block == TeleVetBlock.noMessagesLeft || check.block == TeleVetBlock.chatClosed) ...[
        const SizedBox(height: Space.sm),
        SecondaryButton(
          label: l.tvBookVisit,
          icon: Icons.local_hospital_rounded,
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/book/find/clinic');
          },
        ),
      ],
      if (!me.isPlus)
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            showPlusPrompt(context, title: l.tvPlusPromptTitle, body: l.plusPerkVideo);
          },
          child: Text(l.seePlus),
        ),
    ]);
  });
}
