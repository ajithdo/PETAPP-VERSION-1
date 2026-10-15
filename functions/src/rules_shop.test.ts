/**
 * Security-rules tests for the marketplace (Phase 8): products, orders,
 * carts, expenses, subscriptions, coupons and partner-store clicks.
 * Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { addDoc, collection, doc, getDoc, setDoc, updateDoc } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-pawsetu-rules-shop',
    firestore: { rules: readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8') },
  });
});

after(async () => env?.cleanup());

const order = {
  ownerId: 'priya',
  sellerId: 'seller_1',
  sellerUids: ['sellerUid'],
  groupId: 'g1',
  items: [{ productId: 'food', qty: 1, price: 3899 }],
  subtotal: 3899,
  discount: 0,
  coupon: null,
  deliveryFee: 0,
  total: 3899,
  commission: 312,
  payout: 3587,
  payoutStatus: 'pending',
  invoiceNo: 'PS/26-27/00001',
  status: 'placed',
  paymentStatus: 'paid',
};

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'sellers/seller_1'), { name: 'Tail Treats', uid: 'sellerUid', status: 'approved' });
    await setDoc(doc(db, 'sellers/seller_2'), { name: 'Other', uid: 'otherSeller', status: 'approved' });
    await setDoc(doc(db, 'products/food'), { name: 'Food', sellerId: 'seller_1', price: 3899, stock: 10, rating: 4.5, reviewCount: 20 });
    await setDoc(doc(db, 'orders/o1'), order);
    await setDoc(doc(db, 'orders/o2'), { ...order, paymentStatus: 'pending' });
    await setDoc(doc(db, 'coupons/WELCOME10'), { percent: 10, uses: 1 });
  });
});

const as = (uid: string, role = 'owner') => env.authenticatedContext(uid, { role }).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe('products', () => {
  it('anyone can browse; a seller edits only their own products, never ratings', async () => {
    await assertSucceeds(getDoc(doc(anon(), 'products/food')));
    await assertSucceeds(updateDoc(doc(as('sellerUid', 'seller'), 'products/food'), { price: 3799, stock: 8 }));
    await assertFails(updateDoc(doc(as('sellerUid', 'seller'), 'products/food'), { rating: 5 }));
    await assertFails(updateDoc(doc(as('otherSeller', 'seller'), 'products/food'), { price: 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'products/food'), { stock: 999 }));
  });
  it('sellers add products only under their own store', async () => {
    await assertSucceeds(setDoc(doc(as('sellerUid', 'seller'), 'products/new1'), { name: 'Biscuits', sellerId: 'seller_1', price: 249, stock: 40 }));
    await assertFails(setDoc(doc(as('sellerUid', 'seller'), 'products/new2'), { name: 'X', sellerId: 'seller_2', price: 249, stock: 40 }));
    await assertFails(setDoc(doc(as('sellerUid', 'seller'), 'products/new3'), { name: 'X', sellerId: 'seller_1', price: 249, stock: 40, rating: 5, reviewCount: 99 }));
  });
});

describe('orders', () => {
  it('only the buyer, the seller and admins can see an order', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'orders/o1')));
    await assertSucceeds(getDoc(doc(as('sellerUid', 'seller'), 'orders/o1')));
    await assertFails(getDoc(doc(as('ravi'), 'orders/o1')));
    await assertFails(getDoc(doc(as('otherSeller', 'seller'), 'orders/o1')));
  });
  it('orders are created only by the createOrder function', async () => {
    await assertFails(setDoc(doc(as('priya'), 'orders/new'), { ...order, total: 1 }));
  });
  it('the buyer can cancel or ask for a return, but not touch money or mark it paid', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'orders/o1'), { status: 'cancelled', cancelReason: 'Changed my mind' }));
    await assertFails(updateDoc(doc(as('priya'), 'orders/o1'), { status: 'delivered' }));
    await assertFails(updateDoc(doc(as('priya'), 'orders/o1'), { total: 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'orders/o1'), { paymentStatus: 'refunded' }));
    // A pending demo payment can be completed.
    await assertSucceeds(updateDoc(doc(as('priya'), 'orders/o2'), { paymentStatus: 'paid' }));
  });
  it('the seller moves the order along but cannot change money, payouts or payment', async () => {
    await assertSucceeds(updateDoc(doc(as('sellerUid', 'seller'), 'orders/o1'), { status: 'packed' }));
    await assertFails(updateDoc(doc(as('sellerUid', 'seller'), 'orders/o1'), { payoutStatus: 'paid' }));
    await assertFails(updateDoc(doc(as('sellerUid', 'seller'), 'orders/o1'), { commission: 0 }));
    await assertFails(updateDoc(doc(as('sellerUid', 'seller'), 'orders/o1'), { paymentStatus: 'refunded' }));
  });
});

describe('carts, expenses, subscriptions, coupons, clicks', () => {
  it('a cart belongs to one person', async () => {
    await assertSucceeds(setDoc(doc(as('priya'), 'carts/priya'), { items: [{ productId: 'food', qty: 1 }] }));
    await assertFails(getDoc(doc(as('ravi'), 'carts/priya')));
  });
  it('expenses and subscriptions are private', async () => {
    await assertSucceeds(setDoc(doc(as('priya'), 'expenses/e1'), { ownerId: 'priya', amount: 500, category: 'food' }));
    await assertFails(setDoc(doc(as('priya'), 'expenses/e2'), { ownerId: 'ravi', amount: 500, category: 'food' }));
    await assertFails(getDoc(doc(as('ravi'), 'expenses/e1')));
    await assertSucceeds(setDoc(doc(as('priya'), 'subscriptions/s1'), { ownerId: 'priya', productId: 'food', everyWeeks: 4 }));
    await assertFails(getDoc(doc(as('ravi'), 'subscriptions/s1')));
  });
  it('coupons are read-only for shoppers', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'coupons/WELCOME10')));
    await assertFails(updateDoc(doc(as('priya'), 'coupons/WELCOME10'), { uses: 0 }));
  });
  it('partner-store clicks are recorded as yourself and read only by admins', async () => {
    await assertSucceeds(addDoc(collection(as('priya'), 'affiliateClicks'), { uid: 'priya', productId: 'aff', partnerId: 'p1' }));
    await assertFails(addDoc(collection(as('priya'), 'affiliateClicks'), { uid: 'ravi', productId: 'aff', partnerId: 'p1' }));
    await assertFails(getDoc(doc(as('priya'), 'affiliateClicks/x')));
  });
});
