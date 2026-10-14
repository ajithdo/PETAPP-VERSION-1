import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

String serviceLabel(BuildContext context, String id) {
  final l = context.l10n;
  return switch (id) {
    'consultation' => l.svcConsultation,
    'vaccination' => l.svcVaccination,
    'surgery' => l.svcSurgery,
    'dental' => l.svcDental,
    'lab_tests' => l.svcLabTests,
    'xray_ultrasound' => l.svcXray,
    'grooming' => l.svcGrooming,
    'boarding' => l.svcBoarding,
    'home_visit' => l.svcHomeVisit,
    'bath_brush' => l.svcBathBrush,
    'full_groom' => l.svcFullGroom,
    'nail_trim' => l.svcNailTrim,
    'tick_treatment' => l.svcTickTreatment,
    'puppy_basics' => l.svcPuppyBasics,
    'obedience' => l.svcObedience,
    'behaviour' => l.svcBehaviour,
    'boarding_night' => l.svcBoardingNight,
    'day_care' => l.svcDayCare,
    'home_sitting' => l.svcHomeSitting,
    'walk_30' => l.svcWalk30,
    'walk_60' => l.svcWalk60,
    _ => id,
  };
}

String kindLabel(BuildContext context, String kind) {
  final l = context.l10n;
  return switch (kind) {
    'clinic' => l.kindVet,
    'groomer' => l.kindGrooming,
    'trainer' => l.kindTraining,
    'boarder' => l.kindBoarding,
    'walker' => l.kindWalking,
    _ => kind,
  };
}

IconData kindIcon(String kind) => switch (kind) {
  'clinic' => Icons.local_hospital_rounded,
  'groomer' => Icons.content_cut_rounded,
  'trainer' => Icons.sports_rounded,
  'boarder' => Icons.house_rounded,
  'walker' => Icons.directions_walk_rounded,
  _ => Icons.storefront_rounded,
};

(String, ChipTone) bookingStatus(BuildContext context, String s) {
  final l = context.l10n;
  return switch (s) {
    'pending' => (l.bsPending, ChipTone.warning),
    'suggested' => (l.bsSuggested, ChipTone.accent),
    'confirmed' => (l.bsConfirmed, ChipTone.success),
    'in_progress' => (l.bsInProgress, ChipTone.info),
    'completed' => (l.bsCompleted, ChipTone.neutral),
    'cancelled' => (l.bsCancelled, ChipTone.error),
    'declined' => (l.bsDeclined, ChipTone.error),
    'expired' => (l.bsExpired, ChipTone.error),
    _ => (s, ChipTone.neutral),
  };
}

String languageShort(String code) => switch (code) {
  'hi' => 'हिन्दी',
  'te' => 'తెలుగు',
  _ => 'English',
};
