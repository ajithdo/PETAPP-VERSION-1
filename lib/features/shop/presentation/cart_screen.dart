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
import 'quick_reorder.dart';
import 'shop_labels.dart';
import '../../../core/theme/ph.dart';

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

    final orders = ref.watch(myOrdersProvider).value ?? const <ShopOrder>[];

    return Scaffold(
      appBar: AppBar(title: Text(l.shopCart)),
      body: AsyncView<List<CartLine>>(
        value: cart,
        data: (lines) {
          if (lines.isEmpty || user == null) {
            final again = [for (final id in buyAgainIds(orders)) ?products[id]].where((p) => p.active && !p.isAffiliate).take(2).toList();
            return _EmptyCart(again: again);
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
          final paw = context.paw;

          // Left on a wide screen, first on a phone: what, where, when.
          final main = <Widget>[
            if (!price.isEmpty)
              PawCard(
                padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs + Space.xxs),
                child: PawList(children: [
                  for (final g in price.groups)
                    for (final x in g.lines) _line(context, user.uid, x.product, x.qty),
                ]),
              ),
            if (price.skipped.isNotEmpty) ...[
              InfoNote(l.cartSkipped, tone: ChipTone.warning),
              PawPanel(
                padding: PawPanel.listPadding,
                child: PawList(children: [
                  for (final s in price.skipped)
                    if (products[s.productId] != null) _line(context, user.uid, products[s.productId]!, s.qty, skipped: true),
                ]),
              ),
            ],
            if (!price.isEmpty) ...[
              PawPanel(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  if (address == null)
                    PawButton(
                      label: l.addrAdd,
                      icon: Ph.mapPinPlus,
                      kind: BtnKind.line,
                      size: BtnSize.regular,
                      block: true,
                      onPressed: () async {
                        final a = await editAddress(context, ref);
                        if (a != null) setState(() => _addressId = a.id);
                      },
                    )
                  else ...[
                    Row(children: [
                      Icon(Ph.mapPin, size: IconSizes.sm + Space.xxs, color: paw.textPrimary),
                      const SizedBox(width: Space.sm),
                      Expanded(child: Text(l.cartDeliverToLabel(addressLabel(context, address.label)), style: context.text.labelLarge)),
                      TextLink(
                        l.change,
                        onTap: () async {
                          final a = await pickAddress(context, ref, selectedId: address.id);
                          if (a != null) setState(() => _addressId = a.id);
                        },
                      ),
                    ]),
                    const SizedBox(height: Space.xs),
                    Text([if (address.name.isNotEmpty) address.name, address.oneLine].join(', '), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
                  ],
                  const SizedBox(height: Space.lg),
                  Text(l.cartSlot, style: context.text.labelLarge),
                  const SizedBox(height: Space.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      for (final (i, s) in slots.indexed) ...[
                        if (i > 0) const SizedBox(width: Space.sm),
                        PawChip(
                          // The first chip carries the date; the rest just the day.
                          label: '${i == 0 ? Fmt.weekdayDate(s.date, context.lang).replaceFirst(',', '') : Fmt.weekdayShort(s.date, context.lang)}, ${windowShort(context, s.window)}',
                          selected: s.date == slot.date && s.window == slot.window,
                          onTap: () => setState(() => _slot = s),
                        ),
                      ],
                    ]),
                  ),
                  if (pets.length > 1) ...[
                    const SizedBox(height: Space.lg),
                    Text(l.shopForWhichPet, style: context.text.labelLarge),
                    const SizedBox(height: Space.sm),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        for (final (i, p) in pets.indexed) ...[
                          if (i > 0) const SizedBox(width: Space.sm),
                          PawChip(label: p.name, selected: p.id == pet?.id, onTap: () => setState(() => _petId = p.id)),
                        ],
                      ]),
                    ),
                    const SizedBox(height: Space.xs),
                    Text(l.cartPetHint, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
                  ],
                ]),
              ),
              _couponRow(context, price),
            ],
          ];
          // Right on a wide screen, last on a phone: the bill and paying.
          final side = <Widget>[
            if (!price.isEmpty) ...[
              _bill(context, price, user.isPlus, settings, onPay: address == null ? null : () => _checkout(price, address, slot, pet?.id)),
              if (price.groups.length > 1) InfoNote(l.cartSplitNote(price.groups.length)),
              DemoBanner(l.cartDemoPayNote),
            ],
          ];
          Widget stack(List<Widget> items) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, w) in items.indexed) ...[if (i > 0) const SizedBox(height: Space.md), w],
                ],
              );
          return LayoutBuilder(builder: (context, box) {
            final wide = box.maxWidth >= Space.readingWidth;
            return PageBody(maxWidth: wide ? Space.maxContentWidth : Space.formWidth, children: [
              const SizedBox(height: Space.sm),
              if (wide)
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 7, child: stack(main)),
                  const SizedBox(width: Space.md),
                  Expanded(flex: 5, child: stack(side)),
                ])
              else
                stack([...main, ...side]),
              const SizedBox(height: Space.xl),
            ]);
          });
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

  /// One thing in the cart: its picture, name and brand, then the
  /// quantity pill with the price at the end of the row.
  Widget _line(BuildContext context, String uid, Product p, int qty, {bool skipped = false}) {
    final l = context.l10n;
    final paw = context.paw;
    final repo = ref.read(shopRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.tileXl * Sizes.tileCorner),
          onTap: () => context.push('/shop/product/${p.id}'),
          child: ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: Sizes.tileXl, radius: Sizes.tileXl * Sizes.tileCorner, label: p.name),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.shortName, style: context.text.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
            if (p.brand.isNotEmpty) Text(p.brand, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
            if (skipped) Text(p.isAffiliate ? l.cartPartnerOnly : l.shopOutOfStock, style: context.text.bodySmall?.copyWith(color: paw.warning)),
            const SizedBox(height: Space.sm),
            Row(children: [
              if (skipped)
                PawButton(label: l.remove, icon: Ph.trash, kind: BtnKind.line, semanticLabel: l.shopRemoveItem(p.name), onPressed: () => repo.setQty(uid, p.id, 0))
              else
                QtyStepper(qty: qty, itemName: p.name, max: (p.stock ?? 1).clamp(1, 20), onChanged: (q) => repo.setQty(uid, p.id, q)),
              const Spacer(),
              Text(Fmt.inr(p.price), style: context.text.titleMedium),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _couponRow(BuildContext context, CartPrice price) {
    final l = context.l10n;
    final paw = context.paw;
    if (_applied != null && price.coupon?.result == CouponResult.ok) {
      // The code in a field-shaped box, a green "Applied" tag and Remove
      // (on a second line with big text).
      final box = Container(
        constraints: const BoxConstraints(minHeight: Sizes.field),
        padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        decoration: BoxDecoration(
          color: paw.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: context.tint.line2, width: Strokes.strong),
        ),
        child: Row(children: [
          Icon(Ph.ticket, size: IconSizes.md, color: paw.textPrimary),
          const SizedBox(width: Space.md),
          Expanded(child: ExcludeSemantics(child: Text(_applied!.code, style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis))),
        ]),
      );
      final tag = PawTag(l.cartApplied, kind: TagKind.green, icon: Ph.checkCircleFill);
      final remove = TextLink(l.remove, onTap: _removeCoupon);
      return Semantics(
        container: true,
        label: l.couponSaved(_applied!.code, Fmt.inr(price.discount)),
        child: MediaQuery.textScalerOf(context).scale(1) > 1.15
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                box,
                const SizedBox(height: Space.sm),
                Wrap(alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, spacing: Space.md, runSpacing: Space.sm, children: [tag, remove]),
              ])
            : Row(children: [Expanded(child: box), const SizedBox(width: Space.md), tag, const SizedBox(width: Space.md), remove]),
      );
    }
    final check = price.coupon;
    final msg = _couponMsg ?? (check != null && check.result != CouponResult.ok ? couponMessage(context, check.result, minOrder: _applied?.minOrder ?? 0) : null);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: PawTextField(label: l.couponCode, labelInside: true, prefixIcon: Ph.ticket, controller: _coupon, onSubmitted: (_) => _apply())),
        const SizedBox(width: Space.sm),
        PawButton(label: l.couponApply, kind: BtnKind.soft, size: BtnSize.regular, onPressed: _apply),
      ]),
      if (msg != null) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(msg, style: context.text.bodySmall?.copyWith(color: paw.error))),
    ]);
  }

  Future<void> _apply({bool silent = false}) async {
    final code = normaliseCoupon(_coupon.text);
    if (code.isEmpty) return;
    final user = ref.read(currentUserProvider)!;
    final c = await ref.read(shopRepositoryProvider).coupon(code, uid: user.uid);
    if (!mounted) return;
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

  /// The bill as a ticket: what it adds up to, then the button to pay.
  Widget _bill(BuildContext context, CartPrice price, bool plus, ShopSettings s, {required VoidCallback? onPay}) {
    final l = context.l10n;
    final paw = context.paw;
    final freeAbove = plus ? s.plusFreeDeliveryAbove : s.freeDeliveryAbove;
    final toFree = freeAbove - (price.subtotal - price.discount);
    final plusFree = plus && price.deliveryFee == 0 && price.subtotal - price.discount < s.freeDeliveryAbove;
    return PawCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.cartBillShort, style: context.text.titleMedium),
        const SizedBox(height: Space.md),
        KvList(valuesAtEnd: true, rows: [
          (l.cartItems(price.itemCount), Fmt.inr(price.subtotal), null),
          (l.shopDeliveryFee, price.deliveryFee > 0 ? Fmt.inr(price.deliveryFee) : (plusFree ? l.cartFreeWithPlus : l.shopFree), price.deliveryFee > 0 ? null : Tone.green),
          if (price.discount > 0) (_applied == null ? l.cartCouponDiscount : l.cartCouponDiscountCode(_applied!.code), '−${Fmt.inr(price.discount)}', Tone.green),
        ]),
        const Padding(padding: EdgeInsets.only(top: Space.sm - Space.xxs, bottom: Space.md + Space.xxs), child: DashedRule()),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: Text(l.shopToPay, style: context.text.labelLarge)),
          Text(Fmt.inr(price.total), style: context.text.headlineSmall),
        ]),
        if (price.savings > 0) Text(l.cartSaveOnOrder(Fmt.inr(price.savings)), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
        if (price.deliveryFee > 0 && toFree > 0)
          Padding(
            padding: const EdgeInsets.only(top: Space.xs),
            child: Text(l.cartAddForFree(Fmt.inr(toFree)), style: context.text.bodySmall?.copyWith(color: paw.success)),
          ),
        const SizedBox(height: Space.lg),
        SegText(items: [l.payOnlineDemo, l.payOnDelivery], index: _online ? 0 : 1, onChanged: (i) => setState(() => _online = i == 0)),
        const SizedBox(height: Space.md),
        PawButton(
          label: _online ? l.cartPay(Fmt.inr(price.total)) : l.cartPlaceOrder,
          icon: _online ? Ph.lockKey : Ph.package,
          size: BtnSize.large,
          block: true,
          onPressed: _busy ? null : onPay,
        ),
        if (!_online) Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.cartCodNote, style: context.text.bodySmall?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center)),
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

