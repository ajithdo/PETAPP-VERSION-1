import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';

/// Centered single-column layout for auth screens, with the logo on top.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, this.subtitle, required this.children, this.showBack = false});
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBack ? AppBar() : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.gutter),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!showBack) const SizedBox(height: Space.lg),
                  const Center(child: PawSetuLogo(size: 56)),
                  const SizedBox(height: Space.lg),
                  Semantics(
                    header: true,
                    child: Text(title, style: context.text.headlineSmall, textAlign: TextAlign.center),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: Space.sm),
                    Text(subtitle!,
                        style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary),
                        textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: Space.xl),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String authErrorText(BuildContext context, Object e) {
  final l = context.l10n;
  final code = e is AuthFailure ? e.code : 'unknown';
  return switch (code) {
    'user-not-found' => l.authErrNoAccount,
    'wrong-password' => l.authErrWrongPassword,
    'email-in-use' => l.authErrEmailInUse,
    'weak-password' => l.authErrWeakPassword,
    'invalid-email' => l.authErrInvalidEmail,
    'invalid-code' => l.authErrInvalidCode,
    'network' => l.authErrNetwork,
    'cancelled' => l.authErrCancelled,
    _ => l.errorBody,
  };
}

String? validateEmail(BuildContext context, String? v) {
  if (v == null || v.trim().isEmpty) return context.l10n.fieldRequired;
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return context.l10n.authErrInvalidEmail;
  return null;
}

/// Google / phone / Apple sign-in buttons.
class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key, required this.onGoogle, required this.onPhone, required this.onApple, this.busy = false});
  final VoidCallback onGoogle;
  final VoidCallback onPhone;
  final VoidCallback onApple;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Apple sign-in is offered on iOS and the website (spec 5).
    final showApple = kIsWeb || defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;
    return Column(
      children: [
        SecondaryButton(label: l.continueWithGoogle, icon: Icons.g_mobiledata_rounded, onPressed: busy ? null : onGoogle),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: l.continueWithPhone, icon: Icons.phone_iphone_rounded, onPressed: busy ? null : onPhone),
        if (showApple) ...[
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.continueWithApple, icon: Icons.apple_rounded, onPressed: busy ? null : onApple),
        ],
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.lg),
      child: Row(children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          child: Text(context.l10n.or, style: context.text.bodySmall),
        ),
        const Expanded(child: Divider()),
      ]),
    );
  }
}
