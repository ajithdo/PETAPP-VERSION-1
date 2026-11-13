import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../domain/routine.dart';

/// Walk-weather tip with heat safety (spec 7.3), UI Design 6: the temperature,
/// what it means for this pet, and a strip of the day showing the cool hours.
/// DEMO VERSION 1 uses demo temperatures; flat-faced breeds get stronger
/// warnings.
class HeatCard extends ConsumerWidget {
  const HeatCard({super.key, required this.pet, this.compact = false});
  final Pet pet;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final city = ref.watch(currentUserProvider)?.city;
    final now = DateTime.now();
    final temp = demoTemperature(city, now);
    final level = heatLevel(temp, flatFaced: pet.flatFaced);
    final title = switch (level) {
      HeatLevel.ok => l.heatOk(pet.name),
      HeatLevel.warm => l.heatWarm,
      HeatLevel.hot => l.heatHot(pet.name),
      HeatLevel.danger => l.heatDanger(pet.name),
    };
    final tips = [
      if (level != HeatLevel.ok) l.heatTipTime,
      if (level == HeatLevel.hot || level == HeatLevel.danger) l.heatTipWater,
      if (pet.flatFaced) l.heatTipFlatFaced(pet.name),
      if (ref.watch(appConfigProvider).isDemo) l.demoTemperature,
    ];
    final tint = context.tint;
    final paw = context.paw;
    final lang = context.lang;
    // The day from 6 am to 9 pm as a strip: green when it's fine to walk,
    // marigold when warm, red when too hot. A marker shows "now".
    const from = 6, to = 21;
    Color colorOf(HeatLevel v) => switch (v) {
          HeatLevel.ok => paw.success,
          HeatLevel.warm => paw.marigold,
          _ => tint.heat,
        };
    final runs = <(HeatLevel, int)>[];
    for (var h = from; h < to; h++) {
      final v = heatLevel(demoTemperature(city, DateTime(now.year, now.month, now.day, h, 30)), flatFaced: pet.flatFaced);
      if (runs.isNotEmpty && runs.last.$1 == v) {
        runs[runs.length - 1] = (v, runs.last.$2 + 1);
      } else {
        runs.add((v, 1));
      }
    }
    final at = (now.hour + now.minute / 60 - from) / (to - from);
    final showNow = at >= 0 && at <= 1;
    const end = Radius.circular(Radii.sm);
    final small = context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w500);
    return Semantics(
      container: true,
      label: [title, ...tips, '${temp.toStringAsFixed(0)}°C'].join('. '),
      excludeSemantics: true,
      child: Wash(
        tone: Tone.sky,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${temp.toStringAsFixed(0)}°', style: context.text.displaySmall?.copyWith(color: tint.sky, height: TypeScale.tightLineHeight)),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: context.text.labelLarge),
                if (tips.isNotEmpty) Text(tips.join(' '), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              ]),
            ),
          ]),
          const SizedBox(height: Space.md),
          SizedBox(
            height: Sizes.walkNow,
            child: LayoutBuilder(
              builder: (context, c) => Stack(clipBehavior: Clip.none, alignment: Alignment.centerLeft, children: [
                SizedBox(
                  height: Sizes.walkBar,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    for (final (i, r) in runs.indexed) ...[
                      if (i > 0) const SizedBox(width: Space.xxs),
                      Expanded(
                        flex: r.$2,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorOf(r.$1),
                            borderRadius: BorderRadius.horizontal(left: i == 0 ? end : Radius.zero, right: i == runs.length - 1 ? end : Radius.zero),
                          ),
                        ),
                      ),
                    ],
                  ]),
                ),
                if (showNow)
                  Positioned(
                    left: (c.maxWidth * at - Space.xxs).clamp(0, c.maxWidth - Space.xs),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: Space.xs,
                      decoration: BoxDecoration(
                        color: paw.textPrimary,
                        borderRadius: BorderRadius.circular(Radii.xs),
                        boxShadow: [BoxShadow(color: tint.skyWash, spreadRadius: Space.xxs)],
                      ),
                    ),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: Space.xs),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(Fmt.hour(DateTime(now.year, now.month, now.day, from), lang), style: small),
            if (showNow) Flexible(child: Text(l.nowAt(Fmt.hour(now, lang)), style: small, textAlign: TextAlign.center)),
            Text(Fmt.hour(DateTime(now.year, now.month, now.day, to), lang), style: small),
          ]),
        ]),
      ),
    );
  }
}
