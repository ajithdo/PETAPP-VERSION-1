import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/demo/seed/seed_people.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'auth_widgets.dart';

/// Phone OTP sign-in, +91 by default.
class PhoneSignInScreen extends ConsumerStatefulWidget {
  const PhoneSignInScreen({super.key});
  @override
  ConsumerState<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends ConsumerState<PhoneSignInScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  String? _verificationId;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final digits = _phone.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      setState(() => _error = context.l10n.phoneInvalid);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await ref.read(authServiceProvider).startPhoneSignIn('+91$digits');
      if (!mounted) return;
      setState(() => _verificationId = id);
      if (ref.read(appConfigProvider).isDemo) {
        await showDemoDialog(context, title: context.l10n.demoTitle, body: context.l10n.demoOtpBody(demoOtp));
      }
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).confirmPhoneCode(_verificationId!, _code.text);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final codeStep = _verificationId != null;
    return AuthScaffold(
      showBack: true,
      title: codeStep ? l.enterCodeTitle : l.phoneTitle,
      subtitle: codeStep ? l.enterCodeSubtitle('+91 ${_phone.text}') : l.phoneSubtitle,
      children: [
        if (!codeStep)
          PawTextField(
            label: l.mobileNumber,
            controller: _phone,
            prefixText: '+91 ',
            keyboardType: TextInputType.phone,
            autofill: const [AutofillHints.telephoneNumberNational],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            onSubmitted: (_) => _sendCode(),
            autofocus: true,
          )
        else
          PawTextField(
            label: l.sixDigitCode,
            controller: _code,
            keyboardType: TextInputType.number,
            autofill: const [AutofillHints.oneTimeCode],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
            onSubmitted: (_) => _verify(),
            autofocus: true,
          ),
        if (_error != null) ...[
          InfoNote(_error!, icon: Icons.error_outline_rounded, tone: ChipTone.error),
          const SizedBox(height: Space.md),
        ],
        PrimaryButton(
          label: codeStep ? l.verifyAndContinue : l.sendCode,
          loading: _busy,
          onPressed: codeStep ? _verify : _sendCode,
        ),
        if (codeStep)
          TextButton(
            onPressed: _busy ? null : () => setState(() => _verificationId = null),
            child: Text(l.changeNumber),
          ),
      ],
    );
  }
}
