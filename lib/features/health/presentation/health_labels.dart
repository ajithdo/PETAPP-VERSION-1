import 'package:flutter/material.dart';

import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/health_repository.dart';
import '../domain/vaccine_schedule.dart';

String doseLabel(BuildContext context, String key) {
  final l = context.l10n;
  return switch (key) {
    'dose_1' => l.doseN(1),
    'dose_2' => l.doseN(2),
    'dose_3' => l.doseN(3),
    'booster' => l.booster,
    _ => l.optionalVaccine,
  };
}

(String, ChipTone, IconData) statusChip(BuildContext context, DoseStatus s) {
  final l = context.l10n;
  return switch (s) {
    DoseStatus.done => (l.statusDone, ChipTone.success, Icons.check_rounded),
    DoseStatus.overdue => (l.statusOverdue, ChipTone.error, Icons.error_rounded),
    DoseStatus.dueSoon => (l.statusDueSoon, ChipTone.warning, Icons.schedule_rounded),
    DoseStatus.upcoming => (l.statusUpcoming, ChipTone.info, Icons.event_rounded),
    DoseStatus.askVet => (l.statusAskVet, ChipTone.neutral, Icons.help_outline_rounded),
  };
}

Widget statusChipWidget(BuildContext context, DoseStatus s) {
  final c = statusChip(context, s);
  return StatusChip(c.$1, tone: c.$2, icon: c.$3);
}

String frequencyLabel(BuildContext context, Medicine m) {
  final l = context.l10n;
  return switch (m.frequency) {
    'twice' => l.freqTwice,
    'every_x_hours' => l.freqEveryHours((m.raw['everyHours'] as num?)?.toInt() ?? 8),
    'weekly' => l.freqWeekly,
    'custom' => l.freqCustom,
    _ => l.freqOnce,
  };
}

/// Sentence for a due item, e.g. "Bruno's deworming · due 20 Oct".
String dueTitle(BuildContext context, DueItem i) {
  final l = context.l10n;
  return switch (i.kind) {
    'deworming' => l.deworming,
    'flea_tick' => l.fleaTick,
    'refill' => l.refillNeeded(i.title),
    _ => i.title,
  };
}

String dueWhen(BuildContext context, DueItem i) {
  final l = context.l10n;
  if (i.at == null) return '';
  final now = DateTime.now();
  final days = DateTime(i.at!.year, i.at!.month, i.at!.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  if (i.kind == 'medicine') return Fmt.sameDay(i.at!, now) ? l.todayAt(Fmt.time(i.at!, context.lang)) : Fmt.dateTime(i.at!, context.lang);
  if (days < 0) return l.overdueBy(-days);
  if (days == 0) return l.dueToday;
  return l.dueInDays(days);
}

IconData dueIcon(String kind) => switch (kind) {
      'vaccine' => Icons.vaccines_rounded,
      'medicine' => Icons.medication_rounded,
      'refill' => Icons.inventory_2_rounded,
      'deworming' => Icons.bug_report_rounded,
      'flea_tick' => Icons.pest_control_rounded,
      'booking' => Icons.event_available_rounded,
      _ => Icons.alarm_rounded,
    };

String symptomLabel(BuildContext context, String? s) {
  final l = context.l10n;
  return switch (s) {
    'vomiting' => l.symVomiting,
    'diarrhoea' => l.symDiarrhoea,
    'not_eating' => l.symNotEating,
    'limping' => l.symLimping,
    'itching' => l.symItching,
    'coughing' => l.symCoughing,
    'lethargy' => l.symLethargy,
    'sneezing' => l.symSneezing,
    _ => l.symOther,
  };
}

const symptoms = ['vomiting', 'diarrhoea', 'not_eating', 'limping', 'itching', 'coughing', 'lethargy', 'sneezing', 'other'];
