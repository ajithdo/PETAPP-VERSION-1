import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';

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
      children: [
        if (cfg.isDemo) ...[
          PawCard(
            color: context.paw.accent.withValues(alpha: 0.16),
            onTap: () => context.push('/demo'),
            semanticLabel: l.exploreDemo,
            child: Row(children: [
              Icon(Icons.science_rounded, color: context.paw.textPrimary),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.exploreDemo, style: context.text.titleSmall),
                  Text(l.exploreDemoHint, style: context.text.bodySmall),
                ]),
              ),
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
          const SizedBox(height: Space.lg),
        ],
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(children: [
              PawTextField(
                label: l.email,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofill: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: (v) => validateEmail(context, v),
                prefixIcon: Icons.mail_outline_rounded,
              ),
              PawTextField(
                label: l.password,
                controller: _password,
                obscure: _hide,
                autofill: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outline_rounded,
                validator: (v) => (v == null || v.isEmpty) ? l.fieldRequired : null,
                onSubmitted: (_) => _submit(auth),
                suffix: IconButton(
                  tooltip: _hide ? l.showPassword : l.hidePassword,
                  icon: Icon(_hide ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                  onPressed: () => setState(() => _hide = !_hide),
                ),
              ),
            ]),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => context.push('/forgot'), child: Text(l.forgotPassword)),
        ),
        if (_error != null) ...[
          InfoNote(_error!, icon: Icons.error_outline_rounded, tone: ChipTone.error),
          const SizedBox(height: Space.md),
        ],
        PrimaryButton(label: l.signIn, loading: _busy, onPressed: () => _submit(auth)),
        const OrDivider(),
        SocialButtons(
          busy: _busy,
          onGoogle: () => _social(auth.signInWithGoogle, 'Google'),
          onApple: () => _social(auth.signInWithApple, 'Apple'),
          onPhone: () => context.push('/phone'),
        ),
        const SizedBox(height: Space.lg),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Flexible(child: Text(l.newHere, style: context.text.bodyMedium)),
          TextButton(onPressed: () => context.push('/signup'), child: Text(l.createAccount)),
        ]),
        Center(
          child: TextButton.icon(
            onPressed: () => context.push('/partner-signup'),
            icon: const Icon(Icons.storefront_rounded),
            label: Text(l.partnerSignupLink),
          ),
        ),
      ],
    );
  }

  void _submit(dynamic auth) {
    if (!(_form.currentState?.validate() ?? false)) return;
    _run(() => auth.signInWithEmail(_email.text, _password.text));
  }
}
