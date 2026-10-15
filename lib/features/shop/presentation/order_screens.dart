import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'invoice.dart';
import 'product_screen.dart';
import 'product_widgets.dart';
import 'shop_labels.dart';

/// My orders and auto-reorder subscriptions.
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key, this.tab = 0});
  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      initialIndex: tab,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.ordMyOrders),
          actions: const [CartButton()],
          bottom: TabBar(tabs: [Tab(text: l.ordTabOrders), Tab(text: l.subsTab)]),
        ),
        body: TabBarView(children: [
          AsyncView<List<ShopOrder>>(
            value: ref.watch(myOrdersProvider),
            data: (orders) => orders.isEmpty
                ? EmptyState(scene: Scene.shop, title: l.ordNone, actionLabel: l.cartStartShopping, onAction: () => context.go('/shop'))
                : PageBody(maxWidth: 820, children: [
                    const SizedBox(height: Space.md),
                    for (final o in orders) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: OrderCard(order: o)),
                  ]),
          ),
          const _Subscriptions(),
        ]),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.sellerView = false});
  final ShopOrder order;
  final bool sellerView;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = order;
    final s = orderStatusInfo(context, o.status);
    final first = o.items.isEmpty ? null : o.items.first;
    return PawCard(
      onTap: () => context.push(sellerView ? '/partner/order/${o.id}' : '/shop/orders/${o.id}'),
      child: Row(children: [
        if (first != null) ProductArt(category: first.category, seed: first.imageSeed, size: 56, radius: 12),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.items.length > 1 ? l.ordItemsMore(first?.name ?? '', o.items.length - 1) : (first?.name ?? ''), style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text(
              [
                shortOrderNo(o.id),
                if (sellerView) o.ownerName,
                Fmt.date(o.createdAt, context.lang),
                Fmt.inr(sellerView ? o.subtotal : o.total),
              ].join(' · '),
              style: context.text.bodySmall,
            ),
            if (o.isOpen && o.expectedBy != null && !sellerView)
              Text(l.ordArrivingBy(Fmt.weekdayDate(o.expectedBy!, context.lang)), style: context.text.bodySmall?.copyWith(color: context.colors.primary)),
            const SizedBox(height: 4),
            StatusChip(s.$1, tone: s.$2),
          ]),
        ),
      ]),
    );
  }
}

class _Subscriptions extends ConsumerWidget {
  const _Subscriptions();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final products = ref.watch(productMapProvider);
    return AsyncView<List<Subscription>>(
      value: ref.watch(mySubscriptionsProvider),
      data: (subs) => subs.isEmpty
          ? EmptyState(title: l.subsNone, message: l.subsNoneBody, actionLabel: l.cartStartShopping, onAction: () => context.go('/shop/search?cat=food'))
          : PageBody(maxWidth: 820, children: [
              const SizedBox(height: Space.md),
              for (final s in subs)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: PawCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        ProductArt(category: products[s.productId]?.category ?? 'food', seed: products[s.productId]?.imageSeed ?? 0, size: 56, radius: 12),
                        const SizedBox(width: Space.md),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(s.productName, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text('${l.subsWeeks(s.everyWeeks)} · ${l.shopQtyShort(s.qty)}', style: context.text.bodySmall),
                            Text(s.active ? l.subsNext(Fmt.weekdayDate(s.nextAt, context.lang)) : l.subsPaused, style: context.text.bodySmall?.copyWith(color: s.active ? context.colors.primary : context.paw.warning)),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: Space.sm),
                      Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
                        for (final w in subscriptionWeeks)
                          ChoiceChip(
                            label: Text(l.subsWeeks(w)),
                            selected: s.everyWeeks == w,
                            onSelected: (_) => ref.read(orderRepositoryProvider).updateSubscription(s.id, {'everyWeeks': w, 'nextAt': nextSubscriptionDate(DateTime.now(), w)}),
                          ),
                      ]),
                      const SizedBox(height: Space.xs),
                      Row(children: [
                        TextButton.icon(
                          onPressed: () => ref.read(orderRepositoryProvider).updateSubscription(s.id, {'active': !s.active}),
                          icon: Icon(s.active ? Icons.pause_rounded : Icons.play_arrow_rounded),
                          label: Text(s.active ? l.subsPause : l.subsResume),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final ok = await confirmAction(context, title: l.subsCancelQ, body: s.productName, confirmLabel: l.subsCancel);
                            if (ok) await ref.read(orderRepositoryProvider).deleteSubscription(s.id);
                          },
                          icon: const Icon(Icons.close_rounded),
                          label: Text(l.subsCancel),
                        ),
                      ]),
                    ]),
                  ),
                ),
            ]),
    );
  }
}

