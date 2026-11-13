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
import '../../../core/theme/ph.dart';

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
          Icon(Ph.cameraPlus, color: context.paw.accent, size: IconSizes.xl),
          const SizedBox(width: Space.md),
          Expanded(child: Text(l.albumAddFirst(pet.name), style: context.text.titleSmall)),
          const Icon(Ph.caretRight),
        ]),
      );
    } else {
      if (otd.isNotEmpty) header = yearsAgo(latest.takenAt, now) == 1 ? l.albumYearAgo : l.albumOnThisDay;
      card = _MemoryCard(pet: pet, item: latest, onThisDay: otd.isNotEmpty);
    }
  }
  return [
    const SizedBox(height: Sizes.sectionGap),
    SecHead(header, action: l.albumSeeAlbum, onAction: () => context.push('/pets/${pet.id}/album')),
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    void open() => context.push(viewerPath(pet.id, item.id));
    // UI Design 6: the memory as a small instant print, a little askew, with
    // its date written under the picture.
    final print = Semantics(
      button: true,
      label: [item.caption, when].where((s) => s.isNotEmpty).join(', '),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: open,
        child: Transform.rotate(
          angle: -Sizes.printTilt,
          child: Container(
            width: Sizes.print,
            padding: const EdgeInsets.fromLTRB(Space.xs + Space.xxs, Space.xs + Space.xxs, Space.xs + Space.xxs, Space.xs),
            decoration: BoxDecoration(
              color: dark ? PrintColors.brandTint : PrintColors.paper,
              borderRadius: BorderRadius.circular(Radii.xs + Space.xxs),
              boxShadow: Shadows.card(context.paw.ink),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Radii.xs),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(fit: StackFit.expand, children: [
                    MediaImage(url: item.url!, fit: BoxFit.cover),
                    if (item.isVideo) const Center(child: Icon(Ph.playCircleFill, color: MediaColors.foreground, size: IconSizes.xxl)),
                  ]),
                ),
              ),
              const SizedBox(height: Space.xs),
              Text(
                Fmt.date(item.takenAt, context.lang),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelSmall?.copyWith(color: PrintColors.muted, fontWeight: FontWeight.w500),
              ),
            ]),
          ),
        ),
      ),
    );
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      print,
      const SizedBox(width: Space.lg),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Space.xs),
          Text(item.caption.isEmpty ? l.albumOfPet(pet.name) : item.caption, style: context.text.labelLarge, maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: Space.xs),
          Text(
            [if (item.milestone != null) itemMilestoneLabel(context, item), when].join(' · '),
            style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
          ),
          const SizedBox(height: Space.md),
          PawButton(label: l.qaAddPhoto, icon: Ph.cameraPlus, kind: BtnKind.soft, onPressed: () => context.push('/pets/${pet.id}/album?add=1')),
        ]),
      ),
    ]);
  }
}
