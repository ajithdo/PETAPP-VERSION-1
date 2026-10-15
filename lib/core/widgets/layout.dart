import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../theme/tokens.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String get lang => Localizations.localeOf(this).languageCode;
}

enum ScreenSize { phone, tablet, desktop }

extension ResponsiveX on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  ScreenSize get screenSize {
    final w = width;
    if (w >= 1024) return ScreenSize.desktop;
    if (w >= 640) return ScreenSize.tablet;
    return ScreenSize.phone;
  }

  bool get isPhone => screenSize == ScreenSize.phone;
  double get gutter => isPhone ? Space.lg : Space.xl;
  bool get reduceMotion => MediaQuery.of(this).disableAnimations;
}

/// Centres content at most 1200 px wide with the standard screen padding.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = Space.maxContentWidth, this.padding = true});
  final Widget child;
  final double maxWidth;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          child: padding
              ? Padding(padding: EdgeInsets.symmetric(horizontal: context.gutter), child: child)
              : child,
        ),
      ),
    );
  }
}

/// A scrollable page body with standard padding and max width.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.maxWidth = Space.maxContentWidth, this.controller});
  final List<Widget> children;
  final double maxWidth;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.only(bottom: Space.xxl + MediaQuery.paddingOf(context).bottom),
      children: [
        for (final c in children) ContentWidth(maxWidth: maxWidth, child: c),
      ],
    );
  }
}

/// Lays children in a responsive grid: 1 column on phones, more on wider screens.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.children, this.minItemWidth = 320, this.spacing = Space.md});
  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = (c.maxWidth / minItemWidth).floor().clamp(1, 4);
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    });
  }
}

/// Equal-width tiles in rows of [columns]. Each row is as tall as its
/// tallest tile, so tiles grow with big text (200%) instead of cutting it.
class TileGrid extends StatelessWidget {
  const TileGrid({super.key, required this.columns, required this.children, this.spacing = Space.md, this.minTileHeight = 0});
  final int columns;
  final List<Widget> children;
  final double spacing;

  /// Keeps short tiles from looking squashed at normal text size.
  final double minTileHeight;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      rows.add(IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var j = i; j < i + columns; j++) ...[
            if (j > i) SizedBox(width: spacing),
            Expanded(
              child: j < children.length
                  ? ConstrainedBox(constraints: BoxConstraints(minHeight: minTileHeight), child: children[j])
                  : const SizedBox.shrink(),
            ),
          ],
        ]),
      ));
    }
    return Column(children: [
      for (var r = 0; r < rows.length; r++) ...[
        if (r > 0) SizedBox(height: spacing),
        rows[r],
      ],
    ]);
  }
}

/// One row of chips that scrolls sideways (filters, suggestions). It grows
/// with the text size and keeps every chip at least 48 px tall.
class ChipStrip extends StatelessWidget {
  const ChipStrip({super.key, required this.chips});
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(32) + 24,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.xs),
        children: [
          for (final c in chips) Padding(padding: const EdgeInsets.only(right: Space.sm), child: Center(child: c)),
        ],
      ),
    );
  }
}

class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}
