import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/converters.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/presentation/booking_labels.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../data/chat_models.dart';
import 'attachments.dart';
import 'voice_note.dart';
import '../../../core/theme/ph.dart';

IconData conversationIcon(Conversation c) => switch (c.type) {
      'televet' => Ph.videoCamera,
      'assistant' => Ph.sparkle,
      _ => c.providerKind == 'vet' ? Ph.firstAidKit : kindIcon(c.providerKind),
    };

/// Who a conversation is with: for pet parents the vet (a circle with
/// initials) or the place (a tile with its shopfront); for partners the pet.
class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({super.key, required this.conversation, required this.viewerUid, this.size = Sizes.tile});
  final Conversation conversation;
  final String viewerUid;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    if (viewerUid != c.ownerId) {
      return PetAvatar(species: c.petSpecies, colorTag: null, size: size, name: c.petName);
    }
    // A shape for everything (UI Design 6): a vet is a person, so a circle
    // with initials; a clinic, salon or other place is a tile with its
    // shopfront.
    if (c.isTeleVet || c.providerKind == 'vet') {
      final name = c.providerName.replaceFirst(RegExp(r'^Dr\.?\s*'), '');
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: context.paw.marigold, shape: BoxShape.circle),
        child: name.isEmpty
            ? Icon(Ph.stethoscope, size: size * Sizes.tileIcon, color: context.paw.onMarigold)
            : Text(initials(name), style: context.text.labelLarge?.copyWith(color: context.paw.onMarigold, fontFamily: FontFamilies.heading, fontWeight: FontWeight.w700)),
      );
    }
    final id = c.providerId ?? '';
    final n = (int.tryParse(id.split('_').last) ?? id.length + 1) - 1;
    return PawTile(size: size, child: SeedArt(seed: 'seed:${c.providerKind == 'clinic' ? 'clinic' : 'provider'}:$n'));
  }
}

/// "Today", "Yesterday" or a date between messages.
class DaySeparator extends StatelessWidget {
  const DaySeparator({super.key, required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final label = Fmt.sameDay(day, now)
        ? l.today
        : Fmt.sameDay(day, now.subtract(const Duration(days: 1)))
            ? l.msgYesterday
            : Fmt.weekdayDate(day, context.lang);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.xs),
          decoration: BoxDecoration(color: context.colors.surfaceContainer, borderRadius: BorderRadius.circular(Radii.full)),
          child: Text(label, style: context.text.labelSmall),
        ),
      ),
    );
  }
}

