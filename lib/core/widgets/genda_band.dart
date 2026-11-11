import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';
import 'layout.dart';

/// UI Design 5's signature (DESIGN.md, "The Genda band"): on Home, the
/// selected pet's photo sits in a marigold garland with one flower per task
/// today. Flowers open as tasks are done. Next to it: the date, "Bruno's day",
/// "2 of 4 done" and a marigold progress bar. Warm register only (Home).
class GendaBand extends StatelessWidget {
  const GendaBand({super.key, required this.petName, required this.photo, required this.done, required this.total, this.dateLabel, this.onTap});

  final String petName;

  /// The pet's photo (or drawn face), clipped to a circle by the band.
  final Widget photo;
  final int done;
  final int total;

  /// "Sunday, 8 November".
  final String? dateLabel;
  final VoidCallback? onTap;

  /// At most this many flowers; the count line carries the rest.
  static const int maxFlowers = 8;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final l = context.l10n;
    final allDone = total > 0 && done >= total;
    final status = total == 0 ? l.gendaNothingPlanned : (allDone ? l.allDoneToday(petName) : l.gendaProgress(done, total));
    final title = l.todayFor(petName);
    final textBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dateLabel != null) Text(dateLabel!, style: context.text.bodySmall?.copyWith(color: paw.onBandMuted)),
        Text(title, style: context.text.titleLarge?.copyWith(color: paw.onBand)),
        const SizedBox(height: Space.xxs),
        Text(status, style: context.text.labelLarge?.copyWith(color: paw.onBand)),
        if (total > 0) ...[const SizedBox(height: Space.sm), _ProgressBar(value: done / total)],
      ],
    );
    return Semantics(
      container: true,
      button: onTap != null,
      label: '$title. $status',
      excludeSemantics: true,
      child: Material(
        color: paw.band,
        borderRadius: BorderRadius.circular(Radii.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Space.lg + Space.xxs),
            child: LayoutBuilder(
              builder: (context, c) {
                // Side by side when there's room; stacked on narrow screens and
                // at big text sizes, so nothing is squeezed.
                final scale = MediaQuery.textScalerOf(context).scale(1);
                final stacked = c.maxWidth < 250 || (scale > 1.4 && c.maxWidth < 520);
                final size = c.maxWidth < 340 || stacked ? Sizes.garlandCompact : Sizes.garland;
                final garland = Garland(photo: photo, done: done, total: total, size: size);
                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      garland,
                      const SizedBox(height: Space.md),
                      textBlock,
                    ],
                  );
                }
                return Row(
                  children: [
                    garland,
                    const SizedBox(width: Space.lg),
                    Expanded(child: textBlock),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.full),
      child: SizedBox(
        height: Sizes.gendaBar,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1)),
          duration: context.reduceMotion ? Duration.zero : Motion.enter,
          curve: Motion.emphasized,
          builder: (_, v, _) => Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: paw.onBand.withValues(alpha: Opacities.chip)),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: v,
                child: ColoredBox(color: paw.marigold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The garland itself: the photo in a circle, ringed by one marigold flower
/// per task (filled when done, outlined when not) with small beads between.
/// Newly done flowers open over 250 ms (instant with reduce motion).
class Garland extends StatelessWidget {
  const Garland({super.key, required this.photo, required this.done, required this.total, this.size = Sizes.garland});
  final Widget photo;
  final int done;
  final int total;
  final double size;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final flowers = math.min(total, GendaBand.maxFlowers);
    final shownDone = total == 0 ? 0 : (done * flowers / total).round();
    final photoSize = size * Sizes.garlandPhotoShare;
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: shownDone.toDouble()),
        duration: context.reduceMotion ? Duration.zero : Motion.enter,
        curve: Motion.emphasized,
        builder: (context, opened, child) => CustomPaint(
          painter: _GarlandPainter(flowers: flowers, opened: opened, marigold: paw.marigold, open: paw.onBandMuted, band: paw.band, heart: paw.onMarigold),
          child: child,
        ),
        child: Center(
          child: ClipOval(
            child: SizedBox.square(dimension: photoSize, child: photo),
          ),
        ),
      ),
    );
  }
}

