import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../assistant/presentation/assistant_labels.dart';
import '../../health/presentation/health_labels.dart';
import '../../messaging/presentation/attachments.dart';
import '../../messaging/presentation/chat_view.dart';
import '../../pets/presentation/pet_labels.dart';
import '../data/consultation.dart';
import '../data/televet_repository.dart';

/// Vet workspace for one consultation (spec 7.7): pet history panel, the
/// chat, private notes, recommendations, e-prescription and end.
class VetConsultScreen extends ConsumerWidget {
  const VetConsultScreen({super.key, required this.consultationId});
  final String consultationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final cv = ref.watch(consultationProvider(consultationId));
    return AsyncView<Consultation?>(
      value: cv,
      loading: const Scaffold(body: SkeletonList()),
      data: (c) {
        if (c == null) return Scaffold(appBar: AppBar(), body: EmptyState(title: l.notFoundTitle));
        final wide = context.width >= 1100;
        final chat = Column(children: [
          if (c.isQueued) _AcceptBanner(consultation: c),
          Expanded(child: ChatView(conversationId: c.conversationId)),
        ]);
        final actions = [
          if (c.isActive)
            IconButton(tooltip: l.tvVideoCall, onPressed: () => context.push('/televet/call/${c.id}'), icon: const Icon(Icons.videocam_rounded)),
          if (!c.isEnded)
            Padding(
              padding: const EdgeInsets.only(right: Space.sm),
              child: TextButton.icon(onPressed: () => _end(context, ref, c), icon: const Icon(Icons.task_alt_rounded), label: Text(l.tvEnd)),
            ),
        ];
        final title = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${c.petName} · ${c.ownerName}', maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(
            [c.isVideo ? l.tvModeVideo : l.tvModeChat, c.isQueued ? l.tvStatusQueuedShort : (c.isEnded ? l.tvStatusEndedShort : l.tvStatusActiveShort)].join(' · '),
            style: context.text.bodySmall,
          ),
        ]);
        if (wide) {
          return Scaffold(
            appBar: AppBar(title: title, actions: actions),
            body: Row(children: [
              SizedBox(width: 340, child: PetHistoryPanel(consultation: c)),
              const VerticalDivider(width: 1),
              Expanded(child: chat),
              const VerticalDivider(width: 1),
              SizedBox(width: 360, child: VetToolsPanel(consultation: c)),
            ]),
          );
        }
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: title,
              actions: actions,
              bottom: TabBar(tabs: [
                Tab(text: l.tvTabChat),
                Tab(text: l.tvTabHistory),
                Tab(text: l.tvTabTools),
              ]),
            ),
            body: TabBarView(children: [
              chat,
              PetHistoryPanel(consultation: c),
              VetToolsPanel(consultation: c),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _end(BuildContext context, WidgetRef ref, Consultation c) async {
    final l = context.l10n;
    final ok = await confirmAction(context, title: l.tvEndTitle, body: c.prescriptionId == null ? l.tvEndBodyNoRx : l.tvEndBody, confirmLabel: l.tvEnd, danger: false);
    if (!ok) return;
    await ref.read(teleVetBackendProvider).end(c, ref.read(currentUserProvider)!);
    if (context.mounted) showToast(context, l.tvEndedToast);
  }
}

class _AcceptBanner extends ConsumerStatefulWidget {
  const _AcceptBanner({required this.consultation});
  final Consultation consultation;
  @override
  ConsumerState<_AcceptBanner> createState() => _AcceptBannerState();
}

class _AcceptBannerState extends ConsumerState<_AcceptBanner> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: context.paw.accent.withValues(alpha: 0.15),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.sm),
        child: Row(children: [
          Expanded(child: Text(l.tvAcceptHint(widget.consultation.petName), style: context.text.bodyMedium)),
          const SizedBox(width: Space.sm),
          PrimaryButton(
            label: l.tvAccept,
            expand: false,
            loading: _busy,
            onPressed: () async {
              setState(() => _busy = true);
              try {
                await ref.read(teleVetBackendProvider).accept(widget.consultation, ref.read(currentUserProvider)!);
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
          ),
        ]),
      ),
    );
  }
}

