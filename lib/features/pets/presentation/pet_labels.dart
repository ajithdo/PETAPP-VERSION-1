import 'package:flutter/material.dart';

import '../../../core/widgets/layout.dart';
import '../domain/pet.dart';

String speciesLabel(BuildContext context, String species) => switch (species) {
      'cat' => context.l10n.speciesCat,
      'bird' => context.l10n.speciesBird,
      'rabbit' => context.l10n.speciesRabbit,
      _ => context.l10n.speciesDog,
    };

/// "2 yrs 3 mo", "5 mo", or "" if no birthday.
String petAgeLabel(BuildContext context, Pet pet) {
  final a = pet.age();
  if (a == null) return '';
  if (a.years == 0) return context.l10n.ageMonths(a.months);
  if (a.months == 0) return context.l10n.ageYears(a.years);
  return context.l10n.ageYearsMonths(a.years, a.months);
}

String lifeStageLabel(BuildContext context, Pet pet) {
  final l = context.l10n;
  return switch (pet.lifeStage()) {
    'young' => switch (pet.species) {
        'dog' => l.stagePuppy,
        'cat' => l.stageKitten,
        _ => l.stageYoung,
      },
    'senior' => l.stageSenior,
    _ => l.stageAdult,
  };
}

String genderLabel(BuildContext context, String? g) => switch (g) {
      'male' => context.l10n.genderMale,
      'female' => context.l10n.genderFemale,
      _ => context.l10n.genderUnknown,
    };

String petRoleLabel(BuildContext context, String role) => switch (role) {
      'owner' => context.l10n.roleOwner,
      'coowner' => context.l10n.roleCoowner,
      'carer' => context.l10n.roleCarer,
      _ => context.l10n.roleViewer,
    };

IconData speciesIcon(String species) => switch (species) {
      'bird' => Icons.flutter_dash_rounded,
      'rabbit' => Icons.cruelty_free_rounded,
      _ => Icons.pets_rounded,
    };