class _GarlandPainter extends CustomPainter {
  _GarlandPainter({required this.flowers, required this.opened, required this.marigold, required this.open, required this.band, required this.heart});
  final int flowers;
  final double opened;
  final Color marigold;
  final Color open;
  final Color band;
  final Color heart;

  static const int _beads = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - size.width * 0.075;
    final petal = size.width * 0.034;
    final stroke = size.width * 0.011;
    // With no tasks: a closed garland of beads only.
    final slots = flowers == 0 ? 0 : _beads ~/ flowers * flowers;
    final every = flowers == 0 ? _beads : _beads ~/ flowers;
    for (var k = 0; k < _beads; k++) {
      final a = -math.pi / 2 + k * 2 * math.pi / _beads;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      final isFlower = flowers > 0 && k % every == 0 && k ~/ every < flowers && k < slots;
      if (!isFlower) {
        canvas.drawCircle(p, petal * 0.75, Paint()..color = marigold.withValues(alpha: Opacities.fadedArt));
        continue;
      }
      final index = k ~/ every;
      final t = (opened - index).clamp(0.0, 1.0);
      _flower(canvas, p, petal, stroke, t);
    }
  }

  void _flower(Canvas canvas, Offset p, double petal, double stroke, double t) {
    final fill = Paint()..color = marigold.withValues(alpha: t);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Color.lerp(open, marigold, t)!;
    final grow = 0.85 + 0.15 * t;
    for (var j = 0; j < 8; j++) {
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(j * math.pi / 4);
      final rect = Rect.fromCenter(center: Offset(0, -petal * 1.5 * grow), width: petal * 1.2 * grow, height: petal * 2.3 * grow);
      if (t > 0) canvas.drawOval(rect, fill);
      canvas.drawOval(rect, line);
      canvas.restore();
    }
    canvas.drawCircle(p, petal * 0.9, Paint()..color = t > 0.5 ? heart : band);
    canvas.drawCircle(p, petal * 0.9, line);
  }

  @override
  bool shouldRepaint(_GarlandPainter o) =>
      o.flowers != flowers || o.opened != opened || o.marigold != marigold || o.open != open || o.band != band || o.heart != heart;
}

/// Widget previews (Flutter widget previewer): the band in light and dark,
/// half done, all done, and with nothing planned.
@Preview(name: 'Genda band, 2 of 4 done', group: 'UI Design 5', size: Size(390, 220))
Widget gendaBandHalf() => _PreviewFrame(brightness: Brightness.light, child: _sample(done: 2, total: 4));

@Preview(name: 'Genda band, dark, all done', group: 'UI Design 5', size: Size(390, 220))
Widget gendaBandDone() => _PreviewFrame(brightness: Brightness.dark, child: _sample(done: 5, total: 5));

@Preview(name: 'Genda band, nothing planned, Telugu', group: 'UI Design 5', size: Size(390, 240))
Widget gendaBandEmpty() => _PreviewFrame(brightness: Brightness.light, locale: 'te', child: _sample(done: 0, total: 0));

Widget _sample({required int done, required int total}) => Builder(
  builder: (context) => GendaBand(
    petName: 'Bruno',
    dateLabel: 'Sunday, 8 November',
    photo: ColoredBox(color: context.paw.marigold),
    done: done,
    total: total,
  ),
);

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.brightness, required this.child, this.locale = 'en'});
  final Brightness brightness;
  final Widget child;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: Locale(locale),
      child: Theme(
        data: AppTheme.build(brightness: brightness, locale: locale),
        child: Builder(
          builder: (context) => ColoredBox(
            color: context.paw.background,
            child: Padding(padding: const EdgeInsets.all(Space.lg), child: child),
          ),
        ),
      ),
    );
  }
}
