import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_controller.dart';
import '../theme/tokens.dart';
import 'layout.dart';

/// Red SOS button (spec 7.12): hold for 2 seconds while a ring fills.
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
            style: FilledButton.styleFrom(backgroundColor: ctx.paw.sos, foregroundColor: ctx.paw.onSos),
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
    final size = widget.large ? 72.0 : (easy ? 52.0 : 44.0);
    final paw = context.paw;
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
        child: SizedBox(
          width: size + 6,
          height: size + 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ExcludeSemantics(child: AnimatedBuilder(
                animation: _c,
                builder: (_, _) => SizedBox(
                  width: size + 6,
                  height: size + 6,
                  child: CircularProgressIndicator(
                    value: _c.value,
                    strokeWidth: 4,
                    color: paw.sos,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )),
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
                    fontSize: widget.large ? 20 : 13,
                    fontFamily: 'PlusJakartaSans',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
