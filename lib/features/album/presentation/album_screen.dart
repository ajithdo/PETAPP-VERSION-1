import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/paging.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/data/health_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../vault/presentation/vault_screen.dart' show StorageMeter;
import '../data/album_repository.dart';
import '../domain/album.dart';
import 'album_add.dart';
import 'album_labels.dart';
import 'album_share.dart';
import '../../../core/theme/ph.dart';

String viewerPath(String petId, String itemId, [String? filter]) =>
    '/pets/$petId/album/item/$itemId${filter == null ? '' : '?set=${Uri.encodeComponent(filter)}'}';

/// Memory album (spec 7.11): photos and videos by month, "On this day",
/// milestones timeline, albums and favourites, for one pet.
class AlbumScreen extends ConsumerStatefulWidget {
  const AlbumScreen({super.key, this.petId, this.openAdd = false});
  final String? petId;
  final bool openAdd;

  @override
  ConsumerState<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends ConsumerState<AlbumScreen> {
  String? _chosen;
  bool _addShown = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = ref.watch(myPetsProvider).value ?? const <Pet>[];
    final fixed = widget.petId;
    Pet? pet;
    if (fixed != null) {
      pet = ref.watch(petProvider(fixed)).value;
    } else {
      pet = pets.where((p) => p.id == _chosen).firstOrNull ?? ref.watch(selectedPetProvider) ?? pets.firstOrNull;
    }
    if (pet == null) {
      final loading = fixed != null ? ref.watch(petProvider(fixed)).isLoading : ref.watch(myPetsProvider).isLoading;
      return Scaffold(
        appBar: AppBar(title: Text(l.memoryAlbum)),
        body: loading ? const SkeletonList() : EmptyState(title: l.noPetsTitle, actionLabel: l.addPet, onAction: () => context.push('/pets/new')),
      );
    }
    final p = pet;
    if (widget.openAdd && !_addShown) {
      _addShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showAddMemorySheet(context, ref, p);
      });
    }
    final items = ref.watch(petAlbumProvider(p.id));
    final canLog = ref.watch(currentUserProvider) != null && p.canLog(ref.watch(currentUserProvider)!.uid);
    final title = Text(l.albumTitle(p.name), overflow: TextOverflow.ellipsis);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: fixed == null && pets.length > 1
              ? Semantics(
                  button: true,
                  label: l.switchPet,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.full),
                    onTap: () => _pickPet(pets),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: TapTarget.min),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.avatarXs),
                        const SizedBox(width: Space.sm),
                        Flexible(child: title),
                        const Icon(Ph.caretDown),
                      ]),
                    ),
                  ),
                )
              : title,
          actions: [
            IconButton(
              tooltip: l.albumFamilyLink,
              icon: const Icon(Ph.users),
              onPressed: () => showFamilyLinkSheet(context, ref, p, albumNames(items.value ?? const [])),
            ),
            if (p.birthday != null)
              IconButton(tooltip: l.albumBirthdayScreenTitle, icon: const Icon(Ph.cake), onPressed: () => context.push('/pets/${p.id}/birthday')),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [Tab(text: l.albumPhotos), Tab(text: l.albumTimeline), Tab(text: l.albumAlbums), Tab(text: l.albumFavourites)],
          ),
        ),
        floatingActionButton: canLog
            ? FloatingActionButton.extended(
                onPressed: () => showAddMemorySheet(context, ref, p),
                icon: const Icon(Ph.cameraPlus),
                label: Text(l.albumAdd),
              )
            : null,
        body: AsyncView<List<AlbumItem>>(
          value: items,
          data: (list) => TabBarView(children: [
            _PhotosTab(pet: p, items: list, canLog: canLog),
            _TimelineTab(pet: p, items: list, canLog: canLog),
            _AlbumsTab(pet: p, items: list, canLog: canLog),
            _FavouritesTab(pet: p, items: list),
          ]),
        ),
      ),
    );
  }

  void _pickPet(List<Pet> pets) {
    showPawSheet<void>(context, builder: (ctx) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(ctx.l10n.switchPet, style: ctx.text.titleMedium),
        const SizedBox(height: Space.sm),
        for (final p in pets)
          ListTile(
            leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: Sizes.avatarSm),
            title: Text(p.name),
            subtitle: p.archived ? Text(ctx.l10n.inLovingMemory) : null,
            onTap: () {
              Navigator.pop(ctx);
              setState(() => _chosen = p.id);
            },
          ),
      ]);
    });
  }
}

