import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/places_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'address_screens.dart';
import 'product_widgets.dart';
import 'shop_labels.dart';

/// Product page (spec 7.10): photos, price with MRP and discount, seller or
/// partner store, rating and reviews, suitable for, ingredients and specs,
/// delivery estimate by PIN code, return policy, auto-reorder for food.
class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;
  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  int _qty = 1;
  final _pin = TextEditingController();
  bool _pinTouched = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = ref.watch(productProvider(widget.productId));
    return Scaffold(
      appBar: AppBar(
        title: Text(l.shopProduct),
        actions: [
          if (p.value != null)
            IconButton(
              tooltip: l.share,
              icon: const Icon(Icons.share_rounded),
              onPressed: () => SharePlus.instance.share(ShareParams(text: l.shopShareText(p.value!.name, Fmt.inr(p.value!.price)))),
            ),
          const CartButton(),
        ],
      ),
      body: AsyncView<Product?>(
        value: p,
        data: (product) => product == null ? EmptyState(title: l.shopProductGone) : _body(context, product),
      ),
      bottomNavigationBar: p.value == null ? null : _bottomBar(context, p.value!),
    );
  }

  Widget _body(BuildContext context, Product p) {
    final l = context.l10n;
    final wide = !context.isPhone;
    final sellers = ref.watch(sellerMapProvider);
    final partners = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
    final seller = p.sellerId == null ? null : sellers[p.sellerId];
    final store = partners.where((s) => s.id == p.partnerId).firstOrNull;
    final addresses = ref.watch(addressesProvider).value ?? const <Address>[];
    if (!_pinTouched && _pin.text.isEmpty && addresses.isNotEmpty) _pin.text = addresses.first.pin;
    final estimate = deliveryEstimate(_pin.text, p.deliveryDays, DateTime.now());

    final art = AspectRatio(aspectRatio: 1, child: ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, radius: 20, label: p.name));
    final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(p.brand, style: context.text.labelLarge?.copyWith(color: context.paw.textSecondary)),
      Text(p.name, style: context.text.titleLarge),
      const SizedBox(height: Space.xs),
      if (!p.isAffiliate) RatingLine(rating: p.rating, count: p.reviewCount),
      const SizedBox(height: Space.sm),
      PriceTag(price: p.price, mrp: p.mrp, big: true),
      Text(l.shopInclTaxes, style: context.text.bodySmall),
      const SizedBox(height: Space.md),
      if (p.isAffiliate)
        InfoNote(l.shopAffiliateNote(store?.name ?? l.shopPartnerStore), icon: Icons.open_in_new_rounded)
      else ...[
        Row(children: [
          Icon(Icons.storefront_rounded, size: 18, color: context.paw.textSecondary),
          const SizedBox(width: Space.xs),
          Expanded(child: Text(l.shopSoldBy(seller?.name ?? '', seller?.city ?? ''), style: context.text.bodyMedium)),
        ]),
        const SizedBox(height: Space.xs),
        Text(
          !p.inStock ? l.shopOutOfStock : ((p.stock ?? 0) <= 5 ? l.shopOnlyLeft(p.stock ?? 0) : l.shopInStock),
          style: context.text.labelLarge?.copyWith(color: !p.inStock ? context.paw.error : ((p.stock ?? 0) <= 5 ? context.paw.warning : context.paw.success)),
        ),
      ],
      const SizedBox(height: Space.md),
      Text(l.shopSuitableFor, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
        for (final s in p.species) StatusChip(speciesName(context, s), icon: Icons.pets_rounded),
        for (final s in p.lifeStages) StatusChip(lifeStageTag(context, s)),
        if (p.species.contains('dog'))
          for (final s in p.breedSizes) StatusChip(breedSizeTag(context, s)),
      ]),
      if (!p.isAffiliate) ...[
        const SizedBox(height: Space.md),
        Text(l.shopCheckDelivery, style: context.text.titleSmall),
        const SizedBox(height: Space.xs),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 160,
            child: PawTextField(
              label: l.addrPin,
              controller: _pin,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              onChanged: (_) => setState(() => _pinTouched = true),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: Space.md),
              child: Text(
                estimate == null
                    ? (_pin.text.length == 6 ? l.addrPinInvalid : l.shopEnterPin)
                    : l.shopDeliveryBetween(Fmt.weekdayDate(estimate.from, context.lang), Fmt.weekdayDate(estimate.to, context.lang)),
                style: context.text.bodyMedium?.copyWith(color: estimate == null ? context.paw.textSecondary : context.paw.success),
              ),
            ),
          ),
        ]),
        Row(children: [
          Icon(p.returnable ? Icons.assignment_return_rounded : Icons.block_rounded, size: 18, color: context.paw.textSecondary),
          const SizedBox(width: Space.xs),
          Expanded(child: Text(p.returnable ? l.shopReturnable(returnWindowDays) : l.shopNotReturnable, style: context.text.bodySmall)),
        ]),
      ],
    ]);

    return PageBody(children: [
      const SizedBox(height: Space.md),
      if (wide)
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 5, child: art),
          const SizedBox(width: Space.xl),
          Expanded(flex: 6, child: info),
        ])
      else ...[
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: art)),
        const SizedBox(height: Space.md),
        info,
      ],
      if (p.isFood && !p.isAffiliate) ...[
        const SizedBox(height: Space.md),
        PawCard(
          onTap: () => _subscribe(p),
          child: Row(children: [
            Icon(Icons.autorenew_rounded, color: context.colors.primary),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.subsTitle, style: context.text.titleSmall),
                Text(l.subsHint, style: context.text.bodySmall),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ],
      SectionHeader(l.shopAbout),
      Text(p.description.isEmpty ? '–' : p.description, style: context.text.bodyMedium),
      const SizedBox(height: Space.md),
      PawCard(
        child: Column(children: [
          _spec(context, l.shopCategory, categoryLabel(context, p.category)),
          if (p.packKg != null) _spec(context, l.shopPackSize, Fmt.weight(p.packKg!)),
          if (p.ingredients != null) _spec(context, l.shopIngredients, p.ingredients!),
          _spec(context, l.shopBrand, p.brand),
          if (!p.isAffiliate) _spec(context, l.shopReturnPolicy, seller?.returnPolicy ?? ''),
        ]),
      ),
      if (!p.isAffiliate) ..._reviews(context, p),
    ]);
  }

  Widget _spec(BuildContext context, String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 120, child: Text(k, style: context.text.bodySmall)),
          Expanded(child: Text(v, style: context.text.bodyMedium)),
        ]),
      );

  List<Widget> _reviews(BuildContext context, Product p) {
    final l = context.l10n;
    final reviews = ref.watch(reviewsProvider(p.id)).value ?? const <Review>[];
    final orders = ref.watch(myOrdersProvider).value ?? const <ShopOrder>[];
    final canReview = orders.where((o) => o.status == 'delivered' && o.items.any((i) => i.productId == p.id) && ((o.raw['reviewed'] as Map?)?[p.id] != true)).firstOrNull;
    return [
      SectionHeader(l.reviews, action: canReview == null ? null : l.writeReview, onAction: canReview == null ? null : () => writeProductReview(context, ref, p, canReview.id)),
      if (reviews.isEmpty) PawCard(child: Text(l.shopNoReviewsYet)),
      for (final r in reviews.take(6))
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                for (var i = 0; i < 5; i++) Icon(i < r.rating ? Icons.star_rounded : Icons.star_border_rounded, size: 16, color: context.paw.accent),
                const SizedBox(width: Space.sm),
                Expanded(child: Text(r.ownerName, style: context.text.labelLarge)),
                Text(Fmt.date(r.createdAt, context.lang), style: context.text.bodySmall),
              ]),
              if (r.text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(r.text)),
              Padding(padding: const EdgeInsets.only(top: Space.xs), child: StatusChip(l.shopVerifiedBuyer, tone: ChipTone.success, icon: Icons.verified_rounded)),
              if (r.reply != null)
                Padding(
                  padding: const EdgeInsets.only(top: Space.sm),
                  child: Text(l.shopSellerReplied(r.reply!), style: context.text.bodySmall),
                ),
            ]),
          ),
        ),
    ];
  }

  Widget _bottomBar(BuildContext context, Product p) {
    final l = context.l10n;
    final partners = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
    final store = partners.where((s) => s.id == p.partnerId).firstOrNull;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(context.gutter, Space.sm, context.gutter, Space.sm),
        decoration: BoxDecoration(color: context.paw.surface, border: Border(top: BorderSide(color: context.paw.outline))),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: p.isAffiliate
                ? PrimaryButton(label: l.shopBuyOn(store?.name ?? l.shopPartnerStore), icon: Icons.open_in_new_rounded, onPressed: () => _openPartner(p, store))
                : Row(children: [
                    QtyStepper(qty: _qty, itemName: p.name, max: (p.stock ?? 1).clamp(1, 20), onChanged: (q) => setState(() => _qty = q < 1 ? 1 : q)),
                    const SizedBox(width: Space.sm),
                    Expanded(child: SecondaryButton(label: l.shopAddToCart, onPressed: p.inStock ? () => _add(p) : null)),
                    const SizedBox(width: Space.sm),
                    Expanded(child: PrimaryButton(label: l.shopBuyNow, onPressed: p.inStock ? () => _add(p, go: true) : null)),
                  ]),
          ),
        ),
      ),
    );
  }

  Future<void> _add(Product p, {bool go = false}) async {
    final l = context.l10n;
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    await ref.read(shopRepositoryProvider).addToCart(user.uid, p.id, qty: _qty);
    if (!mounted) return;
    if (go) {
      context.push('/shop/cart');
    } else {
      showToast(context, l.shopAddedToCart, actionLabel: l.shopViewCart, onAction: () => context.push('/shop/cart'));
    }
  }

  /// Partner store: say clearly where the purchase happens, record the
  /// click, then open the partner's site.
  Future<void> _openPartner(Product p, PartnerStore? store) async {
    final l = context.l10n;
    final name = store?.name ?? l.shopPartnerStore;
    final ok = await confirmAction(context, title: l.shopLeavingTitle(name), body: l.shopLeavingBody(name), confirmLabel: l.shopContinueTo(name));
    if (!ok || !mounted) return;
    final user = ref.read(currentUserProvider);
    if (user != null) await ref.read(shopRepositoryProvider).trackAffiliateClick(uid: user.uid, p: p);
    final url = Uri.tryParse(p.affiliateUrl ?? store?.url ?? '');
    if (url != null) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _subscribe(Product p) async {
    final done = await showPawSheet<bool>(context, builder: (_) => SubscribeSheet(product: p));
    if (done == true && mounted) showToast(context, context.l10n.subsCreated);
  }
}

