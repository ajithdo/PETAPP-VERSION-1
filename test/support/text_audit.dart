import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exact text audit of the current screen: reads every on-screen paragraph's
/// own text colour and the colour painted behind it (decorated boxes,
/// coloured boxes, Material surfaces, with opacity), instead of sampling
/// pixels. Flutter's textContrastGuideline samples the whole semantics rect,
/// which for merged nodes (list tiles, cards) often spans two backgrounds.
///
/// Counts per screen: WCAG contrast failures for text (4.5:1, or 3:1 for
/// large text) and icons (3:1), small text, and text cut off by maxLines.
class TextAudit {
  int texts = 0;
  int icons = 0;
  int smallText = 0; // under 14 logical px
  int tinyText = 0; // 12 px or smaller
  int truncated = 0; // cut off with an ellipsis, fade or clip
  int disabled = 0; // text in disabled buttons, exempt from contrast rules
  final contrastFailures = <String>[];
  final iconFailures = <String>[];
  final truncatedExamples = <String>[];
  final screens = <String>{};

  /// Audits what is on screen now; [where] labels the findings.
  void check(WidgetTester tester, String where) {
    screens.add(where);
    final seen = <RenderParagraph>{};
    for (final element in find.byType(RichText).evaluate()) {
      final paragraph = element.renderObject;
      if (paragraph is! RenderParagraph || !paragraph.attached || !paragraph.hasSize || !seen.add(paragraph)) continue;
      if (_hidden(paragraph)) continue;
      // WCAG exempts inactive controls from the contrast rules.
      var inDisabledButton = false;
      element.visitAncestorElements((a) {
        if (a.widget is ButtonStyleButton) inDisabledButton = !(a.widget as ButtonStyleButton).enabled;
        return a.widget is! ButtonStyleButton;
      });
      final background = _background(paragraph, Theme.of(element).colorScheme.surface);
      final opacity = _opacity(paragraph);
      _spans(paragraph.text, const TextStyle(), (text, style) {
        final color = (style.color ?? Colors.black).withValues(alpha: (style.color ?? Colors.black).a * opacity);
        final size = style.fontSize ?? 14;
        final isIcon = (style.fontFamily ?? '').contains('Icons');
        final ratio = contrast(Color.alphaBlend(color, background), background);
        if (isIcon) {
          icons++;
          if (ratio < 3.0) _add(iconFailures, '$where: icon ${_hex(color)} on ${_hex(background)} = ${ratio.toStringAsFixed(2)}');
          return;
        }
        texts++;
        if (inDisabledButton) {
          disabled++;
          return;
        }
        if (size < 14) smallText++;
        if (size <= 12) tinyText++;
        final large = size >= 24 || (size >= 18.66 && (style.fontWeight?.value ?? 400) >= 700);
        if (ratio < (large ? 3.0 : 4.5)) {
          _add(contrastFailures, '$where: "${_short(text)}" ${size.toStringAsFixed(0)}px ${_hex(color)} on ${_hex(background)} = ${ratio.toStringAsFixed(2)}');
        }
      });
      if (paragraph.didExceedMaxLines && paragraph.overflow != TextOverflow.visible) {
        truncated++;
        _add(truncatedExamples, '$where: "${_short(paragraph.text.toPlainText())}"');
      }
    }
  }

  String summary(String title) => '$title: ${screens.length} screens, $texts text runs, $icons icons\n'
      '    text contrast failures: ${contrastFailures.length} (disabled buttons skipped: $disabled)${_list(contrastFailures)}\n'
      '    icon contrast failures (3:1): ${iconFailures.length}${_list(iconFailures)}\n'
      '    small text (<14 px): $smallText (${_pct(smallText)}), of which 12 px or less: $tinyText (${_pct(tinyText)})\n'
      '    cut-off text: $truncated${_list(truncatedExamples)}';

  String _pct(int n) => texts == 0 ? '0%' : '${(100 * n / texts).toStringAsFixed(0)}%';

  static String _list(List<String> items) => items.isEmpty ? '' : '\n      ${items.take(12).join('\n      ')}${items.length > 12 ? '\n      … ${items.length - 12} more' : ''}';

  static void _add(List<String> list, String item) {
    if (!list.contains(item)) list.add(item);
  }

  static String _short(String s) => s.replaceAll('\n', ' ').length > 48 ? '${s.replaceAll('\n', ' ').substring(0, 48)}…' : s.replaceAll('\n', ' ');

  static String _hex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}${c.a < 1 ? '@${(c.a * 100).round()}%' : ''}';

  /// WCAG 2 contrast ratio between two opaque colours.
  static double contrast(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// Calls [visit] for every text span with its inherited style.
  static void _spans(InlineSpan span, TextStyle inherited, void Function(String text, TextStyle style) visit) {
    if (span is! TextSpan) return;
    final style = inherited.merge(span.style);
    if ((span.text ?? '').trim().isNotEmpty) visit(span.text!, style);
    for (final child in span.children ?? const <InlineSpan>[]) {
      _spans(child, style, visit);
    }
  }

  /// Paragraphs inside fully transparent or offstage subtrees aren't seen.
  static bool _hidden(RenderObject o) {
    for (RenderObject? p = o; p != null; p = p.parent) {
      if (p is RenderOffstage && p.offstage) return true;
      if (p is RenderOpacity && p.opacity == 0) return true;
      if (p is RenderAnimatedOpacity && p.opacity.value == 0) return true;
    }
    return false;
  }

  /// Opacity applied by ancestors up to the first painted background.
  static double _opacity(RenderObject o) {
    var opacity = 1.0;
    for (RenderObject? p = o.parent; p != null; p = p.parent) {
      if (_paintedColor(p) != null) break;
      if (p is RenderOpacity) opacity *= p.opacity;
      if (p is RenderAnimatedOpacity) opacity *= p.opacity.value;
    }
    return opacity;
  }

  /// The colour painted behind [o], blending translucent layers over the
  /// ones below them; [fallback] when nothing is painted.
  static Color _background(RenderObject o, Color fallback) {
    final layers = <Color>[];
    for (RenderObject? p = o.parent; p != null; p = p.parent) {
      final c = _paintedColor(p);
      if (c == null || c.a == 0) continue;
      layers.add(c);
      if (c.a >= 1) break;
    }
    var color = layers.isNotEmpty && layers.last.a >= 1 ? layers.removeLast() : fallback;
    for (final layer in layers.reversed) {
      color = Color.alphaBlend(layer, color);
    }
    return color;
  }

  static Color? _paintedColor(RenderObject p) {
    if (p is RenderDecoratedBox && p.position == DecorationPosition.background) {
      final d = p.decoration;
      if (d is BoxDecoration) return d.color ?? d.gradient?.colors.first;
      if (d is ShapeDecoration) return d.color ?? d.gradient?.colors.first;
    }
    if (p is RenderPhysicalShape) return p.color;
    if (p is RenderPhysicalModel) return p.color;
    // ColoredBox's render object is private; its colour is a public getter.
    if (p.runtimeType.toString() == '_RenderColoredBox') return (p as dynamic).color as Color;
    return null;
  }
}
