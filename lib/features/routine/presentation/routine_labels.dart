import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/layout.dart';
import '../domain/routine.dart';

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
      LogType.walk => Icons.directions_walk_outlined,
      LogType.play => Icons.sports_baseball_outlined,
      LogType.meal => Icons.restaurant_outlined,
      LogType.water => Icons.water_drop_outlined,
      LogType.potty => Icons.grass_outlined,
      LogType.sleep => Icons.bedtime_outlined,
      LogType.grooming => Icons.content_cut_outlined,
      LogType.training => Icons.school_outlined,
      LogType.mood => Icons.mood_outlined,
      LogType.weight => Icons.monitor_weight_outlined,
      LogType.behaviour => Icons.psychology_outlined,
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
      'happy' => Icons.sentiment_very_satisfied_outlined,
      'calm' => Icons.self_improvement_outlined,
      'playful' => Icons.celebration_outlined,
      'tired' => Icons.bedtime_outlined,
      'anxious' => Icons.sentiment_dissatisfied_outlined,
      'unwell' => Icons.sick_outlined,
      _ => Icons.mood_outlined,
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
