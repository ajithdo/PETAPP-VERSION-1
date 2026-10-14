import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final title = Text(l.albumOfPet(p.name), overflow: TextOverflow.ellipsis);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: fixed == null && pets.length > 1
              ? Semantics(
                  button: true,
                  label: l.switchPet,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => _pickPet(pets),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 32),
                      const SizedBox(width: Space.sm),
                      Flexible(child: title),
                      const Icon(Icons.expand_more_rounded),
                    ]),
                  ),
                )
              : title,
          actions: [
            IconButton(
              tooltip: l.albumFamilyLink,
              icon: const Icon(Icons.group_rounded),
              onPressed: () => showFamilyLinkSheet(context, ref, p, albumNames(items.value ?? const [])),
            ),
            if (p.birthday != null)
              IconButton(tooltip: l.albumBirthdayScreenTitle, icon: const Icon(Icons.cake_rounded), onPressed: () => context.push('/pets/${p.id}/birthday')),
          ],
          bottom: TabBar(
            isScrollable: context.isPhone,
            tabAlignment: context.isPhone ? TabAlignment.start : null,
            tabs: [Tab(text: l.albumPhotos), Tab(text: l.albumTimeline), Tab(text: l.albumAlbums), Tab(text: l.albumFavourites)],
          ),
        ),
        floatingActionButton: canLog
            ? FloatingActionButton.extended(
                onPressed: () => showAddMemorySheet(context, ref, p),
                icon: const Icon(Icons.add_a_photo_rounded),
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
            leading: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 40),
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
  const MemoryGrid({super.key, required this.items, required this.onTap, this.onLongPress});
  final List<AlbumItem> items;
  final void Function(AlbumItem) onTap;
  final void Function(AlbumItem)? onLongPress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth / 130).floor().clamp(3, 8);
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: [for (final i in items) MemoryTile(item: i, onTap: () => onTap(i), onLongPress: onLongPress == null ? null : () => onLongPress!(i))],
      );
    });
  }
}

class MemoryTile extends StatelessWidget {
  const MemoryTile({super.key, required this.item, required this.onTap, this.onLongPress, this.selected});
  final AlbumItem item;
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
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: context.paw.outline,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(fit: StackFit.expand, children: [
              MediaImage(url: item.url!, fit: BoxFit.cover),
              if (item.isVideo)
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                      Text(videoLength(item.durationSec), style: const TextStyle(color: Colors.white, fontSize: 11)),
                    ]),
                  ),
                ),
              if (item.favourite)
                Positioned(right: 6, top: 6, child: Icon(Icons.favorite_rounded, color: PetTagColors.of('rose'), size: 18, shadows: const [Shadow(blurRadius: 4)])),
              if (item.milestone != null) Positioned(left: 6, top: 6, child: MilestoneBadge(kind: item.milestone!, size: 24)),
              if (selected != null)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Icon(selected! ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: selected! ? context.colors.primary : Colors.white, shadows: const [Shadow(blurRadius: 4)]),
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
    return PageBody(maxWidth: 1100, children: [
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
        ),
      for (final g in groups) ...[
        Padding(
          padding: const EdgeInsets.only(top: Space.md, bottom: Space.sm),
          child: Row(children: [
            Expanded(child: Semantics(header: true, child: Text(Fmt.monthYear(g.month, context.lang), style: context.text.titleMedium))),
            Text(l.albumMonthCount(g.items.length), style: context.text.bodySmall),
          ]),
        ),
        MemoryGrid(items: g.items, onTap: (i) => context.push(viewerPath(pet.id, i.id))),
      ],
      const SizedBox(height: Space.xl),
      const StorageMeter(),
      const SizedBox(height: 80),
    ]);
  }
}

