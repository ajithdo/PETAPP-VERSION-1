import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Circular progress ring (Home "Today" checklist).
class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.progress, this.size = 72, this.stroke = 8, this.center, this.color});
  final double progress;
  final double size;
  final double stroke;
  final Widget? center;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0);
    return Semantics(
      value: '${(p * 100).round()}%',
      child: SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: p),
          duration: MediaQuery.of(context).disableAnimations ? Duration.zero : const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, v, _) => CustomPaint(
            painter: _RingPainter(v, stroke, color ?? context.colors.primary, context.paw.outline),
            child: Center(child: center),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.v, this.stroke, this.color, this.bg);
  final double v;
  final double stroke;
  final Color color;
  final Color bg;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = bg;
    canvas.drawArc(r, 0, math.pi * 2, false, p);
    if (v > 0) canvas.drawArc(r, -math.pi / 2, math.pi * 2 * v, false, p..color = color);
  }

  @override
  bool shouldRepaint(covariant _RingPainter o) => o.v != v || o.color != color || o.bg != bg;
}