/// Pet details, problem, and (Plus) the full health history.
class PetHistoryPanel extends ConsumerWidget {
  const PetHistoryPanel({super.key, required this.consultation});
  final Consultation consultation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = consultation;
    final pet = c.pet;
    final lang = context.lang;
    final full = c.isPlus;
    final events = full ? (ref.watch(petEventsForVetProvider(c.petId)).value ?? const <Map<String, dynamic>>[]) : const <Map<String, dynamic>>[];
    final vaccines = full ? (ref.watch(petVaccinesForVetProvider(c.petId)).value ?? const <Map<String, dynamic>>[]) : const <Map<String, dynamic>>[];
    Widget kv(String k, String v) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 96, child: Text(k, style: context.text.bodySmall)),
            Expanded(child: Text(v.isEmpty ? '–' : v, style: context.text.bodyMedium)),
          ]),
        );
    return ListView(padding: const EdgeInsets.all(Space.lg), children: [
      Row(children: [
        PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 56),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(pet.name, style: context.text.titleLarge),
            Text([speciesLabel(context, pet.species), pet.breedName(lang)].where((s) => s.isNotEmpty).join(' · '), style: context.text.bodySmall),
          ]),
        ),
      ]),
      const SizedBox(height: Space.md),
      kv(l.age, petAgeLabel(context, pet)),
      kv(l.weight, pet.weightKg == null ? '' : Fmt.weight(pet.weightKg!, grams: pet.isBird)),
      kv(l.gender, genderLabel(context, pet.gender)),
      kv(l.neutered, pet.neutered ? l.yes : l.no),
      kv(l.owner, c.ownerName),
      const SizedBox(height: Space.sm),
      Text(l.allergies, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      if (pet.allergies.isEmpty)
        Text(l.noKnownAllergies, style: context.text.bodySmall)
      else
        Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [for (final a in pet.allergies) StatusChip(a, tone: ChipTone.error)]),
      SectionHeader(l.tvProblemLabel),
      if (c.redFlag != null) ...[
        StatusChip(l.tvUrgentSign(redFlagLabel(context, c.redFlag!)), tone: ChipTone.error, icon: Icons.emergency_rounded),
        const SizedBox(height: Space.xs),
      ],
      Text(c.problem, style: context.text.bodyMedium),
      if (c.photos.isNotEmpty) ...[
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          for (final p in c.photos)
            InkWell(
              onTap: () => PhotoViewerScreen.open(context, p),
              child: ClipRRect(borderRadius: BorderRadius.circular(10), child: MediaImage(url: p, width: 72, height: 72)),
            ),
        ]),
      ],
      if (!full) ...[
        const SizedBox(height: Space.lg),
        InfoNote(l.tvFreeContext),
      ] else ...[
        if ((pet.dietType ?? '').isNotEmpty || (pet.temperament ?? '').isNotEmpty) ...[
          const SizedBox(height: Space.md),
          kv(l.dietType, pet.dietType ?? ''),
          kv(l.tvTemperament, pet.temperament ?? ''),
        ],
        SectionHeader(l.medicines),
        if (c.medicines.isEmpty) Text(l.tvNone, style: context.text.bodySmall),
        for (final m in c.medicines)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.medication_rounded),
            title: Text(m['name'] as String? ?? ''),
            subtitle: Text([m['dose'], m['unit']].whereType<String>().join(' ')),
          ),
        SectionHeader(l.vaccinations),
        if (vaccines.isEmpty) Text(l.tvNone, style: context.text.bodySmall),
        for (final v in vaccines.take(6))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.vaccines_rounded),
            title: Text(v['name'] as String? ?? ''),
            subtitle: Text(parseDate(v['givenDate']) == null ? '' : Fmt.date(parseDate(v['givenDate'])!, lang)),
          ),
        SectionHeader(l.tvRecentHealth),
        if (events.isEmpty) Text(l.tvNone, style: context.text.bodySmall),
        for (final e in events.take(8))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(switch (e['type']) {
              'symptom' => Icons.sick_rounded,
              'vet_visit' => Icons.local_hospital_rounded,
              'deworming' => Icons.bug_report_rounded,
              _ => Icons.event_note_rounded,
            }),
            title: Text(e['type'] == 'symptom' ? symptomLabel(context, e['symptom'] as String?) : (e['title'] as String? ?? '')),
            subtitle: Text([
              if (parseDate(e['date']) != null) Fmt.date(parseDate(e['date'])!, lang),
              if ((e['diagnosis'] as String?)?.isNotEmpty == true) e['diagnosis'] as String,
              if ((e['notes'] as String?)?.isNotEmpty == true) e['notes'] as String,
            ].join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
      ],
    ]);
  }
}

