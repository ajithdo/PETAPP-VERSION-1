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
    final side = selected
        ? BorderSide(color: paw.textPrimary)
        : BorderSide(color: paw.controlBorder.withValues(alpha: outlined ? Opacities.muted : Opacities.half));
    final text = context.text.labelLarge?.copyWith(color: selected ? paw.background : (outlined ? paw.textSecondary : paw.textPrimary), fontWeight: selected ? FontWeight.w700 : FontWeight.w600);
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: TapTarget.min),
        child: Center(
          widthFactor: 1,
          child: PressScale(
            child: Material(
              color: fill,
              shape: RoundedRectangleBorder(borderRadius: radius, side: side),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    leading == null ? Space.md + Space.xxs : Space.xs + Space.xxs,
                    Space.xs + Space.xxs,
                    Space.md + Space.xxs,
                    Space.xs + Space.xxs,
                  ),
                  child: LayoutBuilder(
                    builder: (context, c) {
                      // In a wrap the label shortens to fit; in a scrolling
                      // row (unbounded width) it keeps its full length.
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
