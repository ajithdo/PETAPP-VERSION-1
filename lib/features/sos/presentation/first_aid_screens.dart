import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../shell/presentation/sos_launcher.dart';
import 'safety_labels.dart';
import '../../../core/theme/ph.dart';

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
        InfoNote(l.firstAidEmergencyNote, icon: Ph.asterisk, tone: ChipTone.error),
        const SizedBox(height: Space.sm),
        Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
          PawTag(l.firstAidOffline, kind: TagKind.green, icon: Ph.cloudCheckFill),
          const DraftLabel(),
        ]),
        safetyGap,
        // UI Design 6: "Is it safe?" first, as a marigold card with a few
        // common things to check, then the guides as a grid of cards.
        _SafeCheckCard(),
        const SizedBox(height: Space.xl),
        SecHead(l.firstAidGuides),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth >= 720 ? 3 : (c.maxWidth >= 320 && MediaQuery.textScalerOf(context).scale(1) < 1.3 ? 2 : 1);
          return TileGrid(columns: cols, children: [for (final id in firstAidIds) _GuideTile(id: id)]);
        }),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}

/// "Is it safe?": opens the toxic checker, with common things as shortcuts.
class _SafeCheckCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final items = ['chocolate', 'grapes', 'onionGarlic', 'xylitol', 'avocado'];
    // "Grapes and raisins" becomes "Grapes": one word on each chip.
    String short(String name) => name.split(RegExp(r'[ (,]')).first;
    return Wash(
      onTap: () => context.push('/toxic-check'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const PawTile(icon: Ph.magnifyingGlass, tone: Tone.marigold, size: TapTarget.min),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.toxTitle, style: context.text.titleSmall),
              Text(l.toxTileHint, style: context.text.bodySmall?.copyWith(color: paw.accent)),
            ]),
          ),
        ]),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          for (final id in items)
            Semantics(
              button: true,
              label: toxText(l, id).$1,
              excludeSemantics: true,
              child: Material(
                color: paw.surface,
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.push('/toxic-check?q=${Uri.encodeComponent(toxText(l, id).$1)}'),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: Sizes.buttonSmall - Space.xxs),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Space.md + Space.xxs),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(short(toxText(l, id).$1), style: context.text.labelMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
        ]),
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
    final paw = context.paw;
    return PawCard(
      onTap: () => context.push('/first-aid/$id'),
      semanticLabel: t.title,
      padding: const EdgeInsets.all(Space.md + Space.xxs),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PawTile(icon: firstAidIcon(id), tone: Tone.red),
        const SizedBox(height: Space.md),
        Text(t.title, style: context.text.labelLarge),
        Text(t.signs, maxLines: 2, overflow: TextOverflow.ellipsis, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
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
        heading(Ph.eye, l.firstAidSigns, context.colors.primary),
        Text(t.signs, style: context.text.bodyLarge),
        heading(Ph.listChecks, l.firstAidWhatToDo, context.paw.success),
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
        heading(Ph.prohibit, l.firstAidAvoid, context.paw.error),
        for (final a in t.avoid)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Ph.x, size: IconSizes.md, color: context.paw.error),
              const SizedBox(width: Space.sm),
              Expanded(child: Text(a, style: context.text.bodyLarge)),
            ]),
          ),
        heading(Ph.firstAid, l.firstAidWhenVet, context.paw.warning),
        InfoNote(t.vet, icon: Ph.firstAid, tone: ChipTone.error),
        safetyGap,
        PrimaryButton(label: l.sosGetHelp, icon: Ph.asterisk, danger: true, onPressed: () => openSos(context, ref)),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: l.firstAidTalkToVet, icon: Ph.videoCamera, onPressed: () => context.push('/televet')),
        const SizedBox(height: Space.xxl),
      ]),
    );
  }
}