/// Grid of square memory tiles that fits the width (3 on phones).
class MemoryGrid extends StatelessWidget {
  const MemoryGrid({super.key, required this.items, required this.onTap, this.onLongPress, this.feature = false});
  final List<AlbumItem> items;
  final void Function(AlbumItem) onTap;
  final void Function(AlbumItem)? onLongPress;

  /// UI Design 6 month walls: the first memory big (two columns, two rows)
  /// with the next two beside it, then the rest in the grid.
  final bool feature;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth / 130).floor().clamp(3, 8);
      Widget tile(AlbumItem i) => MemoryTile(item: i, onTap: () => onTap(i), onLongPress: onLongPress == null ? null : () => onLongPress!(i));
      if (feature && items.length >= 3) {
        const gap = Space.xs + Space.xxs;
        final cell = (c.maxWidth - gap * (cols - 1)) / cols;
        final rest = items.skip(3).toList();
        return Column(children: [
          SizedBox(
            height: cell * 2 + gap,
            child: Row(children: [
              SizedBox(width: cell * 2 + gap, child: tile(items[0])),
              const SizedBox(width: gap),
              SizedBox(width: cell, child: Column(children: [Expanded(child: tile(items[1])), const SizedBox(height: gap), Expanded(child: tile(items[2]))])),
            ]),
          ),
          if (rest.isNotEmpty) ...[const SizedBox(height: gap), MemoryGrid(items: rest, onTap: onTap, onLongPress: onLongPress)],
        ]);
      }
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: Space.xs + Space.xxs,
        crossAxisSpacing: Space.xs + Space.xxs,
        children: [for (final i in items) MemoryTile(item: i, onTap: () => onTap(i), onLongPress: onLongPress == null ? null : () => onLongPress!(i))],
      );
    });
  }
}

class MemoryTile extends StatelessWidget {
  const MemoryTile({super.key, required this.item, required this.onTap, this.onLongPress, this.selected, this.radius});
  final AlbumItem item;

  /// Corner radius; a print's picture is squarer than a grid tile.
  final double? radius;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final label = [
      if (item.isVideo) l.albumVideo,
      if (item.caption.isNotEmpty) item.caption,
      Fmt.date(item.takenAt, context.lang),
      if (item.favourite) l.albumFavourites,
    ].join(', ');
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? Radii.md),
        child: Material(
          color: context.paw.outline,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(fit: StackFit.expand, children: [
              MediaImage(url: item.url!, fit: BoxFit.cover),
              if (item.isVideo) Positioned(left: Space.xs + Space.xxs, bottom: Space.xs + Space.xxs, child: PawTag(videoLength(item.durationSec), kind: TagKind.ink, icon: Ph.playFill)),
              if (item.favourite)
                const Positioned(
                  right: Space.xs + Space.xxs,
                  top: Space.xs + Space.xxs,
                  child: Icon(Ph.heartFill, color: MediaColors.foreground, size: IconSizes.sm, shadows: [Shadow(color: MediaColors.scrim, blurRadius: Space.xxs, offset: Offset(0, Strokes.hairline))]),
                ),
              if (selected != null)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Icon(selected! ? Ph.checkCircleFill : Ph.circle,
                      color: selected! ? context.colors.primary : MediaColors.foreground, shadows: const [Shadow(blurRadius: Space.xs)]),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _PhotosTab extends ConsumerWidget {
  const _PhotosTab({required this.pet, required this.items, required this.canLog});
  final Pet pet;
  final List<AlbumItem> items;
  final bool canLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final media = items.where((i) => i.hasMedia).toList();
    final now = DateTime.now();
    final otd = onThisDay(media, now);
    final groups = groupByMonth(media);
    final next = nextBirthday(pet.birthday, now);
    final days = next == null ? null : daysUntil(next, now);
    return PageBody(maxWidth: Space.maxContentWidth, children: [
      const SizedBox(height: Space.md),
      if (next != null && days != null && days <= 30 && !pet.archived) ...[
        BirthdayCard(pet: pet, next: next, days: days),
        const SizedBox(height: Space.md),
      ],
      if (otd.isNotEmpty) ...[
        OnThisDayCard(pet: pet, items: otd),
        const SizedBox(height: Space.md),
      ],
      if (media.isEmpty)
        EmptyState(
          scene: Scene.memory,
          title: l.albumEmptyTitle,
          message: l.albumEmptyBody(pet.name),
          actionLabel: canLog ? l.albumAdd : null,
          onAction: canLog ? () => showAddMemorySheet(context, ref, pet) : null,
        )
      else
        StorageMeter(note: _videoNote(context, ref)),
      ..._months(context, ref, groups, media.length),
      const SizedBox(height: Space.fabClearance),
    ]);
  }

  /// "Videos up to 3 min with Plus."
  String _videoNote(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final secs = ((ref.watch(planLimitsProvider)['videoSeconds'] as num?) ?? 60).toInt();
    final length = secs >= 60 ? l.plusMinutes((secs / 60).round()) : l.plusSeconds(secs);
    return ref.watch(currentUserProvider)?.isPlus ?? false ? l.albumVideoUpToPlus(length) : l.albumVideoUpTo(length);
  }

  /// Month by month, newest first, a page of photos at a time.
  List<Widget> _months(BuildContext context, WidgetRef ref, List<MonthGroup> groups, int total) {
    final key = 'album:${pet.id}';
    final limit = ref.watch(listLimitProvider(key));
    var shown = 0;
    final out = <Widget>[];
    for (final g in groups) {
      if (shown >= limit) break;
      final part = g.items.take(limit - shown).toList();
      shown += part.length;
      final marks = part.where((i) => i.milestone != null).toList();
      final newest = out.isEmpty;
      out
        ..add(const SizedBox(height: Sizes.sectionGap))
        ..add(SecHead(Fmt.monthYear(g.month, context.lang), note: context.l10n.albumMonthCount(g.items.length)))
        // The newest month opens with one big picture, as in the design.
        ..add(MemoryGrid(items: part, feature: newest, onTap: (i) => context.push(viewerPath(pet.id, i.id))));
      if (marks.isNotEmpty) {
        out.add(Padding(
          padding: const EdgeInsets.only(top: Space.sm),
          child: Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
            for (final m in marks) PawTag(context.l10n.albumMilestoneTag(itemMilestoneLabel(context, m)), kind: TagKind.gold, icon: milestoneIcon(m.milestone!)),
          ]),
        ));
      }
    }
    if (total > limit) out.add(ShowMoreButton(onPressed: () => ref.read(listLimitProvider(key).notifier).more()));
    return out;
  }
}

