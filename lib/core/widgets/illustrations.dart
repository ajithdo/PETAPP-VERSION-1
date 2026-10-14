import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Original flat illustrations (soft rounded shapes in teal and apricot),
/// drawn in code so they are crisp, tiny and copyright-free.
/// Used only for onboarding, empty states and success screens (spec 4).
enum Scene { welcomeCare, welcomeHealth, welcomeBridge, empty, success, search, lost, memory, shop, chat, vault }

const _teal = Color(0xFF0F766E);
const _tealLight = Color(0xFF5EEAD4);
const _apricot = Color(0xFFF4A261);
const _apricotLight = Color(0xFFFDE7D3);
const _ink = Color(0xFF1C2B2D);

class Illustration extends StatelessWidget {
  const Illustration(this.scene, {super.key, this.size = 180});
  final Scene scene;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _ScenePainter(scene, dark)),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.dark);
  final Scene scene;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final p = Paint()..isAntiAlias = true;
    // Soft background blob
    p.color = (dark ? _teal : _tealLight).withValues(alpha: dark ? 0.35 : 0.25);
    final blob = Path()
      ..moveTo(s * 0.15, s * 0.45)
      ..cubicTo(s * 0.10, s * 0.15, s * 0.45, s * 0.05, s * 0.70, s * 0.15)
      ..cubicTo(s * 0.95, s * 0.25, s * 0.98, s * 0.60, s * 0.80, s * 0.80)
      ..cubicTo(s * 0.60, s * 0.98, s * 0.25, s * 0.92, s * 0.15, s * 0.70)
      ..close();
    canvas.drawPath(blob, p);

    switch (scene) {
      case Scene.welcomeCare:
        _face(canvas, Offset(s * 0.38, s * 0.55), s * 0.22, 'dog', _apricot);
        _face(canvas, Offset(s * 0.66, s * 0.60), s * 0.17, 'cat', const Color(0xFFD6B98C));
        _heart(canvas, Offset(s * 0.55, s * 0.24), s * 0.09, _apricot);
      case Scene.welcomeHealth:
        _rrect(canvas, Rect.fromLTWH(s * 0.22, s * 0.2, s * 0.56, s * 0.62), s * 0.06,
            dark ? const Color(0xFF172124) : Colors.white);
        for (var i = 0; i < 3; i++) {
          final y = s * (0.34 + i * 0.15);
          _circle(canvas, Offset(s * 0.32, y), s * 0.035, i < 2 ? _teal : _apricotLight);
          _rrect(canvas, Rect.fromLTWH(s * 0.40, y - s * 0.02, s * 0.30, s * 0.04), s * 0.02,
              (dark ? Colors.white : _ink).withValues(alpha: 0.15));
        }
        _ring(canvas, Offset(s * 0.74, s * 0.74), s * 0.11, 0.7);
      case Scene.welcomeBridge:
        final bridge = Paint()
          ..color = _teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.04
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(Rect.fromLTWH(s * 0.18, s * 0.35, s * 0.64, s * 0.5), math.pi, math.pi, false, bridge);
        _house(canvas, Offset(s * 0.2, s * 0.62), s * 0.14, _apricot);
        _clinic(canvas, Offset(s * 0.8, s * 0.62), s * 0.14);
        _paw(canvas, Offset(s * 0.5, s * 0.35), s * 0.06, _apricot);
      case Scene.empty:
        _bowl(canvas, Offset(s * 0.5, s * 0.62), s * 0.28);
        _paw(canvas, Offset(s * 0.5, s * 0.32), s * 0.08, _apricot);
      case Scene.success:
        _circle(canvas, Offset(s * 0.5, s * 0.5), s * 0.24, _teal);
        final check = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.045
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(
            Path()
              ..moveTo(s * 0.39, s * 0.50)
              ..lineTo(s * 0.47, s * 0.58)
              ..lineTo(s * 0.62, s * 0.42),
            check);
        for (var i = 0; i < 8; i++) {
          final a = i * math.pi / 4;
          _circle(canvas, Offset(s * 0.5 + math.cos(a) * s * 0.36, s * 0.5 + math.sin(a) * s * 0.36), s * 0.02,
              i.isEven ? _apricot : _tealLight);
        }
      case Scene.search:
        final glass = Paint()
          ..color = _teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.05;
        canvas.drawCircle(Offset(s * 0.45, s * 0.45), s * 0.17, glass);
        canvas.drawLine(Offset(s * 0.58, s * 0.58), Offset(s * 0.72, s * 0.72), glass..strokeCap = StrokeCap.round);
        _paw(canvas, Offset(s * 0.45, s * 0.45), s * 0.06, _apricot);
      case Scene.lost:
        _pin(canvas, Offset(s * 0.5, s * 0.5), s * 0.22);
        _face(canvas, Offset(s * 0.5, s * 0.44), s * 0.11, 'dog', _apricot);
      case Scene.memory:
        _rrect(canvas, Rect.fromLTWH(s * 0.22, s * 0.25, s * 0.42, s * 0.42), s * 0.04, Colors.white);
        _rrect(canvas, Rect.fromLTWH(s * 0.36, s * 0.36, s * 0.42, s * 0.42), s * 0.04, _apricotLight);
        _face(canvas, Offset(s * 0.57, s * 0.57), s * 0.12, 'cat', const Color(0xFFD6B98C));
        _heart(canvas, Offset(s * 0.30, s * 0.32), s * 0.05, _apricot);
      case Scene.shop:
        _bag(canvas, Offset(s * 0.5, s * 0.55), s * 0.24);
        _paw(canvas, Offset(s * 0.5, s * 0.58), s * 0.06, Colors.white);
      case Scene.chat:
        _bubble(canvas, Rect.fromLTWH(s * 0.18, s * 0.25, s * 0.42, s * 0.28), _teal);
        _bubble(canvas, Rect.fromLTWH(s * 0.40, s * 0.50, s * 0.42, s * 0.26), _apricot);
      case Scene.vault:
        _rrect(canvas, Rect.fromLTWH(s * 0.28, s * 0.40, s * 0.44, s * 0.36), s * 0.06, _teal);
        final shackle = Paint()
          ..color = _teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.05;
        canvas.drawArc(Rect.fromLTWH(s * 0.36, s * 0.22, s * 0.28, s * 0.32), math.pi, math.pi, false, shackle);
        _paw(canvas, Offset(s * 0.5, s * 0.58), s * 0.06, _apricotLight);
    }
  }

  void _circle(Canvas c, Offset o, double r, Color color) => c.drawCircle(o, r, Paint()..color = color);
  void _rrect(Canvas c, Rect r, double radius, Color color) =>
      c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(radius)), Paint()..color = color);

  void _heart(Canvas c, Offset o, double r, Color color) {
    final path = Path()
      ..moveTo(o.dx, o.dy + r * 0.9)
      ..cubicTo(o.dx - r * 1.6, o.dy - r * 0.2, o.dx - r * 0.6, o.dy - r * 1.3, o.dx, o.dy - r * 0.4)
      ..cubicTo(o.dx + r * 0.6, o.dy - r * 1.3, o.dx + r * 1.6, o.dy - r * 0.2, o.dx, o.dy + r * 0.9);
    c.drawPath(path, Paint()..color = color);
  }

  void _paw(Canvas c, Offset o, double r, Color color) {
    final p = Paint()..color = color;
    c.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.4), width: r * 1.6, height: r * 1.3), p);
    for (final d in [const Offset(-0.9, -0.5), const Offset(-0.3, -1.0), const Offset(0.3, -1.0), const Offset(0.9, -0.5)]) {
      c.drawCircle(o.translate(d.dx * r, d.dy * r), r * 0.33, p);
    }
  }

  void _ring(Canvas c, Offset o, double r, double progress) {
    final bg = Paint()
      ..color = _apricotLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.3;
    c.drawCircle(o, r, bg);
    c.drawArc(Rect.fromCircle(center: o, radius: r), -math.pi / 2, math.pi * 2 * progress, false,
        bg..color = _apricot..strokeCap = StrokeCap.round);
  }

  void _house(Canvas c, Offset o, double r, Color color) {
    _rrect(c, Rect.fromCenter(center: o.translate(0, r * 0.3), width: r * 1.4, height: r * 1.1), r * 0.15, color);
    c.drawPath(
        Path()
          ..moveTo(o.dx - r, o.dy - r * 0.1)
          ..lineTo(o.dx, o.dy - r * 0.9)
          ..lineTo(o.dx + r, o.dy - r * 0.1)
          ..close(),
        Paint()..color = _teal);
  }

  void _clinic(Canvas c, Offset o, double r) {
    _rrect(c, Rect.fromCenter(center: o.translate(0, r * 0.1), width: r * 1.5, height: r * 1.5), r * 0.2,
        dark ? const Color(0xFF172124) : Colors.white);
    final cross = Paint()..color = _teal;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: o.translate(0, r * 0.1), width: r * 0.3, height: r * 0.9), Radius.circular(r * 0.08)), cross);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: o.translate(0, r * 0.1), width: r * 0.9, height: r * 0.3), Radius.circular(r * 0.08)), cross);
  }

  void _bowl(Canvas c, Offset o, double r) {
    final path = Path()
      ..moveTo(o.dx - r, o.dy - r * 0.2)
      ..lineTo(o.dx + r, o.dy - r * 0.2)
      ..quadraticBezierTo(o.dx + r * 0.85, o.dy + r * 0.6, o.dx, o.dy + r * 0.6)
      ..quadraticBezierTo(o.dx - r * 0.85, o.dy + r * 0.6, o.dx - r, o.dy - r * 0.2);
    c.drawPath(path, Paint()..color = _teal);
    c.drawOval(Rect.fromCenter(center: o.translate(0, -r * 0.2), width: r * 2, height: r * 0.35), Paint()..color = _apricotLight);
  }

  void _pin(Canvas c, Offset o, double r) {
    final path = Path()
      ..addOval(Rect.fromCircle(center: o.translate(0, -r * 0.25), radius: r))
      ..moveTo(o.dx - r * 0.6, o.dy + r * 0.5)
      ..lineTo(o.dx, o.dy + r * 1.4)
      ..lineTo(o.dx + r * 0.6, o.dy + r * 0.5)
      ..close();
    c.drawPath(path, Paint()..color = _teal);
  }

  void _bag(Canvas c, Offset o, double r) {
    _rrect(c, Rect.fromCenter(center: o, width: r * 1.8, height: r * 1.7), r * 0.25, _teal);
    final handle = Paint()
      ..color = _apricot
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.14
      ..strokeCap = StrokeCap.round;
    c.drawArc(Rect.fromCenter(center: o.translate(0, -r * 0.85), width: r * 0.9, height: r * 0.9), math.pi, math.pi, false, handle);
  }

  void _bubble(Canvas c, Rect r, Color color) {
    _rrect(c, r, r.height * 0.4, color);
    for (var i = 0; i < 3; i++) {
      c.drawCircle(Offset(r.left + r.width * (0.3 + i * 0.2), r.center.dy), r.height * 0.08, Paint()..color = Colors.white);
    }
  }

  void _face(Canvas c, Offset o, double r, String species, Color fur) => drawPetFace(c, o, r, species, fur);

  @override
  bool shouldRepaint(covariant _ScenePainter old) => old.scene != scene || old.dark != dark;
}

