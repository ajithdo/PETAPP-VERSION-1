import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _hide = true;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).signUpWithEmail(_name.text.trim(), _email.text, _password.text);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthScaffold(
      showBack: true,
      title: l.signUpTitle,
      subtitle: l.signUpSubtitle,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(children: [
              PawTextField(
                label: l.yourName,
                controller: _name,
                autofill: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
              ),
              PawTextField(
                label: l.email,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofill: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.mail_outline_rounded,
                validator: (v) => validateEmail(context, v),
              ),
              PawTextField(
                label: l.password,
                controller: _password,
                obscure: _hide,
                helper: l.passwordHelper,
                autofill: const [AutofillHints.newPassword],
                prefixIcon: Icons.lock_outline_rounded,
                onSubmitted: (_) => _submit(),
                validator: (v) => (v == null || v.length < 6) ? l.authErrWeakPassword : null,
                suffix: IconButton(
                  tooltip: _hide ? l.showPassword : l.hidePassword,
                  icon: Icon(_hide ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                  onPressed: () => setState(() => _hide = !_hide),
                ),
              ),
            ]),
          ),
        ),
        if (_error != null) ...[
          InfoNote(_error!, icon: Icons.error_outline_rounded, tone: ChipTone.error),
          const SizedBox(height: Space.md),
        ],
        PrimaryButton(label: l.createAccount, loading: _busy, onPressed: _submit),
        const SizedBox(height: Space.md),
        Text(l.termsNote, style: context.text.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
