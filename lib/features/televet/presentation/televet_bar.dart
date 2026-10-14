import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../data/consultation.dart';
import '../data/televet_repository.dart';

/// Status strip above a tele-vet chat: waiting, who the vet is, allowance
/// left, video call, prescription and rating.
class TeleVetBar extends ConsumerWidget {
  const TeleVetBar({super.key, required this.consultation, required this.me});
  final Consultation consultation;
  final AppUser me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = consultation;
    final isOwner = me.uid == c.ownerId;
    final now = DateTime.now();
    final lang = context.lang;

    Widget strip({required Widget leading, required String title, String? subtitle, List<Widget> trailing = const [], Color? color}) => Material(
          color: color ?? context.colors.surfaceContainerLow,
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter - 4, Space.sm),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: LayoutBuilder(builder: (context, box) => Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      leading,
                      const SizedBox(width: Space.md),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: (box.maxWidth - 56).clamp(80, 640)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                          Text(title, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                          if (subtitle != null) Text(subtitle, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                    ]),
                    if (trailing.isNotEmpty) Wrap(spacing: Space.sm, runSpacing: Space.xs, children: trailing),
                  ],
                )),
              ),
            ),
          ),
        );

    if (!isOwner) {
      return strip(
        leading: CircleAvatar(backgroundColor: context.paw.primaryContainer, child: Icon(Icons.medical_services_rounded, color: context.colors.primary)),
        title: l.tvVetBarTitle(c.petName, c.ownerName),
        subtitle: c.isQueued ? l.tvStatusQueued : (c.isEnded ? l.tvStatusEnded : l.tvStatusActive),
        trailing: [
          FilledButton.tonalIcon(
            onPressed: () => context.push('/partner/consult/${c.id}'),
            icon: const Icon(Icons.medical_information_rounded),
            label: Text(l.tvOpenVetTools),
          ),
        ],
      );
    }

    if (c.isQueued) {
      final scheduled = c.scheduledAt != null && c.scheduledAt!.isAfter(now);
      return strip(
        leading: scheduled
            ? Icon(Icons.schedule_rounded, color: context.colors.primary)
            : SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: context.colors.primary)),
        title: scheduled ? l.tvScheduledTitle(Fmt.dateTime(c.scheduledAt!, lang)) : l.tvFindingVet(c.petName),
        subtitle: scheduled ? l.tvScheduledHint : l.tvFindingVetHint,
        trailing: [if (c.priority) StatusChip(l.tvPriority, tone: ChipTone.accent, icon: Icons.bolt_rounded)],
      );
    }

    if (c.isEnded) {
      return strip(
        leading: Icon(Icons.check_circle_rounded, color: context.paw.success),
        title: l.tvEndedWith(c.vetName),
        subtitle: c.endedAt == null ? null : Fmt.dateTime(c.endedAt!, lang),
        trailing: [
          if (c.prescriptionId != null)
            FilledButton.tonalIcon(
              onPressed: () => context.push('/prescriptions/${c.prescriptionId}'),
              icon: const Icon(Icons.receipt_long_rounded),
              label: Text(l.rxView),
            ),
          if (c.rating == null)
            FilledButton.icon(onPressed: () => showRateSheet(context, ref, c, me), icon: const Icon(Icons.star_rounded), label: Text(l.tvRate))
          else
            StatusChip('★ ${c.rating}', tone: ChipTone.accent),
        ],
      );
    }

    final closed = c.closedFor(now);
    final limits = c.limits;
    return strip(
      leading: CircleAvatar(
        backgroundColor: context.paw.accent.withValues(alpha: 0.25),
        child: Text(c.vetName.replaceAll('Dr. ', '').characters.firstOrNull ?? 'V', style: context.text.titleMedium),
      ),
      title: c.vetName,
      subtitle: [
        if (c.clinicName.isNotEmpty) c.clinicName,
        if (c.endsAt != null) (closed ? l.tvClosedShort : l.tvOpenUntil(Fmt.time(c.endsAt!, lang))),
      ].join(' · '),
      trailing: [
        StatusChip(
          l.tvMessagesLeft(c.messagesLeft),
          tone: c.messagesLeft == 0 ? ChipTone.error : (c.messagesLeft <= (limits.messages / 4).ceil() ? ChipTone.warning : ChipTone.info),
          icon: Icons.chat_bubble_outline_rounded,
        ),
        FilledButton.icon(
          onPressed: () {
            if (!me.isPlus && !c.isVideo) {
              showPlusPrompt(context, title: l.tvVideoPlusTitle, body: l.plusPerkVideo);
              return;
            }
            context.push('/televet/call/${c.id}');
          },
          icon: const Icon(Icons.videocam_rounded),
          label: Text(l.tvVideoCall),
        ),
      ],
    );
  }
}

/// Stars + a short comment after a consultation (spec 7.7).
Future<void> showRateSheet(BuildContext context, WidgetRef ref, Consultation c, AppUser me) async {
  var stars = 5;
  final text = TextEditingController();
  final ok = await showPawSheet<bool>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, set) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.tvRateTitle(c.vetName), style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 1; i <= 5; i++)
            IconButton(
              tooltip: l.tvStars(i),
              iconSize: 36,
              onPressed: () => set(() => stars = i),
              icon: Icon(i <= stars ? Icons.star_rounded : Icons.star_outline_rounded, color: ctx.paw.accent),
            ),
        ]),
        const SizedBox(height: Space.md),
        PawTextField(label: l.tvRateComment, controller: text, maxLines: 3),
        PrimaryButton(label: l.tvRateSubmit, onPressed: () => Navigator.pop(ctx, true)),
      ]);
    });
  });
  if (ok == true) {
    await ref.read(teleVetRepositoryProvider).rate(c, me, stars, text.text.trim());
    if (context.mounted) showToast(context, context.l10n.tvRateThanks);
  }
  text.dispose();
}
