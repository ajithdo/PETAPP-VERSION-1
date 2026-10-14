import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      await ref.read(authServiceProvider).sendPasswordReset(_email.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) showToast(context, authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AuthScaffold(
      showBack: true,
      title: l.resetTitle,
      subtitle: _sent ? null : l.resetSubtitle,
      children: _sent
          ? [
              const Center(child: Illustration(Scene.success, size: 140)),
              const SizedBox(height: Space.md),
              Text(l.resetSent(_email.text.trim()), textAlign: TextAlign.center, style: context.text.bodyLarge),
              if (ref.read(appConfigProvider).isDemo) ...[
                const SizedBox(height: Space.md),
                DemoBanner(l.demoOutboxNote),
              ],
              const SizedBox(height: Space.xl),
              PrimaryButton(label: l.backToSignIn, onPressed: () => Navigator.of(context).maybePop()),
            ]
          : [
              Form(
                key: _form,
                child: PawTextField(
                  label: l.email,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: (v) => validateEmail(context, v),
                  onSubmitted: (_) => _send(),
                ),
              ),
              PrimaryButton(label: l.sendResetLink, loading: _busy, onPressed: _send),
            ],
    );
  }
}