/// Auto-reorder every 2, 4 or 6 weeks (spec 7.10).
class SubscribeSheet extends ConsumerStatefulWidget {
  const SubscribeSheet({super.key, required this.product});
  final Product product;
  @override
  ConsumerState<SubscribeSheet> createState() => _SubscribeSheetState();
}

class _SubscribeSheetState extends ConsumerState<SubscribeSheet> {
  int _weeks = 4;
  int _qty = 1;
  String? _petId;
  String? _addressId;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pets = ref.watch(activePetsProvider).where((p) => widget.product.species.contains(p.species)).toList();
    final addresses = ref.watch(addressesProvider).value ?? const <Address>[];
    final address = addresses.where((a) => a.id == _addressId).firstOrNull ?? addresses.firstOrNull;
    final pet = pets.where((p) => p.id == _petId).firstOrNull ?? pets.firstOrNull;
    final first = nextSubscriptionDate(DateTime.now(), _weeks);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.subsTitle, style: context.text.titleMedium),
      const SizedBox(height: Space.xs),
      Text(widget.product.name, style: context.text.bodyMedium),
      const SizedBox(height: Space.md),
      Text(l.subsEvery, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.sm, children: [
        for (final w in subscriptionWeeks) ChoiceChip(label: Text(l.subsWeeks(w)), selected: _weeks == w, onSelected: (_) => setState(() => _weeks = w)),
      ]),
      const SizedBox(height: Space.md),
      Row(children: [
        Expanded(child: Text(l.shopQuantity, style: context.text.titleSmall)),
        QtyStepper(qty: _qty, itemName: widget.product.name, max: 5, onChanged: (q) => setState(() => _qty = q < 1 ? 1 : q)),
      ]),
      if (pets.isNotEmpty) ...[
        const SizedBox(height: Space.md),
        Text(l.shopForWhichPet, style: context.text.titleSmall),
        const SizedBox(height: Space.xs),
        Wrap(spacing: Space.sm, children: [
          for (final p in pets) ChoiceChip(label: Text(p.name), selected: p.id == pet?.id, onSelected: (_) => setState(() => _petId = p.id)),
        ]),
      ],
      const SizedBox(height: Space.md),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.location_on_rounded),
        title: Text(address == null ? l.addrAddFirst : '${addressLabel(context, address.label)} · ${address.name}'),
        subtitle: address == null ? null : Text(address.oneLine, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: TextButton(
          onPressed: () async {
            final a = await pickAddress(context, ref, selectedId: address?.id);
            if (a != null) setState(() => _addressId = a.id);
          },
          child: Text(address == null ? l.add : l.change),
        ),
      ),
      InfoNote(l.subsFirstOn(Fmt.date(first, context.lang)), icon: Icons.event_repeat_rounded),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.subsStart,
        loading: _busy,
        onPressed: address == null
            ? null
            : () async {
                setState(() => _busy = true);
                await ref.read(orderRepositoryProvider).subscribe(owner: ref.read(currentUserProvider)!, pet: pet, p: widget.product, qty: _qty, everyWeeks: _weeks, address: address);
                if (context.mounted) Navigator.pop(context, true);
              },
      ),
    ]);
  }
}