/// Nothing in the cart: the drawn bag, a way back to the shop, and the
/// last things bought with one-tap reorder.
class _EmptyCart extends ConsumerWidget {
  const _EmptyCart({required this.again});
  final List<Product> again;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final paw = context.paw;
    final pet = ref.watch(selectedPetProvider);
    return PageBody(maxWidth: Space.formWidth, children: [
      const SizedBox(height: Space.x3l + Space.lg),
      const Center(
        child: ClipOval(
          child: SizedBox(width: Sizes.emptyArt, height: Sizes.emptyArt, child: ExcludeSemantics(child: PackShot(kind: PackKind.bag, colors: PackColors.emptyBag))),
        ),
      ),
      const SizedBox(height: Space.xl),
      Text(l.cartEmpty, style: context.text.headlineSmall, textAlign: TextAlign.center),
      const SizedBox(height: Space.sm),
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Sizes.emptyArt * 2.25),
          child: Text(l.cartEmptyBody, style: context.text.bodyMedium?.copyWith(color: paw.textSecondary), textAlign: TextAlign.center),
        ),
      ),
      const SizedBox(height: Space.lg + Space.xs),
      Center(child: PawButton(label: l.cartStartShopping, icon: Ph.bag, size: BtnSize.regular, onPressed: () => context.go('/shop'))),
      if (again.isNotEmpty) ...[
        const SizedBox(height: Space.x3l),
        SecHead(l.shopBuyAgain, action: l.ordMyOrders, onAction: () => context.push('/shop/orders')),
        PawPanel(
          padding: PawPanel.listPadding,
          child: PawList(children: [
            for (final p in again)
              PawItem(
                lead: ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: Sizes.tileLg, radius: Sizes.tileLg * Sizes.tileCorner),
                title: p.shortName,
                titleWidget: Text(p.shortName, style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                sub: Fmt.inr(p.price),
                onTap: () => context.push('/shop/product/${p.id}'),
                trailing: PawButton(
                  label: l.shopReorder,
                  icon: Ph.arrowClockwise,
                  kind: BtnKind.soft,
                  semanticLabel: '${l.shopReorder}: ${p.name}',
                  onPressed: p.inStock ? () => showQuickReorder(context, ref, product: p, pet: pet) : null,
                ),
              ),
          ]),
        ),
      ],
      const SizedBox(height: Space.xl),
    ]);
  }
}