/// After checkout: the orders in the group (one per seller).
class OrderPlacedScreen extends ConsumerWidget {
  const OrderPlacedScreen({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final orders = ref.watch(orderGroupProvider(groupId)).value ?? const <ShopOrder>[];
    final pending = orders.any((o) => o.paymentStatus == 'pending');
    return Scaffold(
      appBar: AppBar(title: Text(l.ordPlacedTitle), automaticallyImplyLeading: false, actions: [IconButton(tooltip: l.close, onPressed: () => context.go('/shop'), icon: const Icon(Icons.close_rounded))]),
      body: PageBody(maxWidth: 720, children: [
        const SizedBox(height: Space.lg),
        const Center(child: Illustration(Scene.success, size: 140)),
        const SizedBox(height: Space.md),
        Text(l.ordPlacedHeading, style: context.text.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: Space.xs),
        Text(orders.length > 1 ? l.ordPlacedSplit(orders.length) : l.ordPlacedBody, style: context.text.bodyMedium, textAlign: TextAlign.center),
        if (pending) ...[const SizedBox(height: Space.md), InfoNote(l.payPendingNote, tone: ChipTone.warning)],
        const SizedBox(height: Space.lg),
        for (final o in orders) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: OrderCard(order: o)),
        const SizedBox(height: Space.md),
        PrimaryButton(label: l.ordTrack, onPressed: orders.isEmpty ? null : () => context.pushReplacement('/shop/orders/${orders.first.id}')),
        const SizedBox(height: Space.sm),
        SecondaryButton(label: l.ordContinueShopping, onPressed: () => context.go('/shop')),
      ]),
    );
  }
}