/// Simple friendly pet faces, used as avatars when a pet has no photo.
void drawPetFace(Canvas c, Offset o, double r, String species, Color fur) {
  final furPaint = Paint()..color = fur;
  final dark = Paint()..color = _ink;
  final darker = Paint()..color = Color.lerp(fur, Colors.black, 0.25)!;
  final light = Paint()..color = Color.lerp(fur, Colors.white, 0.55)!;
  switch (species) {
    case 'cat':
      for (final side in [-1, 1]) {
        c.drawPath(
            Path()
              ..moveTo(o.dx + side * r * 0.85, o.dy - r * 0.2)
              ..lineTo(o.dx + side * r * 0.75, o.dy - r * 1.15)
              ..lineTo(o.dx + side * r * 0.2, o.dy - r * 0.8)
              ..close(),
            furPaint);
      }
      c.drawCircle(o, r, furPaint);
      c.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.35), width: r * 0.9, height: r * 0.55), light);
      for (final side in [-1, 1]) {
        c.drawOval(Rect.fromCenter(center: o.translate(side * r * 0.38, -r * 0.1), width: r * 0.18, height: r * 0.26), dark);
        final w = Paint()
          ..color = _ink.withValues(alpha: 0.5)
          ..strokeWidth = r * 0.03;
        c.drawLine(o.translate(side * r * 0.3, r * 0.35), o.translate(side * r * 0.95, r * 0.25), w);
        c.drawLine(o.translate(side * r * 0.3, r * 0.42), o.translate(side * r * 0.95, r * 0.5), w);
      }
      c.drawPath(
          Path()
            ..moveTo(o.dx - r * 0.1, o.dy + r * 0.2)
            ..lineTo(o.dx + r * 0.1, o.dy + r * 0.2)
            ..lineTo(o.dx, o.dy + r * 0.32)
            ..close(),
          Paint()..color = const Color(0xFFF472B6));
    case 'bird':
      for (var i = -1; i <= 1; i++) {
        c.drawOval(
            Rect.fromCenter(center: o.translate(i * r * 0.18, -r * 1.0), width: r * 0.18, height: r * 0.55),
            Paint()..color = const Color(0xFFFBBF24));
      }
      c.drawCircle(o, r, furPaint);
      c.drawCircle(o.translate(r * 0.45, r * 0.15), r * 0.2, Paint()..color = const Color(0xFFF4A261));
      c.drawCircle(o.translate(-r * 0.45, r * 0.15), r * 0.2, Paint()..color = const Color(0xFFF4A261));
      c.drawCircle(o.translate(-r * 0.3, -r * 0.2), r * 0.12, dark);
      c.drawCircle(o.translate(r * 0.3, -r * 0.2), r * 0.12, dark);
      c.drawPath(
          Path()
            ..moveTo(o.dx - r * 0.15, o.dy)
            ..lineTo(o.dx + r * 0.15, o.dy)
            ..lineTo(o.dx, o.dy + r * 0.3)
            ..close(),
          Paint()..color = const Color(0xFF9A3412));
    case 'rabbit':
      for (final side in [-1, 1]) {
        c.drawOval(Rect.fromCenter(center: o.translate(side * r * 0.35, -r * 1.15), width: r * 0.42, height: r * 1.2), furPaint);
        c.drawOval(Rect.fromCenter(center: o.translate(side * r * 0.35, -r * 1.1), width: r * 0.2, height: r * 0.85),
            Paint()..color = const Color(0xFFF9A8D4));
      }
      c.drawCircle(o, r, furPaint);
      c.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.35), width: r * 0.8, height: r * 0.5), light);
      c.drawCircle(o.translate(-r * 0.35, -r * 0.1), r * 0.12, dark);
      c.drawCircle(o.translate(r * 0.35, -r * 0.1), r * 0.12, dark);
      c.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.18), width: r * 0.2, height: r * 0.14),
          Paint()..color = const Color(0xFFF472B6));
      c.drawRect(Rect.fromCenter(center: o.translate(0, r * 0.4), width: r * 0.18, height: r * 0.16), Paint()..color = Colors.white);
    default: // dog
      c.drawCircle(o, r, furPaint);
      for (final side in [-1, 1]) {
        c.save();
        c.translate(o.dx + side * r * 0.9, o.dy - r * 0.1);
        c.rotate(side * 0.35);
        c.drawOval(Rect.fromCenter(center: Offset(0, r * 0.25), width: r * 0.55, height: r * 1.1), darker);
        c.restore();
      }
      c.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.35), width: r * 0.95, height: r * 0.7), light);
      c.drawCircle(o.translate(-r * 0.35, -r * 0.15), r * 0.12, dark);
      c.drawCircle(o.translate(r * 0.35, -r * 0.15), r * 0.12, dark);
      c.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.2), width: r * 0.32, height: r * 0.22), dark);
      final mouth = Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.05
        ..strokeCap = StrokeCap.round;
      c.drawArc(Rect.fromCenter(center: o.translate(-r * 0.1, r * 0.38), width: r * 0.2, height: r * 0.16), 0, math.pi, false, mouth);
      c.drawArc(Rect.fromCenter(center: o.translate(r * 0.1, r * 0.38), width: r * 0.2, height: r * 0.16), 0, math.pi, false, mouth);
  }
}

/// Canvas widget for a single pet face.
class PetFace extends StatelessWidget {
  const PetFace({super.key, required this.species, required this.color, this.size = 48});
  final String species;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FacePainter(species, color, Theme.of(context).extension<PawColors>()!.primaryContainer)),
    );
  }
}

class _FacePainter extends CustomPainter {
  _FacePainter(this.species, this.color, this.bg);
  final String species;
  final Color color;
  final Color bg;
  @override
  void paint(Canvas canvas, Size size) {
    final o = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(o, size.width / 2, Paint()..color = color.withValues(alpha: 0.22));
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: o, radius: size.width / 2)));
    final r = size.width * (species == 'rabbit' || species == 'bird' ? 0.26 : 0.30);
    drawPetFace(canvas, o.translate(0, species == 'rabbit' || species == 'bird' ? size.width * 0.12 : size.width * 0.04), r, species, color);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FacePainter old) => old.species != species || old.color != color;
}
