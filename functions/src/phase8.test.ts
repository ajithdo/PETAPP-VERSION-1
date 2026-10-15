/**
 * Unit tests for the Phase 8 order rules on the server (no emulator):
 *   npm --prefix functions test
 * The same cases are tested in Dart (test/features/phase8_shop_test.dart).
 */
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

process.env.GCLOUD_PROJECT ??= 'demo-pawsetu';
import { getApps, initializeApp } from 'firebase-admin/app';
if (!getApps().length) initializeApp({ projectId: 'demo-pawsetu' });
// eslint-disable-next-line @typescript-eslint/no-require-imports
const m = require('./phase8') as typeof import('./phase8');

const s = m.settingsFrom({ commission: { foodMarginPercent: 8, otherMarginPercent: 15, freeDeliveryAbove: 499 }, shop: { deliveryFee: 49, freeDeliveryAbove: 999 } });
const now = new Date('2026-10-14T05:30:00Z');

describe('orders (server)', () => {
  const products = {
    food: { name: 'Food', category: 'food', price: 3899, mrp: 4499, stock: 10, sellerId: 's1' },
    chew: { name: 'Chew', category: 'treats', price: 399, stock: 10, sellerId: 's1' },
    ball: { name: 'Ball', category: 'toys', price: 249, stock: 1, sellerId: 's2' },
    aff: { name: 'Fountain', category: 'bowls_feeders', price: 1999, partnerId: 'p1' },
  };

  it('commission, delivery and coupons match the app', () => {
    assert.equal(m.commissionPercent('food', s), 8);
    assert.equal(m.commissionPercent('toys', s), 15);
    assert.equal(m.commissionPercent('food', s, { food: 6 }), 6);
    assert.equal(m.deliveryFee(998, false, s), 49);
    assert.equal(m.deliveryFee(999, false, s), 0);
    assert.equal(m.deliveryFee(499, true, s), 0);
    assert.deepEqual(m.checkCoupon({ percent: 10, maxDiscount: 200, minOrder: 499 }, 5000, now), { result: 'ok', discount: 200 });
    assert.equal(m.checkCoupon({ flat: 100, minOrder: 999 }, 998, now).result, 'minOrder');
    assert.equal(m.checkCoupon({ percent: 50, validTill: new Date('2026-10-01') }, 500, now).result, 'expired');
    assert.equal(m.checkCoupon({ percent: 5, uses: 3, maxUses: 3 }, 500, now).result, 'usedUp');
  });

  it('one order per seller, shares add up, affiliates skipped, short stock caught', () => {
    const r = m.priceCart(
      [
        { productId: 'food', qty: 1 },
        { productId: 'chew', qty: 1 },
        { productId: 'ball', qty: 1 },
        { productId: 'aff', qty: 1 },
      ],
      products,
      { plus: false, s, coupon: { percent: 10, maxDiscount: 200 }, now },
    );
    assert.deepEqual(r.groups.map((g) => g.sellerId), ['s1', 's2']);
    assert.equal(r.subtotal, 3899 + 399 + 249);
    assert.equal(r.discount, 200);
    assert.equal(r.groups.reduce((a, g) => a + g.total, 0), r.total);
    assert.equal(r.groups[0].commission, Math.round(3899 * 0.08) + Math.round(399 * 0.15));
    const short = m.priceCart([{ productId: 'ball', qty: 2 }], products, { plus: false, s, now });
    assert.deepEqual(short.short, ['ball']);
  });

  it('allocation, expenses, invoice and order numbers', () => {
    assert.deepEqual(m.allocate(100, [1, 1, 1]), [34, 33, 33]);
    assert.deepEqual(m.allocate(49, [3899, 249]), [46, 3]);
    const parts = m.expenseSplit(
      [
        { category: 'food', price: 3899, qty: 1 },
        { category: 'toys', price: 399, qty: 1 },
      ],
      4249,
    );
    assert.equal(parts.reduce((a, p) => a + p.amount, 0), 4249);
    assert.equal(m.invoiceNumber(new Date(2026, 9, 14), 123), 'PS/26-27/00123');
    assert.equal(m.invoiceNumber(new Date(2027, 1, 1), 7), 'PS/26-27/00007');
    // Same short number as the app (shortOrderNo in shop_rules.dart).
    assert.equal(m.shortOrderNo('ord_1'), 'PS806099');
  });
});
