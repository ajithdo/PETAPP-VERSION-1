import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../data/vault_lock.dart';
import '../domain/pin_hash.dart';

/// Wraps every vault screen: asks for fingerprint/face on Android and iOS,
/// or the vault PIN (web and as a fallback); first time, the owner chooses
/// a PIN. Any touch inside the vault keeps it unlocked; it locks itself
/// after 2 minutes away (spec 7.9).
class VaultGate extends ConsumerWidget {
  const VaultGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(vaultLockProvider);
    final notifier = ref.read(vaultLockProvider.notifier);
    if (lock.unlocked) {
      return Listener(behavior: HitTestBehavior.translucent, onPointerDown: (_) => notifier.touch(), child: child);
    }
    if (!notifier.hasPin) return const _SetupPinScreen();
    return const _LockScreen();
  }
}

class _GateFrame extends StatelessWidget {
  const _GateFrame({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.documentVault)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.gutter),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(mainAxisSize: MainAxisSize.min, children: children),
            ),
          ),
        ),
      ),
    );
  }
}

class _LockScreen extends ConsumerStatefulWidget {
  const _LockScreen();
  @override
  ConsumerState<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<_LockScreen> {
  String? _error;
  bool _bioTried = false;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoBiometric());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && ref.read(vaultLockProvider).lockedOutUntil != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _autoBiometric() async {
    if (_bioTried || !mounted) return;
    _bioTried = true;
    final notifier = ref.read(vaultLockProvider.notifier);
    if (!notifier.biometricsOn) return;
    if (await ref.read(biometricAvailableProvider.future)) await _biometric();
  }

  Future<void> _biometric() async {
    final ok = await ref.read(biometricAuthProvider).authenticate(context.l10n.vaultBiometricReason);
    if (ok) ref.read(vaultLockProvider.notifier).unlock();
  }

  Future<void> _forgot() async {
    final l = context.l10n;
    final ok = await confirmAction(context, title: l.vaultForgotPinTitle, body: l.vaultForgotPinBody, confirmLabel: l.vaultSignInAgain, danger: false);
    if (!ok) return;
    ref.read(vaultLockProvider.notifier).resetPin();
    await ref.read(authServiceProvider).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(vaultLockProvider);
    final now = DateTime.now();
    final lockedOut = state.lockedOut(now);
    final bio = ref.watch(biometricAvailableProvider).value ?? false;
    final bioOn = ref.read(vaultLockProvider.notifier).biometricsOn;
    String? message = _error;
    if (lockedOut) message = l.vaultLockedOut(state.lockedOutUntil!.difference(now).inSeconds + 1);
    return _GateFrame(children: [
      const Illustration(Scene.vault, size: 110),
      const SizedBox(height: Space.md),
      Semantics(header: true, child: Text(l.vaultLockedTitle, style: context.text.titleLarge, textAlign: TextAlign.center)),
      const SizedBox(height: Space.xs),
      Text(l.vaultLockedBody, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: Space.lg),
      PinPad(
        enabled: !lockedOut,
        submitLabel: l.vaultUnlock,
        error: message,
        onSubmit: (pin) async {
          final ok = ref.read(vaultLockProvider.notifier).tryPin(pin);
          if (!ok && mounted) {
            HapticFeedback.heavyImpact();
            final left = vaultMaxWrongPins - ref.read(vaultLockProvider).wrongPins;
            setState(() => _error = ref.read(vaultLockProvider).lockedOut(DateTime.now()) ? null : '${l.vaultWrongPin} ${l.vaultTriesLeft(left)}');
          }
          return ok;
        },
      ),
      if (bio && bioOn) ...[
        const SizedBox(height: Space.md),
        SecondaryButton(label: l.vaultUseBiometrics, icon: Icons.fingerprint_rounded, onPressed: _biometric),
      ],
      const SizedBox(height: Space.sm),
      TextButton(onPressed: _forgot, child: Text(l.vaultForgotPin)),
      const SizedBox(height: Space.sm),
      Text(l.vaultAutoLockNote, style: context.text.bodySmall, textAlign: TextAlign.center),
    ]);
  }
}