/// "On this day" memories from earlier years: two instant prints, a little
/// askew and overlapping, on a marigold wash, with what the day was.
class OnThisDayCard extends StatelessWidget {
  const OnThisDayCard({super.key, required this.pet, required this.items});
  final Pet pet;
  final List<AlbumItem> items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final paw = context.paw;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final shown = items.take(2).toList();
    final sameYear = items.every((i) => i.takenAt.year == items.first.takenAt.year);
    final caption = items.map((i) => i.caption).firstWhere((c) => c.isNotEmpty, orElse: () => '');
    Widget print(AlbumItem item, double angle) => Transform.rotate(
          angle: angle,
          child: Container(
            width: Sizes.onThisDayPrint,
            padding: const EdgeInsets.fromLTRB(Space.xs + Space.xxs, Space.xs + Space.xxs, Space.xs + Space.xxs, Space.xl),
            decoration: BoxDecoration(color: dark ? PrintColors.brandTint : PrintColors.paper, borderRadius: BorderRadius.circular(Radii.xs + Space.xxs), boxShadow: Shadows.card(paw.ink)),
            child: AspectRatio(aspectRatio: 1, child: MemoryTile(item: item, radius: Radii.xs, onTap: () => context.push(viewerPath(pet.id, item.id)))),
          ),
        );
    return Wash(
      tone: Tone.gold,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Ph.clockCounterClockwise, size: IconSizes.sm + Space.xxs, color: paw.textPrimary),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(sameYear ? l.albumOnThisDayAgo(yearsAgoLabel(context, items.first.takenAt)) : l.albumOnThisDay, style: context.text.labelLarge)),
        ]),
        const SizedBox(height: Space.lg + Space.xs),
        Center(
          child: shown.length == 1
              ? print(shown.first, -Sizes.printTilt)
              : SizedBox(
                  // Two prints, the second tucked 20 px under the first and
                  // 12 px lower.
                  width: Sizes.onThisDayPrint * 2 - Space.lg - Space.xs,
                  height: Sizes.onThisDayPrint + Space.xl + Space.lg,
                  child: Stack(clipBehavior: Clip.none, children: [
                    Positioned(left: 0, top: 0, child: print(shown[0], -Sizes.printTilt * 1.6)),
                    Positioned(right: 0, top: Space.md, child: print(shown[1], Sizes.printTilt * 1.2)),
                  ]),
                ),
        ),
        if (caption.isNotEmpty) ...[
          const SizedBox(height: Space.lg),
          Text(caption, style: context.text.bodySmall?.copyWith(color: paw.accent), textAlign: TextAlign.center),
        ],
      ]),
    );
  }
}

