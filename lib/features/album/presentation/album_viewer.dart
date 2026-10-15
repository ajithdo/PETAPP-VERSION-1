import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/album_repository.dart';
import '../domain/album.dart';
import 'album_add.dart';
import 'album_labels.dart';
import 'album_share.dart';
import 'video/video_view.dart';

/// Which items a viewer pages through: everything, favourites or one album.
List<AlbumItem> filterItems(List<AlbumItem> all, String? filter) {
  final media = all.where((i) => i.hasMedia).toList()..sort((a, b) => b.takenAt.compareTo(a.takenAt));
  if (filter == 'fav') return media.where((i) => i.favourite).toList();
  if (filter != null && filter.startsWith('album:')) {
    final name = filter.substring(6);
    return media.where((i) => i.albums.contains(name)).toList();
  }
  return media;
}

/// Full-screen swipe viewer for the owner and family (spec 7.11).
class AlbumViewerScreen extends ConsumerWidget {
  const AlbumViewerScreen({super.key, required this.petId, required this.itemId, this.filter});
  final String petId;
  final String itemId;
  final String? filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(petAlbumProvider(petId));
    final pet = ref.watch(petProvider(petId)).value;
    return Scaffold(
      backgroundColor: Colors.black,
      body: all.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ErrorState(onRetry: () => ref.invalidate(petAlbumProvider(petId))),
        data: (list) {
          final items = filterItems(list, filter);
          if (items.isEmpty || pet == null) {
            return Center(child: IconButton(tooltip: context.l10n.close, onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded, color: Colors.white)));
          }
          final start = items.indexWhere((i) => i.id == itemId);
          return MediaPager(items: items, initialIndex: start < 0 ? 0 : start, pet: pet);
        },
      ),
    );
  }
}

/// Swipeable photos and videos. With [pet] set, owner actions are shown
/// (favourite, share, edit, delete); without it the viewer is read-only
/// (public family link).
class MediaPager extends ConsumerStatefulWidget {
  const MediaPager({super.key, required this.items, required this.initialIndex, this.pet, this.petName});
  final List<AlbumItem> items;
  final int initialIndex;
  final Pet? pet;
  final String? petName;

  @override
  ConsumerState<MediaPager> createState() => _MediaPagerState();
}

class _MediaPagerState extends ConsumerState<MediaPager> {
  late final PageController _page = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;
  final _focus = FocusNode();

  @override
  void dispose() {
    _page.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.items.length - 1);
    if (next == _index) return;
    _page.animateToPage(next, duration: Duration(milliseconds: context.reduceMotion ? 1 : 250), curve: Curves.easeOut);
  }

  void _close() {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = widget.items;
    final item = items[_index.clamp(0, items.length - 1)];
    final pet = widget.pet;
    final user = ref.watch(currentUserProvider);
    final canLog = pet != null && user != null && pet.canLog(user.uid);
    final wide = !context.isPhone;
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: (_, e) {
        if (e is! KeyDownEvent) return KeyEventResult.ignored;
        if (e.logicalKey == LogicalKeyboardKey.arrowLeft) _go(-1);
        if (e.logicalKey == LogicalKeyboardKey.arrowRight) _go(1);
        if (e.logicalKey == LogicalKeyboardKey.escape) _close();
        return KeyEventResult.handled;
      },
      child: SafeArea(
        child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.xs),
            child: Row(children: [
              IconButton(tooltip: l.albumClose, onPressed: _close, icon: const Icon(Icons.close_rounded, color: Colors.white)),
              Expanded(
                child: Text(l.albumOfCount(_index + 1, items.length),
                    style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              ),
              if (pet != null) ...[
                IconButton(
                  tooltip: item.favourite ? l.albumUnfavourite : l.albumFavourite,
                  onPressed: canLog ? () => ref.read(albumRepositoryProvider).toggleFavourite(item) : null,
                  icon: Icon(item.favourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: item.favourite ? PetTagColors.of('rose') : Colors.white),
                ),
                IconButton(
                  tooltip: l.albumShare,
                  onPressed: () => showShareMemorySheet(context, ref, item, pet),
                  icon: const Icon(Icons.ios_share_rounded, color: Colors.white),
                ),
                if (canLog)
                  PopupMenuButton<String>(
                    tooltip: l.moreOptions,
                    iconColor: Colors.white,
                    onSelected: (v) async {
                      if (v == 'edit') {
                        await showMemoryEditSheet(context, ref, pet, existing: item);
                        return;
                      }
                      if (v == 'album') {
                        await showAddToAlbumSheet(context, ref, pet, [item]);
                        return;
                      }
                      if (v == 'delete') {
                        final ok = await confirmAction(context, title: l.albumDeleteQ, body: l.albumDeleteBody(pet.name), confirmLabel: l.delete);
                        if (!ok) return;
                        await ref.read(albumRepositoryProvider).delete(item);
                        if (context.mounted) {
                          showToast(context, l.albumDeleted);
                          _close();
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: ListTile(leading: const Icon(Icons.edit_rounded), title: Text(l.albumEditCaption))),
                      PopupMenuItem(value: 'album', child: ListTile(leading: const Icon(Icons.photo_album_rounded), title: Text(l.albumAddToAlbum))),
                      PopupMenuItem(value: 'delete', child: ListTile(leading: const Icon(Icons.delete_outline_rounded), title: Text(l.albumDelete))),
                    ],
                  ),
              ],
            ]),
          ),
          Expanded(
            child: Stack(children: [
              PageView.builder(
                controller: _page,
                itemCount: items.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final it = items[i];
                  return Center(
                    child: it.isVideo
                        ? AlbumVideoView(key: ValueKey(it.id), item: it)
                        : InteractiveViewer(
                            maxScale: 4,
                            child: MediaImage(url: it.url!, fit: BoxFit.contain, semanticLabel: it.caption.isEmpty ? null : it.caption),
                          ),
                  );
                },
              ),
              if (wide && _index > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton.filledTonal(tooltip: l.albumPrevious, onPressed: () => _go(-1), icon: const Icon(Icons.chevron_left_rounded)),
                ),
              if (wide && _index < items.length - 1)
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filledTonal(tooltip: l.next, onPressed: () => _go(1), icon: const Icon(Icons.chevron_right_rounded)),
                ),
            ]),
          ),
          // Caption
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(context.gutter, Space.md, context.gutter, Space.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  if (item.milestone != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.xs),
                      child: Row(children: [
                        MilestoneBadge(kind: item.milestone!, size: 24),
                        const SizedBox(width: Space.sm),
                        Flexible(child: Text(itemMilestoneLabel(context, item), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                      ]),
                    ),
                  if (item.caption.isNotEmpty)
                    Text(item.caption, style: const TextStyle(color: Colors.white, fontSize: 16), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    [
                      Fmt.date(item.takenAt, context.lang),
                      if (item.isVideo) videoLength(item.durationSec),
                      if (pet != null && item.byName.isNotEmpty) l.albumAddedBy(item.byName),
                    ].join(' · '),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
