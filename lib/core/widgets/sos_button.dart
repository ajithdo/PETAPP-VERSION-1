import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_controller.dart';
import '../theme/tokens.dart';
import 'layout.dart';

/// SOS button (spec 7.12): hold for 2 seconds while it fills.
/// A quick tap shows "Hold to activate". In Easy mode a tap opens a simple
/// confirm dialog instead.
class SosButton extends ConsumerStatefulWidget {
  const SosButton({super.key, required this.onActivate, this.large = false});
  final VoidCallback onActivate;
  final bool large;

  @override
  ConsumerState<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends ConsumerState<SosButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        _c.reset();
        widget.onActivate();
      }
    });
  Timer? _tick;

  @override
  void dispose() {
    _tick?.cancel();
    _c.dispose();
    super.dispose();
  }

  void _down() {
    HapticFeedback.mediumImpact();
    _c.forward(from: 0);
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(milliseconds: 500), (_) => HapticFeedback.selectionClick());
  }

  void _up() {
    _tick?.cancel();
    if (_c.isAnimating && _c.value < 1) {
      final wasQuick = _c.value < 0.25;
      _c.reverse();
      if (wasQuick && !ref.read(settingsProvider).easyMode) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(context.l10n.sosHoldHint), duration: const Duration(seconds: 2)));
      }
    }
  }

  Future<void> _easyTap() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.sosConfirmTitle),
        content: Text(ctx.l10n.sosConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ctx.paw.sos, foregroundColor: ctx.paw.onSos, iconColor: ctx.paw.onSos),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.sosGetHelp),
          ),
        ],
      ),
    );
    if (ok == true) widget.onActivate();
  }

  @override
  Widget build(BuildContext context) {
    final easy = ref.watch(settingsProvider).easyMode;
    final paw = context.paw;
    final visual = widget.large ? _circle(paw) : _pill(context, paw, easy);
    return Semantics(
      button: true,
      label: context.l10n.sosSemantic,
      hint: easy ? null : context.l10n.sosHoldHint,
      // Screen readers activate directly (a hold isn't possible); Easy mode
      // still asks first.
      onTap: easy ? _easyTap : widget.onActivate,
      child: GestureDetector(
        onTapDown: easy ? null : (_) => _down(),
        onTapUp: easy ? null : (_) => _up(),
        onTapCancel: easy ? null : _up,
        onTap: easy ? _easyTap : null,
        child: visual,
      ),
    );
  }

  /// Design 2 top-bar SOS: a soft red pill that fills while held.
  Widget _pill(BuildContext context, PawColors paw, bool easy) {
    // The pill is 8 px shorter than the tap area around it.
    final target = easy ? TapTarget.easy : TapTarget.min;
    final radius = BorderRadius.circular(Radii.full);
    final pill = Container(
      height: target - Space.sm,
      decoration: BoxDecoration(
        color: paw.sosContainer,
        borderRadius: radius,
        border: Border.all(color: paw.sosBorder),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(alignment: Alignment.center, children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: AnimatedBuilder(
                animation: _c,
                builder: (_, _) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _c.value,
                  child: ColoredBox(color: paw.sos.withValues(alpha: Opacities.tintStrong)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.md + Space.xxs),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.emergency_outlined, size: IconSizes.sm, color: paw.onSosContainer),
              const SizedBox(width: Space.xs + Space.xxs),
              Text(
                'SOS',
                style: context.text.labelLarge?.copyWith(
                  color: paw.onSosContainer,
                  fontWeight: FontWeight.w800,
                  fontFamily: FontFamilies.heading,
                  letterSpacing: Tracking.wide,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
    return SizedBox(height: target, child: Center(widthFactor: 1, child: pill));
  }

  /// Big round SOS (SOS screen): solid red with a ring that fills while held.
  Widget _circle(PawColors paw) {
    const size = TapTarget.easy + Space.lg;
    const ringGap = Space.xs + Space.xxs;
    return SizedBox(
      width: size + ringGap,
      height: size + ringGap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ExcludeSemantics(
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, _) => SizedBox(
                width: size + ringGap,
                height: size + ringGap,
                child: CircularProgressIndicator(
                  value: _c.value,
                  strokeWidth: Strokes.ring,
                  color: paw.sos,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
          Container(
            width: size - 4,
            height: size - 4,
            decoration: BoxDecoration(color: paw.sos, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              'SOS',
              style: TextStyle(
                color: paw.onSos,
                fontWeight: FontWeight.w800,
                fontSize: TypeScale.title.size,
                fontFamily: FontFamilies.heading,
                letterSpacing: Tracking.wide,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
