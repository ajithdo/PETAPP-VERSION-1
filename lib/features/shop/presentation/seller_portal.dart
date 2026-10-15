import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../booking/data/places_repository.dart';
import '../data/order_repository.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'order_screens.dart';
import 'product_widgets.dart';
import 'shop_labels.dart';

/// Seller portal (spec 7.10 and 9): dashboard, products and stock (with CSV
/// upload), orders, returns, payouts (demo), reviews and profile.
Widget? sellerPortalSection(BuildContext context, WidgetRef ref, AppUser user, String section) => switch (section) {
      'dashboard' => const _SellerDashboard(),
      'products' => const _SellerProducts(),
      'orders' => const _SellerOrders(),
      'returns' => const _SellerReturns(),
      'payouts' => const _SellerPayouts(),
      'reviews' => const _SellerReviews(),
      'profile' => const _SellerProfile(),
      _ => null,
    };

Widget _needSeller(WidgetRef ref, Widget Function(Seller s) build) {
  final s = ref.watch(mySellerProvider);
  if (s == null) {
    return ref.watch(sellersProvider).isLoading ? const SkeletonList() : Builder(builder: (c) => EmptyState(title: c.l10n.noBusinessLinked));
  }
  return build(s);
}

class _SellerDashboard extends ConsumerWidget {
  const _SellerDashboard();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final orders = ref.watch(sellerOrdersProvider).value ?? const <ShopOrder>[];
    final now = DateTime.now();
    return _needSeller(ref, (s) {
      final products = ref.watch(sellerProductsProvider(s.id)).value ?? const <Product>[];
      final toPack = orders.where((o) => o.status == 'placed').toList();
      final moving = orders.where((o) => o.status == 'packed' || o.status == 'shipped' || o.status == 'out_for_delivery').length;
      final month = orders.where((o) => o.status == 'delivered' && o.createdAt.year == now.year && o.createdAt.month == now.month);
      final earnings = month.fold(0, (a, o) => a + o.payout);
      final low = products.where((p) => (p.stock ?? 0) <= 5).toList();
      final returns = orders.where((o) => o.status == 'return_requested').length;
      return PageBody(children: [
        const SizedBox(height: Space.md),
        Text(l.helloPartner(user.firstName), style: context.text.headlineSmall),
        Text(s.name, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary)),
        if (s.status != 'approved') ...[const SizedBox(height: Space.md), InfoNote(l.waitingApproval, tone: ChipTone.warning)],
        const SizedBox(height: Space.lg),
        ResponsiveGrid(minItemWidth: 200, children: [
          StatTile(label: l.selToPack, value: '${toPack.length}', icon: Icons.inventory_2_rounded, color: toPack.isEmpty ? null : context.paw.warning),
          StatTile(label: l.selOnTheWay, value: '$moving', icon: Icons.local_shipping_rounded),
          StatTile(label: l.earningsThisMonth, value: Fmt.inr(earnings), icon: Icons.account_balance_wallet_rounded),
          StatTile(label: l.selLowStock, value: '${low.length}', icon: Icons.warning_amber_rounded, color: low.isEmpty ? null : context.paw.error),
        ]),
        if (returns > 0) ...[
          const SizedBox(height: Space.md),
          PawCard(
            onTap: () => context.go('/partner/returns'),
            borderColor: context.paw.warning,
            child: Row(children: [
              Icon(Icons.assignment_return_rounded, color: context.paw.warning),
              const SizedBox(width: Space.md),
              Expanded(child: Text(l.selReturnsWaiting(returns))),
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
        ],
        SectionHeader(l.selNewOrders, action: l.seeAll, onAction: () => context.go('/partner/orders')),
        if (toPack.isEmpty) PawCard(child: Text(l.selNoNewOrders)),
        for (final o in toPack.take(5)) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: OrderCard(order: o, sellerView: true)),
        if (low.isNotEmpty) ...[
          SectionHeader(l.selLowStock, action: l.pProducts, onAction: () => context.go('/partner/products')),
          for (final p in low.take(5))
            Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: PawCard(
                onTap: () => context.push('/partner/product/${p.id}'),
                child: Row(children: [
                  ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: 44, radius: 10),
                  const SizedBox(width: Space.md),
                  Expanded(child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
                  StatusChip(l.selStockLeft(p.stock ?? 0), tone: (p.stock ?? 0) == 0 ? ChipTone.error : ChipTone.warning),
                ]),
              ),
            ),
        ],
      ]);
    });
  }
}

