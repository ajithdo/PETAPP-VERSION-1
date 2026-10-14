import 'package:flutter/widgets.dart';

import '../../../core/widgets/layout.dart';

/// Suggested question for a topic, in the reader's language.
String aiQuestion(BuildContext context, String topic) {
  final l = context.l10n;
  return switch (topic) {
    'bath' => l.aiQBath,
    'feeding' => l.aiQFeeding,
    'toxic_food' => l.aiQToxicFood,
    'vaccines' => l.aiQVaccines,
    'deworming' => l.aiQDeworming,
    'ticks' => l.aiQTicks,
    'heat' => l.aiQHeat,
    'vomiting' => l.aiQVomiting,
    'diarrhoea' => l.aiQDiarrhoea,
    'not_eating' => l.aiQNotEating,
    'itching' => l.aiQItching,
    'limping' => l.aiQLimping,
    'litter' => l.aiQLitter,
    'chewing' => l.aiQChewing,
    'nails' => l.aiQNails,
    'teeth' => l.aiQTeeth,
    'bird_diet' => l.aiQBirdDiet,
    'rabbit_diet' => l.aiQRabbitDiet,
    'weight' => l.aiQWeight,
    'anxiety' => l.aiQAnxiety,
    _ => topic,
  };
}

/// Scripted demo answer for a topic (Version 2 uses Gemini).
String aiAnswer(BuildContext context, String topic) {
  final l = context.l10n;
  return switch (topic) {
    'bath' => l.aiABath,
    'feeding' => l.aiAFeeding,
    'toxic_food' => l.aiAToxicFood,
    'vaccines' => l.aiAVaccines,
    'deworming' => l.aiADeworming,
    'ticks' => l.aiATicks,
    'heat' => l.aiAHeat,
    'vomiting' => l.aiAVomiting,
    'diarrhoea' => l.aiADiarrhoea,
    'not_eating' => l.aiANotEating,
    'itching' => l.aiAItching,
    'limping' => l.aiALimping,
    'litter' => l.aiALitter,
    'chewing' => l.aiAChewing,
    'nails' => l.aiANails,
    'teeth' => l.aiATeeth,
    'bird_diet' => l.aiABirdDiet,
    'rabbit_diet' => l.aiARabbitDiet,
    'weight' => l.aiAWeight,
    'anxiety' => l.aiAAnxiety,
    _ => l.aiUnknown,
  };
}

/// Plain-language name of a red-flag sign.
String redFlagLabel(BuildContext context, String flag) {
  final l = context.l10n;
  return switch (flag) {
    'breathing' => l.rfBreathing,
    'collapse' => l.rfCollapse,
    'seizure' => l.rfSeizure,
    'poisoning' => l.rfPoisoning,
    'bleeding' => l.rfBleeding,
    'bloat' => l.rfBloat,
    'heatstroke' => l.rfHeatstroke,
    'urine' => l.rfUrine,
    _ => l.rfInjury,
  };
}