/// Upcoming birthday or "Happy birthday" today.
class BirthdayCard extends StatelessWidget {
  const BirthdayCard({super.key, required this.pet, required this.next, required this.days});
  final Pet pet;
  final DateTime next;
  final int days;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final age = turningAge(pet.birthday!, next);
    final today = days == 0;
    return PawCard(
      color: today ? context.paw.accent.withValues(alpha: Opacities.selection) : context.paw.primaryContainer.withValues(alpha: Opacities.half),
      onTap: () => context.push('/pets/${pet.id}/birthday'),
      child: Row(children: [
        Icon(Ph.cake, color: today ? context.paw.onAccentContainer : context.colors.primary, size: IconSizes.xxl),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(today ? l.albumBirthdayToday(pet.name) : l.albumBirthdayIn(days, pet.name, age), style: context.text.titleSmall),
            Text(today ? l.albumBirthdaySubtitle(age, pet.name) : Fmt.date(next, context.lang), style: context.text.bodySmall),
          ]),
        ),
        Text(l.albumCelebrate, style: context.text.labelLarge?.copyWith(color: context.colors.primary)),
      ]),
    );
  }
}

class _TimelineTab extends ConsumerWidget {
  const _TimelineTab({required this.pet, required this.items, required this.canLog});
  final Pet pet;
  final List<AlbumItem> items;
  final bool canLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ms = milestones(items);
    final earned = earnedBadges(items);
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final reminderOn = reminders.any((r) => r.petId == pet.id && r.type == 'birthday' && !r.done);
    final user = ref.watch(currentUserProvider);
    return PageBody(maxWidth: Space.readingWidth, children: [
      const SizedBox(height: Space.md),
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.albumBadges, style: context.text.titleSmall),
          const SizedBox(height: Space.md),
          Wrap(spacing: Space.md, runSpacing: Space.md, children: [
            for (final k in milestoneKinds)
              SizedBox(
                width: Sizes.badgeCell,
                child: Semantics(
                  label: '${milestoneLabel(context, k)}${earned.contains(k) ? '' : ' (${l.albumBadgeLocked})'}',
                  excludeSemantics: true,
                  child: Column(children: [
                    MilestoneBadge(kind: k, size: Sizes.avatarMd, earned: earned.contains(k)),
                    const SizedBox(height: Space.xs),
                    Text(milestoneLabel(context, k), style: context.text.labelSmall, textAlign: TextAlign.center, maxLines: 2),
                  ]),
                ),
              ),
          ]),
        ]),
      ),
      if (pet.birthday != null && user != null && pet.ownerId == user.uid && !pet.archived) ...[
        const SizedBox(height: Space.md),
        PawCard(
          padding: EdgeInsets.zero,
          child: SwitchListTile(
            secondary: Icon(Ph.cake, color: context.paw.accent),
            title: Text(l.albumBirthdayReminder(pet.name)),
            subtitle: Text(reminderOn ? l.albumBirthdayReminderOn : Fmt.date(nextBirthday(pet.birthday, DateTime.now())!, context.lang)),
            value: reminderOn,
            onChanged: (v) => ref.read(albumRepositoryProvider).setBirthdayReminder(
                  pet: pet,
                  ownerId: user.uid,
                  at: nextBirthday(pet.birthday, DateTime.now())!,
                  title: l.albumBirthdayReminderTitle(pet.name),
                  on: v,
                ),
          ),
        ),
      ],
      SectionHeader(l.albumTimeline, action: canLog ? l.albumAddMilestone : null, onAction: () => showMemoryEditSheet(context, ref, pet, milestone: 'custom')),
      if (pet.birthday != null) _TimelineEntry(icon: Ph.babyCarriage, color: context.colors.primary, title: l.albumTimelineBorn(pet.name), date: pet.birthday!),
      for (final m in ms)
        _TimelineEntry(
          badge: m.milestone,
          title: itemMilestoneLabel(context, m),
          date: m.takenAt,
          caption: m.caption,
          thumb: m.hasMedia ? m : null,
          onTap: m.hasMedia ? () => context.push(viewerPath(pet.id, m.id)) : (canLog ? () => showMemoryEditSheet(context, ref, pet, existing: m) : null),
          last: m == ms.last,
        ),
      if (ms.isEmpty)
        Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Text(l.albumTimelineEmpty(pet.name), style: context.text.bodyMedium),
        ),
      const SizedBox(height: Space.fabClearance),
    ]);
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.title, required this.date, this.badge, this.icon, this.color, this.caption, this.thumb, this.onTap, this.last = false});
  final String title;
  final DateTime date;
  final String? badge;
  final IconData? icon;
  final Color? color;
  final String? caption;
  final AlbumItem? thumb;
  final VoidCallback? onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
          width: Sizes.avatarMd,
          child: Column(children: [
            badge != null
                ? MilestoneBadge(kind: badge!, size: Sizes.avatarSm)
                : CircleAvatar(radius: Sizes.avatarSm / 2, backgroundColor: (color ?? context.colors.primary).withValues(alpha: Opacities.tintStrong), child: Icon(icon, color: color)),
            if (!last) Expanded(child: Container(width: Strokes.focus, color: context.paw.outline)),
          ]),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Space.lg),
            child: PawCard(
              padding: const EdgeInsets.all(Space.md),
              onTap: onTap,
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: context.text.titleSmall),
                    Text(Fmt.date(date, context.lang), style: context.text.bodySmall),
                    if (caption?.isNotEmpty ?? false) ...[
                      const SizedBox(height: Space.xs),
                      Text(caption!, style: context.text.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ]),
                ),
                if (thumb != null) ...[
                  const SizedBox(width: Space.md),
                  ClipRRect(borderRadius: BorderRadius.circular(Radii.md), child: MediaImage(url: thumb!.url!, width: Sizes.thumbLg, height: Sizes.thumbLg)),
                ],
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _AlbumsTab extends ConsumerWidget {
  const _AlbumsTab({required this.pet, required this.items, required this.canLog});
  final Pet pet;
  final List<AlbumItem> items;
  final bool canLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final names = albumNames(items);
    return PageBody(maxWidth: Space.maxContentWidth, children: [
      const SizedBox(height: Space.md),
      if (canLog)
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.tonalIcon(
            onPressed: () async {
              final name = await askAlbumName(context);
              if (name == null || !context.mounted) return;
              final picked = await pickMemories(context, pet, items, l.albumChooseForAlbum(name));
              if (picked == null || picked.isEmpty) return;
              await ref.read(albumRepositoryProvider).addToAlbum(picked, name);
              if (context.mounted) showToast(context, l.albumAddedToAlbum(name));
            },
            icon: const Icon(Ph.folderPlus),
            label: Text(l.albumNewAlbum),
          ),
        ),
      const SizedBox(height: Space.md),
      if (names.isEmpty)
        EmptyState(scene: Scene.memory, title: l.albumNoAlbums, message: l.albumNoAlbumsBody, compact: true)
      else
        ResponsiveGrid(minItemWidth: 160, children: [
          for (final n in names)
            Builder(builder: (context) {
              final inAlbum = items.where((i) => i.albums.contains(n) && i.hasMedia).toList();
              return PawCard(
                padding: EdgeInsets.zero,
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AlbumDetailScreen(petId: pet.id, name: n))),
                semanticLabel: '$n, ${l.albumMonthCount(inAlbum.length)}',
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: inAlbum.isEmpty
                        ? ColoredBox(color: context.paw.primaryContainer, child: Icon(Ph.imagesSquare, color: context.colors.primary, size: IconSizes.xxxl))
                        : MediaImage(url: inAlbum.first.url!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Space.md),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(n, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(l.albumMonthCount(inAlbum.length), style: context.text.bodySmall),
                    ]),
                  ),
                ]),
              );
            }),
        ]),
      const SizedBox(height: Space.fabClearance),
    ]);
  }
}

