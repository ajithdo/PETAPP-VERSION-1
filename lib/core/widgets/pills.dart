import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'buttons.dart';

/// Design 2 selectable pill (pet switcher, filters): white with a brand
/// border when selected, soft sand when not. The tap area is at least 48 px
/// tall even though the pill itself is smaller.
class PawPill extends StatelessWidget {
  const PawPill({
    super.key,
    required this.label,
    required this.onTap,
    this.leading,
    this.selected = false,
    this.outlined = false,
    this.semanticLabel,
  });

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
    final fill = selected ? paw.surface : (outlined ? Colors.transparent : paw.surfaceSubtle);
    final side = selected
        ? BorderSide(color: paw.brand, width: 2)
        : BorderSide(color: outlined ? paw.controlBorder : paw.outline);
    final text = context.text.labelLarge?.copyWith(
      color: selected ? paw.textPrimary : paw.textSecondary,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
    );
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
                  padding: EdgeInsets.fromLTRB(leading == null ? Space.md + 2 : Space.xs + 2, Space.xs + 2, Space.md + 2, Space.xs + 2),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (leading != null) ...[leading!, const SizedBox(width: Space.sm)],
                    Text(label, style: text),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