class _SetupPinScreen extends ConsumerStatefulWidget {
  const _SetupPinScreen();
  @override
  ConsumerState<_SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends ConsumerState<_SetupPinScreen> {
  String? _first;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final bio = ref.watch(biometricAvailableProvider).value ?? false;
    final notifier = ref.read(vaultLockProvider.notifier);
    return _GateFrame(children: [
      const Illustration(Scene.vault, size: 110),
      const SizedBox(height: Space.md),
      Semantics(header: true, child: Text(l.vaultSetupTitle, style: context.text.titleLarge, textAlign: TextAlign.center)),
      const SizedBox(height: Space.xs),
      Text(bio ? l.vaultSetupBodyBio : l.vaultSetupBody,
          style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: Space.lg),
      Text(_first == null ? l.vaultChoosePin : l.vaultConfirmPin, style: context.text.titleSmall),
      const SizedBox(height: Space.sm),
      PinPad(
        key: ValueKey(_first == null),
        submitLabel: _first == null ? l.next : l.vaultSetPinButton,
        error: _error,
        onSubmit: (pin) async {
          if (_first == null) {
            if (isWeakPin(pin)) {
              setState(() => _error = l.vaultPinWeak);
              return false;
            }
            setState(() {
              _first = pin;
              _error = null;
            });
            return true;
          }
          if (pin != _first) {
            setState(() {
              _first = null;
              _error = l.vaultPinMismatch;
            });
            return false;
          }
          notifier.setPin(pin);
          if (context.mounted) showToast(context, l.vaultPinSet);
          return true;
        },
      ),
      if (bio) ...[
        const SizedBox(height: Space.md),
        SwitchListTile(
          value: notifier.biometricsOn,
          onChanged: (v) => setState(() => notifier.setBiometrics(v)),
          title: Text(l.vaultBiometricsToggle),
          secondary: const Icon(Icons.fingerprint_rounded),
        ),
      ],
      const SizedBox(height: Space.md),
      Text(l.vaultAutoLockNote, style: context.text.bodySmall, textAlign: TextAlign.center),
    ]);
  }
}

/// Number pad for 4–6 digit PINs. Also takes digits, Backspace and Enter
/// from a hardware keyboard (web and desktop).
class PinPad extends StatefulWidget {
  const PinPad({super.key, required this.onSubmit, required this.submitLabel, this.error, this.enabled = true, this.maxLength = 6});

  /// Returns true when the PIN was accepted (the pad then stays as is) or
  /// false to clear it.
  final Future<bool> Function(String pin) onSubmit;
  final String submitLabel;
  final String? error;
  final bool enabled;
  final int maxLength;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _pin = '';
  bool _busy = false;
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _add(String d) {
    if (!widget.enabled || _busy || _pin.length >= widget.maxLength) return;
    HapticFeedback.selectionClick();
    setState(() => _pin += d);
  }

  void _back() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    if (!widget.enabled || _busy || _pin.length < 4) return;
    setState(() => _busy = true);
    final ok = await widget.onSubmit(_pin);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _pin = '';
    });
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final ch = e.character;
    if (ch != null && RegExp(r'^\d$').hasMatch(ch)) {
      _add(ch);
      return KeyEventResult.handled;
    }
    if (e.logicalKey == LogicalKeyboardKey.backspace) {
      _back();
      return KeyEventResult.handled;
    }
    if (e.logicalKey == LogicalKeyboardKey.enter || e.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget key(String d) => _PadKey(label: d, semantic: d, onTap: () => _add(d), enabled: widget.enabled);
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Semantics(
          label: l.vaultPinDigits(_pin.length),
          liveRegion: true,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < widget.maxLength; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 7),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _pin.length ? context.colors.primary : Colors.transparent,
                  border: Border.all(color: i < 4 || i < _pin.length ? context.colors.primary : context.paw.outline, width: 2),
                ),
              ),
          ]),
        ),
        SizedBox(
          height: 44,
          child: Center(
            child: widget.error == null
                ? null
                : Text(widget.error!, textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(color: context.paw.error)),
          ),
        ),
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [for (final d in row) key(d)]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(width: 80, height: 80),
          key('0'),
          _PadKey(icon: Icons.backspace_outlined, semantic: l.vaultPinBackspace, onTap: _back, enabled: widget.enabled),
        ]),
        const SizedBox(height: Space.md),
        PrimaryButton(
          label: widget.submitLabel,
          loading: _busy,
          onPressed: widget.enabled && _pin.length >= 4 ? _submit : null,
        ),
      ]),
    );
  }
}