/// Order tracking timeline, items, address, bill, invoice, cancel / return,
/// review and help.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.ordDetail)),
      body: AsyncView<ShopOrder?>(
        value: ref.watch(orderProvider(orderId)),
        data: (o) => o == null ? EmptyState(title: l.ordNotFound) : _body(context, ref, o),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, ShopOrder o) {
    final l = context.l10n;
    final now = DateTime.now();
    final products = ref.watch(productMapProvider);
    final s = orderStatusInfo(context, o.status);
    final reviewed = (o.raw['reviewed'] as Map?) ?? const {};
    return PageBody(maxWidth: 820, children: [
      const SizedBox(height: Space.md),
      Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.ordNumber(shortOrderNo(o.id)), style: context.text.titleMedium),
            Text(l.ordPlacedOn(Fmt.dateTime(o.createdAt, context.lang)), style: context.text.bodySmall),
            Text(l.cartSoldBy(o.sellerName), style: context.text.bodySmall),
          ]),
        ),
        StatusChip(s.$1, tone: s.$2, icon: s.$3),
      ]),
      if (o.paymentStatus == 'pending') ...[
        const SizedBox(height: Space.md),
        PawCard(
          borderColor: context.paw.warning,
          child: Row(children: [
            Icon(Icons.hourglass_top_rounded, color: context.paw.warning),
            const SizedBox(width: Space.md),
            Expanded(child: Text(l.payPendingNote)),
            TextButton(
              onPressed: () async {
                final r = await ref.read(paymentServiceProvider).pay(context, amount: o.total, description: l.ordNumber(shortOrderNo(o.id)));
                if (r == PaymentOutcome.success) await ref.read(orderRepositoryProvider).markPaid(o);
              },
              child: Text(l.payNow),
            ),
          ]),
        ),
      ],
      SectionHeader(l.ordTracking),
      OrderTimeline(order: o),
      SectionHeader(l.ordItems(o.itemCount)),
      for (final i in o.items)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            padding: const EdgeInsets.all(Space.sm),
            onTap: () => context.push('/shop/product/${i.productId}'),
            child: Row(children: [
              ProductArt(category: i.category, seed: i.imageSeed, size: 56, radius: 12),
              const SizedBox(width: Space.sm),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(i.name, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text('${l.shopQtyShort(i.qty)} · ${Fmt.inr(i.amount)}', style: context.text.bodySmall),
                ]),
              ),
              if (o.status == 'delivered' && reviewed[i.productId] != true && products[i.productId] != null)
                TextButton(onPressed: () => writeProductReview(context, ref, products[i.productId]!, o.id), child: Text(l.shopRate)),
            ]),
          ),
        ),
      SectionHeader(l.cartDeliverTo),
      PawCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${o.address['name'] ?? ''} · ${o.address['phone'] ?? ''}', style: context.text.titleSmall),
          Text(Address.fromMap(o.address).oneLine),
          if (o.slotDate != null && o.slotWindow != null) ...[
            const SizedBox(height: Space.xs),
            Text(l.ordSlot(Fmt.weekdayDate(o.slotDate!, context.lang), windowLabel(context, o.slotWindow!)), style: context.text.bodySmall),
          ],
          if (o.petName.isNotEmpty) Text(l.ordForPet(o.petName), style: context.text.bodySmall),
        ]),
      ),
      SectionHeader(l.cartBill),
      PawCard(
        child: Column(children: [
          _line(context, l.shopItemsTotal, Fmt.inr(o.subtotal)),
          if (o.discount > 0) _line(context, l.cartCouponDiscountCode(o.coupon ?? ''), '− ${Fmt.inr(o.discount)}', color: context.paw.success),
          _line(context, l.shopDeliveryFee, o.deliveryFee == 0 ? l.shopFree : Fmt.inr(o.deliveryFee)),
          const Divider(),
          _line(context, l.ordTotal, Fmt.inr(o.total), bold: true),
          _line(context, l.ordPayment, paymentLabel(context, o)),
        ]),
      ),
      const SizedBox(height: Space.lg),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        OutlinedButton.icon(onPressed: () => openInvoice(context, o), icon: const Icon(Icons.picture_as_pdf_rounded), label: Text(l.ordInvoice)),
        OutlinedButton.icon(
          onPressed: () async {
            final user = ref.read(currentUserProvider);
            if (user == null) return;
            for (final i in o.items) {
              await ref.read(shopRepositoryProvider).addToCart(user.uid, i.productId, qty: i.qty);
            }
            if (context.mounted) context.push('/shop/cart');
          },
          icon: const Icon(Icons.replay_rounded),
          label: Text(l.shopBuyAgain),
        ),
        if (canCancel(o))
          OutlinedButton.icon(onPressed: () => _cancel(context, ref, o), icon: const Icon(Icons.cancel_outlined), label: Text(l.ordCancel)),
        if (canReturn(o, now))
          OutlinedButton.icon(onPressed: () => _return(context, ref, o), icon: const Icon(Icons.assignment_return_rounded), label: Text(l.ordReturn)),
        OutlinedButton.icon(onPressed: () => context.push('/me/help/new?order=${o.id}'), icon: const Icon(Icons.support_agent_rounded), label: Text(l.ordHelp)),
      ]),
      if (o.status == 'delivered' && !canReturn(o, now) && o.items.any((i) => i.returnable))
        Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.ordReturnWindowOver(returnWindowDays), style: context.text.bodySmall)),
    ]);
  }

  Widget _line(BuildContext context, String a, String b, {Color? color, bool bold = false}) {
    final style = (bold ? context.text.titleSmall : context.text.bodyMedium)?.copyWith(color: color);
    return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Expanded(child: Text(a, style: style)), Text(b, style: style)]));
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, ShopOrder o) async {
    final l = context.l10n;
    final reason = await _reasonSheet(context, l.ordCancelTitle, [l.ordReasonChangedMind, l.ordReasonWrongItem, l.ordReasonTooLate, l.ordReasonOther], l.ordCancel);
    if (reason == null) return;
    await ref.read(orderRepositoryProvider).cancel(o, reason: reason);
    if (context.mounted) showToast(context, o.paymentStatus == 'paid' ? l.ordCancelledRefund : l.ordCancelledToast);
  }

  Future<void> _return(BuildContext context, WidgetRef ref, ShopOrder o) async {
    final l = context.l10n;
    final reason = await _reasonSheet(context, l.ordReturnTitle, [l.ordReasonDamaged, l.ordReasonWrongItem, l.ordReasonNotSuitable, l.ordReasonOther], l.ordReturn);
    if (reason == null) return;
    await ref.read(orderRepositoryProvider).requestReturn(o, reason: reason);
    if (context.mounted) showToast(context, l.ordReturnRequestedToast);
  }

  Future<String?> _reasonSheet(BuildContext context, String title, List<String> reasons, String action) {
    String? picked;
    return showPawSheet<String>(context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: ctx.text.titleMedium),
            const SizedBox(height: Space.sm),
            RadioGroup<String>(
              groupValue: picked,
              onChanged: (v) => setState(() => picked = v),
              child: Column(children: [for (final r in reasons) RadioListTile<String>(value: r, title: Text(r))]),
            ),
            const SizedBox(height: Space.sm),
            PrimaryButton(label: action, onPressed: picked == null ? null : () => Navigator.pop(ctx, picked)),
          ]);
        }));
  }
}

