import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// Text field with its label above the box (Design 2) and inline validation.
class PawTextField extends StatelessWidget {
  const PawTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscure = false,
    this.maxLines = 1,
    this.prefixText,
    this.prefixIcon,
    this.suffix,
    this.onChanged,
    this.autofill,
    this.inputFormatters,
    this.textInputAction,
    this.onSubmitted,
    this.initialValue,
    this.enabled = true,
    this.helper,
    this.autofocus = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final int maxLines;
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofill;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? initialValue;
  final bool enabled;
  final String? helper;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    // Design 2: the label sits above the box. MergeSemantics keeps it read
    // out together with the field.
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: context.text.labelLarge?.copyWith(color: enabled ? paw.textPrimary : paw.textSecondary)),
            const SizedBox(height: Space.xs + Space.xxs),
            TextFormField(
              controller: controller,
              initialValue: controller == null ? initialValue : null,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: obscure,
              maxLines: obscure ? 1 : maxLines,
              minLines: 1,
              onChanged: onChanged,
              autofillHints: autofill,
              inputFormatters: inputFormatters,
              textInputAction: textInputAction,
              onFieldSubmitted: onSubmitted,
              enabled: enabled,
              autofocus: autofocus,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: hint,
                helperText: helper,
                helperMaxLines: 3,
                errorMaxLines: 3,
                prefixText: prefixText,
                prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
                suffixIcon: suffix,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row of single-choice chips (species, gender, filters …).
class ChoiceRow<T> extends StatelessWidget {
  const ChoiceRow({super.key, required this.options, required this.selected, required this.onSelected, required this.label, this.icons});
  final List<T> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String Function(T) label;
  final IconData Function(T)? icons;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(label(o)),
            avatar: icons == null ? null : Icon(icons!(o), size: IconSizes.chip),
            selected: o == selected,
            showCheckmark: icons == null,
            onSelected: (_) => onSelected(o),
          ),
      ],
    );
  }
}

/// The bold label above a form control (Design 2 forms).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.hint});
  final String text;

  /// Optional smaller line under the label.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(text, style: context.text.labelLarge?.copyWith(color: context.paw.textPrimary)),
      if (hint != null) ...[
        const SizedBox(height: Space.xxs),
        Text(hint!, style: context.text.bodySmall),
      ],
      const SizedBox(height: Space.xs + Space.xxs),
    ]);
  }
}

/// Any control (dropdown, segmented button, chips) with a [FieldLabel]
/// above it, read out together by screen readers.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child, this.hint, this.merge = true});
  final String label;
  final String? hint;
  final Widget child;

  /// Merge label and control into one screen-reader item. Turn off for
  /// groups of several buttons (chips, tiles) so each stays reachable.
  final bool merge;

  @override
  Widget build(BuildContext context) {
    final body = Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      FieldLabel(label, hint: hint),
      child,
    ]);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.lg),
      child: merge ? MergeSemantics(child: body) : body,
    );
  }
}

