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
import '../../pets/presentation/pet_labels.dart';
import 'televet_home_screen.dart';
import '../../../core/theme/ph.dart';

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
          ResponsiveGrid(minColumns: 2, minItemWidth: 200, children: [
            StatTile(label: l.tvWaiting, value: '${queued.length}', icon: Ph.hourglassHigh, color: queued.isEmpty ? null : context.paw.warning),
            StatTile(label: l.tvInProgress, value: '${active.length}', icon: Ph.chatsCircle),
            StatTile(label: l.tvDoneToday, value: '$today', icon: Ph.checkCircle, color: context.paw.success),
            StatTile(label: l.tvPrescriptionsWritten, value: '$rx', icon: Ph.receipt, color: context.paw.accent),
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

/// The first person waiting, for the vet's dashboard.
class VetQueuePeek extends ConsumerWidget {
  const VetQueuePeek({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final list = ref.watch(vetConsultationsProvider).value ?? const <Consultation>[];
    final queued = list.where((c) => c.isQueued).toList()
      ..sort((a, b) => compareQueue(aPriority: a.priority, aAt: a.scheduledAt ?? a.createdAt, bPriority: b.priority, bAt: b.scheduledAt ?? b.createdAt));
    if (queued.isEmpty) return PawPanel(child: Text(l.tvQueueEmpty, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)));
    return _QueueCard(consultation: queued.first);
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
    final paw = context.paw;
    final c = widget.consultation;
    final now = DateTime.now();
    final waited = now.difference(c.createdAt).inMinutes;
    final scheduled = c.scheduledAt != null && c.scheduledAt!.isAfter(now);
    // "Labrador, 3 yrs. Waiting 4 min. Chat"
    final about = [
      [c.pet.breedName(context.lang), petAgeLabel(context, c.pet)].where((s) => s.isNotEmpty).join(', '),
      scheduled ? l.tvScheduledFor(Fmt.dateTime(c.scheduledAt!, context.lang)) : l.tvWaitingFor(waited),
      c.isVideo ? l.tvModeVideo : l.tvModeChat,
    ].where((s) => s.isNotEmpty).join('. ');
    return PawCard(
      borderColor: c.redFlag != null ? paw.sos : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PetAvatar(species: c.petSpecies, colorTag: c.pet.colorTag, photoUrl: c.pet.photoUrl, size: Sizes.avatarMd, ring: false),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: Space.sm, runSpacing: Space.xxs, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text('${c.petName}, ${c.ownerName}', style: context.text.labelLarge),
                if (c.isPlus) PawTag(l.planPlus, kind: TagKind.plus),
                if (c.redFlag != null) PawTag(l.tvUrgent, kind: TagKind.red, icon: Ph.asteriskFill),
                if (c.vetUid != null) PawTag(l.tvAskedForYou, kind: TagKind.green),
              ]),
              Text(about, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              const SizedBox(height: Space.sm),
              Text(c.problem, style: context.text.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          PawButton(
            label: l.tvAccept,
            icon: Ph.check,
            onPressed: _busy
                ? null
                : () async {
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
          PawButton(label: l.pHistory, icon: Ph.clockCounterClockwise, kind: BtnKind.soft, onPressed: () => context.push('/partner/consult/${c.id}')),
        ]),
      ]),
    );
  }
}
