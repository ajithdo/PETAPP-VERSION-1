import 'package:flutter/material.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/document_preview.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';

/// PDF invoice for an order (spec 7.10). Tax fields are placeholders until
/// GST is set up; demo invoices say so.
void openInvoice(BuildContext context, ShopOrder o) {
  final l = context.l10n;
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => DocumentPreviewScreen(
      title: l.invTitle,
      fileName: 'PawSetu-invoice-${shortOrderNo(o.id)}.pdf',
      pages: (ctx) => [_InvoicePage(order: o, lang: ctx.lang)],
    ),
  ));
}

class _InvoicePage extends StatelessWidget {
  const _InvoicePage({required this.order, required this.lang});
  final ShopOrder order;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = order;
    final a = Address.fromMap(o.address);
    String inr(int v) => Fmt.inr(v, lang);
    return A4Page(
      title: l.invTitle,
      subtitle: '${o.invoiceNo} · ${Fmt.date(o.createdAt, lang)}',
      footer: l.invFooter,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: A4Section(
              title: l.invSoldBy,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o.sellerName, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(l.invGstin('SAMPLE-GSTIN')),
                Text(l.invMarketplace),
              ]),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: A4Section(
              title: l.invBillTo,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.name.isEmpty ? o.ownerName : a.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(a.oneLine),
                if (a.phone.isNotEmpty) Text(a.phone),
              ]),
            ),
          ),
        ]),
        A4Section(
          title: l.invOrder,
          child: Text('${shortOrderNo(o.id)} · ${l.invInvoiceNo(o.invoiceNo)} · ${l.invPayment(_payment(l, o))}'),
        ),
        A4Section(
          title: l.invItems,
          child: A4Table(
            header: [l.invItem, l.invQty, l.invPrice, l.invAmount],
            flex: const [6, 1, 2, 2],
            rows: [
              for (final i in o.items) [i.name, '${i.qty}', inr(i.price), inr(i.amount)],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 240,
            child: Column(children: [
              _row(l.shopItemsTotal, inr(o.subtotal)),
              if (o.discount > 0) _row(l.cartCouponDiscountCode(o.coupon ?? ''), '− ${inr(o.discount)}'),
              _row(l.shopDeliveryFee, o.deliveryFee == 0 ? l.shopFree : inr(o.deliveryFee)),
              _row(l.invTax, l.invTaxPlaceholder),
              const Divider(height: 10, color: Color(0xFFE5E1DA)),
              _row(l.ordTotal, inr(o.total), bold: true),
            ]),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFFFF4E5), borderRadius: BorderRadius.circular(6)),
          child: Text(l.invDemoNote, style: const TextStyle(color: Color(0xFF8A4B08), fontSize: 9)),
        ),
      ],
    );
  }

  String _payment(AppLocalizations l, ShopOrder o) => switch (o.paymentStatus) {
        'paid' => l.payPaidOnline,
        'pending' => l.payPending,
        'cod' => l.payOnDelivery,
        'refunded' => l.payRefunded,
        _ => o.paymentStatus,
      };

  Widget _row(String a, String b, {bool bold = false}) {
    final style = TextStyle(fontSize: bold ? 11 : 9.5, fontWeight: bold ? FontWeight.w700 : FontWeight.w400);
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [Expanded(child: Text(a, style: style)), Text(b, style: style)]));
  }
}
