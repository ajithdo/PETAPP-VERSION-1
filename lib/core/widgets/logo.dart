import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// PawSetu mark (UI Design 6 "Toran"): a paw under a marigold bridge arch
/// ("setu"), in a rounded kaapi tile. On the dark band ([onDark]) the tile
/// turns marigold and the arch and paw kaapi, so the mark still stands out.
/// The mark keeps its brand colours in light and dark mode.
class PawSetuLogo extends StatelessWidget {
  const PawSetuLogo({super.key, this.size = 56, this.withName = false, this.onDark = false});
  final double size;
  final bool withName;

  /// Drawn on the dark kaapi band (side menu, portal menu).
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final mark = Semantics(
      label: 'PawSetu',
      image: true,
      child: SizedBox(width: size, height: size, child: CustomPaint(painter: _LogoPainter(onDark: onDark))),
    );
    if (!withName) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.25),
        Text('PawSetu',
            style: TextStyle(
              fontFamily: FontFamilies.heading,
              fontWeight: FontWeight.w800,
              fontSize: size * 0.6,
              color: onDark ? context.paw.onBand : context.paw.textPrimary,
              letterSpacing: -0.3,
            )),
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.onDark});
  final bool onDark;

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn in a 40 × 40 grid (the mock's units).
    final k = size.width / 40;
    final tile = onDark ? PawColors.light.marigold : PawColors.light.band;
    final arch = onDark ? PawColors.light.band : PawColors.light.marigold;
    final paw = onDark ? PawColors.light.band : PawColors.light.onBand;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(12 * k)), Paint()..color = tile);
    final line = Paint()
      ..color = arch
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6 * k
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(9 * k, 25.5 * k)
      ..lineTo(9 * k, 21.5 * k)
      ..arcToPoint(Offset(31 * k, 21.5 * k), radius: Radius.circular(11 * k))
      ..lineTo(31 * k, 25.5 * k);
    canvas.drawPath(path, line);
    final fill = Paint()..color = paw;
    canvas.drawOval(Rect.fromCenter(center: Offset(20 * k, 27.6 * k), width: 8.6 * k, height: 7 * k), fill);
    for (final (x, y, r) in const [(14.6, 23.4, 1.75), (18.1, 20.6, 1.85), (21.9, 20.6, 1.85), (25.4, 23.4, 1.75)]) {
      canvas.drawCircle(Offset(x * k, y * k), r * k, fill);
    }
  }

  @override
  bool shouldRepaint(_LogoPainter o) => o.onDark != onDark;
}
