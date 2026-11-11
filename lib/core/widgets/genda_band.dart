import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';
import 'layout.dart';

/// UI Design 6 "Toran" signature (DESIGN.md, "The toran"): on Home, the
/// selected pet stands in an arched doorway on the dark kaapi band, and a
/// marigold garland (a toran) hangs over the doorway with one flower per task
/// today. A flower opens as each task is done; a full garland is a good day.
/// Next to it: "Bruno's day", "2 of 5 done" and the streak. On wide screens
/// [aside] (the next thing to do) sits on the right.
class GendaBand extends StatelessWidget {
  const GendaBand({
    super.key,
    required this.petName,
    required this.photo,
    required this.done,
    required this.total,
    this.dateLabel,
    this.onTap,
    this.streakDays = 0,
    this.aside,
  });

  final String petName;

  /// The pet's photo (or drawn face). The band clips it to the arch.
  final Widget photo;
  final int done;
  final int total;

  /// "Sunday, 8 November".
  final String? dateLabel;
  final VoidCallback? onTap;

  /// Days in a row with something logged; shown when more than 1.
  final int streakDays;

  /// Shown on the right on wide screens (desktop Home).
  final Widget? aside;

  /// At most this many flowers; the count line carries the rest.
  static const int maxFlowers = 8;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final l = context.l10n;
    final allDone = total > 0 && done >= total;
    final title = l.todayFor(petName);
    final status = total == 0 ? l.gendaNothingPlanned : (allDone ? l.allDoneToday(petName) : l.gendaProgress(done, total));
    final countStyle = context.text.bodyLarge?.copyWith(color: paw.onBandMuted);
    Widget progressLine() {
      if (total == 0 || allDone) return Text(status, style: countStyle?.copyWith(color: paw.onBand));
      // "2 of 5 done" with the done count big and marigold.
      final parts = status.split('$done');
      if (parts.length != 2) return Text(status, style: countStyle);
      return Text.rich(
        TextSpan(children: [
          TextSpan(text: parts[0]),
          TextSpan(text: '$done', style: context.text.headlineMedium?.copyWith(color: paw.marigold, height: TypeScale.tightLineHeight)),
          TextSpan(text: parts[1]),
        ]),
        style: countStyle,
      );
    }

    Widget textBlock(TextAlign align) => Column(
      crossAxisAlignment: align == TextAlign.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dateLabel != null) Text(dateLabel!, style: context.text.bodySmall?.copyWith(color: paw.onBandMuted), textAlign: align),
        Text(title, style: context.text.headlineMedium?.copyWith(color: paw.onBand), textAlign: align),
        const SizedBox(height: Space.xs),
        progressLine(),
        if (streakDays > 1) ...[const SizedBox(height: Space.md), _StreakTag(text: l.streakDays(streakDays))],
      ],
    );
    return Semantics(
      container: true,
      button: onTap != null,
      label: '$title. $status',
      excludeSemantics: true,
      child: Material(
        color: paw.band,
        borderRadius: BorderRadius.circular(Radii.xxl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: LayoutBuilder(
            builder: (context, c) {
              // Side by side when there's room; stacked (text over the
              // doorway) on narrow screens and at big text sizes.
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final stacked = c.maxWidth < 300 || (scale > 1.3 && c.maxWidth < 520);
              final size = c.maxWidth < 340 || stacked ? Sizes.garlandCompact : (c.maxWidth > 500 ? Sizes.garlandLarge : Sizes.garland);
              final garland = Garland(photo: photo, done: done, total: total, size: size);
              if (stacked) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg + Space.xs, Space.lg, 0),
                  child: Column(children: [textBlock(TextAlign.center), const SizedBox(height: Space.md), garland]),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(Space.sm, Space.md, Space.lg, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    garland,
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Space.lg + Space.xs),
                        child: Align(alignment: Alignment.centerLeft, child: textBlock(TextAlign.start)),
                      ),
                    ),
                    if (aside != null && c.maxWidth > 480) ...[
                      Container(width: Strokes.hairline, height: size * 0.6, margin: const EdgeInsets.only(bottom: Space.xl), color: paw.onBand.withValues(alpha: Opacities.tint)),
                      const SizedBox(width: Space.lg),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: Space.lg + Space.xs),
                          child: DefaultTextStyle.merge(style: TextStyle(color: paw.onBandMuted), child: aside!),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StreakTag extends StatelessWidget {
  const _StreakTag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    return DecoratedBox(
      decoration: BoxDecoration(color: paw.onBand.withValues(alpha: Opacities.chip), borderRadius: BorderRadius.circular(Radii.sm)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.xxs),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.local_fire_department_rounded, size: IconSizes.sm, color: paw.marigold),
          const SizedBox(width: Space.xs),
          Flexible(child: Text(text, style: context.text.labelSmall?.copyWith(color: paw.onBand))),
        ]),
      ),
    );
  }
}

