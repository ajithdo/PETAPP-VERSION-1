import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/consultation.dart';
import '../data/televet_repository.dart';
import '../domain/televet_rules.dart';
import 'televet_home_screen.dart';

/// Partner portal "Tele-vet queue" for vets (spec 7.7 and 9): waiting
/// consultations (Plus members first), my open chats and recent ones.
class VetQueueSection extends ConsumerWidget {
  const VetQueueSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final me = ref.watch(currentUserProvider)!;
    final all = ref.watch(vetConsultationsProvider);
    return AsyncView<List<Consultation>>(
      value: all,
      data: (list) {
        final now = DateTime.now();
        final queued = list.where((c) => c.isQueued).toList()
          ..sort((a, b) => compareQueue(
                aPriority: a.priority,
                aAt: a.scheduledAt ?? a.createdAt,
                bPriority: b.priority,
                bAt: b.scheduledAt ?? b.createdAt,
              ));
        final active = list.where((c) => c.isActive && c.vetUid == me.uid).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final ended = list.where((c) => c.isEnded && c.vetUid == me.uid).toList()
          ..sort((a, b) => (b.endedAt ?? b.createdAt).compareTo(a.endedAt ?? a.createdAt));
        final today = ended.where((c) => Fmt.sameDay(c.endedAt ?? c.createdAt, now)).length;
        final rx = ended.where((c) => c.prescriptionId != null).length;
        return PageBody(children: [
          const SizedBox(height: Space.md),
          Text(l.tvQueueTitle, style: context.text.headlineSmall),
          Text(l.tvQueueHint, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
          const SizedBox(height: Space.lg),
          ResponsiveGrid(minItemWidth: 200, children: [
            StatTile(label: l.tvWaiting, value: '${queued.length}', icon: Icons.hourglass_top_rounded, color: queued.isEmpty ? null : context.paw.warning),
            StatTile(label: l.tvInProgress, value: '${active.length}', icon: Icons.forum_rounded),
            StatTile(label: l.tvDoneToday, value: '$today', icon: Icons.task_alt_rounded, color: context.paw.success),
            StatTile(label: l.tvPrescriptionsWritten, value: '$rx', icon: Icons.receipt_long_rounded, color: context.paw.accent),
          ]),
          SectionHeader(l.tvWaiting),
          if (queued.isEmpty) PawCard(child: Text(l.tvQueueEmpty)),
          for (final c in queued) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: _QueueCard(consultation: c)),
          SectionHeader(l.tvInProgress),
          if (active.isEmpty) PawCard(child: Text(l.tvNoActive)),
          for (final c in active) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ConsultCard(consultation: c, partnerView: true)),
          if (ended.isNotEmpty) ...[
            SectionHeader(l.tvRecent),
            for (final c in ended.take(10)) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ConsultCard(consultation: c, partnerView: true)),
          ],
        ]);
      },
    );
  }
}

class _QueueCard extends ConsumerStatefulWidget {
  const _QueueCard({required this.consultation});
  final Consultation consultation;
  @override
  ConsumerState<_QueueCard> createState() => _QueueCardState();
}

class _QueueCardState extends ConsumerState<_QueueCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = widget.consultation;
    final now = DateTime.now();
    final waited = now.difference(c.createdAt).inMinutes;
    final scheduled = c.scheduledAt != null && c.scheduledAt!.isAfter(now);
    return PawCard(
      borderColor: c.redFlag != null ? context.paw.sos : (c.priority ? context.paw.accent : null),
      padding: const EdgeInsets.all(Space.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          PetAvatar(species: c.petSpecies, colorTag: c.pet.colorTag, photoUrl: c.pet.photoUrl, size: 44),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${c.petName} · ${c.ownerName}', style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                scheduled ? l.tvScheduledFor(Fmt.dateTime(c.scheduledAt!, context.lang)) : l.tvWaitingFor(waited),
                style: context.text.bodySmall,
              ),
            ]),
          ),
        ]),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
          if (c.priority) StatusChip(l.tvPriority, tone: ChipTone.accent, icon: Icons.bolt_rounded),
          StatusChip(c.isVideo ? l.tvModeVideo : l.tvModeChat, tone: ChipTone.info, icon: c.isVideo ? Icons.videocam_rounded : Icons.chat_rounded),
          if (c.redFlag != null) StatusChip(l.tvUrgent, tone: ChipTone.error, icon: Icons.emergency_rounded),
          if (c.vetUid != null) StatusChip(l.tvAskedForYou, tone: ChipTone.success),
        ]),
        const SizedBox(height: Space.sm),
        Text(c.problem, style: context.text.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
        const SizedBox(height: Space.md),
        Row(children: [
          Expanded(child: SecondaryButton(label: l.tvView, onPressed: () => context.push('/partner/consult/${c.id}'))),
          const SizedBox(width: Space.sm),
          Expanded(
            child: PrimaryButton(
              label: l.tvAccept,
              loading: _busy,
              onPressed: () async {
                setState(() => _busy = true);
                try {
                  await ref.read(teleVetBackendProvider).accept(c, ref.read(currentUserProvider)!);
                  if (context.mounted) context.push('/partner/consult/${c.id}');
                } catch (e) {
                  debugPrint('Accept failed: $e');
                  if (context.mounted) showToast(context, l.errorBody);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
            ),
          ),
        ]),
      ]),
    );
  }
}
