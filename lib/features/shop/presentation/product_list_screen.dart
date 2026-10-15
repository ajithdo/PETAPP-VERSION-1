import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';
import 'product_widgets.dart';
import 'shop_labels.dart';

/// Search and category results with filters (species, category, price,
/// brand, rating, partner stores) and sorting (spec 7.10).
class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key, this.query = '', this.category, this.species, this.store, this.sort, this.focus = false});
  final String query;
  final String? category;
  final String? species;
  final String? store;
  final String? sort;
  final bool focus;

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  late final _search = TextEditingController(text: widget.query);
  late ProductFilter _f = ProductFilter(query: widget.query, category: widget.category, species: widget.species);
  late ProductSort _sort = ProductSort.values.where((s) => s.name == widget.sort).firstOrNull ?? ProductSort.popular;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final all = ref.watch(productsProvider);
    final partners = ref.watch(partnerStoresProvider).value ?? const <PartnerStore>[];
    final store = partners.where((s) => s.id == widget.store).firstOrNull;
    final title = store?.name ?? (widget.category != null && _f.query.isEmpty ? categoryLabel(context, widget.category!) : l.shopSearchTitle);
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: const [CartButton()]),
      body: AsyncView<List<Product>>(
        value: all,
        data: (products) {
          final source = widget.store == null ? products : products.where((p) => p.partnerId == widget.store).toList();
          final list = searchProducts(source, _f, sort: _sort, labels: (p) => '${categoryLabel(context, p.category)} ${p.species.map((s) => speciesName(context, s)).join(' ')}');
          final brands = (source.map((p) => p.brand).toSet().toList()..sort());
          return PageBody(children: [
            const SizedBox(height: Space.sm),
            TextField(
              controller: _search,
              autofocus: widget.focus,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l.shopSearchHint,
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l.shopClearSearch,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() {
                          _search.clear();
                          _f = _f.copyWith(query: '');
                        }),
                      ),
              ),
              onChanged: (v) => setState(() => _f = _f.copyWith(query: v)),
            ),
            const SizedBox(height: Space.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ActionChip(
                  avatar: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(_f.activeCount == 0 ? l.filters : l.shopFiltersCount(_f.activeCount)),
                  onPressed: () => _openFilters(brands),
                ),
                const SizedBox(width: Space.sm),
                for (final s in shopSpecies) ...[
                  FilterChip(
                    label: Text(speciesName(context, s)),
                    selected: _f.species == s,
                    onSelected: (on) => setState(() => _f = _f.copyWith(species: () => on ? s : null)),
                  ),
                  const SizedBox(width: Space.xs),
                ],
              ]),
            ),
            const SizedBox(height: Space.sm),
            Row(children: [
              Expanded(child: Text(l.shopResults(list.length), style: context.text.bodySmall)),
              Text('${l.sortBy} ', style: context.text.bodySmall),
              DropdownButton<ProductSort>(
                value: _sort,
                underline: const SizedBox.shrink(),
                items: [for (final s in ProductSort.values) DropdownMenuItem(value: s, child: Text(sortLabel(context, s)))],
                onChanged: (s) => setState(() => _sort = s ?? _sort),
              ),
            ]),
            const SizedBox(height: Space.sm),
            if (list.isEmpty)
              EmptyState(
                scene: Scene.search,
                compact: true,
                title: l.shopNoResults,
                message: l.shopNoResultsBody,
                actionLabel: _f.activeCount > 0 || _f.query.isNotEmpty ? l.shopClearFilters : null,
                onAction: () => setState(() {
                  _search.clear();
                  _f = const ProductFilter();
                }),
              )
            else
              ProductGrid(products: list),
          ]);
        },
      ),
    );
  }

  Future<void> _openFilters(List<String> brands) async {
    final r = await showPawSheet<ProductFilter>(context, builder: (_) => _FilterSheet(filter: _f, brands: brands));
    if (r != null) setState(() => _f = r);
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.filter, required this.brands});
  final ProductFilter filter;
  final List<String> brands;
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ProductFilter _f = widget.filter;
  late final _min = TextEditingController(text: widget.filter.minPrice?.toString() ?? '');
  late final _max = TextEditingController(text: widget.filter.maxPrice?.toString() ?? '');

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: Text(l.filters, style: context.text.titleMedium)),
        TextButton(
          onPressed: () => setState(() {
            _f = ProductFilter(query: _f.query);
            _min.clear();
            _max.clear();
          }),
          child: Text(l.shopClearFilters),
        ),
      ]),
      const SizedBox(height: Space.sm),
      Text(l.shopCategory, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
        for (final c in shopCategories)
          FilterChip(
            label: Text(categoryLabel(context, c)),
            selected: _f.category == c,
            onSelected: (on) => setState(() => _f = _f.copyWith(category: () => on ? c : null)),
          ),
      ]),
      const SizedBox(height: Space.md),
      Text(l.shopPrice, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Row(children: [
        Expanded(
          child: PawTextField(
            label: l.shopMinPrice,
            controller: _min,
            prefixText: '₹ ',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => _f = _f.copyWith(minPrice: () => int.tryParse(v)),
          ),
        ),
        const SizedBox(width: Space.md),
        Expanded(
          child: PawTextField(
            label: l.shopMaxPrice,
            controller: _max,
            prefixText: '₹ ',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => _f = _f.copyWith(maxPrice: () => int.tryParse(v)),
          ),
        ),
      ]),
      Wrap(spacing: Space.xs, children: [
        for (final r in const [(0, 499), (500, 999), (1000, 2999), (3000, 9999)])
          ActionChip(
            label: Text('${Fmt.inr(r.$1)} – ${Fmt.inr(r.$2)}'),
            onPressed: () => setState(() {
              _f = _f.copyWith(minPrice: () => r.$1, maxPrice: () => r.$2);
              _min.text = '${r.$1}';
              _max.text = '${r.$2}';
            }),
          ),
      ]),
      const SizedBox(height: Space.md),
      Text(l.shopBrand, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
        for (final b in widget.brands)
          FilterChip(
            label: Text(b),
            selected: _f.brands.contains(b),
            onSelected: (on) => setState(() => _f = _f.copyWith(brands: on ? {..._f.brands, b} : ({..._f.brands}..remove(b)))),
          ),
      ]),
      const SizedBox(height: Space.md),
      Text(l.rating, style: context.text.titleSmall),
      const SizedBox(height: Space.xs),
      Wrap(spacing: Space.xs, children: [
        for (final r in const [4.0, 3.5, 3.0])
          ChoiceChip(
            label: Text(l.shopRatingAtLeast(r.toStringAsFixed(1))),
            selected: _f.minRating == r,
            onSelected: (on) => setState(() => _f = _f.copyWith(minRating: () => on ? r : null)),
          ),
      ]),
      const SizedBox(height: Space.sm),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: _f.sellerOnly,
        title: Text(l.shopHidePartner),
        subtitle: Text(l.shopHidePartnerHint),
        onChanged: (v) => setState(() => _f = _f.copyWith(sellerOnly: v)),
      ),
      const SizedBox(height: Space.md),
      PrimaryButton(label: l.shopShowResults, onPressed: () => Navigator.pop(context, _f)),
    ]);
  }
}
