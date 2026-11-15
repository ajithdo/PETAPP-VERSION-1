import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';
import '../../onboarding/presentation/welcome_screen.dart';
import 'demo_login_screen.dart';
import '../../../core/theme/ph.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _hide = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _social(Future<void> Function() action, String provider) async {
    final cfg = ref.read(appConfigProvider);
    if (cfg.isStandalone) {
      await showDemoDialog(context,
          title: context.l10n.demoTitle, body: context.l10n.demoSocialBody(provider));
    }
    await _run(action);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = ref.read(authServiceProvider);
    final cfg = ref.watch(appConfigProvider);
    return AuthScaffold(
      title: l.signInTitle,
      subtitle: l.signInSubtitle,
      trailing: const LanguageMenu(),
      // UI Design 6: the form first, the demo accounts on a marigold panel
      // under it (beside it on desktop).
      below: cfg.isDemo ? const DemoAccountList(minItemWidth: 250, embedded: true) : null,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(children: [
              PawTextField(
                label: l.email,
                labelInside: true,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofill: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: (v) => validateEmail(context, v),
                prefixIcon: Ph.envelopeSimple,
              ),
              PawTextField(
                label: l.password,
                labelInside: true,
                controller: _password,
                obscure: _hide,
                autofill: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                prefixIcon: Ph.lockKey,
                validator: (v) => (v == null || v.isEmpty) ? l.fieldRequired : null,
                onSubmitted: (_) => _submit(auth),
                suffix: IconButton(
                  tooltip: _hide ? l.showPassword : l.hidePassword,
                  icon: Icon(_hide ? Ph.eye : Ph.eyeSlash, size: IconSizes.md, color: context.paw.textPrimary),
                  onPressed: () => setState(() => _hide = !_hide),
                ),
              ),
            ]),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(child: TextLink(l.forgotPassword, onTap: () => context.push('/forgot'))),
          const SizedBox(width: Space.md),
          Flexible(child: TextLink(l.createAccount, onTap: () => context.push('/signup'))),
        ]),
        const SizedBox(height: Space.md),
        if (_error != null) ...[
          InfoNote(_error!, icon: Ph.warningCircle, tone: ChipTone.error),
          const SizedBox(height: Space.md),
        ],
        PawButton(label: l.signIn, icon: Ph.signIn, kind: BtnKind.ink, size: BtnSize.regular, block: true, onPressed: _busy ? null : () => _submit(auth)),
        const SizedBox(height: Space.md),
        const OrDivider(),
        const SizedBox(height: Space.md),
        SocialButtons(
          busy: _busy,
          onGoogle: () => _social(auth.signInWithGoogle, 'Google'),
          onApple: () => _social(auth.signInWithApple, 'Apple'),
          onPhone: () => context.push('/phone'),
        ),
        const SizedBox(height: Space.md),
        Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.xs, children: [
          Text(l.partnerAsk, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
          TextLink(l.partnerApply, onTap: () => context.push('/partner-signup')),
        ]),
      ],
    );
  }

  void _submit(dynamic auth) {
    if (!(_form.currentState?.validate() ?? false)) return;
    _run(() => auth.signInWithEmail(_email.text, _password.text));
  }
}
