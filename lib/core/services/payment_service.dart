import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../providers.dart';
import '../theme/tokens.dart';
import '../utils/format.dart';
import '../widgets/widgets.dart';

enum PaymentOutcome { success, failure, pending, cancelled }

/// Takes a payment. Demo shows a "Demo payment, no money is charged" sheet
/// with success, failure and pending outcomes. Version 2 (L2) adds
/// RazorpayPaymentService: orders created and signatures verified in
/// Cloud Functions.
abstract class PaymentService {
  Future<PaymentOutcome> pay(BuildContext context, {required int amount, required String description});
}

class DemoPaymentService implements PaymentService {
  @override
  Future<PaymentOutcome> pay(BuildContext context, {required int amount, required String description}) async {
    final r = await showPawSheet<PaymentOutcome>(context, builder: (ctx) {
      final l = ctx.l10n;
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Icons.payments_rounded, color: ctx.colors.primary, size: 32),
          const SizedBox(width: Space.md),
          Expanded(child: Text(l.demoPaymentTitle, style: ctx.text.titleMedium)),
        ]),
        const SizedBox(height: Space.md),
        DemoBanner(l.demoPaymentNote),
        const SizedBox(height: Space.lg),
        Text(description, style: ctx.text.bodyMedium),
        const SizedBox(height: Space.sm),
        Text(Fmt.inr(amount), style: ctx.text.displaySmall),
        const SizedBox(height: Space.lg),
        Text(l.demoPaymentChoose, style: ctx.text.bodySmall),
        const SizedBox(height: Space.sm),
        PrimaryButton(label: l.payUpiDemo, icon: Icons.check_circle_rounded, onPressed: () => Navigator.pop(ctx, PaymentOutcome.success)),
        const SizedBox(height: Space.sm),
        Row(children: [
          Expanded(child: SecondaryButton(label: l.simulateFailure, onPressed: () => Navigator.pop(ctx, PaymentOutcome.failure))),
          const SizedBox(width: Space.sm),
          Expanded(child: SecondaryButton(label: l.simulatePending, onPressed: () => Navigator.pop(ctx, PaymentOutcome.pending))),
        ]),
      ]);
    });
    return r ?? PaymentOutcome.cancelled;
  }
}

class LivePaymentService implements PaymentService {
  @override
  Future<PaymentOutcome> pay(BuildContext context, {required int amount, required String description}) async {
    await showDemoDialog(context, title: 'Razorpay', body: 'Live payments are switched on in Version 2 (L2).');
    return PaymentOutcome.cancelled;
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return cfg.serviceMode('payments') == AppMode.demo ? DemoPaymentService() : LivePaymentService();
});