/// Three bouncing dots while the other person types.
class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key, required this.name});
  final String name;
  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      liveRegion: true,
      label: l.msgTyping(widget.name),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(top: Space.xs, bottom: Space.xs),
          padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm + Space.xxs),
          decoration: BoxDecoration(
            color: context.paw.surface,
            border: Border.all(color: context.paw.outline),
            borderRadius: BorderRadius.circular(Radii.xl),
          ),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Row(mainAxisSize: MainAxisSize.min, children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.xxs),
                  child: Transform.translate(
                    offset: Offset(0, context.reduceMotion ? 0 : -3 * math.sin((_c.value * 2 * math.pi) - i * 0.8).clamp(0, 1)),
                    child: Container(
                      width: Sizes.dot,
                      height: Sizes.dot,
                      decoration: BoxDecoration(color: context.paw.textSecondary, shape: BoxShape.circle),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// One chat message. Handles text, photo, PDF, voice note, prescription
/// and system messages.
class MessageBubble extends ConsumerWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.mine,
    this.showSender = false,
    this.highlight,
    this.recommendClinicId,
  });
  final ChatMessage message;
  final bool mine;
  final bool showSender;
  final String? highlight;
  final String? recommendClinicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = message;
    if (m.type == 'system' || m.type == 'call') return _system(context, ref);
    if (m.type == 'prescription') return _prescription(context);
    final l = context.l10n;
    final maxW = math.min(520.0, MediaQuery.sizeOf(context).width * 0.78);
    // UI Design 6: your messages are ink bubbles with paper text; the other
    // person's are white cards. Quiet text and accents switch to match.
    final paw = context.paw;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = mine ? paw.textPrimary : paw.surface;
    final fg = mine ? paw.background : paw.textPrimary;
    final quiet = mine ? (dark ? PawColors.light.textSecondary : paw.onBandMuted) : paw.textSecondary;
    final accent = mine ? (dark ? PawColors.light.accent : paw.marigold) : context.colors.primary;
    final small = context.text.labelSmall?.copyWith(color: quiet);
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(Radii.xl),
      topRight: const Radius.circular(Radii.xl),
      bottomLeft: Radius.circular(mine ? 18 : 4),
      bottomRight: Radius.circular(mine ? 4 : 18),
    );
    final read = m.readByAnyoneBut(m.senderId);
    Widget content = switch (m.type) {
      'photo' => GestureDetector(
          onTap: () => PhotoViewerScreen.open(context, m.url ?? ''),
          child: Semantics(
            button: true,
            label: l.msgPreviewPhoto,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radii.md),
              child: MediaImage(url: m.url ?? '', width: math.min(240, maxW - 24), height: math.min(240, maxW - 24)),
            ),
          ),
        ),
      'pdf' => InkWell(
          onTap: () => openChatPdf(context, ref, m),
          borderRadius: BorderRadius.circular(Radii.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.all(Space.sm),
                decoration: BoxDecoration(color: context.paw.error.withValues(alpha: Opacities.chip), borderRadius: BorderRadius.circular(Radii.md)),
                child: Icon(Ph.filePdf, color: context.paw.error),
              ),
              const SizedBox(width: Space.sm),
              Flexible(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(m.fileName ?? l.msgPreviewPdf, style: context.text.titleSmall?.copyWith(color: fg), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text([l.msgPdf, if (m.sizeBytes > 0) fileSizeLabel(m.sizeBytes), l.msgTapToOpen].join(' · '), style: small),
                ]),
              ),
            ]),
          ),
        ),
      'voice' => VoiceNotePlayer(url: m.url ?? 'seed:voice:0', durationSec: m.durationSec, color: accent),
      _ => _HighlightedText(text: m.text, query: highlight, style: context.text.bodyMedium?.copyWith(color: fg)),
    };
    if (m.type == 'text' && (m.meta['problem'] == true)) {
      content = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(l.tvProblemLabel, style: context.text.labelMedium?.copyWith(color: accent)),
        const SizedBox(height: Space.xxs),
        content,
      ]);
    }
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.xxs),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Container(
            padding: EdgeInsets.fromLTRB(m.type == 'voice' ? Space.xs : Space.md, Space.sm, Space.md, Space.xs + Space.xxs),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
              border: mine ? null : Border.all(color: context.paw.outline),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              if (showSender && !mine)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.xxs),
                  child: Text(m.senderName, style: context.text.labelMedium?.copyWith(color: context.colors.primary)),
                ),
              content,
              if (m.masked)
                Padding(
                  padding: const EdgeInsets.only(top: Space.xs),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Ph.shield, size: IconSizes.xs, color: quiet),
                    const SizedBox(width: Space.xs),
                    Flexible(child: Text(l.msgNumberHidden, style: small)),
                  ]),
                ),
              const SizedBox(height: Space.xxs),
              Row(mainAxisSize: MainAxisSize.min, children: [
                if (m.demo) ...[
                  Text(l.msgDemoReply, style: context.text.labelSmall?.copyWith(color: mine ? accent : paw.warning, fontWeight: FontWeight.w700)),
                  const SizedBox(width: Space.xs + Space.xxs),
                ],
                Text(Fmt.time(m.createdAt, context.lang), style: small),
                if (mine) ...[
                  const SizedBox(width: Space.xs),
                  Semantics(
                    label: read ? l.msgRead : l.msgSent,
                    child: Icon(read ? Ph.checks : Ph.check, size: IconSizes.sm, color: read ? accent : quiet),
                  ),
                ],
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _prescription(BuildContext context) {
    final l = context.l10n;
    final m = message;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Sizes.emptyStateWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: PawCard(
            borderColor: context.colors.primary,
            padding: const EdgeInsets.all(Space.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Icon(Ph.receipt, color: context.colors.primary),
                const SizedBox(width: Space.sm),
                Expanded(child: Text(l.rxCardTitle(m.senderName), style: context.text.titleSmall)),
              ]),
              if (m.text.isNotEmpty) ...[const SizedBox(height: Space.xs), Text(m.text, style: context.text.bodySmall)],
              const SizedBox(height: Space.sm),
              FilledButton.tonalIcon(
                onPressed: m.prescriptionId == null ? null : () => context.push('/prescriptions/${m.prescriptionId}'),
                icon: const Icon(Ph.filePdf),
                label: Text(l.rxView),
              ),
              const SizedBox(height: Space.xxs),
              Text(Fmt.time(m.createdAt, context.lang), style: context.text.labelSmall, textAlign: TextAlign.end),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _system(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = message;
    final meta = m.meta;
    String timeOf(String k) {
      final d = parseDate(meta[k]);
      return d == null ? '' : Fmt.dateTime(d, context.lang);
    }

    if (m.event == 'recommend_visit' || m.event == 'recommend_emergency') {
      final emergency = m.event == 'recommend_emergency';
      final c = emergency ? context.paw.sos : context.colors.primary;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Sizes.bubbleMaxWidth),
            child: PawCard(
              borderColor: c,
              padding: const EdgeInsets.all(Space.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Icon(emergency ? Ph.asterisk : Ph.firstAid, color: c),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Text(
                      emergency ? l.tvRecEmergencyMsg(meta['name'] as String? ?? '') : l.tvRecVisitMsg(meta['name'] as String? ?? ''),
                      style: context.text.titleSmall,
                    ),
                  ),
                ]),
                if (m.text.isNotEmpty) ...[const SizedBox(height: Space.xs), Text(m.text, style: context.text.bodySmall)],
                const SizedBox(height: Space.sm),
                if (emergency)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: context.paw.sos, foregroundColor: context.paw.onSos, iconColor: context.paw.onSos),
                    onPressed: () => openSos(context, ref),
                    icon: const Icon(Ph.asterisk),
                    label: Text(l.sosGetHelp),
                  )
                else
                  FilledButton.tonalIcon(
                    onPressed: () => context.push(recommendClinicId != null ? '/book/place/$recommendClinicId' : '/book/find/clinic'),
                    icon: const Icon(Ph.calendarCheck),
                    label: Text(l.tvBookVisit),
                  ),
              ]),
            ),
          ),
        ),
      );
    }

    final (IconData icon, String text) = switch (m.event) {
      'booking_chat' => (
          Ph.notepad,
          l.msgSysBookingChat(meta['petName'] as String? ?? '', timeOf('start')),
        ),
      'tv_started' => (
          Ph.videoCamera,
          parseDate(meta['scheduledAt']) != null ? l.msgSysTvScheduled(timeOf('scheduledAt')) : (meta['mode'] == 'video' ? l.msgSysTvStartedVideo : l.msgSysTvStarted),
        ),
      'tv_joined' => (Ph.userCheck, l.msgSysVetJoined(meta['name'] as String? ?? '', timeOf('endsAt'))),
      'tv_ended' => (Ph.checkCircleFill, l.msgSysTvEnded),
      'call_ended' => (Ph.videoCameraSlash, l.msgSysCallEnded(formatSeconds((meta['seconds'] as num?)?.toInt() ?? 0))),
      _ => (Ph.info, m.text),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.bubbleMaxWidth),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
            decoration: BoxDecoration(color: context.colors.surfaceContainer, borderRadius: BorderRadius.circular(Radii.lg)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: IconSizes.sm, color: context.paw.textSecondary),
              const SizedBox(width: Space.sm),
              Flexible(child: Text(text, style: context.text.bodySmall, textAlign: TextAlign.center)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Text with search matches highlighted.
class _HighlightedText extends StatelessWidget {
  const _HighlightedText({required this.text, required this.query, this.style});
  final String text;
  final String? query;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final q = query?.trim().toLowerCase() ?? '';
    if (q.isEmpty || !text.toLowerCase().contains(q)) return SelectableText(text, style: style);
    final spans = <TextSpan>[];
    final lower = text.toLowerCase();
    var i = 0;
    while (true) {
      final j = lower.indexOf(q, i);
      if (j < 0) {
        spans.add(TextSpan(text: text.substring(i)));
        break;
      }
      if (j > i) spans.add(TextSpan(text: text.substring(i, j)));
      spans.add(TextSpan(
        text: text.substring(j, j + q.length),
        style: TextStyle(backgroundColor: context.paw.accent.withValues(alpha: Opacities.half), fontWeight: FontWeight.w700),
      ));
      i = j + q.length;
    }
    return SelectableText.rich(TextSpan(style: style, children: spans));
  }
}

/// Safety reminder shown at the top of every chat (spec 7.8).
class ChatSafetyNote extends StatelessWidget {
  const ChatSafetyNote({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: InfoNote(context.l10n.msgSafetyNote, icon: Ph.shield),
    );
  }
}
