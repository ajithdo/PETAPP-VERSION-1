import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../health/presentation/next_up_panel.dart';
import '../../pets/domain/pet.dart';

export '../../messaging/messaging_slots.dart' show askVetLink;
export '../../shop/shop_slots.dart' show foodLowSection;
export '../../sos/sos_slots.dart' show lostPetSection;
export '../../vault/vault_slots.dart' show addPhotoLink, latestMemorySection;

/// Home "Next up": vaccines, medicines and care due soonest (spec 5).
/// The most urgent item is a UI Design 2 alert card; up to two more follow as
/// rows. [flush] drops the space above the title (top of a desktop column).
/// With [skipFirst] the most urgent item is left out, because Home already
/// shows it in the dark health card at the top; only the next ones are listed.
List<Widget> nextUpSection(BuildContext context, WidgetRef ref, {required List<Pet> pets, bool flush = false, bool skipFirst = false}) {
  final l = context.l10n;
  final items = <(Pet, DueItem)>[];
  for (final p in pets) {
    for (final i in ref.watch(petDueProvider(p)).value ?? const <DueItem>[]) {
      if (i.status == DoseStatus.overdue || i.status == DoseStatus.dueSoon) items.add((p, i));
    }
  }
  items.sort((a, b) {
    int rank(DoseStatus s) => s == DoseStatus.overdue ? 0 : 1;
    final r = rank(a.$2.status).compareTo(rank(b.$2.status));
    return r != 0 ? r : (a.$2.at ?? DateTime.now()).compareTo(b.$2.at ?? DateTime.now());
  });
  final shown = items.skip(skipFirst ? 1 : 0).take(3).toList();
  if (skipFirst && shown.isEmpty) return const [];
  return [
    if (!flush) const SizedBox(height: Sizes.sectionGap),
    SecHead(l.nextUp, action: l.seeAll, onAction: () => context.go('/health')),
    NextUpPanel(items: shown, showPet: pets.length > 1),
  ];
}
