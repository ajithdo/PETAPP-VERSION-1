import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A drawn map preview (UI Design 6): streets, a park, water, the person's
/// position and clinic pins. Used where a picture of a map invites a tap
/// ("Clinics on the map"); the real map opens behind it. Decorative, so it
/// needs no network and reads the same offline.
class MapSketch extends StatelessWidget {
  const MapSketch({super.key, this.height = Sizes.mapSmall, this.pins = const [Offset(0.3, 0.38), Offset(0.67, 0.28), Offset(0.82, 0.7)]});
  final double height;

  /// Clinic pins as fractions of the width and height; the first is marigold.
  final List<Offset> pins;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(height: height, width: double.infinity, child: CustomPaint(painter: _MapPainter(pins, context.paw))),
  );
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.pins, this.paw);
  final List<Offset> pins;
  final PawColors paw;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    canvas.drawRect(Offset.zero & s, Paint()..color = MapColors.land);
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.82)
        ..quadraticBezierTo(w * 0.2, h * 0.62, w * 0.35, h * 0.8)
        ..quadraticBezierTo(w * 0.6, h * 0.95, w, h * 0.78)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = MapColors.park,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.7, 0)
        ..quadraticBezierTo(w * 0.72, h * 0.3, w * 0.86, h * 0.3)
        ..quadraticBezierTo(w, h * 0.3, w, h * 0.12)
        ..lineTo(w, 0)
        ..close(),
      Paint()..color = MapColors.water,
    );
    final road = Paint()
      ..color = MapColors.road
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, h * 0.53), Offset(w, h * 0.53), road..strokeWidth = 10);
    canvas.drawLine(Offset(w * 0.37, 0), Offset(w * 0.37, h), road..strokeWidth = 10);
    road.strokeWidth = 5;
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.22)
        ..quadraticBezierTo(w * 0.35, h * 0.38, w * 0.5, h * 0.22)
        ..quadraticBezierTo(w * 0.75, h * 0.05, w, h * 0.3),
      road,
    );
    canvas.drawLine(Offset(w * 0.67, 0), Offset(w * 0.7, h), road);
    canvas.drawLine(Offset(w * 0.12, 0), Offset(w * 0.12, h), road);
    // You are here.
    final you = Offset(w * 0.47, h * 0.58);
    canvas.drawCircle(you, 14, Paint()..color = MapColors.you.withValues(alpha: 0.18));
    canvas.drawCircle(you, 6, Paint()..color = MapColors.you);
    canvas.drawCircle(you, 6, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = MapColors.road);
    for (var i = 0; i < pins.length; i++) {
      final p = Offset(pins[i].dx * w, pins[i].dy * h);
      final fill = i == 0 ? paw.marigold : MapColors.pin;
      final mark = i == 0 ? paw.onMarigold : MapColors.road;
      final pin = Path()
        ..moveTo(p.dx, p.dy)
        ..cubicTo(p.dx - 9, p.dy - 11, p.dx - 14, p.dy - 17, p.dx - 14, p.dy - 24)
        ..arcToPoint(Offset(p.dx + 14, p.dy - 24), radius: const Radius.circular(14))
        ..cubicTo(p.dx + 14, p.dy - 17, p.dx + 9, p.dy - 11, p.dx, p.dy)
        ..close();
      canvas.drawPath(pin, Paint()..color = fill);
      canvas.drawPath(pin, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = MapColors.road);
      final plus = Paint()
        ..color = mark
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(p.dx, p.dy - 30), Offset(p.dx, p.dy - 19), plus);
      canvas.drawLine(Offset(p.dx - 5.5, p.dy - 24.5), Offset(p.dx + 5.5, p.dy - 24.5), plus);
    }
  }

  @override
  bool shouldRepaint(_MapPainter o) => o.pins != pins || o.paw != paw;
}