class _SellerProducts extends ConsumerStatefulWidget {
  const _SellerProducts();
  @override
  ConsumerState<_SellerProducts> createState() => _SellerProductsState();
}

class _SellerProductsState extends ConsumerState<_SellerProducts> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _needSeller(ref, (s) {
      final all = ref.watch(sellerProductsProvider(s.id)).value ?? const <Product>[];
      final list = all.where((p) => _q.isEmpty || p.name.toLowerCase().contains(_q.toLowerCase())).toList()..sort((a, b) => a.name.compareTo(b.name));
      return PageBody(children: [
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, crossAxisAlignment: WrapCrossAlignment.center, children: [
          FilledButton.icon(onPressed: () => context.push('/partner/product/new'), icon: const Icon(Icons.add_rounded), label: Text(l.selAddProduct)),
          OutlinedButton.icon(onPressed: () => context.push('/partner/products/import'), icon: const Icon(Icons.upload_file_rounded), label: Text(l.selCsvUpload)),
        ]),
        const SizedBox(height: Space.md),
        TextField(
          decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: l.selSearchProducts),
          onChanged: (v) => setState(() => _q = v),
        ),
        const SizedBox(height: Space.sm),
        Text(l.selProductCount(all.length), style: context.text.bodySmall),
        const SizedBox(height: Space.sm),
        for (final p in list)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: PawCard(
              padding: const EdgeInsets.all(Space.sm),
              onTap: () => context.push('/partner/product/${p.id}'),
              child: Row(children: [
                ProductArt(category: p.category, photoUrl: p.photoUrl, seed: p.imageSeed, size: 56, radius: 12),
                const SizedBox(width: Space.md),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.name, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('${categoryLabel(context, p.category)} · ${Fmt.inr(p.price)}', style: context.text.bodySmall),
                    if (!p.active) Text(l.selHidden, style: context.text.bodySmall?.copyWith(color: context.paw.warning)),
                  ]),
                ),
                StatusChip(l.selStockLeft(p.stock ?? 0), tone: (p.stock ?? 0) == 0 ? ChipTone.error : ((p.stock ?? 0) <= 5 ? ChipTone.warning : ChipTone.success)),
              ]),
            ),
          ),
      ]);
    });
  }
}

