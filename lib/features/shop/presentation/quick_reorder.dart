import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/domain/pet.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'address_screens.dart';
import 'product_widgets.dart';
import 'shop_labels.dart';

/// One-sheet reorder (Home "food running low" card and Buy again): the
/// saved address, the earliest delivery slot and pay on delivery are
/// filled in, so reordering is two taps: Reorder, then Place order.
Future<void> showQuickReorder(BuildContext context, WidgetRef ref, {required Product product, Pet? pet, int qty = 1}) async {
  final placed = await showPawSheet<String>(context, builder: (_) => _QuickReorder(product: product, pet: pet, qty: qty));
  if (placed == null || !context.mounted) return;
  final l = context.l10n;
  showToast(context, l.shopOrderPlacedToast, actionLabel: l.ordTrack, onAction: () => context.push('/shop/placed/$placed'));
}

class _QuickReorder extends ConsumerStatefulWidget {
  const _QuickReorder({required this.product, this.pet, required this.qty});
  final Product product;
  final Pet? pet;
  final int qty;
  @override
  ConsumerState<_QuickReorder> createState() => _QuickReorderState();
}

class _QuickReorderState extends ConsumerState<_QuickReorder> {
  late int _qty = widget.qty;
  String? _addressId;
  bool _online = false;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final p = widget.product;
    final addresses = ref.watch(addressesProvider).value ?? const <Address>[];
    final address = addresses.where((a) => a.id == _addressId).firstOrNull ?? addresses.firstOrNull;
    final settings = ref.watch(shopSettingsProvider);
    final now = DateTime.now();
    final price = priceCart([CartLine(p.id, _qty)], {p.id: p}, plus: user.isPlus, settings: settings, now: now);
    final slot = deliverySlots(addWorkingDays(Fmt.dayOnly(now), p.deliveryDays), now).first;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(widget.pet == null ? l.shopReorderTitle : l.shopReorderFor(widget.pet!.name), style: context.text.titleMedium),
      const SizedBox(height: Space.md),
      Row(children: [
        ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: 64, radius: 12),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
            PriceTag(price: p.price, mrp: p.mrp),
          ]),
        ),
        QtyStepper(qty: _qty, itemName: p.name, max: (p.stock ?? 1).clamp(1, 20), onChanged: (q) => setState(() => _qty = q < 1 ? 1 : q)),
      ]),
      const Divider(height: Space.xl),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.location_on_rounded),
        title: Text(address == null ? l.addrAddFirst : '${address.label} · ${address.name}'),
        subtitle: address == null ? null : Text(address.oneLine, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: TextButton(
          onPressed: () async {
            final a = await pickAddress(context, ref, selectedId: address?.id);
            if (a != null) setState(() => _addressId = a.id);
          },
          child: Text(address == null ? l.add : l.change),
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.local_shipping_rounded),
        title: Text(l.shopDeliveryOn(Fmt.weekdayDate(slot.date, context.lang))),
        subtitle: Text(windowLabel(context, slot.window)),
      ),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.sm, children: [
        ChoiceChip(label: Text(l.payOnDelivery), selected: !_online, onSelected: (_) => setState(() => _online = false)),
        ChoiceChip(label: Text(l.payOnlineDemo), selected: _online, onSelected: (_) => setState(() => _online = true)),
      ]),
      const SizedBox(height: Space.md),
      _line(context, l.shopItemsTotal, Fmt.inr(price.subtotal)),
      _line(context, l.shopDeliveryFee, price.deliveryFee == 0 ? l.shopFree : Fmt.inr(price.deliveryFee)),
      _line(context, l.shopToPay, Fmt.inr(price.total), bold: true),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.shopPlaceOrderAmount(Fmt.inr(price.total)),
        icon: Icons.check_rounded,
        loading: _busy,
        onPressed: address == null || price.isEmpty ? null : () => _place(address, slot, price.total),
      ),
    ]);
  }

  Widget _line(BuildContext context, String a, String b, {bool bold = false}) {
    final style = bold ? context.text.titleSmall : context.text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [Expanded(child: Text(a, style: style)), Text(b, style: style)]),
    );
  }

  Future<void> _place(Address address, ({DateTime date, String window}) slot, int total) async {
    final l = context.l10n;
    final user = ref.read(currentUserProvider)!;
    var status = 'cod';
    if (_online) {
      final r = await ref.read(paymentServiceProvider).pay(context, amount: total, description: widget.product.name);
      if (!mounted) return;
      if (r == PaymentOutcome.failure) {
        showToast(context, l.payFailedTryAgain);
        return;
      }
      if (r == PaymentOutcome.cancelled) return;
      status = r == PaymentOutcome.pending ? 'pending' : 'paid';
    }
    setState(() => _busy = true);
    try {
      final group = await ref.read(orderRepositoryProvider).place(
            owner: user,
            pet: widget.pet,
            lines: [CartLine(widget.product.id, _qty)],
            address: address,
            slot: slot,
            paymentMethod: _online ? 'online' : 'cod',
            paymentStatus: status,
            source: 'reorder',
          );
      if (mounted) Navigator.pop(context, group);
    } catch (e) {
      debugPrint('Reorder failed: $e');
      if (mounted) {
        setState(() => _busy = false);
        showToast(context, l.shopOrderFailed);
      }
    }
  }
}
