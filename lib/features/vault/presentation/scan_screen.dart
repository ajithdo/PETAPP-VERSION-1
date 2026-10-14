import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/scan_bounds.dart';

/// Camera scan with auto-crop (spec 7.9): finds the page edges, lets the
/// owner drag the corners, and can turn the scan black and white so text
/// reads clearly. Returns PNG bytes. Works on Android, iOS and web.
class ScanCropScreen extends StatefulWidget {
  const ScanCropScreen({super.key, required this.bytes});
  final Uint8List bytes;

  @override
  State<ScanCropScreen> createState() => _ScanCropScreenState();
}

const _bwMatrix = <double>[
  0.2976, 1.0013, 0.1011, 0, -51.2, //
  0.2976, 1.0013, 0.1011, 0, -51.2, //
  0.2976, 1.0013, 0.1011, 0, -51.2, //
  0, 0, 0, 1, 0,
];

class _ScanCropScreenState extends State<ScanCropScreen> {
  ui.Image? _image;
  NormRect _r = NormRect.fallback;
  bool _found = false;
  bool _bw = true;
  bool _busy = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.bytes, targetWidth: 1800);
      final img = (await codec.getNextFrame()).image;
      final small = await (await ui.instantiateImageCodec(widget.bytes, targetWidth: 220)).getNextFrame();
      final data = await small.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final r = findDocumentBounds(data!.buffer.asUint8List(), small.image.width, small.image.height);
      if (!mounted) return;
      setState(() {
        _image = img;
        _r = r;
        _found = !identical(r, NormRect.fallback);
      });
    } catch (e) {
      debugPrint('Scan decode failed: $e');
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _done() async {
    final img = _image;
    if (img == null) return;
    setState(() => _busy = true);
    final src = Rect.fromLTRB(_r.left * img.width, _r.top * img.height, _r.right * img.width, _r.bottom * img.height);
    final w = src.width.round().clamp(1, 2000);
    final h = (src.height * w / src.width).round().clamp(1, 2800);
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final paint = Paint()..filterQuality = FilterQuality.high;
    if (_bw) paint.colorFilter = const ColorFilter.matrix(_bwMatrix);
    canvas.drawImageRect(img, src, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), paint);
    final out = await rec.endRecording().toImage(w, h);
    final data = await out.toByteData(format: ui.ImageByteFormat.png);
    if (!mounted) return;
    Navigator.pop(context, data!.buffer.asUint8List());
  }

  void _move(int corner, Offset delta, Size box) {
    final dx = delta.dx / box.width;
    final dy = delta.dy / box.height;
    const minSide = 0.15;
    var l = _r.left, t = _r.top, r = _r.right, b = _r.bottom;
    if (corner == 0 || corner == 3) l = (l + dx).clamp(0.0, r - minSide);
    if (corner == 1 || corner == 2) r = (r + dx).clamp(l + minSide, 1.0);
    if (corner == 0 || corner == 1) t = (t + dy).clamp(0.0, b - minSide);
    if (corner == 2 || corner == 3) b = (b + dy).clamp(t + minSide, 1.0);
    setState(() => _r = NormRect(l, t, r, b));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l.vaultScanTitle),
      ),
      body: _failed
          ? ErrorState(message: l.vaultPreviewFailed)
          : _image == null
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Space.lg),
                      child: LayoutBuilder(builder: (context, c) {
                        final img = _image!;
                        final scale = (c.maxWidth / img.width).clamp(0.0, c.maxHeight / img.height);
                        final box = Size(img.width * scale, img.height * scale);
                        final rect = Rect.fromLTRB(_r.left * box.width, _r.top * box.height, _r.right * box.width, _r.bottom * box.height);
                        final corners = [rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft];
                        return Center(
                          child: SizedBox.fromSize(
                            size: box,
                            child: Stack(clipBehavior: Clip.none, children: [
                              Positioned.fill(
                                child: ColorFiltered(
                                  colorFilter: _bw ? const ColorFilter.matrix(_bwMatrix) : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                                  child: RawImage(image: img, fit: BoxFit.fill),
                                ),
                              ),
                              Positioned.fill(child: CustomPaint(painter: _CropPainter(rect, context.colors.primary))),
                              for (var i = 0; i < 4; i++)
                                Positioned(
                                  left: corners[i].dx - 24,
                                  top: corners[i].dy - 24,
                                  child: Semantics(
                                    label: l.vaultScanCorner,
                                    child: GestureDetector(
                                      onPanUpdate: (d) => _move(i, d.delta, box),
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: context.colors.primary, width: 4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ]),
                          ),
                        );
                      }),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Container(
                      color: context.paw.surface,
                      padding: EdgeInsets.all(context.gutter),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(_found ? l.vaultScanAuto : l.vaultScanHint, style: context.text.bodySmall, textAlign: TextAlign.center),
                          SwitchListTile(
                            value: _bw,
                            onChanged: (v) => setState(() => _bw = v),
                            title: Text(l.vaultScanBw),
                            contentPadding: EdgeInsets.zero,
                          ),
                          PrimaryButton(label: l.vaultUseScan, icon: Icons.check_rounded, loading: _busy, onPressed: _done),
                        ]),
                      ),
                    ),
                  ),
                ]),
    );
  }
}

class _CropPainter extends CustomPainter {
  _CropPainter(this.rect, this.color);
  final Rect rect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final outside = Path()
      ..addRect(Offset.zero & size)
      ..addRect(rect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(outside, Paint()..color = Colors.black.withValues(alpha: 0.55));
    canvas.drawRect(rect, Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(_CropPainter old) => old.rect != rect || old.color != color;
}