/// Add or edit a seller product: name, category, species, price, MRP,
/// stock, pack size, description, visible.
class ProductEditScreen extends ConsumerStatefulWidget {
  const ProductEditScreen({super.key, this.productId});
  final String? productId;
  @override
  ConsumerState<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends ConsumerState<ProductEditScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _price = TextEditingController();
  final _mrp = TextEditingController();
  final _stock = TextEditingController();
  final _pack = TextEditingController();
  final _desc = TextEditingController();
  String _category = 'food';
  final _species = <String>{'dog'};
  bool _active = true;
  bool _loaded = false;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _brand, _price, _mrp, _stock, _pack, _desc]) {
      c.dispose();
    }
    super.dispose();
  }

  void _load(Product p) {
    if (_loaded) return;
    _loaded = true;
    _name.text = p.name;
    _brand.text = p.brand;
    _price.text = '${p.price}';
    _mrp.text = '${p.mrp}';
    _stock.text = '${p.stock ?? 0}';
    _pack.text = p.packKg?.toString() ?? '';
    _desc.text = p.description;
    _category = p.category;
    _species
      ..clear()
      ..addAll(p.species);
    _active = p.active;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final id = widget.productId;
    if (id != null) {
      final p = ref.watch(productProvider(id)).value;
      if (p == null) return Scaffold(appBar: AppBar(), body: const SkeletonList());
      _load(p);
    }
    int? n(TextEditingController c) => int.tryParse(c.text.replaceAll(',', ''));
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? l.selAddProduct : l.selEditProduct)),
      body: Form(
        key: _form,
        child: PageBody(maxWidth: 720, children: [
          const SizedBox(height: Space.md),
          PawTextField(label: l.selProductName, controller: _name, validator: (v) => (v ?? '').trim().isEmpty ? l.fieldRequired : null),
          PawTextField(label: l.shopBrand, controller: _brand),
          Text(l.shopCategory, style: context.text.titleSmall),
          const SizedBox(height: Space.xs),
          Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
            for (final c in shopCategories) ChoiceChip(label: Text(categoryLabel(context, c)), selected: _category == c, onSelected: (_) => setState(() => _category = c)),
          ]),
          const SizedBox(height: Space.md),
          Text(l.shopSuitableFor, style: context.text.titleSmall),
          const SizedBox(height: Space.xs),
          Wrap(spacing: Space.xs, children: [
            for (final s in shopSpecies)
              FilterChip(
                label: Text(speciesName(context, s)),
                selected: _species.contains(s),
                onSelected: (on) => setState(() => on ? _species.add(s) : (_species.length > 1 ? _species.remove(s) : null)),
              ),
          ]),
          const SizedBox(height: Space.md),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: PawTextField(
                label: l.selPrice,
                controller: _price,
                prefixText: '₹ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : l.selPriceInvalid,
              ),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: PawTextField(
                label: l.selMrp,
                controller: _mrp,
                prefixText: '₹ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (int.tryParse(v ?? '') ?? 0) >= (n(_price) ?? 0) ? null : l.selMrpInvalid,
              ),
            ),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: PawTextField(
                label: l.selStock,
                controller: _stock,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => int.tryParse(v ?? '') == null ? l.fieldRequired : null,
              ),
            ),
            const SizedBox(width: Space.md),
            Expanded(child: PawTextField(label: l.selPackKg, controller: _pack, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
          ]),
          PawTextField(label: l.selDescription, controller: _desc, maxLines: 4),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: _active, title: Text(l.selVisible), subtitle: Text(l.selVisibleHint), onChanged: (v) => setState(() => _active = v)),
          InfoNote(l.selNoRxNote, icon: Icons.medication_rounded),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    final seller = ref.read(mySellerProvider);
    if (seller == null) return;
    setState(() => _busy = true);
    final price = int.parse(_price.text);
    final fields = {
      'name': _name.text.trim(),
      'brand': _brand.text.trim(),
      'category': _category,
      'species': _species.toList(),
      'price': price,
      'mrp': int.tryParse(_mrp.text) ?? price,
      'stock': int.parse(_stock.text),
      'packKg': double.tryParse(_pack.text.replaceAll(',', '.')),
      'description': _desc.text.trim(),
      'active': _active,
    };
    final repo = ref.read(shopRepositoryProvider);
    if (widget.productId == null) {
      await repo.addProduct(seller.id, fields);
    } else {
      await repo.updateProduct(widget.productId!, fields);
    }
    if (!mounted) return;
    showToast(context, context.l10n.selSaved);
    context.pop();
  }
}

