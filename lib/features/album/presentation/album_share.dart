import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/widget_capture.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../../vault/data/vault_repository.dart';
import '../../vault/domain/share_rules.dart';
import '../../vault/presentation/share_sheet.dart';
import '../../vault/presentation/vault_labels.dart';
import '../domain/album.dart';

/// "Made with PawSetu" stamp drawn on shared photos (optional).
class Watermark extends StatelessWidget {
  const Watermark({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(size * 0.03),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.02, vertical: size * 0.012),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.88), borderRadius: BorderRadius.circular(size)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            PawSetuLogo(size: size * 0.05),
            SizedBox(width: size * 0.012),
            Text(context.l10n.albumWatermarkText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0xFF0F766E), fontSize: size * 0.03, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}

/// Builds the file to share: the photo (or a video's poster for sample
/// clips) with the optional watermark, or the video itself.
Future<XFile?> buildShareFile(BuildContext context, WidgetRef ref, AlbumItem item, Pet pet, {required bool watermark}) async {
  final url = item.url;
  if (url == null) return null;
  final view = View.of(context);
  final theme = Theme.of(context);
  final name = '${pet.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_')}_${item.id.substring(0, item.id.length.clamp(0, 6))}';
  if (item.isVideo && !url.startsWith('seed:')) {
    final bytes = await ref.read(storageServiceProvider).read(url);
    if (bytes == null) return null;
    final mime = item.contentType ?? 'video/mp4';
    return XFile.fromData(bytes, mimeType: mime, name: '$name.${mime.contains('webm') ? 'webm' : 'mp4'}');
  }
  Widget art;
  Size size;
  if (url.startsWith('seed:')) {
    size = const Size(540, 540);
    art = SeedArt(seed: url, width: size.width, height: size.height);
  } else {
    final bytes = await ref.read(storageServiceProvider).read(url);
    if (bytes == null) return null;
    final img = (await (await ui.instantiateImageCodec(bytes, targetWidth: 1600)).getNextFrame()).image;
    final scale = 720 / (img.width > img.height ? img.width : img.height);
    size = Size(img.width * scale, img.height * scale);
    art = RawImage(image: img, fit: BoxFit.cover, width: size.width, height: size.height);
  }
  final png = await renderWidgetToPng(
    Stack(children: [Positioned.fill(child: art), if (watermark) Positioned.fill(child: Watermark(size: size.shortestSide))]),
    view: view,
    theme: theme,
    logicalSize: size,
    pixelRatio: 2,
  );
  return XFile.fromData(Uint8List.fromList(png), mimeType: 'image/png', name: '$name.png');
}

/// Share to WhatsApp, Instagram or any app through the system share sheet.
Future<void> showShareMemorySheet(BuildContext context, WidgetRef ref, AlbumItem item, Pet pet) {
  return showPawSheet<void>(context, builder: (ctx) {
    final l = ctx.l10n;
    final prefs = ref.read(prefsProvider);
    var watermark = prefs.getBool('albumWatermark') ?? true;
    var busy = false;
    return StatefulBuilder(builder: (ctx, setState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.albumShareTitle, style: ctx.text.titleMedium),
        const SizedBox(height: Space.xs),
        Text(l.albumShareBody, style: ctx.text.bodySmall),
        const SizedBox(height: Space.md),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.button),
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(children: [
                Positioned.fill(child: MediaImage(url: item.url!, semanticLabel: item.caption)),
                if (watermark && !(item.isVideo && !item.url!.startsWith('seed:'))) const Positioned.fill(child: Watermark(size: 200)),
              ]),
            ),
          ),
        ),
        const SizedBox(height: Space.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: watermark,
          onChanged: (v) {
            prefs.setBool('albumWatermark', v);
            setState(() => watermark = v);
          },
          title: Text(l.albumWatermark),
          subtitle: item.isVideo && !item.url!.startsWith('seed:') ? Text(l.albumWatermarkPhotosOnly) : null,
        ),
        const SizedBox(height: Space.sm),
        PrimaryButton(
          label: l.albumShareToApps,
          icon: Icons.ios_share_rounded,
          loading: busy,
          onPressed: () async {
            setState(() => busy = true);
            try {
              final file = await buildShareFile(context, ref, item, pet, watermark: watermark);
              if (file != null) {
                await SharePlus.instance.share(ShareParams(files: [file], text: item.caption.isEmpty ? null : item.caption));
              }
              if (ctx.mounted) Navigator.pop(ctx);
            } catch (e) {
              debugPrint('Share memory failed: $e');
              if (ctx.mounted) {
                setState(() => busy = false);
                showToast(ctx, l.albumShareFailed);
              }
            }
          },
        ),
      ]);
    });
  });
}

/// Private family link (spec 7.11): view-only, optional end date, all of the
/// album or one named album.
Future<void> showFamilyLinkSheet(BuildContext context, WidgetRef ref, Pet pet, List<String> albums) {
  return showPawSheet<void>(context, builder: (_) => _FamilyLinkSheet(pet: pet, albums: albums));
}

class _FamilyLinkSheet extends ConsumerStatefulWidget {
  const _FamilyLinkSheet({required this.pet, required this.albums});
  final Pet pet;
  final List<String> albums;
  @override
  ConsumerState<_FamilyLinkSheet> createState() => _FamilyLinkSheetState();
}

class _FamilyLinkSheetState extends ConsumerState<_FamilyLinkSheet> {
  String? _album;
  ShareExpiry _expiry = ShareExpiry.never;
  String? _token;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_token != null) {
      final url = shareLinkUrl(_token!);
      return ShareLinkResult(
        url: url,
        title: l.albumFamilyLink,
        expiresAt: _expiry.from(DateTime.now()),
        message: l.albumFamilyLinkText(widget.pet.name, url),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.albumFamilyLink, style: context.text.titleMedium),
      const SizedBox(height: Space.xs),
      Text(l.albumFamilyLinkBody(widget.pet.name), style: context.text.bodySmall),
      if (widget.albums.isNotEmpty) ...[
        const SizedBox(height: Space.md),
        Text(l.albumFamilyLinkWhich, style: context.text.titleSmall),
        const SizedBox(height: Space.sm),
        ChoiceRow<String?>(
          options: [null, ...widget.albums],
          selected: _album,
          onSelected: (a) => setState(() => _album = a),
          label: (a) => a ?? l.albumWholeAlbum,
        ),
      ],
      const SizedBox(height: Space.md),
      Text(l.vaultLinkValidFor, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      ChoiceRow<ShareExpiry>(
        options: const [ShareExpiry.days7, ShareExpiry.never],
        selected: _expiry,
        onSelected: (e) => setState(() => _expiry = e),
        label: (e) => shareExpiryLabel(context, e),
      ),
      const SizedBox(height: Space.lg),
      PrimaryButton(
        label: l.vaultCreateLink,
        icon: Icons.link_rounded,
        loading: _busy,
        onPressed: () async {
          setState(() => _busy = true);
          final t = await ref.read(vaultRepositoryProvider).createLink(
                owner: ref.read(currentUserProvider)!,
                pet: widget.pet,
                kind: 'album',
                albumName: _album,
                expiresAt: _expiry.from(DateTime.now()),
              );
          if (mounted) {
            setState(() {
              _busy = false;
              _token = t;
            });
          }
        },
      ),
    ]);
  }
}