/// Private notes, recommendations, e-prescription and end.
class VetToolsPanel extends ConsumerStatefulWidget {
  const VetToolsPanel({super.key, required this.consultation});
  final Consultation consultation;
  @override
  ConsumerState<VetToolsPanel> createState() => _VetToolsPanelState();
}

class _VetToolsPanelState extends ConsumerState<VetToolsPanel> {
  late final _notes = TextEditingController(text: widget.consultation.privateNotes);
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _recommend(String kind) async {
    final l = context.l10n;
    final c = widget.consultation;
    final me = ref.read(currentUserProvider)!;
    final emergency = kind == 'emergency';
    final ok = await confirmAction(
      context,
      title: emergency ? l.tvRecEmergency : l.tvRecVisit,
      body: emergency ? l.tvRecEmergencyConfirm(c.ownerName) : l.tvRecVisitConfirm(c.ownerName),
      confirmLabel: l.tvSend,
      danger: emergency,
    );
    if (!ok) return;
    await ref.read(teleVetRepositoryProvider).setRecommendation(c.id, emergency ? 'emergency' : 'in_person');
    await ref.read(teleVetBackendProvider).send(c, me,
        type: 'system', event: emergency ? 'recommend_emergency' : 'recommend_visit', meta: {'name': c.vetName.isEmpty ? me.name : c.vetName});
    if (mounted) showToast(context, l.tvRecSent);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = widget.consultation;
    return ListView(padding: const EdgeInsets.all(Space.lg), children: [
      Text(l.tvPrivateNotes, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Text(l.tvPrivateNotesHint, style: context.text.bodySmall),
      const SizedBox(height: Space.sm),
      TextField(controller: _notes, minLines: 4, maxLines: 10, decoration: InputDecoration(hintText: l.tvNotesPlaceholder)),
      const SizedBox(height: Space.sm),
      SecondaryButton(
        label: _saving ? l.loading : l.save,
        icon: Icons.save_rounded,
        onPressed: _saving
            ? null
            : () async {
                setState(() => _saving = true);
                await ref.read(teleVetRepositoryProvider).saveNotes(c.id, _notes.text.trim());
                if (mounted && context.mounted) {
                  setState(() => _saving = false);
                  showToast(context, l.saved);
                }
              },
      ),
      SectionHeader(l.rxTitle),
      if (c.prescriptionId != null) ...[
        PawCard(
          color: context.paw.success.withValues(alpha: 0.08),
          padding: const EdgeInsets.all(Space.md),
          child: Row(children: [
            Icon(Icons.check_circle_rounded, color: context.paw.success),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(l.rxSaved(c.petName))),
          ]),
        ),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: l.rxView, icon: Icons.picture_as_pdf_rounded, onPressed: () => context.push('/prescriptions/${c.prescriptionId}')),
      ] else
        PrimaryButton(
          label: l.rxWrite,
          icon: Icons.edit_note_rounded,
          onPressed: c.isQueued ? null : () => context.push('/partner/consult/${c.id}/prescription'),
        ),
      SectionHeader(l.tvRecommend),
      SecondaryButton(label: l.tvRecVisit, icon: Icons.local_hospital_rounded, onPressed: c.isEnded || c.isQueued ? null : () => _recommend('visit')),
      const SizedBox(height: Space.sm),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(foregroundColor: context.paw.sos, side: BorderSide(color: context.paw.sos)),
        onPressed: c.isEnded || c.isQueued ? null : () => _recommend('emergency'),
        icon: const Icon(Icons.emergency_rounded),
        label: Text(l.tvRecEmergency),
      ),
      if (c.recommendation != null) ...[
        const SizedBox(height: Space.sm),
        Text(c.recommendation == 'emergency' ? l.tvRecDoneEmergency : l.tvRecDoneVisit, style: context.text.bodySmall),
      ],
      const SizedBox(height: Space.lg),
      InfoNote(l.tvVetSafetyNote),
    ]);
  }
}
