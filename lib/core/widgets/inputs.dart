import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// Labelled text field with inline validation.
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
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: TextFormField(
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
          labelText: label,
          hintText: hint,
          helperText: helper,
          helperMaxLines: 3,
          prefixText: prefixText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          suffixIcon: suffix,
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
            avatar: icons == null ? null : Icon(icons!(o), size: 18),
            selected: o == selected,
            showCheckmark: icons == null,
            onSelected: (_) => onSelected(o),
          ),
      ],
    );
  }
}
