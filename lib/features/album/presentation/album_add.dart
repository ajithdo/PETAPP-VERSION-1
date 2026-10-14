import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../../vault/data/vault_repository.dart';
import '../../vault/domain/storage_quota.dart';
import '../../vault/presentation/upload_flow.dart' show maxVaultFileBytes;
import '../../vault/presentation/vault_screen.dart' show ensureStorageRoom;
import '../data/album_repository.dart';
import '../domain/album.dart';
import 'album_labels.dart';
import 'video/video_source.dart';

/// A picked file waiting to be saved.
class PickedMedia {
  const PickedMedia({required this.bytes, required this.contentType, required this.ext, this.durationSec = 0, this.takenAt});
  final Uint8List bytes;
  final String contentType;
  final String ext;
  final int durationSec;
  final DateTime? takenAt;
  bool get isVideo => contentType.startsWith('video/');
}

/// "Add to Bruno's album": photo, several photos, video or a milestone.
Future<void> showAddMemorySheet(BuildContext context, WidgetRef ref, Pet pet, {String? milestone}) async {
  final limit = ((ref.read(planLimitsProvider)['videoSeconds'] as num?) ?? 60).toInt();
  final choice = await showPawSheet<String>(context, builder: (ctx) {
    final l = ctx.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.albumAddTitle(pet.name), style: ctx.text.titleMedium),
      const SizedBox(height: Space.md),
      ListTile(leading: const Icon(Icons.photo_camera_rounded), title: Text(l.takePhoto), onTap: () => Navigator.pop(ctx, 'camera')),
      ListTile(leading: const Icon(Icons.photo_library_rounded), title: Text(l.albumChoosePhotos), onTap: () => Navigator.pop(ctx, 'photos')),
      ListTile(
        leading: const Icon(Icons.videocam_rounded),
        title: Text(l.albumRecordVideo),
        subtitle: Text(l.albumVideoMaxSec(limit)),
        onTap: () => Navigator.pop(ctx, 'record'),
      ),
      ListTile(
        leading: const Icon(Icons.video_library_rounded),
        title: Text(l.albumChooseVideo),
        subtitle: Text(l.albumVideoMaxSec(limit)),
        onTap: () => Navigator.pop(ctx, 'video'),
      ),
      if (milestone == null)
        ListTile(leading: const Icon(Icons.emoji_events_rounded), title: Text(l.albumAddMilestone), onTap: () => Navigator.pop(ctx, 'milestone')),
      const SizedBox(height: Space.sm),
      Text(l.albumStorageNote, style: ctx.text.bodySmall),
    ]);
  });
  if (choice == null || !context.mounted) return;
  final l = context.l10n;
  final picker = ImagePicker();
  try {
    switch (choice) {
      case 'milestone':
        await showMemoryEditSheet(context, ref, pet, milestone: 'custom');
      case 'camera':
        final f = await picker.pickImage(source: ImageSource.camera, maxWidth: 2000, maxHeight: 2000, imageQuality: 80);
        if (f == null || !context.mounted) return;
        final m = PickedMedia(bytes: await f.readAsBytes(), contentType: 'image/jpeg', ext: 'jpg', takenAt: DateTime.now());
        if (context.mounted) await showMemoryEditSheet(context, ref, pet, media: m, milestone: milestone);
      case 'photos':
        final files = await picker.pickMultiImage(maxWidth: 2000, maxHeight: 2000, imageQuality: 80, limit: 20);
        if (files.isEmpty || !context.mounted) return;
        if (files.length == 1) {
          final f = files.first;
          final m = PickedMedia(bytes: await f.readAsBytes(), contentType: f.mimeType ?? 'image/jpeg', ext: 'jpg', takenAt: await _lastModified(f));
          if (context.mounted) await showMemoryEditSheet(context, ref, pet, media: m, milestone: milestone);
          return;
        }
        final media = <PickedMedia>[];
        for (final f in files) {
          media.add(PickedMedia(bytes: await f.readAsBytes(), contentType: f.mimeType ?? 'image/jpeg', ext: 'jpg', takenAt: await _lastModified(f)));
        }
        if (!context.mounted) return;
        final total = media.fold<int>(0, (s, m) => s + m.bytes.length);
        if (!await ensureStorageRoom(context, ref, total)) return;
        if (!context.mounted) return;
        showToast(context, l.albumUploading);
        for (final m in media) {
          await _saveMedia(ref, pet, m);
        }
        if (context.mounted) showToast(context, l.albumPhotosAdded(media.length));
      case 'record':
      case 'video':
        final f = await picker.pickVideo(source: choice == 'record' ? ImageSource.camera : ImageSource.gallery, maxDuration: Duration(seconds: limit));
        if (f == null || !context.mounted) return;
        final secs = await pickedVideoSeconds(f) ?? 0;
        if (!context.mounted) return;
        if (!videoWithinLimit(secs, limit)) {
          final plus = ref.read(currentUserProvider)?.isPlus ?? false;
          if (plus) {
            showToast(context, l.albumVideoTooLong(secs, limit));
          } else {
            await showPlusPrompt(context, title: l.albumVideoTooLongTitle, body: '${l.albumVideoTooLong(secs, limit)} ${l.albumVideoPlusBody}');
          }
          return;
        }
        final bytes = await f.readAsBytes();
        if (!context.mounted) return;
        if (bytes.length > maxVaultFileBytes) {
          showToast(context, l.vaultTooBig);
          return;
        }
        final mime = f.mimeType ?? (f.name.toLowerCase().endsWith('.webm') ? 'video/webm' : 'video/mp4');
        final m = PickedMedia(bytes: bytes, contentType: mime, ext: mime.contains('webm') ? 'webm' : 'mp4', durationSec: secs, takenAt: await _lastModified(f));
        if (context.mounted) await showMemoryEditSheet(context, ref, pet, media: m, milestone: milestone);
    }
  } catch (e) {
    debugPrint('Add memory failed: $e');
    if (context.mounted) showToast(context, l.errorBody);
  }
}

