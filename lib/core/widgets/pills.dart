import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'buttons.dart';

/// Selectable pill (pet switcher, filters), UI Design 6: filled with the
/// text colour when selected, a thin outline when not, a dashed-looking quiet
/// outline for "add". The tap area is at least 48 px tall even though the pill itself is
/// smaller.
class PawPill extends StatelessWidget {
  const PawPill({super.key, required this.label, required this.onTap, this.leading, this.selected = false, this.outlined = false, this.semanticLabel});

  final String label;
  final VoidCallback onTap;
  final Widget? leading;
  final bool selected;

  /// A quiet "add" pill: no fill, a border only.
  final bool outlined;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final radius = BorderRadius.circular(Radii.full);
    final fill = selected ? paw.textPrimary : Colors.transparent;
    final edge = selected ? paw.textPrimary : context.tint.line2;
    final text = context.text.labelLarge?.copyWith(color: selected ? paw.background : (outlined ? paw.textSecondary : paw.textPrimary), fontWeight: FontWeight.w600);
    final body = Padding(
      // 44 px tall: 6 px before a picture, 12 before an icon, 14 after the label.
      padding: EdgeInsets.only(left: leading is Icon || leading == null ? Space.md : Space.xs + Space.xxs, right: Space.md + Space.xxs),
      child: LayoutBuilder(
        builder: (context, c) {
          // In a wrap the label shortens to fit; in a scrolling row
          // (unbounded width) it keeps its full length.
          final t = Text(label, style: text, maxLines: 1, overflow: TextOverflow.ellipsis);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: Space.sm)],
              c.hasBoundedWidth ? Flexible(child: t) : t,
            ],
          );
        },
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: PressScale(
        child: CustomPaint(
          // "Add" pills have a dashed edge.
          foregroundPainter: outlined ? _DashedPillPainter(edge) : null,
          child: Material(
            color: fill,
            shape: RoundedRectangleBorder(borderRadius: radius, side: outlined ? BorderSide.none : BorderSide(color: edge)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: ConstrainedBox(constraints: const BoxConstraints(minHeight: Sizes.topControl), child: body),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedPillPainter extends CustomPainter {
  _DashedPillPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(size.height / 2)).deflate(Strokes.hairline / 2));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = Strokes.hairline;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += Space.sm) {
        canvas.drawPath(m.extractPath(d, d + Space.xs), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPillPainter o) => o.color != color;
}
