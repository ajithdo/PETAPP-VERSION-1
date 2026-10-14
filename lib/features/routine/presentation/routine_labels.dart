import 'package:flutter/material.dart';

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
      LogType.walk => Icons.directions_walk_rounded,
      LogType.play => Icons.sports_baseball_rounded,
      LogType.meal => Icons.restaurant_rounded,
      LogType.water => Icons.water_drop_rounded,
      LogType.potty => Icons.grass_rounded,
      LogType.sleep => Icons.bedtime_rounded,
      LogType.grooming => Icons.content_cut_rounded,
      LogType.training => Icons.school_rounded,
      LogType.mood => Icons.mood_rounded,
      LogType.weight => Icons.monitor_weight_rounded,
      LogType.behaviour => Icons.psychology_rounded,
    };

Color logTypeColor(LogType t) => switch (t) {
      LogType.walk => const Color(0xFF0F766E),
      LogType.play => const Color(0xFFF4A261),
      LogType.meal => const Color(0xFFD97706),
      LogType.water => const Color(0xFF38BDF8),
      LogType.potty => const Color(0xFF65A30D),
      LogType.sleep => const Color(0xFF9B8AFB),
      LogType.grooming => const Color(0xFFF472B6),
      LogType.training => const Color(0xFF0EA5E9),
      LogType.mood => const Color(0xFFEAB308),
      LogType.weight => const Color(0xFF64748B),
      LogType.behaviour => const Color(0xFF8B5CF6),
    };

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
      'happy' => Icons.sentiment_very_satisfied_rounded,
      'calm' => Icons.self_improvement_rounded,
      'playful' => Icons.celebration_rounded,
      'tired' => Icons.bedtime_rounded,
      'anxious' => Icons.sentiment_dissatisfied_rounded,
      'unwell' => Icons.sick_rounded,
      _ => Icons.mood_rounded,
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
