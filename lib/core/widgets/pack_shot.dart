import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// The shapes a drawn product can take.
enum PackKind { bag, can, pouch, harness, rope, bed, bottle, bowl }

/// A drawn product picture (UI Design 6): a pack, toy or bed in one of the
/// [PackColors] on its pale tint, for products without a seller photo. Not a
/// real product shot and never a brand logo.
class PackShot extends StatelessWidget {
  const PackShot({super.key, required this.kind, this.tone = 0});
  final PackKind kind;

  /// Which colour pair from [PackColors.pairs].
  final int tone;

  /// The usual drawing for a shop category; [seed] varies wet and dry food.
  static PackKind kindFor(String category, int seed) => switch (category) {
    'food' => seed % 4 == 3 ? PackKind.can : PackKind.bag,
    'treats' || 'bird_food_cages' || 'rabbit_care' => PackKind.pouch,
    'toys' => PackKind.rope,
    'grooming' || 'health_hygiene' || 'litter_cat' => PackKind.bottle,
    'beds' || 'clothing' => PackKind.bed,
    'collars_leashes' || 'travel' => PackKind.harness,
    'bowls_feeders' => PackKind.bowl,
    _ => PackKind.bag,
  };

  @override
  Widget build(BuildContext context) {
    final pair = PackColors.pairs[tone % PackColors.pairs.length];
    return ColoredBox(
      color: pair.$2,
      child: AspectRatio(aspectRatio: 1, child: CustomPaint(painter: _PackPainter(kind, pair.$1, pair.$2))),
    );
  }
}

class _PackPainter extends CustomPainter {
  _PackPainter(this.kind, this.c, this.bg);
  final PackKind kind;
  final Color c;
  final Color bg;

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn in a 100 × 100 box, centred.
    final k = size.shortestSide / 100;
    canvas.translate((size.width - 100 * k) / 2, (size.height - 100 * k) / 2);
    canvas.scale(k);
    final fill = Paint()..color = c;
    final label = Paint()..color = PackColors.label;
    final dark = Paint()..color = PackColors.strap;
    final shade = Paint()..color = PackColors.shade;
    canvas.drawOval(const Rect.fromLTWH(24, 87.5, 52, 7), Paint()..color = PackColors.shadow);
    void fish(Offset o, double s, Paint p) {
      canvas.drawPath(
        Path()
          ..moveTo(o.dx - 6 * s, o.dy)
          ..quadraticBezierTo(o.dx, o.dy - 8 * s, o.dx + 6 * s, o.dy)
          ..quadraticBezierTo(o.dx, o.dy + 8 * s, o.dx - 6 * s, o.dy)
          ..moveTo(o.dx + 6 * s, o.dy)
          ..lineTo(o.dx + 10 * s, o.dy - 3.5 * s)
          ..lineTo(o.dx + 10 * s, o.dy + 3.5 * s)
          ..close(),
        p,
      );
    }