/// CSV bulk upload with a preview that flags each problem row.
class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({super.key});
  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  final _text = TextEditingController();
  List<CsvRow> _rows = const [];
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ok = _rows.where((r) => r.ok).length;
    return Scaffold(
      appBar: AppBar(title: Text(l.selCsvUpload)),
      body: PageBody(maxWidth: 900, children: [
        const SizedBox(height: Space.md),
        InfoNote(l.selCsvHelp(productCsvColumns.join(', '))),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          FilledButton.icon(onPressed: _pick, icon: const Icon(Icons.file_open_rounded), label: Text(l.selCsvChoose)),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              _text.text = sampleProductCsv;
              _rows = parseProductCsv(_text.text);
            }),
            icon: const Icon(Icons.description_rounded),
            label: Text(l.selCsvSample),
          ),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(text: sampleProductCsv));
              if (context.mounted) showToast(context, l.selCsvCopied);
            },
            icon: const Icon(Icons.copy_rounded),
            label: Text(l.selCsvCopyTemplate),
          ),
        ]),
        const SizedBox(height: Space.md),
        TextField(
          controller: _text,
          maxLines: 8,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(labelText: l.selCsvPaste, alignLabelWithHint: true),
          onChanged: (v) => setState(() => _rows = parseProductCsv(v)),
        ),
        if (_rows.isNotEmpty) ...[
          SectionHeader(l.selCsvPreview(ok, _rows.length - ok)),
          for (final r in _rows)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: PawCard(
                padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
                borderColor: r.ok ? null : context.paw.error,
                child: Row(children: [
                  Icon(r.ok ? Icons.check_circle_rounded : Icons.error_rounded, color: r.ok ? context.paw.success : context.paw.error),
                  const SizedBox(width: Space.sm),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${l.selCsvLine(r.line)} · ${r.data['name'] ?? ''}', style: context.text.bodyMedium),
                      if (!r.ok) Text(l.selCsvProblems(r.errors.map((e) => _errorLabel(context, e)).join(', ')), style: context.text.bodySmall?.copyWith(color: context.paw.error)),
                      if (r.ok) Text('${categoryLabel(context, r.data['category'] as String)} · ${Fmt.inr(r.data['price'] as int)} · ${l.selStockLeft(r.data['stock'] as int)}', style: context.text.bodySmall),
                    ]),
                  ),
                ]),
              ),
            ),
          const SizedBox(height: Space.md),
          PrimaryButton(label: l.selCsvImport(ok), loading: _busy, onPressed: ok == 0 ? null : _import),
        ],
      ]),
    );
  }

  String _errorLabel(BuildContext context, String e) {
    final l = context.l10n;
    return switch (e) {
      'name' => l.selProductName,
      'category' => l.shopCategory,
      'species' => l.species,
      'price' => l.selPrice,
      'mrp' => l.selMrp,
      'stock' => l.selStock,
      'packKg' => l.selPackKg,
      _ => e,
    };
  }

  Future<void> _pick() async {
    final f = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['csv', 'txt']);
    if (f == null) return;
    final bytes = await f.readAsBytes();
    if (!mounted) return;
    setState(() {
      _text.text = utf8.decode(bytes, allowMalformed: true);
      _rows = parseProductCsv(_text.text);
    });
  }

  Future<void> _import() async {
    final seller = ref.read(mySellerProvider);
    if (seller == null) return;
    setState(() => _busy = true);
    final n = await ref.read(shopRepositoryProvider).importProducts(seller.id, _rows);
    if (!mounted) return;
    showToast(context, context.l10n.selCsvImported(n));
    context.pop();
  }
}

class _SellerOrders extends ConsumerWidget {
  const _SellerOrders();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final orders = ref.watch(sellerOrdersProvider).value ?? const <ShopOrder>[];
    final tabs = [
      (l.selTabNew, orders.where((o) => o.status == 'placed').toList()),
      (l.selTabPacked, orders.where((o) => o.status == 'packed').toList()),
      (l.selTabShipping, orders.where((o) => o.status == 'shipped' || o.status == 'out_for_delivery').toList()),
      (l.selTabDelivered, orders.where((o) => o.status == 'delivered' || o.status == 'return_rejected').toList()),
      (l.selTabCancelled, orders.where((o) => o.status == 'cancelled' || o.status == 'returned').toList()),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Column(children: [
        TabBar(isScrollable: true, tabAlignment: TabAlignment.start, tabs: [for (final t in tabs) Tab(text: '${t.$1} (${t.$2.length})')]),
        Expanded(
          child: TabBarView(children: [
            for (final t in tabs)
              t.$2.isEmpty
                  ? EmptyState(compact: true, title: l.selNoOrdersHere)
                  : PageBody(children: [
                      const SizedBox(height: Space.md),
                      for (final o in t.$2) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: OrderCard(order: o, sellerView: true)),
                    ]),
          ]),
        ),
      ]),
    );
  }
}