class _PadKey extends StatelessWidget {
  const _PadKey({this.label, this.icon, required this.semantic, required this.onTap, this.enabled = true});
  final String? label;
  final IconData? icon;
  final String semantic;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bg = context.paw.surface;
    final fg = context.paw.textPrimary;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Semantics(
        button: true,
        enabled: enabled,
        label: semantic,
        excludeSemantics: true,
        child: Material(
          color: bg,
          shape: CircleBorder(side: BorderSide(color: context.paw.outline)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled ? onTap : null,
            child: SizedBox(
              width: 68,
              height: 68,
              child: Center(
                child: icon != null
                    ? Icon(icon, color: enabled ? fg : context.paw.textSecondary)
                    : Text(label!, style: context.text.headlineSmall?.copyWith(color: enabled ? fg : context.paw.textSecondary)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lock settings: lock now, change PIN, biometrics.
Future<void> showVaultLockSheet(BuildContext context, WidgetRef ref) {
  return showPawSheet<void>(context, builder: (ctx) {
    final l = ctx.l10n;
    final notifier = ref.read(vaultLockProvider.notifier);
    return StatefulBuilder(builder: (ctx, setState) {
      final bio = ref.watch(biometricAvailableProvider).value ?? false;
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.vaultLockSettings, style: ctx.text.titleMedium),
        const SizedBox(height: Space.sm),
        ListTile(
          leading: const Icon(Icons.lock_rounded),
          title: Text(l.vaultLockNow),
          onTap: () {
            Navigator.pop(ctx);
            notifier.lock();
          },
        ),
        ListTile(
          leading: const Icon(Icons.pin_rounded),
          title: Text(l.vaultChangePin),
          onTap: () {
            Navigator.pop(ctx);
            Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const _ChangePinScreen()));
          },
        ),
        if (bio)
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint_rounded),
            value: notifier.biometricsOn,
            title: Text(l.vaultBiometricsToggle),
            onChanged: (v) => setState(() => notifier.setBiometrics(v)),
          ),
        const SizedBox(height: Space.sm),
        InfoNote(l.vaultAutoLockNote, icon: Icons.timer_outlined),
      ]);
    });
  });
}

class _ChangePinScreen extends ConsumerStatefulWidget {
  const _ChangePinScreen();
  @override
  ConsumerState<_ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<_ChangePinScreen> {
  int _step = 0; // 0 current, 1 new, 2 confirm
  String? _new;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final notifier = ref.read(vaultLockProvider.notifier);
    final prompt = [l.vaultCurrentPin, l.vaultChoosePin, l.vaultConfirmPin][_step];
    return Scaffold(
      appBar: AppBar(title: Text(l.vaultChangePin)),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.gutter),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(children: [
              Text(prompt, style: context.text.titleMedium),
              const SizedBox(height: Space.md),
              PinPad(
                key: ValueKey(_step),
                submitLabel: _step == 2 ? l.save : l.next,
                error: _error,
                onSubmit: (pin) async {
                  if (_step == 0) {
                    if (!notifier.tryPin(pin)) {
                      setState(() => _error = l.vaultWrongPin);
                      return false;
                    }
                    setState(() {
                      _step = 1;
                      _error = null;
                    });
                  } else if (_step == 1) {
                    if (isWeakPin(pin)) {
                      setState(() => _error = l.vaultPinWeak);
                      return false;
                    }
                    setState(() {
                      _new = pin;
                      _step = 2;
                      _error = null;
                    });
                  } else {
                    if (pin != _new) {
                      setState(() {
                        _step = 1;
                        _error = l.vaultPinMismatch;
                      });
                      return false;
                    }
                    notifier.setPin(pin);
                    if (context.mounted) {
                      showToast(context, l.vaultPinChanged);
                      Navigator.pop(context);
                    }
                  }
                  return true;
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