Future<DateTime> _lastModified(XFile f) async {
  try {
    final d = await f.lastModified();
    return d.isAfter(DateTime.now()) ? DateTime.now() : d;
  } catch (_) {
    return DateTime.now();
  }
}

Future<String> _saveMedia(WidgetRef ref, Pet pet, PickedMedia m,
    {String caption = '', DateTime? takenAt, String? milestone, String? milestoneTitle, List<String> albums = const []}) async {
  final user = ref.read(currentUserProvider)!;
  final stored = await uploadUserFile(ref.read(storageServiceProvider), m.bytes, uid: user.uid, folder: 'album', ext: m.ext, contentType: m.contentType);
  return ref.read(albumRepositoryProvider).add(
        pet: pet,
        by: user,
        type: m.isVideo ? 'video' : 'photo',
        url: stored.url,
        contentType: m.contentType,
        storagePath: stored.path,
        sizeBytes: stored.sizeBytes,
        durationSec: m.durationSec,
        caption: caption,
        takenAt: takenAt ?? m.takenAt,
        milestone: milestone,
        milestoneTitle: milestoneTitle,
        albums: albums,
      );
}

/// Caption, date taken, milestone and albums for a new upload, a
/// milestone without a photo, or an existing memory.
Future<void> showMemoryEditSheet(BuildContext context, WidgetRef ref, Pet pet, {AlbumItem? existing, PickedMedia? media, String? milestone}) {
  return showPawSheet<void>(context, builder: (_) => _EditSheet(pet: pet, existing: existing, media: media, milestone: milestone));
}

