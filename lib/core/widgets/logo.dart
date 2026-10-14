import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// PawSetu mark: a paw under a bridge arch, in a rounded teal tile.
class PawSetuLogo extends StatelessWidget {
  const PawSetuLogo({super.key, this.size = 56, this.withName = false});
  final double size;
  final bool withName;

  @override
  Widget build(BuildContext context) {
    final mark = Semantics(
      label: 'PawSetu',
      image: true,
      child: SizedBox(width: size, height: size, child: CustomPaint(painter: _LogoPainter())),
    );
    if (!withName) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.25),
        Text('PawSetu',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w700,
              fontSize: size * 0.5,
              color: context.paw.textPrimary,
              letterSpacing: -0.5,
            )),
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(s * 0.28)),
      Paint()..color = const Color(0xFF0F766E),
    );
    final arch = Paint()
      ..color = const Color(0xFFF4A261)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromLTWH(s * 0.16, s * 0.2, s * 0.68, s * 0.5), math.pi, math.pi, false, arch);
    final white = Paint()..color = Colors.white;
    final o = Offset(s * 0.5, s * 0.62);
    final r = s * 0.13;
    canvas.drawOval(Rect.fromCenter(center: o.translate(0, r * 0.45), width: r * 1.7, height: r * 1.35), white);
    for (final d in [const Offset(-0.95, -0.45), const Offset(-0.33, -0.95), const Offset(0.33, -0.95), const Offset(0.95, -0.45)]) {
      canvas.drawCircle(o.translate(d.dx * r, d.dy * r), r * 0.34, white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