class _SellerReturns extends ConsumerWidget {
  const _SellerReturns();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final orders = ref.watch(sellerOrdersProvider).value ?? const <ShopOrder>[];
    final open = orders.where((o) => o.status == 'return_requested').toList();
    final done = orders.where((o) => o.status == 'returned' || o.status == 'return_rejected').toList();
    return PageBody(children: [
      SectionHeader(l.selReturnsOpen),
      if (open.isEmpty) PawCard(child: Text(l.selNoReturns)),
      for (final o in open)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.sm),
          child: PawCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              OrderCard(order: o, sellerView: true),
              const SizedBox(height: Space.sm),
              Text(l.ordReason(o.returnReason ?? ''), style: context.text.bodyMedium),
              const SizedBox(height: Space.sm),
              Row(children: [
                Expanded(child: SecondaryButton(label: l.selRejectReturn, onPressed: () => ref.read(orderRepositoryProvider).sellerUpdate(o, 'return_rejected'))),
                const SizedBox(width: Space.sm),
                Expanded(child: PrimaryButton(label: l.selAcceptReturn, onPressed: () => ref.read(orderRepositoryProvider).sellerUpdate(o, 'returned'))),
              ]),
            ]),
          ),
        ),
      SectionHeader(l.selReturnsDone),
      if (done.isEmpty) PawCard(child: Text(l.selNoReturns)),
      for (final o in done) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: OrderCard(order: o, sellerView: true)),
    ]);
  }
}

class _SellerPayouts extends ConsumerWidget {
  const _SellerPayouts();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final orders = ref.watch(sellerOrdersProvider).value ?? const <ShopOrder>[];
    final now = DateTime.now();
    int sum(String state) => orders.where((o) => payoutState(o, now) == state).fold(0, (a, o) => a + o.payout);
    final listed = orders.where((o) => payoutState(o, now) != 'none').toList();
    final ready = sum('ready');
    return PageBody(children: [
      const SizedBox(height: Space.md),
      DemoBanner(l.selPayoutDemo),
      const SizedBox(height: Space.md),
      ResponsiveGrid(minItemWidth: 200, children: [
        StatTile(label: l.selPayoutPending, value: Fmt.inr(sum('pending') + sum('on_hold')), icon: Icons.hourglass_top_rounded),
        StatTile(label: l.selPayoutReady, value: Fmt.inr(ready), icon: Icons.account_balance_rounded, color: ready > 0 ? context.paw.success : null),
        StatTile(label: l.selPayoutPaid, value: Fmt.inr(sum('paid')), icon: Icons.check_circle_rounded),
        StatTile(label: l.selCommissionPaid, value: Fmt.inr(orders.where((o) => payoutState(o, now) == 'paid').fold(0, (a, o) => a + o.commission)), icon: Icons.percent_rounded),
      ]),
      const SizedBox(height: Space.md),
      PrimaryButton(
        label: l.selRunPayout(Fmt.inr(ready)),
        icon: Icons.payments_rounded,
        onPressed: ready == 0
            ? null
            : () async {
                final n = await ref.read(orderRepositoryProvider).runPayouts(orders);
                if (context.mounted) showToast(context, l.selPayoutDone(n));
              },
      ),
      Text(l.selPayoutRule(returnWindowDays), style: context.text.bodySmall),
      SectionHeader(l.selPayoutOrders),
      for (final o in listed)
        Padding(
          padding: const EdgeInsets.only(bottom: Space.xs),
          child: PawCard(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
            onTap: () => context.push('/partner/order/${o.id}'),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${shortOrderNo(o.id)} · ${Fmt.date(o.createdAt, context.lang)}', style: context.text.bodyMedium),
                  Text(l.selPayoutLine(Fmt.inr(o.subtotal), Fmt.inr(o.commission)), style: context.text.bodySmall),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(Fmt.inr(o.payout), style: context.text.titleSmall),
                _payoutChip(context, payoutState(o, now)),
              ]),
            ]),
          ),
        ),
    ]);
  }

  Widget _payoutChip(BuildContext context, String s) {
    final l = context.l10n;
    return switch (s) {
      'paid' => StatusChip(l.selPayoutPaid, tone: ChipTone.success),
      'ready' => StatusChip(l.selPayoutReady, tone: ChipTone.info),
      'on_hold' => StatusChip(l.selPayoutOnHold, tone: ChipTone.warning),
      _ => StatusChip(l.selPayoutPending),
    };
  }
}

final _sellerReviewsProvider = StreamProvider.family<List<Review>, String>((ref, sellerId) => ref
    .watch(firestoreProvider)
    .collection('reviews')
    .where('sellerId', isEqualTo: sellerId)
    .snapshots()
    .map((s) => [for (final d in s.docs) Review(d.id, d.data())]..sort((a, b) => b.createdAt.compareTo(a.createdAt))));

