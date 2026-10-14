import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final auth = ref.read(authServiceProvider);
    final cfg = ref.watch(appConfigProvider);
    return AuthScaffold(
      title: l.verifyTitle,
      subtitle: l.verifySubtitle(user?.email ?? ''),
      children: [
        const Center(child: Illustration(Scene.chat, size: 140)),
        const SizedBox(height: Space.lg),
        if (cfg.isStandalone) ...[
          DemoBanner(l.verifyDemoNote),
          const SizedBox(height: Space.md),
          PrimaryButton(
            label: l.openDemoEmail,
            loading: _busy,
            onPressed: () async {
              setState(() => _busy = true);
              await auth.sendEmailVerification();
              if (mounted) setState(() => _busy = false);
            },
          ),
        ] else ...[
          PrimaryButton(
            label: l.iveVerified,
            loading: _busy,
            onPressed: () async {
              setState(() => _busy = true);
              await auth.refresh();
              if (mounted) setState(() => _busy = false);
            },
          ),
          const SizedBox(height: Space.sm),
          SecondaryButton(
            label: l.resendEmail,
            onPressed: () async {
              await auth.sendEmailVerification();
              if (context.mounted) showToast(context, l.emailResent);
            },
          ),
        ],
        const SizedBox(height: Space.md),
        TextButton(onPressed: auth.signOut, child: Text(l.signOut)),
      ],
    );
  }
}
