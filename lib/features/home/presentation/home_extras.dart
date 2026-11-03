import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/data/health_repository.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../health/presentation/health_labels.dart';
import '../../health/presentation/health_screen.dart';
import '../../pets/domain/pet.dart';

export '../../messaging/messaging_slots.dart' show askVetLink;
export '../../shop/shop_slots.dart' show foodLowSection;
export '../../sos/sos_slots.dart' show lostPetSection;
export '../../vault/vault_slots.dart' show addPhotoLink, latestMemorySection;

/// Home "Next up": vaccines, medicines and care due soonest (spec 5).
/// The most urgent item is a Design 2 alert card; up to two more follow as
/// rows.
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
  final header = SectionHeader(l.nextUp, action: l.seeAll, onAction: () => context.go('/health'));
  if (items.isEmpty) {
    return [
      header,
      PawCard(
        child: Row(children: [
          Icon(Icons.check_circle_outline_rounded, color: context.paw.success),
          const SizedBox(width: Space.md),
          Expanded(child: Text(l.nothingDueAll, style: context.text.bodyMedium)),
        ]),
      ),
    ];
  }
  final showPet = pets.length > 1;
  final (pet, first) = items.first;
  final title = dueTitle(context, first);
  final when = dueWhen(context, first);
  final status = statusChip(context, first.status).$1;
  final rest = items.skip(1).take(2).toList();
  return [
    header,
    PawAlertCard(
      tone: first.status == DoseStatus.overdue ? ChipTone.error : ChipTone.warning,
      icon: dueIcon(first.kind),
      overline: when.isEmpty ? status : when,
      title: showPet ? '${pet.name} · $title' : title,
      semanticLabel: [status, if (showPet) pet.name, title, when].where((s) => s.isNotEmpty).join(', '),
      onTap: () => openDueItem(context, ref, pet, first),
    ),
    if (rest.isNotEmpty) ...[
      const SizedBox(height: Space.md),
      PawCard(
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Column(children: [
          for (final it in rest) DueTile(item: it.$2, pet: it.$1, showPet: showPet),
        ]),
      ),
    ],
  ];
}
