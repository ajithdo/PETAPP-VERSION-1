import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'address_screens.dart';
import 'product_screen.dart';
import 'product_widgets.dart';
import 'shop_labels.dart';

/// Cart and checkout in one place (spec 7.10): items by seller, coupon,
/// address with PIN code, delivery slot, pet, payment (demo) and the bill.
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _coupon = TextEditingController();
  Coupon? _applied;
  String? _couponMsg;
  String? _addressId;
  ({DateTime date, String window})? _slot;
  String? _petId;
  bool _online = true;
  bool _busy = false;
  bool _restoredCoupon = false;

  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final cart = ref.watch(cartProvider);
    final products = ref.watch(productMapProvider);
    final sellers = ref.watch(sellerMapProvider);
    final settings = ref.watch(shopSettingsProvider);
    final now = DateTime.now();
    _restoreCoupon();

    return Scaffold(
      appBar: AppBar(title: Text(l.shopCart)),
      body: AsyncView<List<CartLine>>(
        value: cart,
        data: (lines) {
          if (lines.isEmpty || user == null) {
            return EmptyState(scene: Scene.shop, title: l.cartEmpty, message: l.cartEmptyBody, actionLabel: l.cartStartShopping, onAction: () => context.go('/shop'));
          }
          final price = priceCart(
            lines,
            products,
            plus: user.isPlus,
            settings: settings,
            sellerOverrides: {for (final s in sellers.values) s.id: s.commissionPercent},
            coupon: _applied,
            now: now,
          );
          final addresses = ref.watch(addressesProvider).value ?? const <Address>[];
          final address = addresses.where((a) => a.id == _addressId).firstOrNull ?? addresses.firstOrNull;
          final maxDays = price.groups.fold(1, (m, g) => g.deliveryDays > m ? g.deliveryDays : m);
          final slots = deliverySlots(addWorkingDays(Fmt.dayOnly(now), maxDays), now);
          final slot = _slot != null && slots.any((s) => s.date == _slot!.date && s.window == _slot!.window) ? _slot! : slots.first;
          final pets = petsForProducts(ref.watch(activePetsProvider), [for (final g in price.groups) for (final x in g.lines) x.product]);
          final pet = pets.where((p) => p.id == _petId).firstOrNull ?? ref.watch(selectedPetProvider) ?? pets.firstOrNull;

          return Column(children: [
            Expanded(
              child: PageBody(maxWidth: 900, children: [
                const SizedBox(height: Space.md),
                for (final g in price.groups) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.xs),
                    child: Text(l.cartSoldBy(sellers[g.sellerId]?.name ?? ''), style: context.text.titleSmall),
                  ),
                  for (final x in g.lines) _lineTile(context, user.uid, x.product, x.qty),
                  const SizedBox(height: Space.md),
                ],
                if (price.skipped.isNotEmpty) ...[
                  InfoNote(l.cartSkipped, tone: ChipTone.warning),
                  const SizedBox(height: Space.xs),
                  for (final s in price.skipped)
                    if (products[s.productId] != null) _lineTile(context, user.uid, products[s.productId]!, s.qty, skipped: true),
                  const SizedBox(height: Space.md),
                ],
                if (!price.isEmpty) ...[
                  if (pets.isNotEmpty) ...[
                    Text(l.shopForWhichPet, style: context.text.titleSmall),
                    const SizedBox(height: Space.xs),
                    Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
                      for (final p in pets)
                        ChoiceChip(
                          avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 24),
                          label: Text(p.name),
                          selected: p.id == pet?.id,
                          onSelected: (_) => setState(() => _petId = p.id),
                        ),
                    ]),
                    Text(l.cartPetHint, style: context.text.bodySmall),
                    const SizedBox(height: Space.md),
                  ],
                  Text(l.cartDeliverTo, style: context.text.titleSmall),
                  const SizedBox(height: Space.xs),
                  if (address == null)
                    SecondaryButton(
                      label: l.addrAdd,
                      icon: Icons.add_location_alt_rounded,
                      onPressed: () async {
                        final a = await editAddress(context, ref);
                        if (a != null) setState(() => _addressId = a.id);
                      },
                    )
                  else
                    AddressCard(
                      address: address,
                      trailing: TextButton(
                        onPressed: () async {
                          final a = await pickAddress(context, ref, selectedId: address.id);
                          if (a != null) setState(() => _addressId = a.id);
                        },
                        child: Text(l.change),
                      ),
                    ),
                  const SizedBox(height: Space.md),
                  Text(l.cartSlot, style: context.text.titleSmall),
                  const SizedBox(height: Space.xs),
                  _SlotPicker(slots: slots, selected: slot, onSelected: (s) => setState(() => _slot = s)),
                  const SizedBox(height: Space.md),
                  Text(l.cartCoupon, style: context.text.titleSmall),
                  const SizedBox(height: Space.xs),
                  _couponRow(context, price),
                  const SizedBox(height: Space.md),
                  Text(l.cartPayment, style: context.text.titleSmall),
                  const SizedBox(height: Space.xs),
                  Wrap(spacing: Space.sm, children: [
                    ChoiceChip(label: Text(l.payOnlineDemo), selected: _online, onSelected: (_) => setState(() => _online = true)),
                    ChoiceChip(label: Text(l.payOnDelivery), selected: !_online, onSelected: (_) => setState(() => _online = false)),
                  ]),
                  const SizedBox(height: Space.md),
                  _bill(context, price, user.isPlus, settings),
                  if (price.groups.length > 1) ...[const SizedBox(height: Space.sm), InfoNote(l.cartSplitNote(price.groups.length))],
                ],
              ]),
            ),
            if (!price.isEmpty)
              SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter, Space.sm),
                  decoration: BoxDecoration(color: context.paw.surface, border: Border(top: BorderSide(color: context.paw.outline))),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                            Text(Fmt.inr(price.total), style: context.text.titleLarge),
                            if (price.savings > 0) Text(l.cartYouSave(Fmt.inr(price.savings)), style: context.text.bodySmall?.copyWith(color: context.paw.success)),
                          ]),
                        ),
                        Expanded(
                          child: PrimaryButton(
                            label: _online ? l.cartPay(Fmt.inr(price.total)) : l.cartPlaceOrder,
                            loading: _busy,
                            onPressed: address == null ? null : () => _checkout(price, address, slot, pet?.id),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
          ]);
        },
      ),
    );
  }

  void _restoreCoupon() {
    if (_restoredCoupon) return;
    final saved = ref.watch(cartCouponProvider).value;
    if (saved == null || saved.isEmpty) return;
    _restoredCoupon = true;
    _coupon.text = saved;
    WidgetsBinding.instance.addPostFrameCallback((_) => _apply(silent: true));
  }

  Widget _lineTile(BuildContext context, String uid, Product p, int qty, {bool skipped = false}) {
    final l = context.l10n;
    final repo = ref.read(shopRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: PawCard(
        padding: const EdgeInsets.all(Space.sm),
        child: Row(children: [
          InkWell(
            onTap: () => context.push('/shop/product/${p.id}'),
            child: ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: 64, radius: 12),
          ),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
              PriceTag(price: p.price, mrp: p.mrp),
              if (skipped) Text(p.isAffiliate ? l.cartPartnerOnly : l.shopOutOfStock, style: context.text.bodySmall?.copyWith(color: context.paw.warning)),
            ]),
          ),
          if (skipped)
            IconButton(tooltip: l.shopRemoveItem(p.name), icon: const Icon(Icons.delete_outline_rounded), onPressed: () => repo.setQty(uid, p.id, 0))
          else
            QtyStepper(qty: qty, itemName: p.name, max: (p.stock ?? 1).clamp(1, 20), onChanged: (q) => repo.setQty(uid, p.id, q)),
        ]),
      ),
    );
  }

  Widget _couponRow(BuildContext context, CartPrice price) {
    final l = context.l10n;
    if (_applied != null && price.coupon?.result == CouponResult.ok) {
      return PawCard(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        borderColor: context.paw.success,
        child: Row(children: [
          Icon(Icons.local_offer_rounded, color: context.paw.success),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(l.couponSaved(_applied!.code, Fmt.inr(price.discount)), style: context.text.bodyMedium)),
          TextButton(onPressed: _removeCoupon, child: Text(l.remove)),
        ]),
      );
    }
    final check = price.coupon;
    final msg = _couponMsg ?? (check != null && check.result != CouponResult.ok ? couponMessage(context, check.result, minOrder: _applied?.minOrder ?? 0) : null);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: PawTextField(label: l.couponCode, controller: _coupon, hint: 'WELCOME10', onSubmitted: (_) => _apply())),
        const SizedBox(width: Space.sm),
        Padding(padding: const EdgeInsets.only(top: 6), child: FilledButton.tonal(onPressed: _apply, child: Text(l.couponApply))),
      ]),
      if (msg != null) Text(msg, style: context.text.bodySmall?.copyWith(color: context.paw.error)),
    ]);
  }

  Future<void> _apply({bool silent = false}) async {
    final code = normaliseCoupon(_coupon.text);
    if (code.isEmpty) return;
    final c = await ref.read(shopRepositoryProvider).coupon(code);
    if (!mounted) return;
    final user = ref.read(currentUserProvider)!;
    setState(() {
      _applied = c;
      _couponMsg = c == null ? (silent ? null : context.l10n.couponNotFound) : null;
    });
    if (c != null) await ref.read(shopRepositoryProvider).setCartCoupon(user.uid, c.code);
  }

  Future<void> _removeCoupon() async {
    final user = ref.read(currentUserProvider)!;
    setState(() {
      _applied = null;
      _couponMsg = null;
      _coupon.clear();
    });
    await ref.read(shopRepositoryProvider).setCartCoupon(user.uid, null);
  }

  Widget _bill(BuildContext context, CartPrice price, bool plus, ShopSettings s) {
    final l = context.l10n;
    Widget line(String a, String b, {Color? color, bool bold = false}) {
      final style = (bold ? context.text.titleSmall : context.text.bodyMedium)?.copyWith(color: color);
      return Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Expanded(child: Text(a, style: style)), Text(b, style: style)]));
    }

    final freeAbove = plus ? s.plusFreeDeliveryAbove : s.freeDeliveryAbove;
    final toFree = freeAbove - (price.subtotal - price.discount);
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.cartBill, style: context.text.titleSmall),
        const SizedBox(height: Space.sm),
        line(l.cartMrpTotal(price.itemCount), Fmt.inr(price.mrpTotal)),
        if (price.mrpTotal > price.subtotal) line(l.cartMrpDiscount, '− ${Fmt.inr(price.mrpTotal - price.subtotal)}', color: context.paw.success),
        if (price.discount > 0) line(l.cartCouponDiscount, '− ${Fmt.inr(price.discount)}', color: context.paw.success),
        line(l.shopDeliveryFee, price.deliveryFee == 0 ? l.shopFree : Fmt.inr(price.deliveryFee)),
        const Divider(),
        line(l.shopToPay, Fmt.inr(price.total), bold: true),
        if (price.deliveryFee > 0 && toFree > 0)
          Padding(
            padding: const EdgeInsets.only(top: Space.xs),
            child: Text(l.cartAddForFree(Fmt.inr(toFree)), style: context.text.bodySmall?.copyWith(color: context.colors.primary)),
          ),
        if (plus && price.deliveryFee == 0 && price.subtotal - price.discount < s.freeDeliveryAbove)
          Padding(padding: const EdgeInsets.only(top: Space.xs), child: StatusChip(l.cartPlusFreeDelivery, tone: ChipTone.accent, icon: Icons.workspace_premium_rounded)),
      ]),
    );
  }

  Future<void> _checkout(CartPrice price, Address address, ({DateTime date, String window}) slot, String? petId) async {
    final l = context.l10n;
    final user = ref.read(currentUserProvider)!;
    var status = 'cod';
    if (_online) {
      final r = await ref.read(paymentServiceProvider).pay(context, amount: price.total, description: l.cartPaymentFor(price.itemCount));
      if (!mounted) return;
      if (r == PaymentOutcome.cancelled) return;
      if (r == PaymentOutcome.failure) {
        showToast(context, l.payFailedTryAgain);
        return;
      }
      status = r == PaymentOutcome.pending ? 'pending' : 'paid';
    }
    setState(() => _busy = true);
    try {
      final pets = ref.read(activePetsProvider);
      final lines = [for (final g in price.groups) for (final x in g.lines) CartLine(x.product.id, x.qty)];
      final group = await ref.read(orderRepositoryProvider).place(
            owner: user,
            pet: pets.where((p) => p.id == petId).firstOrNull,
            lines: lines,
            couponCode: _applied?.code,
            address: address,
            slot: slot,
            paymentMethod: _online ? 'online' : 'cod',
            paymentStatus: status,
          );
      await ref.read(shopRepositoryProvider).removeLines(user.uid, lines.map((x) => x.productId));
      await ref.read(shopRepositoryProvider).setCartCoupon(user.uid, null);
      if (mounted) context.pushReplacement('/shop/placed/$group');
    } on OrderException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, e.code == 'coupon' ? l.couponNotFound : l.shopOrderFailed);
    } catch (e) {
      debugPrint('Checkout failed: $e');
      if (!mounted) return;
      setState(() => _busy = false);
      showToast(context, l.shopOrderFailed);
    }
  }
}

class _SlotPicker extends StatelessWidget {
  const _SlotPicker({required this.slots, required this.selected, required this.onSelected});
  final List<({DateTime date, String window})> slots;
  final ({DateTime date, String window}) selected;
  final ValueChanged<({DateTime date, String window})> onSelected;

  @override
  Widget build(BuildContext context) {
    final days = <DateTime>[];
    for (final s in slots) {
      if (!days.contains(s.date)) days.add(s.date);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
        for (final d in days)
          ChoiceChip(
            label: Text(Fmt.weekdayDate(d, context.lang)),
            selected: selected.date == d,
            onSelected: (_) => onSelected(slots.firstWhere((s) => s.date == d)),
          ),
      ]),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
        for (final s in slots.where((s) => s.date == selected.date))
          ChoiceChip(label: Text(windowLabel(context, s.window)), selected: s.window == selected.window, onSelected: (_) => onSelected(s)),
      ]),
    ]);
  }
}
