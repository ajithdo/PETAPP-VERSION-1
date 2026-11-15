import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/devices.dart';
import '../domain/toxic.dart';
import '../../../core/theme/ph.dart';

/// The 9 first-aid guides (spec 7.14), in the order they are listed.
const firstAidIds = ['choking', 'poisoning', 'heatstroke', 'bleeding', 'fracture', 'seizure', 'burn', 'bite', 'tick'];

IconData firstAidIcon(String id) => switch (id) {
      'choking' => Ph.wind,
      'poisoning' => Ph.flask,
      'heatstroke' => Ph.thermometerHot,
      'bleeding' => Ph.drop,
      'fracture' => Ph.bone,
      'seizure' => Ph.lightning,
      'burn' => Ph.fire,
      'bite' => Ph.bugBeetle,
      'tick' => Ph.bug,
      _ => Ph.firstAidKit,
    };

class FirstAidText {
  const FirstAidText(this.title, this.signs, this.steps, this.avoid, this.vet);
  final String title;
  final String signs;
  final List<String> steps;
  final List<String> avoid;
  final String vet;
}

List<String> _lines(String s) => [for (final l in s.split('\n')) if (l.trim().isNotEmpty) l.trim()];

FirstAidText firstAidText(AppLocalizations l, String id) => switch (id) {
      'choking' => FirstAidText(l.faChokingTitle, l.faChokingSigns, _lines(l.faChokingSteps), _lines(l.faChokingAvoid), l.faChokingVet),
      'poisoning' => FirstAidText(l.faPoisoningTitle, l.faPoisoningSigns, _lines(l.faPoisoningSteps), _lines(l.faPoisoningAvoid), l.faPoisoningVet),
      'heatstroke' => FirstAidText(l.faHeatstrokeTitle, l.faHeatstrokeSigns, _lines(l.faHeatstrokeSteps), _lines(l.faHeatstrokeAvoid), l.faHeatstrokeVet),
      'bleeding' => FirstAidText(l.faBleedingTitle, l.faBleedingSigns, _lines(l.faBleedingSteps), _lines(l.faBleedingAvoid), l.faBleedingVet),
      'fracture' => FirstAidText(l.faFractureTitle, l.faFractureSigns, _lines(l.faFractureSteps), _lines(l.faFractureAvoid), l.faFractureVet),
      'seizure' => FirstAidText(l.faSeizureTitle, l.faSeizureSigns, _lines(l.faSeizureSteps), _lines(l.faSeizureAvoid), l.faSeizureVet),
      'burn' => FirstAidText(l.faBurnTitle, l.faBurnSigns, _lines(l.faBurnSteps), _lines(l.faBurnAvoid), l.faBurnVet),
      'bite' => FirstAidText(l.faBiteTitle, l.faBiteSigns, _lines(l.faBiteSteps), _lines(l.faBiteAvoid), l.faBiteVet),
      _ => FirstAidText(l.faTickTitle, l.faTickSigns, _lines(l.faTickSteps), _lines(l.faTickAvoid), l.faTickVet),
    };

/// Name and explanation of a toxic-checker item.
(String name, String why) toxText(AppLocalizations l, String id) => switch (id) {
      'chocolate' => (l.toxChocolateName, l.toxChocolateWhy),
      'grapes' => (l.toxGrapesName, l.toxGrapesWhy),
      'onionGarlic' => (l.toxOnionGarlicName, l.toxOnionGarlicWhy),
      'xylitol' => (l.toxXylitolName, l.toxXylitolWhy),
      'alcohol' => (l.toxAlcoholName, l.toxAlcoholWhy),
      'caffeine' => (l.toxCaffeineName, l.toxCaffeineWhy),
      'avocado' => (l.toxAvocadoName, l.toxAvocadoWhy),
      'cookedBones' => (l.toxCookedBonesName, l.toxCookedBonesWhy),
      'milk' => (l.toxMilkName, l.toxMilkWhy),
      'saltySnacks' => (l.toxSaltySnacksName, l.toxSaltySnacksWhy),
      'spicyFood' => (l.toxSpicyFoodName, l.toxSpicyFoodWhy),
      'fattyFood' => (l.toxFattyFoodName, l.toxFattyFoodWhy),
      'sweets' => (l.toxSweetsName, l.toxSweetsWhy),
      'fruitSeeds' => (l.toxFruitSeedsName, l.toxFruitSeedsWhy),
      'tomato' => (l.toxTomatoName, l.toxTomatoWhy),
      'peanuts' => (l.toxPeanutsName, l.toxPeanutsWhy),
      'mango' => (l.toxMangoName, l.toxMangoWhy),
      'apple' => (l.toxAppleName, l.toxAppleWhy),
      'banana' => (l.toxBananaName, l.toxBananaWhy),
      'watermelon' => (l.toxWatermelonName, l.toxWatermelonWhy),
      'carrot' => (l.toxCarrotName, l.toxCarrotWhy),
      'rice' => (l.toxRiceName, l.toxRiceWhy),
      'egg' => (l.toxEggName, l.toxEggWhy),
      'lily' => (l.toxLilyName, l.toxLilyWhy),
      'sagoPalm' => (l.toxSagoPalmName, l.toxSagoPalmWhy),
      'oleander' => (l.toxOleanderName, l.toxOleanderWhy),
      'castor' => (l.toxCastorName, l.toxCastorWhy),
      'datura' => (l.toxDaturaName, l.toxDaturaWhy),
      'lantana' => (l.toxLantanaName, l.toxLantanaWhy),
      'aloeVera' => (l.toxAloeVeraName, l.toxAloeVeraWhy),
      'moneyPlant' => (l.toxMoneyPlantName, l.toxMoneyPlantWhy),
      'snakePlant' => (l.toxSnakePlantName, l.toxSnakePlantWhy),
      'marigold' => (l.toxMarigoldName, l.toxMarigoldWhy),
      'tulsi' => (l.toxTulsiName, l.toxTulsiWhy),
      'arecaPalm' => (l.toxArecaPalmName, l.toxArecaPalmWhy),
      'spiderPlant' => (l.toxSpiderPlantName, l.toxSpiderPlantWhy),
      'ratPoison' => (l.toxRatPoisonName, l.toxRatPoisonWhy),
      'humanMedicines' => (l.toxHumanMedicinesName, l.toxHumanMedicinesWhy),
      'mosquitoRepellent' => (l.toxMosquitoRepellentName, l.toxMosquitoRepellentWhy),
      'mothballs' => (l.toxMothballsName, l.toxMothballsWhy),
      'nonStickFumes' => (l.toxNonStickFumesName, l.toxNonStickFumesWhy),
      _ => (l.toxPhenylName, l.toxPhenylWhy),
    };

