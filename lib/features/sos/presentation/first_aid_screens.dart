import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../shell/presentation/sos_launcher.dart';
import 'safety_labels.dart';

/// First-aid guides (spec 7.14). Everything is in the app itself, so the
/// guides open without internet.
class FirstAidListScreen extends ConsumerWidget {
  const FirstAidListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.firstAidTitle),
        actions: [Padding(padding: const EdgeInsets.only(right: Space.md), child: SosButton(onActivate: () => openSos(context, ref)))],
      ),
      body: PageBody(maxWidth: Space.readingWidth, children: [
        const SizedBox(height: Space.md),
        InfoNote(l.firstAidEmergencyNote, icon: Icons.emergency_outlined, tone: ChipTone.error),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
          StatusChip(l.firstAidOffline, tone: ChipTone.info, icon: Icons.offline_bolt_outlined),
          const DraftLabel(),
        ]),
        safetyGap,
        ResponsiveGrid(minItemWidth: 300, children: [
          for (final id in firstAidIds) _GuideTile(id: id),
        ]),
        safetyGap,
        PawCard(
          onTap: () => context.push('/toxic-check'),
          child: Row(children: [
            Icon(Icons.no_food_outlined, color: context.paw.warning, size: IconSizes.xl),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.toxTitle, style: context.text.titleMedium),
                Text(l.toxTileHint, style: context.text.bodySmall),
              ]),
            ),
            const Icon(Icons.chevron_right_outlined),
          ]),
        ),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}

class _GuideTile extends StatelessWidget {
  const _GuideTile({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final t = firstAidText(context.l10n, id);
    return PawCard(
      onTap: () => context.push('/first-aid/$id'),
      semanticLabel: t.title,
      child: Row(children: [
        CircleAvatar(
          radius: Sizes.avatarMd / 2,
          backgroundColor: context.paw.sosContainer,
          child: Icon(firstAidIcon(id), color: context.paw.sos),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.title, style: context.text.titleMedium),
            Text(t.signs, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodySmall),
          ]),
        ),
        const Icon(Icons.chevron_right_outlined),
      ]),
    );
  }
}

class FirstAidGuideScreen extends ConsumerWidget {
  const FirstAidGuideScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = firstAidText(l, firstAidIds.contains(id) ? id : 'choking');
    Widget heading(IconData icon, String text, Color color) => Padding(
          padding: const EdgeInsets.only(top: Space.lg, bottom: Space.sm),
          child: Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(text, style: context.text.titleMedium)),
          ]),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(t.title),
        actions: [Padding(padding: const EdgeInsets.only(right: Space.md), child: SosButton(onActivate: () => openSos(context, ref)))],
      ),
      body: PageBody(maxWidth: Space.formWidth, children: [
        const SizedBox(height: Space.md),
        const DraftLabel(),
        heading(Icons.visibility_outlined, l.firstAidSigns, context.colors.primary),
        Text(t.signs, style: context.text.bodyLarge),
        heading(Icons.checklist_outlined, l.firstAidWhatToDo, context.paw.success),
        PawCard(
          child: Column(children: [
            for (var i = 0; i < t.steps.length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: i == t.steps.length - 1 ? 0 : Space.md),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CircleAvatar(
                    radius: Sizes.avatarXs / 2,
                    backgroundColor: context.colors.primary,
                    child: Text('${i + 1}', style: context.text.labelLarge?.copyWith(color: context.colors.onPrimary)),
                  ),
                  const SizedBox(width: Space.md),
                  Expanded(child: Text(t.steps[i], style: context.text.bodyLarge)),
                ]),
              ),
          ]),
        ),
        heading(Icons.block_outlined, l.firstAidAvoid, context.paw.error),
        for (final a in t.avoid)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.close_outlined, size: IconSizes.md, color: context.paw.error),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(a, style: context.text.bodyLarge)),
            ]),
          ),
        heading(Icons.local_hospital_outlined, l.firstAidWhenVet, context.paw.sos),
        InfoNote(t.vet, icon: Icons.local_hospital_outlined, tone: ChipTone.error),
        safetyGap,
        PrimaryButton(label: l.sosGetHelp, icon: Icons.emergency_outlined, danger: true, onPressed: () => openSos(context, ref)),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: l.firstAidTalkToVet, icon: Icons.video_call_outlined, onPressed: () => context.push('/televet')),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}