/// A box that looks like a text field but opens a picker (breed, date,
/// time). Shows the chosen value, or [placeholder] when nothing is chosen.
class PawPickerField extends StatelessWidget {
  const PawPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
    this.placeholder,
    this.trailingIcon = Icons.expand_more_outlined,
  });

  final String label;
  final String? value;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? placeholder;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final empty = value == null || value!.isEmpty;
    final shown = empty ? (placeholder ?? '') : value!;
    final radius = BorderRadius.circular(Radii.input);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Semantics(
        button: true,
        label: label,
        value: shown,
        excludeSemantics: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          FieldLabel(label),
          Material(
            color: paw.surface,
            shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: paw.controlBorder)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: Sizes.fieldHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
                  child: Row(children: [
                    if (icon != null) ...[
                      Icon(icon, size: IconSizes.md, color: paw.textSecondary),
                      const SizedBox(width: Space.md),
                    ],
                    Expanded(
                      child: Text(
                        shown,
                        style: context.text.bodyLarge?.copyWith(color: empty ? paw.textSecondary : paw.textPrimary),
                      ),
                    ),
                    const SizedBox(width: Space.sm),
                    Icon(trailingIcon, size: IconSizes.md, color: paw.textSecondary),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Big single-choice tiles with an icon above a label (Design 2 species
/// picker). The chosen tile is sage with a forest border.
class ChoiceTiles<T> extends StatelessWidget {
  const ChoiceTiles({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.label,
    required this.icon,
  });

  final List<T> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String Function(T) label;
  final IconData Function(T) icon;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return LayoutBuilder(builder: (context, c) {
      final perRow = (c.maxWidth / Sizes.choiceTileMin).floor().clamp(1, options.length);
      final width = (c.maxWidth - Space.sm * (perRow - 1)) / perRow;
      return Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (final o in options)
          SizedBox(
            width: width,
            child: Semantics(
              button: true,
              inMutuallyExclusiveGroup: true,
              selected: o == selected,
              label: label(o),
              excludeSemantics: true,
              child: Material(
                color: o == selected ? paw.primaryContainer : paw.surfaceSubtle,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.lg),
                  side: o == selected
                      ? BorderSide(color: paw.brand, width: Strokes.focus)
                      : BorderSide(color: paw.outline),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(o);
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: Sizes.choiceTileHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(Space.sm),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(icon(o), size: IconSizes.lg, color: o == selected ? paw.brand : paw.textSecondary),
                        const SizedBox(height: Space.xs),
                        Text(
                          label(o),
                          textAlign: TextAlign.center,
                          style: context.text.labelMedium?.copyWith(
                            color: o == selected ? paw.onPrimaryContainer : paw.textPrimary,
                            fontWeight: o == selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]);
    });
  }
}

/// A tappable card for one choice in a list (service, payment method).
/// The chosen card has a soft coral wash and border (Design 2).
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;

  /// Usually a price, shown on the right.
  final String? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final radius = BorderRadius.circular(Radii.lg);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        button: true,
        label: [title, ?subtitle, ?trailing].join(', '),
        excludeSemantics: true,
        child: Material(
          color: selected ? paw.actionContainer : paw.surface,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: selected ? BorderSide(color: paw.action, width: Strokes.focus) : BorderSide(color: paw.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onTap!();
                  },
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_unchecked_outlined,
                  color: selected ? paw.action : paw.controlBorder,
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: context.text.titleSmall?.copyWith(color: selected ? paw.onActionContainer : paw.textPrimary)),
                    if (subtitle != null) ...[
                      const SizedBox(height: Space.xxs),
                      Text(subtitle!, style: context.text.bodySmall),
                    ],
                  ]),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: Space.md),
                  Text(trailing!, style: context.textX.mono.copyWith(fontWeight: FontWeight.w700, color: paw.textPrimary)),
                ],
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// A sand box listing charges, with the total on the last line in the
/// action colour (Design 2 price summary).
class PriceSummary extends StatelessWidget {
  const PriceSummary({super.key, required this.lines, required this.totalLabel, required this.total});

  /// (label, amount) pairs above the total.
  final List<(String, String)> lines;
  final String totalLabel;
  final String total;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    Widget row(String k, String v, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text(k, style: bold ? context.text.titleSmall : context.text.bodyMedium)),
            const SizedBox(width: Space.md),
            Text(
              v,
              style: bold
                  ? context.textX.mono.copyWith(fontWeight: FontWeight.w700, color: paw.action)
                  : context.textX.mono.copyWith(color: paw.textPrimary),
            ),
          ]),
        );
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: paw.surfaceSubtle,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: paw.outline),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final (k, v) in lines) row(k, v),
        const Divider(height: Space.lg),
        row(totalLabel, total, bold: true),
      ]),
    );
  }
}
