import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../health/presentation/health_screen.dart';
import '../../pets/domain/pet.dart';

export '../../messaging/messaging_slots.dart' show askVetLink;
export '../../shop/shop_slots.dart' show foodLowSection;
export '../../vault/vault_slots.dart' show addPhotoLink, latestMemorySection;

/// Home "Next up": vaccines, medicines and care due soonest (spec 5).
List<Widget> nextUpSection(BuildContext context, WidgetRef ref, {required List<Pet> pets}) {
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
  return [
    SectionHeader(l.nextUp, action: l.seeAll, onAction: () => context.go('/health')),
    PawCard(
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: items.isEmpty
          ? ListTile(
              leading: Icon(Icons.check_circle_rounded, color: context.paw.success),
              title: Text(l.nothingDueAll),
            )
          : Column(children: [
              for (final it in items.take(3)) DueTile(item: it.$2, pet: it.$1, showPet: pets.length > 1),
            ]),
    ),
  ];
}

