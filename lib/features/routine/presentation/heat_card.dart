import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../domain/routine.dart';

/// Walk-weather tip with heat safety (spec 7.3). Version 1 uses demo
/// temperatures; flat-faced breeds get stronger warnings.
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
    final (tone, icon, title) = switch (level) {
      HeatLevel.ok => (ChipTone.success, Icons.wb_sunny_rounded, l.heatOk(pet.name)),
      HeatLevel.warm => (ChipTone.info, Icons.wb_sunny_rounded, l.heatWarm),
      HeatLevel.hot => (ChipTone.warning, Icons.thermostat_rounded, l.heatHot(pet.name)),
      HeatLevel.danger => (ChipTone.error, Icons.local_fire_department_rounded, l.heatDanger(pet.name)),
    };
    final c = switch (tone) {
      ChipTone.success => context.paw.success,
      ChipTone.warning => context.paw.warning,
      ChipTone.error => context.paw.error,
      _ => context.colors.primary,
    };
    final tips = [
      if (level != HeatLevel.ok) l.heatTipTime,
      if (level == HeatLevel.hot || level == HeatLevel.danger) l.heatTipWater,
      if (pet.flatFaced) l.heatTipFlatFaced(pet.name),
    ];
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(Space.md),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(compact ? Radii.button : Radii.card),
          border: Border.all(color: c.withValues(alpha: 0.35)),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: c, size: 28),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(title, style: context.text.titleSmall)),
                Text('${temp.toStringAsFixed(0)}°C', style: context.text.titleMedium?.copyWith(color: c)),
              ]),
              if (!compact || level != HeatLevel.ok)
                for (final t in tips)
                  Padding(padding: const EdgeInsets.only(top: 2), child: Text('• $t', style: context.text.bodySmall)),
              if (ref.watch(appConfigProvider).isDemo)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(l.demoTemperature, style: context.text.labelSmall),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}
