import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/album_repository.dart';
import '../domain/album.dart';
import 'album_labels.dart';
import 'album_screen.dart';

/// Home "latest memory" (spec 5): the birthday on the day, otherwise an
/// "On this day" memory, otherwise the newest photo; a gentle prompt when
/// the album is still empty.
List<Widget> homeMemorySection(BuildContext context, WidgetRef ref, Pet pet) {
  final l = context.l10n;
  final items = ref.watch(petAlbumProvider(pet.id)).value;
  if (items == null) return const [];
  final now = DateTime.now();
  final Widget card;
  String header = l.albumLatestMemory;
  if (isBirthdayToday(pet.birthday, now)) {
    header = l.albumBirthdayScreenTitle;
    card = BirthdayCard(pet: pet, next: nextBirthday(pet.birthday, now)!, days: 0);
  } else {
    final otd = onThisDay(items, now);
    final latest = otd.isNotEmpty ? otd.first : latestMemory(items);
    if (latest == null) {
      card = PawCard(
        onTap: () => context.push('/pets/${pet.id}/album?add=1'),
        child: Row(children: [
          Icon(Icons.add_a_photo_rounded, color: context.paw.accent, size: 32),
          const SizedBox(width: Space.md),
          Expanded(child: Text(l.albumAddFirst(pet.name), style: context.text.titleSmall)),
          const Icon(Icons.chevron_right_rounded),
        ]),
      );
    } else {
      if (otd.isNotEmpty) header = l.albumOnThisDay;
      card = _MemoryCard(pet: pet, item: latest, onThisDay: otd.isNotEmpty);
    }
  }
  return [
    SectionHeader(header, action: l.albumSeeAlbum, onAction: () => context.push('/pets/${pet.id}/album')),
    card,
  ];
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({required this.pet, required this.item, required this.onThisDay});
  final Pet pet;
  final AlbumItem item;
  final bool onThisDay;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final when = onThisDay ? yearsAgoLabel(context, item.takenAt) : Fmt.date(item.takenAt, context.lang);
    return PawCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(viewerPath(pet.id, item.id)),
      semanticLabel: [item.caption, when].where((s) => s.isNotEmpty).join(', '),
      child: Row(children: [
        SizedBox(
          width: 112,
          height: 112,
          child: Stack(fit: StackFit.expand, children: [
            MediaImage(url: item.url!, fit: BoxFit.cover),
            if (item.isVideo) const Center(child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 36)),
          ]),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (item.milestone != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: StatusChip(itemMilestoneLabel(context, item), tone: ChipTone.accent, icon: milestoneIcon(item.milestone!)),
                ),
              Text(item.caption.isEmpty ? l.albumOfPet(pet.name) : item.caption, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(when, style: context.text.bodySmall),
            ]),
          ),
        ),
        const Padding(padding: EdgeInsets.only(right: Space.sm), child: Icon(Icons.chevron_right_rounded)),
      ]),
    );
  }
}