/// Verified review after delivery.
Future<void> writeProductReview(BuildContext context, WidgetRef ref, Product p, String orderId) async {
  final l = context.l10n;
  var rating = 5;
  final text = TextEditingController();
  final ok = await showPawSheet<bool>(context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.writeReview, style: ctx.text.titleMedium),
          Text(p.name, style: ctx.text.bodySmall),
          const SizedBox(height: Space.md),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                tooltip: l.shopStars(i),
                iconSize: 36,
                onPressed: () => setState(() => rating = i),
                icon: Icon(i <= rating ? Icons.star_rounded : Icons.star_border_rounded, color: ctx.paw.accent),
              ),
          ]),
          PawTextField(label: l.shopReviewText, controller: text, maxLines: 4),
          PrimaryButton(label: l.shopPostReview, onPressed: () => Navigator.pop(ctx, true)),
        ]);
      }));
  if (ok == true) {
    final user = ref.read(currentUserProvider);
    if (user != null) await ref.read(shopRepositoryProvider).addProductReview(p: p, orderId: orderId, by: user, rating: rating, text: text.text);
    if (context.mounted) showToast(context, l.shopThanksReview);
  }
  text.dispose();
}

/// Pet chips helper used by the cart.
List<Pet> petsForProducts(List<Pet> pets, Iterable<Product> products) {
  final species = {for (final p in products) ...p.species};
  final match = pets.where((p) => species.contains(p.species)).toList();
  return match.isEmpty ? pets : match;
}