class _FavouritesTab extends StatelessWidget {
  const _FavouritesTab({required this.pet, required this.items});
  final Pet pet;
  final List<AlbumItem> items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fav = items.where((i) => i.favourite && i.hasMedia).toList();
    if (fav.isEmpty) return EmptyState(scene: Scene.memory, title: l.albumNoFavourites, message: l.albumNoFavouritesBody);
    return PageBody(maxWidth: Space.maxContentWidth, children: [
      const SizedBox(height: Space.md),
      MemoryGrid(items: fav, onTap: (i) => context.push(viewerPath(pet.id, i.id, 'fav'))),
      const SizedBox(height: Space.fabClearance),
    ]);
  }
}

/// One named album: its photos, add more, rename or remove the album.
class AlbumDetailScreen extends ConsumerWidget {
  const AlbumDetailScreen({super.key, required this.petId, required this.name});
  final String petId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final all = ref.watch(petAlbumProvider(petId)).value ?? const <AlbumItem>[];
    final pet = ref.watch(petProvider(petId)).value;
    final items = all.where((i) => i.albums.contains(name) && i.hasMedia).toList()..sort((a, b) => b.takenAt.compareTo(a.takenAt));
    final user = ref.watch(currentUserProvider);
    final canLog = pet != null && user != null && pet.canLog(user.uid);
    final repo = ref.read(albumRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          if (canLog)
            PopupMenuButton<String>(
              tooltip: l.moreOptions,
              onSelected: (v) async {
                if (v == 'add') {
                  final picked = await pickMemories(context, pet, all.where((i) => i.hasMedia && !i.albums.contains(name)).toList(), l.albumChooseForAlbum(name));
                  if (picked != null && picked.isNotEmpty) await repo.addToAlbum(picked, name);
                }
                if (v == 'rename' && context.mounted) {
                  final to = await askAlbumName(context, initial: name, title: l.albumRenameAlbum);
                  if (to != null && to != name) {
                    await repo.renameAlbum(all, name, to);
                    if (context.mounted) Navigator.pop(context);
                  }
                }
                if (v == 'delete' && context.mounted) {
                  final ok = await confirmAction(context, title: l.albumDeleteAlbum, body: l.albumDeleteAlbumBody(pet.name), confirmLabel: l.remove);
                  if (ok) {
                    await repo.deleteAlbum(all, name);
                    if (context.mounted) Navigator.pop(context);
                  }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'add', child: ListTile(leading: const Icon(Ph.image), title: Text(l.albumAddToAlbum))),
                PopupMenuItem(value: 'rename', child: ListTile(leading: const Icon(Ph.pencilSimple), title: Text(l.albumRenameAlbum))),
                PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Ph.folderMinus), title: Text(l.albumDeleteAlbum))),
              ],
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(scene: Scene.memory, title: l.albumNoAlbums, compact: true)
          : PageBody(maxWidth: Space.maxContentWidth, children: [
              const SizedBox(height: Space.md),
              MemoryGrid(
                items: items,
                onTap: (i) => context.push(viewerPath(petId, i.id, 'album:$name')),
                onLongPress: canLog
                    ? (i) async {
                        final ok = await confirmAction(context, title: l.albumRemoveFromAlbum, confirmLabel: l.remove, danger: false);
                        if (ok) await repo.removeFromAlbum(i, name);
                      }
                    : null,
              ),
            ]),
    );
  }
}

