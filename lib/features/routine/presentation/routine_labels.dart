import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/layout.dart';
import '../domain/routine.dart';
import '../../../core/theme/ph.dart';

String logTypeLabel(BuildContext context, LogType t) {
  final l = context.l10n;
  return switch (t) {
    LogType.walk => l.logWalk,
    LogType.play => l.logPlay,
    LogType.meal => l.logMeal,
    LogType.water => l.logWater,
    LogType.potty => l.logPotty,
    LogType.sleep => l.logSleep,
    LogType.grooming => l.logGrooming,
    LogType.training => l.logTraining,
    LogType.mood => l.logMood,
    LogType.weight => l.logWeight,
    LogType.behaviour => l.logBehaviour,
  };
}

IconData logTypeIcon(LogType t) => switch (t) {
      LogType.walk => Ph.personSimpleWalk,
      LogType.play => Ph.tennisBall,
      LogType.meal => Ph.forkKnife,
      LogType.water => Ph.drop,
      LogType.potty => Ph.plant,
      LogType.sleep => Ph.moon,
      LogType.grooming => Ph.scissors,
      LogType.training => Ph.graduationCap,
      LogType.mood => Ph.smiley,
      LogType.weight => Ph.scales,
      LogType.behaviour => Ph.brain,
    };

/// Icon colour for a kind of log, readable (3:1) on cards in light and dark.
Color logTypeColor(BuildContext context, LogType t) {
  final c = switch (t) {
    LogType.walk => CategoryColors.teal,
    LogType.play => CategoryColors.clay,
    LogType.meal => CategoryColors.amber,
    LogType.water => CategoryColors.sky,
    LogType.potty => CategoryColors.olive,
    LogType.sleep => CategoryColors.plum,
    LogType.grooming => CategoryColors.rose,
    LogType.training => CategoryColors.ocean,
    LogType.mood => CategoryColors.gold,
    LogType.weight => CategoryColors.slate,
    LogType.behaviour => CategoryColors.violet,
  };
  return readableOn(c, [context.paw.surface], ratio: 3);
}

String moodLabel(BuildContext context, String? mood) {
  final l = context.l10n;
  return switch (mood) {
    'happy' => l.moodHappy,
    'calm' => l.moodCalm,
    'playful' => l.moodPlayful,
    'tired' => l.moodTired,
    'anxious' => l.moodAnxious,
    'unwell' => l.moodUnwell,
    _ => '',
  };
}

IconData moodIcon(String? mood) => switch (mood) {
      'happy' => Ph.smiley,
      'calm' => Ph.flowerLotus,
      'playful' => Ph.confetti,
      'tired' => Ph.moon,
      'anxious' => Ph.smileySad,
      'unwell' => Ph.smileyNervous,
      _ => Ph.smiley,
    };

String behaviourLabel(BuildContext context, String tag) {
  final l = context.l10n;
  return switch (tag) {
    'playful' => l.tagPlayful,
    'calm' => l.tagCalm,
    'anxious' => l.tagAnxious,
    'leash_pulling' => l.tagLeashPulling,
    'barking' => l.tagBarking,
    'aggression_dogs' => l.tagAggressionDogs,
    'separation_anxiety' => l.tagSeparationAnxiety,
    'scratching_furniture' => l.tagScratching,
    'chewing' => l.tagChewing,
    'jumping_on_people' => l.tagJumping,
    'hiding' => l.tagHiding,
    'not_eating_well' => l.tagNotEating,
    _ => tag,
  };
}

String intensityLabel(BuildContext context, int i) => switch (i) {
      1 => context.l10n.intensityMild,
      2 => context.l10n.intensityModerate,
      _ => context.l10n.intensityStrong,
    };

/// Which log types make sense for a species.
List<LogType> logTypesFor(String species) => switch (species) {
      'dog' => const [LogType.walk, LogType.meal, LogType.water, LogType.play, LogType.potty, LogType.mood, LogType.sleep, LogType.grooming, LogType.training, LogType.behaviour, LogType.weight],
      'cat' => const [LogType.meal, LogType.water, LogType.play, LogType.potty, LogType.mood, LogType.sleep, LogType.grooming, LogType.behaviour, LogType.weight],
      _ => const [LogType.meal, LogType.water, LogType.play, LogType.mood, LogType.sleep, LogType.grooming, LogType.behaviour, LogType.weight],
    };
