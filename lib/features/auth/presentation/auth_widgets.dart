import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/ph.dart';

/// The layout of the sign-in pages (UI Design 6): the mark and the language
/// switch on top, a big left-aligned title, the form, and [below] (the demo
/// accounts) under it. On desktop the form sits on the left and [below]
/// beside it.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.title, this.subtitle, required this.children, this.showBack = false, this.below, this.trailing});
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool showBack;

  /// Shown under the form, as wide as the page (e.g. the demo accounts).
  final Widget? below;

  /// Shown at the top right (e.g. the language switch).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final head = <Widget>[
      Semantics(header: true, child: Text(title, style: context.text.displaySmall)),
      if (subtitle != null) ...[
        const SizedBox(height: Space.sm),
        Text(subtitle!, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
      ],
      const SizedBox(height: Space.lg + Space.xs),
    ];
    final wide = below != null && context.screenSize == ScreenSize.desktop;
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter, context.gutter + Space.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: below != null ? Space.maxContentWidth : Sizes.authCard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    if (showBack) ...[
                      PawIconButton(icon: Ph.arrowLeft, tooltip: MaterialLocalizations.of(context).backButtonTooltip, onPressed: () => Navigator.maybePop(context)),
                      const SizedBox(width: Space.md),
                    ],
                    const PawSetuLogo(size: Sizes.topLogo, withName: true),
                    const Spacer(),
                    ?trailing,
                  ]),
                  const SizedBox(height: Space.xl),
                  if (wide)
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(flex: 5, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...head, ...children])),
                      const SizedBox(width: Space.xxl),
                      Expanded(flex: 7, child: below!),
                    ])
                  else ...[
                    ...head,
                    ...children,
                    if (below != null) ...[const SizedBox(height: Sizes.sectionGap), below!],
                  ],
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

/// Google, Apple and Phone sign-in as three soft buttons side by side.
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
    Widget b(String name, String say, IconData icon, VoidCallback on) =>
        PawButton(label: name, semanticLabel: say, icon: icon, kind: BtnKind.soft, size: BtnSize.regular, block: true, onPressed: busy ? null : on);
    final buttons = [
      b('Google', l.continueWithGoogle, Ph.googleLogo, onGoogle),
      if (showApple) b('Apple', l.continueWithApple, Ph.appleLogo, onApple),
      b(l.phone, l.continueWithPhone, Ph.deviceMobile, onPhone),
    ];
    // Side by side; one under another with big text.
    if (MediaQuery.textScalerOf(context).scale(1) > 1.15) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final (i, x) in buttons.indexed) ...[if (i > 0) const SizedBox(height: Space.sm), x],
      ]);
    }
    return Row(children: [
      for (final (i, x) in buttons.indexed) ...[if (i > 0) const SizedBox(width: Space.md), Expanded(child: x)],
    ]);
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider(height: Strokes.hairline)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.md),
        child: Text(context.l10n.orContinueWith, style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary)),
      ),
      const Expanded(child: Divider(height: Strokes.hairline)),
    ]);
  }
}