/// Lets the owner tick several memories; returns them, or null if cancelled.
Future<List<AlbumItem>?> pickMemories(BuildContext context, Pet pet, List<AlbumItem> items, String title) {
  return Navigator.of(context).push<List<AlbumItem>>(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => _PickMemoriesScreen(items: items.where((i) => i.hasMedia).toList(), title: title),
  ));
}

class _PickMemoriesScreen extends StatefulWidget {
  const _PickMemoriesScreen({required this.items, required this.title});
  final List<AlbumItem> items;
  final String title;
  @override
  State<_PickMemoriesScreen> createState() => _PickMemoriesScreenState();
}

class _PickMemoriesScreenState extends State<_PickMemoriesScreen> {
  final _sel = <String>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: _sel.isEmpty ? null : () => Navigator.pop(context, widget.items.where((i) => _sel.contains(i.id)).toList()),
            child: Text(l.done),
          ),
        ],
      ),
      body: PageBody(maxWidth: Space.maxContentWidth, children: [
        const SizedBox(height: Space.sm),
        Text(l.albumItemsSelected(_sel.length), style: context.text.bodySmall),
        const SizedBox(height: Space.sm),
        LayoutBuilder(builder: (context, c) {
          final cols = (c.maxWidth / 130).floor().clamp(3, 8);
          return GridView.count(
            crossAxisCount: cols,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: [
              for (final i in widget.items)
                MemoryTile(
                  item: i,
                  selected: _sel.contains(i.id),
                  onTap: () => setState(() => _sel.contains(i.id) ? _sel.remove(i.id) : _sel.add(i.id)),
                ),
            ],
          );
        }),
      ]),
    );
  }
}