/// The doorway: the pet's photo in an arch, with the toran hanging over it.
/// One marigold per task: open when done, a bud when not, with pairs of mango
/// leaves between. Newly done flowers open over 250 ms (instant with reduce
/// motion). [size] is the width; the height is [size] × 152 / 148.
class Garland extends StatelessWidget {
  const Garland({super.key, required this.photo, required this.done, required this.total, this.size = Sizes.garland});
  final Widget photo;
  final int done;
  final int total;
  final double size;

  // Geometry in a 148 × 152 box (the mock's units).
  static const double _w = 148, _h = 152, _cx = 74, _cy = 82, _r = 52;

  @override
  Widget build(BuildContext context) {
    final flowers = math.min(total, GendaBand.maxFlowers);
    final shownDone = total == 0 ? 0 : (done * flowers / total).round();
    final k = size / _w;
    final archW = 2 * _r * k;
    return SizedBox(
      width: size,
      height: _h * k,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: shownDone.toDouble()),
        duration: context.reduceMotion ? Duration.zero : Motion.enter,
        curve: Motion.emphasized,
        builder: (context, opened, child) => CustomPaint(
          painter: _DoorwayPainter(scale: k),
          foregroundPainter: _ToranPainter(flowers: flowers, opened: opened, scale: k),
          child: child,
        ),
        child: Stack(children: [
          Positioned(
            left: (_cx - _r) * k,
            top: (_cy - _r) * k,
            width: archW,
            bottom: 0,
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(archW / 2))),
              ),
              child: FittedBox(fit: BoxFit.cover, clipBehavior: Clip.hardEdge, child: SizedBox(width: archW, height: archW * Sizes.archAspect, child: photo)),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Faint doorway outlines behind the arch.
class _DoorwayPainter extends CustomPainter {
  _DoorwayPainter({required this.scale});
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * scale
      ..color = GarlandColors.doorway;
    const cx = Garland._cx, cy = Garland._cy, r = Garland._r;
    for (final f in const [1.44, 1.78]) {
      final rr = r * f * scale;
      final path = Path()
        ..moveTo(cx * scale - rr, size.height)
        ..lineTo(cx * scale - rr, cy * scale)
        ..arcToPoint(Offset(cx * scale + rr, cy * scale), radius: Radius.circular(rr))
        ..lineTo(cx * scale + rr, size.height);
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(_DoorwayPainter o) => o.scale != scale;
}

/// The garland over the arch.
class _ToranPainter extends CustomPainter {
  _ToranPainter({required this.flowers, required this.opened, required this.scale});
  final int flowers;
  final double opened;
  final double scale;

  static const double _ringR = 66;
  static const double _from = -158 * math.pi / 180, _to = -22 * math.pi / 180;

  Offset _at(double a, [double r = _ringR]) => Offset((Garland._cx + math.cos(a) * r) * scale, (Garland._cy + math.sin(a) * r) * scale);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: Offset(Garland._cx * scale, Garland._cy * scale), radius: _ringR * scale);
    canvas.drawArc(
      rect,
      _from - 0.2,
      (_to - _from) + 0.4,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * scale
        ..strokeCap = StrokeCap.round
        ..color = GarlandColors.stem,
    );
    final n = flowers;
    double angle(int i) => n <= 1 ? -math.pi / 2 : _from + (_to - _from) * i / (n - 1);
    // Leaves: a pair between each two flowers, and a bigger pair at each end.
    if (n > 1) {
      for (var i = 0; i < n - 1; i++) {
        _leaves(canvas, (angle(i) + angle(i + 1)) / 2, false);
      }
    }
    _leaves(canvas, _from - 0.2, true);
    _leaves(canvas, _to + 0.2, true);
    for (var i = 0; i < n; i++) {
      final p = _at(angle(i));
      final t = (opened - i).clamp(0.0, 1.0);
      if (t < 1) _bud(canvas, p, 1 - t);
      if (t > 0) _bloom(canvas, p, 12.5 * scale * (0.55 + 0.45 * t), t);
    }
  }

  void _leaves(Canvas canvas, double a, bool big) {
    final p = _at(a);
    final len = (big ? 15.0 : 12.0) * scale, w = (big ? 5.4 : 4.6) * scale;
    final paint = Paint()..color = GarlandColors.leaf;
    for (final rot in const [-16.0, 16.0]) {
      canvas.save();
      canvas.translate(p.dx, p.dy + 0.5 * scale);
      canvas.rotate(rot * math.pi / 180);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(w, len * 0.45, 0, len)
        ..quadraticBezierTo(-w, len * 0.45, 0, 0);
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  void _bud(Canvas canvas, Offset p, double alpha) {
    canvas.drawCircle(p, 8 * scale, Paint()..color = GarlandColors.bud.withValues(alpha: alpha));
    canvas.drawCircle(
      p,
      8 * scale,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * scale
        ..color = GarlandColors.budEdge.withValues(alpha: GarlandColors.budEdge.a * alpha),
    );
    canvas.drawCircle(p, 2.2 * scale, Paint()..color = GarlandColors.budEdge.withValues(alpha: GarlandColors.budEdge.a * alpha));
  }

  void _bloom(Canvas canvas, Offset c, double r, double alpha) {
    void ring(int count, double radius, double petal, Color color, double offset) {
      final paint = Paint()..color = color.withValues(alpha: alpha);
      for (var i = 0; i < count; i++) {
        final a = i / count * 2 * math.pi + offset;
        canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * radius, petal, paint);
      }
    }

    ring(12, r * 0.72, r * 0.3, GarlandColors.petal, 0);
    ring(9, r * 0.44, r * 0.27, GarlandColors.petalLight, 0.2);
    canvas.drawCircle(c, r * 0.3, Paint()..color = GarlandColors.heart.withValues(alpha: alpha));
  }

  @override
  bool shouldRepaint(_ToranPainter o) => o.flowers != flowers || o.opened != opened || o.scale != scale;
}

/// A task's tick in a checklist: an empty ring, a ring that fills with
/// marigold as the task gets done (1 of 2 walks), and a full marigold when
/// it's done. The flower opens over 250 ms (instant with reduce motion).
class TaskTick extends StatelessWidget {
  const TaskTick({super.key, required this.done, required this.goal, this.size = IconSizes.xl});
  final num done;
  final num goal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final paw = context.paw;
    final f = goal <= 0 ? 0.0 : (done / goal).clamp(0.0, 1.0).toDouble();
    return Semantics(
      label: f >= 1 ? context.l10n.done : null,
      child: SizedBox.square(
        dimension: size,
        child: AnimatedSwitcher(
          duration: context.reduceMotion ? Duration.zero : Motion.enter,
          switchInCurve: Motion.emphasized,
          transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
          child: f >= 1
              ? Marigold(key: const ValueKey('done'), size: size)
              : CustomPaint(key: const ValueKey('ring'), size: Size.square(size), painter: _TickRingPainter(f, paw.controlBorder.withValues(alpha: Opacities.half), paw.marigold)),
        ),
      ),
    );
  }
}

class _TickRingPainter extends CustomPainter {
  _TickRingPainter(this.f, this.track, this.fill);
  final double f;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.0875;
    final r = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width * 0.375);
    canvas.drawCircle(r.center, r.width / 2, Paint()..style = PaintingStyle.stroke..strokeWidth = w..color = track);
    if (f > 0) {
      canvas.drawArc(r, -math.pi / 2, f * 2 * math.pi, false, Paint()..style = PaintingStyle.stroke..strokeWidth = w..strokeCap = StrokeCap.round..color = fill);
    }
  }

  @override
  bool shouldRepaint(_TickRingPainter o) => o.f != f || o.track != track || o.fill != fill;
}

