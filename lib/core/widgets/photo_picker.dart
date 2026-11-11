import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/tokens.dart';
import 'dialogs.dart';
import 'layout.dart';

/// Longest side, in pixels, that picked photos and document scans are scaled to.
const double _photoMaxSide = 1600;
const double _documentMaxSide = 2000;

/// Picks a photo (camera or gallery), lets the user crop it to a square by
/// pinching and dragging, and returns compressed JPEG/PNG bytes.
/// Works on Android, iOS and web without native cropping plugins.
Future<Uint8List?> pickSquarePhoto(BuildContext context, {bool allowCamera = true}) async {
  final source = await showPawSheet<ImageSource>(
    context,
    builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(ctx.l10n.addPhotoTitle, style: ctx.text.titleMedium),
      const SizedBox(height: Space.md),
      if (allowCamera)
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined),
          title: Text(ctx.l10n.takePhoto),
          onTap: () => Navigator.pop(ctx, ImageSource.camera),
        ),
      ListTile(
        leading: const Icon(Icons.photo_library_outlined),
        title: Text(ctx.l10n.chooseFromGallery),
        onTap: () => Navigator.pop(ctx, ImageSource.gallery),
      ),
    ]),
  );
  if (source == null) return null;
  final file = await ImagePicker().pickImage(source: source, maxWidth: _photoMaxSide, maxHeight: _photoMaxSide, imageQuality: 85);
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  if (!context.mounted) return null;
  return Navigator.of(context).push<Uint8List>(
    MaterialPageRoute(fullscreenDialog: true, builder: (_) => _CropScreen(bytes: bytes)),
  );
}

/// Picks any image without cropping (album, chat, vault scans).
Future<({Uint8List bytes, String name})?> pickImage(BuildContext context, ImageSource source) async {
  final file = await ImagePicker().pickImage(source: source, maxWidth: _documentMaxSide, maxHeight: _documentMaxSide, imageQuality: 80);
  if (file == null) return null;
  return (bytes: await file.readAsBytes(), name: file.name);
}

class _CropScreen extends StatefulWidget {
  const _CropScreen({required this.bytes});
  final Uint8List bytes;
  @override
  State<_CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<_CropScreen> {
  final _boundary = GlobalKey();
  bool _busy = false;

  Future<void> _done() async {
    setState(() => _busy = true);
    final ro = _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final size = ro.size.width;
    final image = await ro.toImage(pixelRatio: 640 / size);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (!mounted) return;
    Navigator.pop(context, data!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: MediaColors.background,
      appBar: AppBar(
        backgroundColor: MediaColors.background,
        foregroundColor: MediaColors.foreground,
        title: Text(l.cropPhoto),
        actions: [
          TextButton(
            onPressed: _busy ? null : _done,
            child: Text(l.done, style: const TextStyle(color: MediaColors.foreground)),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, c) {
          final side = (c.biggest.shortestSide - Space.xxl).clamp(Sizes.cropMin, Sizes.cropMax);
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: side,
              height: side,
              decoration: BoxDecoration(border: Border.all(color: MediaColors.foreground, width: Strokes.focus)),
              child: RepaintBoundary(
                key: _boundary,
                child: ClipRect(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    constrained: false,
                    boundaryMargin: EdgeInsets.all(side),
                    child: SizedBox(
                      width: side,
                      height: side,
                      child: Image.memory(widget.bytes, fit: BoxFit.cover, semanticLabel: context.l10n.vaultPhoto),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Space.lg),
            Text(l.cropHint, style: const TextStyle(color: MediaColors.foregroundMuted)),
          ]);
        }),
      ),
    );
  }
}