/// Placed → packed → shipped → out for delivery → delivered, with dates.
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.order});
  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final o = order;
    final l = context.l10n;
    final at = {for (final t in o.timeline) t.status: t.at};
    final special = ['cancelled', 'return_requested', 'returned', 'return_rejected'].contains(o.status);
    final steps = [
      for (final s in orderSteps)
        if (!(o.status == 'cancelled' && at[s] == null)) s,
      if (o.status == 'cancelled') 'cancelled',
      if (at.containsKey('return_requested')) 'return_requested',
      if (o.status == 'returned' || o.status == 'return_rejected') o.status,
    ];
    final current = special ? steps.length - 1 : stepIndex(o.status);
    return PawCard(
      child: Column(children: [
        for (var i = 0; i < steps.length; i++)
          _Step(
            label: orderStatusInfo(context, steps[i]).$1,
            when: at[steps[i]] == null
                ? (steps[i] == 'delivered' && o.isOpen && o.expectedBy != null ? l.ordExpected(Fmt.weekdayDate(o.expectedBy!, context.lang)) : null)
                : Fmt.dateTime(at[steps[i]]!, context.lang),
            done: i <= current && at[steps[i]] != null,
            current: i == current,
            last: i == steps.length - 1,
            error: steps[i] == 'cancelled' || steps[i] == 'return_rejected',
          ),
        if (o.cancelReason != null || o.returnReason != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l.ordReason(o.cancelReason ?? o.returnReason!), style: context.text.bodySmall),
          ),
      ]),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.label, this.when, required this.done, required this.current, required this.last, this.error = false});
  final String label;
  final String? when;
  final bool done;
  final bool current;
  final bool last;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final color = error ? context.paw.error : (done ? context.colors.primary : context.paw.outline);
    return Semantics(
      label: [label, ?when, if (done) context.l10n.ordStepDone].join(', '),
      excludeSemantics: true,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 28,
            child: Column(children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(shape: BoxShape.circle, color: done ? color : Colors.transparent, border: Border.all(color: color, width: 2)),
                child: done ? Icon(error ? Icons.close_rounded : Icons.check_rounded, size: 14, color: Colors.white) : null,
              ),
              if (!last) Expanded(child: Container(width: 2, color: done ? color : context.paw.outline)),
            ]),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : Space.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: (current ? context.text.titleSmall : context.text.bodyMedium)?.copyWith(color: done || current ? null : context.paw.textSecondary)),
                if (when != null) Text(when!, style: context.text.bodySmall),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