String toxLevelLabel(AppLocalizations l, ToxLevel v) => switch (v) {
      ToxLevel.danger => l.toxDanger,
      ToxLevel.caution => l.toxCaution,
      ToxLevel.safe => l.toxSafe,
    };

ChipTone toxTone(ToxLevel v) => switch (v) {
      ToxLevel.danger => ChipTone.error,
      ToxLevel.caution => ChipTone.warning,
      ToxLevel.safe => ChipTone.success,
    };

IconData toxIcon(ToxLevel v) => switch (v) {
      ToxLevel.danger => Ph.warningOctagon,
      ToxLevel.caution => Ph.warning,
      ToxLevel.safe => Ph.checkCircleFill,
    };

String toxKindLabel(AppLocalizations l, ToxKind k) => switch (k) {
      ToxKind.food => l.toxKindFood,
      ToxKind.plant => l.toxKindPlant,
      ToxKind.home => l.toxKindHome,
    };

String deviceTypeLabel(AppLocalizations l, DeviceType t) => switch (t) {
      DeviceType.gpsCollar => l.devGpsCollar,
      DeviceType.activityTracker => l.devActivityTracker,
      DeviceType.feeder => l.devFeeder,
      DeviceType.fountain => l.devFountain,
      DeviceType.camera => l.devCamera,
      DeviceType.litterBox => l.devLitterBox,
    };

String deviceTypeHint(AppLocalizations l, DeviceType t) => switch (t) {
      DeviceType.gpsCollar => l.devGpsCollarHint,
      DeviceType.activityTracker => l.devActivityTrackerHint,
      DeviceType.feeder => l.devFeederHint,
      DeviceType.fountain => l.devFountainHint,
      DeviceType.camera => l.devCameraHint,
      DeviceType.litterBox => l.devLitterBoxHint,
    };

IconData deviceIcon(DeviceType t) => switch (t) {
      DeviceType.gpsCollar => Ph.mapPinLine,
      DeviceType.activityTracker => Ph.watch,
      DeviceType.feeder => Ph.bowlFood,
      DeviceType.fountain => Ph.drop,
      DeviceType.camera => Ph.videoCamera,
      DeviceType.litterBox => Ph.package,
    };

/// The "Draft, to be reviewed by a vet" label (DEMO VERSION 1 content). Once the
/// admin records a vet's review (Settings → Content review), it shows who
/// reviewed it instead. [area] is firstAid or toxic.
class DraftLabel extends ConsumerWidget {
  const DraftLabel({super.key, this.area = 'firstAid'});
  final String area;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final review = (ref.watch(appSettingsDocProvider).value?['contentReview'] as Map?) ?? const {};
    final by = (review[area] as String?) ?? '';
    // A plain tag, as long as its words (it sits in a wrap).
    return by.isEmpty
        ? PawTag(context.l10n.draftVetReview, kind: TagKind.gold, icon: Ph.pencilSimpleLineFill)
        : PawTag(context.l10n.reviewedBy(by), kind: TagKind.green, icon: Ph.sealCheckFill);
  }
}

/// Space between list sections in Phase 9 screens.
const safetyGap = SizedBox(height: Space.lg);