class _SellerReviews extends ConsumerWidget {
  const _SellerReviews();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final products = ref.watch(productMapProvider);
    return _needSeller(ref, (s) {
      final reviews = ref.watch(_sellerReviewsProvider(s.id)).value ?? const <Review>[];
      final avg = reviews.isEmpty ? 0.0 : reviews.fold(0, (a, r) => a + r.rating) / reviews.length;
      return PageBody(children: [
        const SizedBox(height: Space.md),
        if (reviews.isNotEmpty) Text(l.selReviewSummary(avg.toStringAsFixed(1), reviews.length), style: context.text.titleMedium),
        const SizedBox(height: Space.sm),
        if (reviews.isEmpty) PawCard(child: Text(l.shopNoReviewsYet)),
        for (final r in reviews)
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
                Text(products[r.targetId]?.name ?? '', style: context.text.bodySmall),
                if (r.text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: Space.xs), child: Text(r.text)),
                if (r.reply != null)
                  Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.shopSellerReplied(r.reply!), style: context.text.bodySmall))
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _reply(context, ref, r),
                      icon: const Icon(Icons.reply_rounded),
                      label: Text(l.reply),
                    ),
                  ),
              ]),
            ),
          ),
      ]);
    });
  }

  Future<void> _reply(BuildContext context, WidgetRef ref, Review r) async {
    final l = context.l10n;
    final c = TextEditingController();
    final ok = await showPawSheet<bool>(context, builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.reply, style: ctx.text.titleMedium),
          const SizedBox(height: Space.md),
          PawTextField(label: l.selReplyText, controller: c, maxLines: 3, autofocus: true),
          PrimaryButton(label: l.selSendReply, onPressed: () => Navigator.pop(ctx, true)),
        ]));
    if (ok == true && c.text.trim().isNotEmpty) await ref.read(placesRepositoryProvider).replyToReview(r.id, c.text.trim());
    c.dispose();
  }
}

class _SellerProfile extends ConsumerWidget {
  const _SellerProfile();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return _needSeller(ref, (s) {
      final raw = s.raw;
      return PageBody(maxWidth: 720, children: [
        const SizedBox(height: Space.md),
        PawCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(s.name, style: context.text.titleLarge)),
              StatusChip(s.status == 'approved' ? l.selApproved : l.waitingApproval, tone: s.status == 'approved' ? ChipTone.success : ChipTone.warning),
            ]),
            Text(s.city, style: context.text.bodyMedium),
            const SizedBox(height: Space.sm),
            Text(l.invGstin('${raw['gstin'] ?? ''}'), style: context.text.bodySmall),
            Text('${raw['phone'] ?? ''} · ${raw['email'] ?? ''}', style: context.text.bodySmall),
          ]),
        ),
        SectionHeader(l.shopReturnPolicy, action: l.edit, onAction: () => _editPolicy(context, ref, s)),
        PawCard(child: Text(s.returnPolicy)),
        SectionHeader(l.selKyc),
        for (final d in (raw['kycDocs'] as List?) ?? const [])
          Padding(
            padding: const EdgeInsets.only(bottom: Space.xs),
            child: PawCard(
              padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
              child: Row(children: [
                const Icon(Icons.description_rounded),
                const SizedBox(width: Space.md),
                Expanded(child: Text('$d')),
                StatusChip(l.selVerified, tone: ChipTone.success, icon: Icons.verified_rounded),
              ]),
            ),
          ),
        const SizedBox(height: Space.md),
        InfoNote(l.selNoRxNote, icon: Icons.medication_rounded),
      ]);
    });
  }

  Future<void> _editPolicy(BuildContext context, WidgetRef ref, Seller s) async {
    final l = context.l10n;
    final c = TextEditingController(text: s.returnPolicy);
    final ok = await showPawSheet<bool>(context, builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.shopReturnPolicy, style: ctx.text.titleMedium),
          const SizedBox(height: Space.md),
          PawTextField(label: l.shopReturnPolicy, controller: c, maxLines: 3),
          PrimaryButton(label: l.save, onPressed: () => Navigator.pop(ctx, true)),
        ]));
    if (ok == true) await ref.read(firestoreProvider).collection('sellers').doc(s.id).update({'returnPolicy': c.text.trim()});
    c.dispose();
  }
}