class _EditSheet extends ConsumerStatefulWidget {
  const _EditSheet({required this.pet, this.existing, this.media, this.milestone});
  final Pet pet;
  final AlbumItem? existing;
  final PickedMedia? media;
  final String? milestone;
  @override
  ConsumerState<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends ConsumerState<_EditSheet> {
  late final _caption = TextEditingController(text: widget.existing?.caption ?? '');
  late final _msTitle = TextEditingController(text: widget.existing?.milestoneTitle ?? '');
  late DateTime _taken = widget.existing?.takenAt ?? widget.media?.takenAt ?? DateTime.now();
  late String? _milestone = widget.existing?.milestone ?? widget.milestone;
  late final Set<String> _albums = {...?widget.existing?.albums};
  bool _busy = false;

  @override
  void dispose() {
    _caption.dispose();
    _msTitle.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final repo = ref.read(albumRepositoryProvider);
    final msTitle = _milestone == 'custom' ? _msTitle.text.trim() : null;
    if (_milestone == 'custom' && (msTitle ?? '').isEmpty && widget.media == null && widget.existing == null) {
      showToast(context, l.albumMilestoneTitle);
      return;
    }
    setState(() => _busy = true);
    try {
      final e = widget.existing;
      if (e != null) {
        await repo.update(e.id, {
          'caption': _caption.text.trim(),
          'takenAt': _taken,
          'milestone': _milestone,
          'milestoneTitle': msTitle,
          'albums': _albums.toList(),
        });
      } else if (widget.media != null) {
        if (!await ensureStorageRoom(context, ref, widget.media!.bytes.length)) {
          setState(() => _busy = false);
          return;
        }
        await _saveMedia(ref, widget.pet, widget.media!,
            caption: _caption.text, takenAt: _taken, milestone: _milestone, milestoneTitle: msTitle, albums: _albums.toList());
      } else {
        await repo.add(
          pet: widget.pet,
          by: ref.read(currentUserProvider)!,
          type: 'milestone',
          caption: _caption.text,
          takenAt: _taken,
          milestone: _milestone ?? 'custom',
          milestoneTitle: msTitle,
          albums: _albums.toList(),
        );
      }
      if (mounted) {
        Navigator.pop(context);
        showToast(context, e != null ? l.saved : l.albumSaved(widget.pet.name));
      }
    } catch (err) {
      debugPrint('Save memory failed: $err');
      if (mounted) {
        setState(() => _busy = false);
        showToast(context, l.errorBody);
      }
    }
  }

  Future<void> _newAlbum() async {
    final name = await askAlbumName(context);
    if (name != null) setState(() => _albums.add(name));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final existingAlbums = albumNames(ref.watch(petAlbumProvider(widget.pet.id)).value ?? const []);
    final allAlbums = {...existingAlbums, ..._albums}.toList()..sort();
    final m = widget.media;
    final e = widget.existing;
    final noMedia = m == null && (e == null || !e.hasMedia);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(e != null ? l.albumEditCaption : (noMedia ? l.albumAddMilestone : l.albumAddTitle(widget.pet.name)), style: context.text.titleMedium),
      const SizedBox(height: Space.md),
      if (!noMedia)
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.button),
            child: SizedBox(
              width: 160,
              height: 160,
              child: m != null
                  ? (m.isVideo
                      ? ColoredBox(
                          color: context.paw.primaryContainer,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.videocam_rounded, size: 48, color: context.colors.primary),
                            Text(videoLength(m.durationSec), style: context.text.titleSmall),
                          ]),
                        )
                      : Image.memory(m.bytes, fit: BoxFit.cover))
                  : MediaImage(url: e!.url!, width: 160, height: 160),
            ),
          ),
        ),
      const SizedBox(height: Space.md),
      PawTextField(label: l.albumCaption, hint: l.albumCaptionHint, controller: _caption, maxLines: 3),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, minimumSize: const Size.fromHeight(52)),
        icon: const Icon(Icons.event_rounded),
        label: Text('${l.albumDateTaken}: ${Fmt.date(_taken, context.lang)}'),
        onPressed: () async {
          final now = DateTime.now();
          final d = await showDatePicker(context: context, firstDate: DateTime(now.year - 30), lastDate: now, initialDate: _taken.isAfter(now) ? now : _taken);
          if (d != null) setState(() => _taken = DateTime(d.year, d.month, d.day, _taken.hour, _taken.minute));
        },
      ),
      const SizedBox(height: Space.md),
      Text(l.albumMilestone, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        if (!noMedia)
          ChoiceChip(label: Text(l.albumNoMilestone), selected: _milestone == null, onSelected: (_) => setState(() => _milestone = null)),
        for (final k in milestoneKinds)
          ChoiceChip(
            avatar: Icon(milestoneIcon(k), size: 18),
            showCheckmark: false,
            label: Text(milestoneLabel(context, k)),
            selected: _milestone == k,
            onSelected: (_) => setState(() => _milestone = k),
          ),
      ]),
      if (_milestone == 'custom') ...[
        const SizedBox(height: Space.md),
        PawTextField(label: l.albumMilestoneTitle, hint: l.albumMilestoneTitleHint, controller: _msTitle),
      ],
      const SizedBox(height: Space.md),
      Text(l.albumAlbums, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (final a in allAlbums)
          FilterChip(label: Text(a), selected: _albums.contains(a), onSelected: (v) => setState(() => v ? _albums.add(a) : _albums.remove(a))),
        ActionChip(avatar: const Icon(Icons.add_rounded, size: 18), label: Text(l.albumNewAlbum), onPressed: _newAlbum),
      ]),
      const SizedBox(height: Space.xl),
      PrimaryButton(label: l.save, icon: Icons.check_rounded, loading: _busy, onPressed: _save),
    ]);
  }
}

/// Asks for a new album name.
Future<String?> askAlbumName(BuildContext context, {String? initial, String? title}) async {
  final l = context.l10n;
  final c = TextEditingController(text: initial);
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title ?? l.albumNewAlbum),
      content: TextField(
        controller: c,
        autofocus: true,
        maxLength: 40,
        decoration: InputDecoration(labelText: l.albumAlbumName),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: Text(l.save)),
      ],
    ),
  );
  c.dispose();
  return (name == null || name.isEmpty) ? null : name;
}

/// Adds memories to an existing or new album.
Future<void> showAddToAlbumSheet(BuildContext context, WidgetRef ref, Pet pet, List<AlbumItem> items) async {
  final names = albumNames(ref.read(petAlbumProvider(pet.id)).value ?? const []);
  final picked = await showPawSheet<String>(context, builder: (ctx) {
    final l = ctx.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.albumAddToAlbum, style: ctx.text.titleMedium),
      const SizedBox(height: Space.sm),
      for (final n in names)
        ListTile(leading: const Icon(Icons.photo_album_rounded), title: Text(n), onTap: () => Navigator.pop(ctx, n)),
      ListTile(leading: const Icon(Icons.add_rounded), title: Text(l.albumNewAlbum), onTap: () => Navigator.pop(ctx, '')),
    ]);
  });
  if (picked == null || !context.mounted) return;
  final name = picked.isEmpty ? await askAlbumName(context) : picked;
  if (name == null) return;
  await ref.read(albumRepositoryProvider).addToAlbum(items, name);
  if (context.mounted) showToast(context, context.l10n.albumAddedToAlbum(name));
}