    switch (kind) {
      case PackKind.bag:
        canvas.drawPath(Path()..moveTo(31, 24)..lineTo(69, 24)..lineTo(73, 86)..lineTo(27, 86)..close(), fill);
        canvas.drawRRect(RRect.fromLTRBR(27, 82, 73, 90, const Radius.circular(4)), fill);
        canvas.drawRect(const Rect.fromLTWH(30, 14, 40, 11), fill);
        canvas.drawRect(const Rect.fromLTWH(30, 14, 40, 11), shade);
        canvas.drawRRect(RRect.fromLTRBR(36, 38, 64, 70, const Radius.circular(6)), label);
        fish(const Offset(48, 54), 1, fill);
        canvas.drawLine(const Offset(40, 78), const Offset(60, 78), label..strokeWidth = 3..strokeCap = StrokeCap.round);
      case PackKind.can:
        canvas.drawOval(const Rect.fromLTWH(26, 68, 48, 16), fill);
        canvas.drawRect(const Rect.fromLTWH(26, 40, 48, 36), fill);
        canvas.drawOval(const Rect.fromLTWH(26, 32, 48, 16), Paint()..color = PackColors.lid);
        canvas.drawOval(const Rect.fromLTWH(32, 34.5, 36, 11), Paint()..color = PackColors.lidInner);
        canvas.drawPath(Path()..moveTo(26, 50)..quadraticBezierTo(50, 59, 74, 50)..lineTo(74, 68)..quadraticBezierTo(50, 77, 26, 68)..close(), label);
        fish(const Offset(48, 62), 0.9, fill);
      case PackKind.pouch:
        canvas.drawPath(Path()..moveTo(30, 20)..lineTo(70, 20)..lineTo(75, 86)..lineTo(25, 86)..close(), fill);
        canvas.drawRect(const Rect.fromLTWH(30, 20, 40, 8), shade);
        canvas.drawCircle(const Offset(50, 60), 15, label);
        canvas.save();
        canvas.translate(50, 60);
        canvas.rotate(-0.42);
        canvas.drawRRect(RRect.fromLTRBR(-8, -4.5, 8, 0, const Radius.circular(2.2)), fill);
        canvas.restore();
        canvas.save();
        canvas.translate(50, 63);
        canvas.rotate(0.31);
        canvas.drawRRect(RRect.fromLTRBR(-8, 0, 8, 4.5, const Radius.circular(2.2)), fill);
        canvas.restore();
        canvas.drawLine(const Offset(38, 36), const Offset(62, 36), label..strokeWidth = 3..strokeCap = StrokeCap.round);
      case PackKind.harness:
        final strap = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round;
        canvas.drawPath(Path()..moveTo(20, 58)..quadraticBezierTo(50, 80, 80, 58), strap);
        canvas.drawPath(Path()..moveTo(33, 31)..quadraticBezierTo(50, 22, 67, 31)..lineTo(74, 61)..quadraticBezierTo(50, 78, 26, 61)..close(), fill);
        canvas.drawOval(const Rect.fromLTWH(39, 24, 22, 12), Paint()..color = bg);
        canvas.drawRRect(RRect.fromLTRBR(41, 44, 59, 57, const Radius.circular(4)), label);
        canvas.drawCircle(const Offset(50, 19), 4.5, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = PackColors.ring);
        canvas.drawRRect(RRect.fromLTRBR(70, 52, 79, 64, const Radius.circular(2.5)), dark);
      case PackKind.rope:
        final rope = Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 11..strokeCap = StrokeCap.round;
        final path = Path()..moveTo(22, 64)..quadraticBezierTo(36, 34, 50, 52)..quadraticBezierTo(64, 70, 78, 38);
        canvas.drawPath(path, rope);
        final twist = Paint()..color = PackColors.label..style = PaintingStyle.stroke..strokeWidth = 2.2;
        for (final m in path.computeMetrics()) {
          for (var d = 4.0; d < m.length - 4; d += 9) {
            final t = m.getTangentForOffset(d)!;
            final n = Offset(-t.vector.dy, t.vector.dx) * 5;
            canvas.drawLine(t.position - n, t.position + n, twist);
          }
        }
        canvas.drawCircle(const Offset(22, 64), 9, fill);
        canvas.drawCircle(const Offset(78, 38), 9, fill);
        final fray = Paint()..color = c..strokeWidth = 2.5..strokeCap = StrokeCap.round;
        canvas.drawLine(const Offset(14, 72), const Offset(9, 81), fray);
        canvas.drawLine(const Offset(19, 75), const Offset(17, 85), fray);
        canvas.drawLine(const Offset(82, 30), const Offset(88, 22), fray);
        canvas.drawLine(const Offset(86, 35), const Offset(95, 31), fray);
      case PackKind.bed:
        canvas.drawOval(const Rect.fromLTWH(16, 38, 68, 44), fill);
        canvas.drawOval(const Rect.fromLTWH(26, 43, 48, 26), label);
        canvas.drawPath(Path()..moveTo(40, 55)..quadraticBezierTo(50, 49, 60, 55), Paint()..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round..color = c);
      case PackKind.bottle:
        canvas.drawRRect(RRect.fromLTRBR(34, 40, 66, 88, const Radius.circular(9)), fill);
        canvas.drawRRect(RRect.fromLTRBR(43, 28, 57, 41, const Radius.circular(2)), dark);
        canvas.drawPath(Path()..moveTo(50, 28)..lineTo(50, 20)..lineTo(64, 20), Paint()..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round..color = PackColors.strap);
        canvas.drawRRect(RRect.fromLTRBR(39, 52, 61, 74, const Radius.circular(5)), label);
        canvas.drawCircle(const Offset(50, 63), 5, fill);
      case PackKind.bowl:
        canvas.drawPath(Path()..moveTo(20, 56)..lineTo(80, 56)..quadraticBezierTo(76, 84, 50, 84)..quadraticBezierTo(24, 84, 20, 56)..close(), fill);
        canvas.drawOval(const Rect.fromLTWH(20, 50, 60, 12), label);
        for (final o in const [Offset(38, 54), Offset(48, 52), Offset(58, 55), Offset(44, 57), Offset(54, 58)]) {
          canvas.drawCircle(o, 3.2, Paint()..color = PackColors.kibble);
        }
    }
  }

  @override
  bool shouldRepaint(_PackPainter o) => o.kind != kind || o.c != c || o.bg != bg;
}