/// One order as the seller sees it, with the next steps.
class SellerOrderScreen extends ConsumerWidget {
  const SellerOrderScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.ordDetail)),
      body: AsyncView<ShopOrder?>(
        value: ref.watch(orderProvider(orderId)),
        data: (o) {
          if (o == null) return EmptyState(title: l.ordNotFound);
          final next = sellerNextStatuses(o.status);
          final a = Address.fromMap(o.address);
          return PageBody(maxWidth: 820, children: [
            const SizedBox(height: Space.md),
            Row(children: [
              Expanded(child: Text(l.ordNumber(shortOrderNo(o.id)), style: context.text.titleMedium)),
              StatusChip(orderStatusInfo(context, o.status).$1, tone: orderStatusInfo(context, o.status).$2),
            ]),
            Text('${o.ownerName} · ${Fmt.dateTime(o.createdAt, context.lang)}', style: context.text.bodySmall),
            if (o.returnReason != null && o.status == 'return_requested') ...[const SizedBox(height: Space.sm), InfoNote(l.ordReason(o.returnReason!), tone: ChipTone.warning)],
            const SizedBox(height: Space.md),
            if (next.isNotEmpty)
              Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
                for (final s in next)
                  s == 'cancelled' || s == 'return_rejected'
                      ? OutlinedButton(
                          onPressed: () async {
                            final ok = await confirmAction(context, title: s == 'cancelled' ? l.selCancelQ : l.selRejectReturn, body: l.selCancelBody, confirmLabel: orderStatusInfo(context, s).$1);
                            if (ok) await ref.read(orderRepositoryProvider).sellerUpdate(o, s, note: s == 'cancelled' ? l.selOutOfStockReason : null);
                          },
                          child: Text(s == 'cancelled' ? l.selCancelOrder : l.selRejectReturn),
                        )
                      : FilledButton.icon(
                          onPressed: () => ref.read(orderRepositoryProvider).sellerUpdate(o, s),
                          icon: Icon(orderStatusInfo(context, s).$3),
                          label: Text(_actionLabel(context, s)),
                        ),
              ]),
            SectionHeader(l.ordTracking),
            OrderTimeline(order: o),
            SectionHeader(l.ordItems(o.itemCount)),
            PawCard(
              child: Column(children: [
                for (final i in o.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.xs),
                    child: Row(children: [
                      ProductArt(category: i.category, seed: i.imageSeed, size: 44, radius: 10),
                      const SizedBox(width: Space.md),
                      Expanded(child: Text('${i.name} × ${i.qty}')),
                      Text(Fmt.inr(i.amount)),
                    ]),
                  ),
                const Divider(),
                _row(context, l.shopItemsTotal, Fmt.inr(o.subtotal)),
                _row(context, l.selCommission, '− ${Fmt.inr(o.commission)}'),
                _row(context, l.selYourPayout, Fmt.inr(o.payout), bold: true),
              ]),
            ),
            SectionHeader(l.selShipTo),
            PawCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.name, style: context.text.titleSmall),
                Text(a.oneLine),
                if (o.slotDate != null && o.slotWindow != null) Text(l.ordSlot(Fmt.weekdayDate(o.slotDate!, context.lang), windowLabel(context, o.slotWindow!)), style: context.text.bodySmall),
                Text(l.selPhoneHidden, style: context.text.bodySmall),
              ]),
            ),
          ]);
        },
      ),
    );
  }

  String _actionLabel(BuildContext context, String s) {
    final l = context.l10n;
    return switch (s) {
      'packed' => l.selMarkPacked,
      'shipped' => l.selMarkShipped,
      'out_for_delivery' => l.selMarkOut,
      'delivered' => l.selMarkDelivered,
      'returned' => l.selAcceptReturn,
      _ => orderStatusInfo(context, s).$1,
    };
  }

  Widget _row(BuildContext context, String a, String b, {bool bold = false}) {
    final style = bold ? context.text.titleSmall : context.text.bodyMedium;
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [Expanded(child: Text(a, style: style)), Text(b, style: style)]));
  }
}