/// "On this day" memories from earlier years.
class OnThisDayCard extends StatelessWidget {
  const OnThisDayCard({super.key, required this.pet, required this.items});
  final Pet pet;
  final List<AlbumItem> items;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PawCard(
      color: context.paw.accent.withValues(alpha: 0.14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.history_rounded, color: context.paw.onAccent),
          const SizedBox(width: Space.sm),
          Text(l.albumOnThisDay, style: context.text.titleMedium),
        ]),
        const SizedBox(height: Space.md),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: Space.sm),
            itemBuilder: (_, i) {
              final it = items[i];
              return SizedBox(
                width: 120,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: 120, width: 120, child: MemoryTile(item: it, onTap: () => context.push(viewerPath(pet.id, it.id)))),
                  const SizedBox(height: 4),
                  Text(yearsAgoLabel(context, it.takenAt), style: context.text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              );
            },
          ),
        ),
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
      color: today ? context.paw.accent.withValues(alpha: 0.28) : context.paw.primaryContainer.withValues(alpha: 0.6),
      onTap: () => context.push('/pets/${pet.id}/birthday'),
      child: Row(children: [
        Icon(Icons.cake_rounded, color: today ? context.paw.onAccent : context.colors.primary, size: 36),
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
    return PageBody(maxWidth: 820, children: [
      const SizedBox(height: Space.md),
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.albumBadges, style: context.text.titleSmall),
          const SizedBox(height: Space.md),
          Wrap(spacing: Space.md, runSpacing: Space.md, children: [
            for (final k in milestoneKinds)
              SizedBox(
                width: 76,
                child: Semantics(
                  label: '${milestoneLabel(context, k)}${earned.contains(k) ? '' : ' (${l.albumBadgeLocked})'}',
                  excludeSemantics: true,
                  child: Column(children: [
                    MilestoneBadge(kind: k, size: 48, earned: earned.contains(k)),
                    const SizedBox(height: 4),
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
            secondary: Icon(Icons.cake_rounded, color: context.paw.accent),
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
      if (pet.birthday != null) _TimelineEntry(icon: Icons.child_friendly_rounded, color: context.colors.primary, title: l.albumTimelineBorn(pet.name), date: pet.birthday!),
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
      const SizedBox(height: 80),
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
          width: 48,
          child: Column(children: [
            badge != null
                ? MilestoneBadge(kind: badge!, size: 40)
                : CircleAvatar(radius: 20, backgroundColor: (color ?? context.colors.primary).withValues(alpha: 0.2), child: Icon(icon, color: color)),
            if (!last) Expanded(child: Container(width: 2, color: context.paw.outline)),
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
                      const SizedBox(height: 4),
                      Text(caption!, style: context.text.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ]),
                ),
                if (thumb != null) ...[
                  const SizedBox(width: Space.md),
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: MediaImage(url: thumb!.url!, width: 64, height: 64)),
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
    return PageBody(maxWidth: 1100, children: [
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
            icon: const Icon(Icons.create_new_folder_rounded),
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
                        ? ColoredBox(color: context.paw.primaryContainer, child: Icon(Icons.photo_album_rounded, color: context.colors.primary, size: 40))
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
      const SizedBox(height: 80),
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
    return PageBody(maxWidth: 1100, children: [
      const SizedBox(height: Space.md),
      MemoryGrid(items: fav, onTap: (i) => context.push(viewerPath(pet.id, i.id, 'fav'))),
      const SizedBox(height: 80),
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
                PopupMenuItem(value: 'add', child: ListTile(leading: const Icon(Icons.add_photo_alternate_rounded), title: Text(l.albumAddToAlbum))),
                PopupMenuItem(value: 'rename', child: ListTile(leading: const Icon(Icons.edit_rounded), title: Text(l.albumRenameAlbum))),
                PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Icons.folder_delete_rounded), title: Text(l.albumDeleteAlbum))),
              ],
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(scene: Scene.memory, title: l.albumNoAlbums, compact: true)
          : PageBody(maxWidth: 1100, children: [
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
      body: PageBody(maxWidth: 1100, children: [
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