/// One marigold, for "done" ticks, a full week and celebrations.
class Marigold extends StatelessWidget {
  const Marigold({super.key, this.size = IconSizes.xl});
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _MarigoldPainter());
}

class _MarigoldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 * 0.95;
    void ring(int count, double radius, double petal, Color color, double offset) {
      final paint = Paint()..color = color;
      for (var i = 0; i < count; i++) {
        final a = i / count * 2 * math.pi + offset;
        canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * radius, petal, paint);
      }
    }

    ring(12, r * 0.72, r * 0.3, GarlandColors.petal, 0);
    ring(9, r * 0.44, r * 0.27, GarlandColors.petalLight, 0.2);
    canvas.drawCircle(c, r * 0.3, Paint()..color = GarlandColors.heart);
  }

  @override
  bool shouldRepaint(_MarigoldPainter o) => false;
}

/// Widget previews (Flutter widget previewer): the band in light and dark,
/// half done, all done, and with nothing planned.
@Preview(name: 'Toran band, 2 of 4 done', group: 'UI Design 6', size: Size(390, 220))
Widget gendaBandHalf() => _PreviewFrame(brightness: Brightness.light, child: _sample(done: 2, total: 4));

@Preview(name: 'Toran band, dark, all done', group: 'UI Design 6', size: Size(390, 220))
Widget gendaBandDone() => _PreviewFrame(brightness: Brightness.dark, child: _sample(done: 5, total: 5));

@Preview(name: 'Toran band, nothing planned, Telugu', group: 'UI Design 6', size: Size(390, 240))
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
