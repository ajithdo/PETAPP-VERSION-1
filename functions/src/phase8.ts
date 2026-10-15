/**
 * Phase 8 Cloud Functions: marketplace orders and what follows them.
 *
 * - createOrder: prices the cart on the server (one order per seller),
 *   checks stock and the coupon in a transaction, writes the orders, the
 *   pet's expenses and the sellers' notifications.
 * - onOrderUpdated: refunds and restocks cancelled or returned orders,
 *   opens a delivered food bag for the pet, and tells the other side.
 * - onAffiliateClick, onProductReview: partner-store click counts and
 *   product ratings (clients cannot write those).
 * - runSubscriptions (daily) and runSellerPayouts (seller, demo payouts).
 *
 * The money rules mirror lib/features/shop/domain/shop_rules.dart, which
 * is unit tested in Dart; phase8.test.ts checks the same numbers here.
 * Version 1 trusts the demo payment sheet's outcome; Live phase L2
 * verifies Razorpay signatures before an order counts as paid.
 */
import { randomInt } from 'node:crypto';

import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { onDocumentCreated, onDocumentUpdated } from 'firebase-functions/v2/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';

const db = getFirestore();

// ---------- rules (same as shop_rules.dart) ----------

export type Settings = { food: number; other: number; categories: Record<string, number>; fee: number; freeAbove: number; plusFreeAbove: number };

export function settingsFrom(cfg: Record<string, any> | undefined): Settings {
  const c = cfg?.commission ?? {};
  const s = cfg?.shop ?? {};
  return {
    food: typeof c.foodMarginPercent === 'number' ? c.foodMarginPercent : 8,
    other: typeof c.otherMarginPercent === 'number' ? c.otherMarginPercent : 15,
    categories: c.categoryPercent ?? {},
    fee: typeof s.deliveryFee === 'number' ? s.deliveryFee : 49,
    freeAbove: typeof s.freeDeliveryAbove === 'number' ? s.freeDeliveryAbove : 999,
    plusFreeAbove: typeof c.freeDeliveryAbove === 'number' ? c.freeDeliveryAbove : 499,
  };
}

export function commissionPercent(category: string, s: Settings, sellerOverride?: unknown): number {
  if (typeof sellerOverride === 'number') return sellerOverride;
  if (sellerOverride && typeof sellerOverride === 'object' && typeof (sellerOverride as any)[category] === 'number') return (sellerOverride as any)[category];
  if (typeof s.categories[category] === 'number') return s.categories[category];
  return category === 'food' ? s.food : s.other;
}

export type CouponResult = 'ok' | 'notFound' | 'inactive' | 'expired' | 'minOrder' | 'usedUp';

const toDate = (v: unknown): Date | null => (v instanceof Timestamp ? v.toDate() : v instanceof Date ? v : null);

export function checkCoupon(c: Record<string, any> | undefined, subtotal: number, now: Date): { result: CouponResult; discount: number } {
  if (!c) return { result: 'notFound', discount: 0 };
  if (c.active === false) return { result: 'inactive', discount: 0 };
  const till = toDate(c.validTill);
  if (till && till.getTime() < now.getTime()) return { result: 'expired', discount: 0 };
  if (typeof c.maxUses === 'number' && (c.uses ?? 0) >= c.maxUses) return { result: 'usedUp', discount: 0 };
  if (subtotal < (c.minOrder ?? 0)) return { result: 'minOrder', discount: 0 };
  let d = 0;
  if (typeof c.percent === 'number') d = Math.round((subtotal * c.percent) / 100);
  if (typeof c.flat === 'number') d = c.flat;
  if (typeof c.maxDiscount === 'number' && d > c.maxDiscount) d = c.maxDiscount;
  if (d > subtotal) d = subtotal;
  return { result: 'ok', discount: d };
}

export function deliveryFee(amount: number, plus: boolean, s: Settings): number {
  if (amount <= 0) return 0;
  return amount >= (plus ? s.plusFreeAbove : s.freeAbove) ? 0 : s.fee;
}

/** Splits [amount] in proportion to [weights]; the parts add up exactly. */
export function allocate(amount: number, weights: number[]): number[] {
  if (weights.length === 0) return [];
  const total = weights.reduce((a, b) => a + b, 0);
  if (total <= 0) return [amount, ...weights.slice(1).map(() => 0)];
  const exact = weights.map((w) => (amount * w) / total);
  const out = exact.map((e) => Math.floor(e));
  let left = amount - out.reduce((a, b) => a + b, 0);
  const order = weights.map((_, i) => i).sort((a, b) => exact[b] - out[b] - (exact[a] - out[a]));
  for (const i of order) {
    if (left <= 0) break;
    out[i]++;
    left--;
  }
  return out;
}

export function invoiceNumber(at: Date, seq: number): string {
  const fy = at.getMonth() >= 3 ? at.getFullYear() : at.getFullYear() - 1;
  const yy = (y: number) => String(y % 100).padStart(2, '0');
  return `PS/${yy(fy)}-${yy(fy + 1)}/${String(seq).padStart(5, '0')}`;
}

export function shortOrderNo(orderId: string): string {
  let h = 0;
  for (let i = 0; i < orderId.length; i++) h = (h * 31 + orderId.charCodeAt(i)) & 0x7fffffff;
  return `PS${(h % 900000) + 100000}`;
}

export type Line = { productId: string; qty: number };
export type PricedLine = { id: string; p: Record<string, any>; qty: number; pct: number; amount: number; commission: number };
export type Group = { sellerId: string; lines: PricedLine[]; subtotal: number; commission: number; deliveryDays: number; discount: number; fee: number; total: number };

export function priceCart(
  lines: Line[],
  products: Record<string, Record<string, any>>,
  opts: { plus: boolean; s: Settings; overrides?: Record<string, unknown>; coupon?: Record<string, any>; now: Date },
): { groups: Group[]; subtotal: number; discount: number; fee: number; total: number; coupon: CouponResult | null; short: string[] } {
  const by: Record<string, PricedLine[]> = {};
  const short: string[] = [];
  for (const l of lines) {
    const p = products[l.productId];
    if (!p || p.partnerId || p.active === false || !p.sellerId || !(l.qty > 0)) continue;
    const stock = typeof p.stock === 'number' ? p.stock : 0;
    if (l.qty > stock) {
      short.push(l.productId);
      continue;
    }
    const pct = commissionPercent(p.category, opts.s, opts.overrides?.[p.sellerId]);
    const amount = p.price * l.qty;
    (by[p.sellerId] ??= []).push({ id: l.productId, p, qty: l.qty, pct, amount, commission: Math.round((amount * pct) / 100) });
  }
  const groups: Group[] = Object.entries(by).map(([sellerId, ls]) => ({
    sellerId,
    lines: ls,
    subtotal: ls.reduce((a, l) => a + l.amount, 0),
    commission: ls.reduce((a, l) => a + l.commission, 0),
    deliveryDays: ls.reduce((m, l) => Math.max(m, l.p.deliveryDays ?? 3), 0),
    discount: 0,
    fee: 0,
    total: 0,
  }));
  const subtotal = groups.reduce((a, g) => a + g.subtotal, 0);
  const c = opts.coupon === undefined ? null : checkCoupon(opts.coupon, subtotal, opts.now);
  const discount = c?.result === 'ok' ? c.discount : 0;
  const fee = deliveryFee(subtotal - discount, opts.plus, opts.s);
  const d = allocate(discount, groups.map((g) => g.subtotal));
  const f = allocate(fee, groups.map((g) => g.subtotal));
  groups.forEach((g, i) => {
    g.discount = d[i];
    g.fee = f[i];
    g.total = g.subtotal - g.discount + g.fee;
  });
  return { groups, subtotal, discount, fee, total: subtotal - discount + fee, coupon: c?.result ?? null, short };
}

/** Food and treats vs everything else, sharing the order total. */
export function expenseSplit(items: { category: string; price: number; qty: number }[], total: number): { category: string; amount: number }[] {
  let food = 0;
  let other = 0;
  for (const i of items) {
    if (i.category === 'food' || i.category === 'treats') food += i.price * i.qty;
    else other += i.price * i.qty;
  }
  const [f, o] = allocate(total, [food, other]);
  return [...(food > 0 ? [{ category: 'food', amount: f }] : []), ...(other > 0 ? [{ category: 'supplies', amount: o }] : [])];
}

function addWorkingDays(d: Date, days: number): Date {
  const out = new Date(d.getFullYear(), d.getMonth(), d.getDate());
  let left = days;
  while (left > 0) {
    out.setDate(out.getDate() + 1);
    if (out.getDay() !== 0) left--;
  }
  return out;
}

// ---------- notifications in each person's language ----------

const T: Record<string, Record<'en' | 'hi' | 'te', string>> = {
  newOrder: { en: 'New order: {item}', hi: 'नया ऑर्डर: {item}', te: 'కొత్త ఆర్డర్: {item}' },
  cancelledByCustomer: { en: 'Order {number} was cancelled by the customer', hi: 'ग्राहक ने ऑर्डर {number} रद्द किया', te: 'కస్టమర్ ఆర్డర్ {number} రద్దు చేశారు' },
  cancelledBySeller: {
    en: 'Sorry, the seller cancelled your order for {item}. Any payment is refunded.',
    hi: 'माफ़ कीजिए, विक्रेता ने {item} का ऑर्डर रद्द किया। भुगतान वापस होगा।',
    te: 'క్షమించండి, అమ్మకందారు {item} ఆర్డర్ రద్దు చేశారు. చెల్లింపు తిరిగి వస్తుంది.',
  },
  packed: { en: '{item} is packed', hi: '{item} पैक हो गया', te: '{item} ప్యాక్ అయింది' },
  shipped: { en: '{item} is on the way', hi: '{item} रास्ते में है', te: '{item} దారిలో ఉంది' },
  out_for_delivery: { en: '{item} is out for delivery today', hi: '{item} आज डिलीवरी के लिए निकला', te: '{item} ఈరోజు డెలివరీకి బయలుదేరింది' },
  delivered: { en: '{item} was delivered', hi: '{item} डिलीवर हो गया', te: '{item} డెలివరీ అయింది' },
  returned: { en: 'Return accepted for {item}. Your refund is on its way.', hi: '{item} की वापसी मंज़ूर। रिफ़ंड आ रहा है।', te: '{item} రిటర్న్ అంగీకరించారు. డబ్బు తిరిగి వస్తోంది.' },
  return_rejected: { en: 'Return declined for {item}. Tap for help.', hi: '{item} की वापसी नामंज़ूर। मदद के लिए टैप करें।', te: '{item} రిటర్న్ తిరస్కరించారు. సహాయం కోసం ట్యాప్ చేయండి.' },
  return_requested: { en: 'Return requested for order {number}', hi: 'ऑर्डर {number} की वापसी माँगी गई', te: 'ఆర్డర్ {number} రిటర్న్ కోరారు' },
  subscription: { en: 'Auto-reorder placed: {item}', hi: 'ऑटो-ऑर्डर हुआ: {item}', te: 'ఆటో రీఆర్డర్ చేశాం: {item}' },
};

async function notify(uid: string, key: keyof typeof T, vars: Record<string, string>, link: string) {
  const u = (await db.collection('users').doc(uid).get()).data();
  const lang = (['hi', 'te'].includes(u?.language) ? u!.language : 'en') as 'en' | 'hi' | 'te';
  let title = T[key][lang];
  for (const [k, v] of Object.entries(vars)) title = title.split(`{${k}}`).join(v);
  await db.collection('notifications').add({ uid, title, body: '', type: 'orders', link, read: false, createdAt: FieldValue.serverTimestamp() });
  return { title, phone: u?.phone as string | undefined };
}

// ---------- placing orders ----------

type PlaceInput = {
  lines: Line[];
  couponCode?: string | null;
  address: Record<string, string>;
  slot: { date: Date; window: string };
  petId?: string | null;
  paymentMethod: 'online' | 'cod';
  paymentStatus: 'paid' | 'pending' | 'cod';
  source: 'cart' | 'reorder' | 'subscription';
  subscriptionId?: string | null;
};

const WINDOWS = ['09-12', '12-15', '15-18', '18-21'];

export async function placeOrder(uid: string, input: PlaceInput): Promise<{ groupId: string; orderIds: string[] }> {
  const now = new Date();
  const groupId = db.collection('orders').doc().id;
  const orderIds: string[] = [];
  const written: { id: string; data: Record<string, any> }[] = [];
  await db.runTransaction(async (tx) => {
    const userSnap = await tx.get(db.collection('users').doc(uid));
    const user = userSnap.data() ?? {};
    const cfg = (await tx.get(db.collection('config').doc('app'))).data();
    const products: Record<string, Record<string, any>> = {};
    for (const l of input.lines) {
      const d = await tx.get(db.collection('products').doc(l.productId));
      if (d.exists) products[d.id] = d.data()!;
    }
    const sellerIds = [...new Set(Object.values(products).map((p) => p.sellerId).filter((x): x is string => typeof x === 'string'))];
    const sellers: Record<string, Record<string, any>> = {};
    for (const id of sellerIds) {
      const d = await tx.get(db.collection('sellers').doc(id));
      if (d.exists) sellers[id] = d.data()!;
    }
    let coupon: Record<string, any> | undefined;
    const code = (input.couponCode ?? '').trim().toUpperCase().replace(/\s+/g, '');
    if (code) {
      const d = await tx.get(db.collection('coupons').doc(code));
      if (!d.exists) throw new HttpsError('failed-precondition', 'coupon');
      coupon = d.data()!;
    }
    let pet: Record<string, any> | undefined;
    if (input.petId) {
      pet = (await tx.get(db.collection('pets').doc(input.petId))).data();
      if (!pet || !(pet.memberIds ?? []).includes(uid)) throw new HttpsError('permission-denied', 'pet');
    }
    const plus = user.plan === 'plus' || user.plan === 'trial';
    const price = priceCart(input.lines, products, {
      plus,
      s: settingsFrom(cfg),
      overrides: Object.fromEntries(Object.entries(sellers).map(([id, s]) => [id, s.commissionPercent])),
      coupon: code ? coupon : undefined,
      now,
    });
    if (price.short.length) throw new HttpsError('failed-precondition', 'stock');
    if (price.groups.length === 0) throw new HttpsError('failed-precondition', 'empty');
    if (code && price.coupon !== 'ok') throw new HttpsError('failed-precondition', 'coupon');

    let seq = randomInt(10000, 99999);
    for (const g of price.groups) {
      const ref = db.collection('orders').doc();
      const seller = sellers[g.sellerId] ?? {};
      const expected = addWorkingDays(now, g.deliveryDays);
      const data: Record<string, any> = {
        groupId,
        ownerId: uid,
        ownerName: user.name ?? '',
        petId: input.petId ?? null,
        petName: pet?.name ?? null,
        sellerId: g.sellerId,
        sellerName: seller.name ?? '',
        sellerUids: seller.uid ? [seller.uid] : [],
        items: g.lines.map((l) => ({
          productId: l.id,
          name: l.p.name,
          brand: l.p.brand ?? '',
          category: l.p.category,
          qty: l.qty,
          price: l.p.price,
          mrp: l.p.mrp ?? l.p.price,
          commissionPercent: l.pct,
          commission: l.commission,
          packKg: l.p.packKg ?? null,
          returnable: l.p.returnable ?? true,
          imageSeed: l.p.imageSeed ?? 0,
        })),
        subtotal: g.subtotal,
        discount: g.discount,
        coupon: code || null,
        deliveryFee: g.fee,
        total: g.total,
        commission: g.commission,
        payout: g.subtotal - g.commission,
        payoutStatus: 'pending',
        tax: { gstPercent: null, gstAmount: 0 },
        address: input.address,
        slot: { date: Timestamp.fromDate(input.slot.date), window: input.slot.window },
        expectedBy: Timestamp.fromDate(input.slot.date > expected ? input.slot.date : expected),
        status: 'placed',
        timeline: [{ status: 'placed', at: Timestamp.fromDate(now) }],
        paymentMethod: input.paymentMethod,
        paymentStatus: input.paymentMethod === 'cod' ? 'cod' : input.paymentStatus,
        invoiceNo: invoiceNumber(now, seq++),
        source: input.source,
        subscriptionId: input.subscriptionId ?? null,
        reviewed: {},
        createdAt: Timestamp.fromDate(now),
      };
      tx.set(ref, data);
      orderIds.push(ref.id);
      written.push({ id: ref.id, data });
      for (const l of g.lines) tx.update(db.collection('products').doc(l.id), { stock: FieldValue.increment(-l.qty) });
    }
    if (code) tx.update(db.collection('coupons').doc(code), { uses: FieldValue.increment(1) });
  });

  for (const { id, data } of written) {
    const first = data.items[0].name as string;
    const note = data.items.length === 1 ? first : `${first} +${data.items.length - 1}`;
    for (const part of expenseSplit(data.items, data.total)) {
      await db.collection('expenses').doc(`exp_${id}_${part.category}`).set({
        ownerId: uid,
        petId: data.petId,
        category: part.category,
        amount: part.amount,
        date: data.createdAt,
        note,
        source: 'order',
        sourceId: id,
      });
    }
    for (const s of data.sellerUids as string[]) await notify(s, 'newOrder', { item: first }, `/partner/order/${id}`);
  }
  return { groupId, orderIds };
}

export const createOrder = onCall(async (req) => {
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign in first');
  const d = req.data ?? {};
  const lines: Line[] = Array.isArray(d.lines)
    ? d.lines.slice(0, 30).map((l: any) => ({ productId: String(l?.productId ?? ''), qty: Math.max(0, Math.min(20, Math.floor(Number(l?.qty) || 0))) }))
    : [];
  if (!lines.length) throw new HttpsError('invalid-argument', 'empty');
  const a = d.address ?? {};
  const address = Object.fromEntries(['id', 'label', 'name', 'phone', 'line1', 'line2', 'area', 'city', 'pin'].map((k) => [k, String(a[k] ?? '').slice(0, 200)]));
  if (!/^[1-9][0-9]{5}$/.test(address.pin) || !address.line1 || !address.city) throw new HttpsError('invalid-argument', 'address');
  const date = new Date(String(d.slot?.date ?? ''));
  const window = String(d.slot?.window ?? '');
  if (Number.isNaN(date.getTime()) || !WINDOWS.includes(window)) throw new HttpsError('invalid-argument', 'slot');
  const method = d.paymentMethod === 'cod' ? 'cod' : 'online';
  const status = method === 'cod' ? 'cod' : d.paymentStatus === 'pending' ? 'pending' : 'paid';
  const source = d.source === 'reorder' ? 'reorder' : 'cart';
  return placeOrder(uid, {
    lines,
    couponCode: typeof d.couponCode === 'string' ? d.couponCode : null,
    address,
    slot: { date, window },
    petId: typeof d.petId === 'string' ? d.petId : null,
    paymentMethod: method,
    paymentStatus: status,
    source,
  });
});

// ---------- after the order ----------

export const onOrderUpdated = onDocumentUpdated('orders/{id}', async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after || before.status === after.status) return;
  const id = event.params.id;
  const ref = event.data!.after.ref;
  const first = (after.items?.[0]?.name as string) ?? '';
  const number = shortOrderNo(id);
  const status = after.status as string;

  if (status === 'cancelled' || status === 'returned') {
    const batch = db.batch();
    for (const i of after.items ?? []) batch.update(db.collection('products').doc(i.productId), { stock: FieldValue.increment(i.qty) });
    for (const c of ['food', 'supplies']) batch.delete(db.collection('expenses').doc(`exp_${id}_${c}`));
    if (after.paymentStatus === 'paid') batch.update(ref, { paymentStatus: 'refunded' });
    await batch.commit();
  }

  if (status === 'cancelled') {
    if (after.cancelledBy === 'seller') await notify(after.ownerId, 'cancelledBySeller', { item: first }, `/shop/orders/${id}`);
    else for (const s of after.sellerUids ?? []) await notify(s, 'cancelledByCustomer', { number }, `/partner/order/${id}`);
    return;
  }
  if (status === 'return_requested') {
    for (const s of after.sellerUids ?? []) await notify(s, 'return_requested', { number }, `/partner/order/${id}`);
    return;
  }
  if (status === 'delivered') await openFoodBag(after);
  if (['packed', 'shipped', 'out_for_delivery', 'delivered', 'returned', 'return_rejected'].includes(status)) {
    const n = await notify(after.ownerId, status as keyof typeof T, { item: first }, `/shop/orders/${id}`);
    if (status === 'out_for_delivery') {
      // Demo mode: the SMS goes to the Demo Outbox (Live phase L3 sends it).
      await db.collection('outbox').add({ channel: 'sms', to: n.phone ?? after.ownerId, body: n.title, uid: after.ownerId, type: 'orders', createdAt: FieldValue.serverTimestamp() });
    }
  }
});

/** A delivered food bag becomes the pet's current bag, opened when the old one runs out. */
async function openFoodBag(order: Record<string, any>) {
  if (!order.petId) return;
  const food = (order.items ?? []).find((i: any) => i.category === 'food' && (i.packKg ?? 0) > 0);
  if (!food) return;
  const petRef = db.collection('pets').doc(order.petId);
  const pet = (await petRef.get()).data();
  if (!pet) return;
  const now = new Date();
  const opened = toDate(pet.foodOpenedAt);
  const oldRunOut = opened && pet.foodBagKg > 0 && pet.dailyPortionG > 0 ? new Date(opened.getTime() + ((pet.foodBagKg * 1000) / pet.dailyPortionG) * 86400000) : null;
  await petRef.update({
    foodProductId: food.productId,
    foodBagKg: food.packKg * food.qty,
    foodOpenedAt: Timestamp.fromDate(oldRunOut && oldRunOut > now ? oldRunOut : now),
  });
}

export const onAffiliateClick = onDocumentCreated('affiliateClicks/{id}', async (event) => {
  const partnerId = event.data?.data().partnerId;
  if (typeof partnerId !== 'string') return;
  const ref = db.collection('partners').doc(partnerId);
  if ((await ref.get()).exists) await ref.update({ clicks: FieldValue.increment(1) });
});

export const onProductReview = onDocumentCreated('reviews/{id}', async (event) => {
  const r = event.data?.data();
  if (!r || r.targetType !== 'product' || typeof r.targetId !== 'string') return;
  const rating = Math.max(1, Math.min(5, Math.round(Number(r.rating) || 0)));
  await db.runTransaction(async (tx) => {
    const ref = db.collection('products').doc(r.targetId);
    const p = (await tx.get(ref)).data();
    if (!p) return;
    const n = (p.reviewCount ?? 0) + 1;
    const avg = ((p.rating ?? 0) * (p.reviewCount ?? 0) + rating) / n;
    tx.update(ref, { rating: Math.round(avg * 10) / 10, reviewCount: n });
  });
});

/** Daily: places due auto-reorders (pay on delivery) and moves them on. */
export const runSubscriptions = onSchedule({ schedule: 'every day 06:00', timeZone: 'Asia/Kolkata' }, async () => {
  const now = new Date();
  const due = await db.collection('subscriptions').where('active', '==', true).where('nextAt', '<=', Timestamp.fromDate(now)).get();
  for (const doc of due.docs) {
    const s = doc.data();
    const date = addWorkingDays(now, 2);
    try {
      const r = await placeOrder(s.ownerId, {
        lines: [{ productId: s.productId, qty: s.qty ?? 1 }],
        address: s.address ?? {},
        slot: { date, window: '18-21' },
        petId: s.petId ?? null,
        paymentMethod: 'cod',
        paymentStatus: 'cod',
        source: 'subscription',
        subscriptionId: doc.id,
      });
      const next = new Date(now.getFullYear(), now.getMonth(), now.getDate() + (s.everyWeeks ?? 4) * 7, 9);
      await doc.ref.update({ nextAt: Timestamp.fromDate(next), lastOrderGroup: r.groupId, lastRunAt: Timestamp.fromDate(now) });
      await notify(s.ownerId, 'subscription', { item: s.productName ?? '' }, '/shop/orders');
    } catch {
      // Out of stock: try again tomorrow.
      await doc.ref.update({ nextAt: Timestamp.fromDate(new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1, 9)) });
    }
  }
});

/** Seller: weekly payout run (simulated in Version 1). */
export const runSellerPayouts = onCall(async (req) => {
  const uid = req.auth?.uid;
  if (!uid || req.auth?.token.role !== 'seller') throw new HttpsError('permission-denied', 'Sellers only');
  const seller = await db.collection('sellers').where('uid', '==', uid).limit(1).get();
  if (seller.empty) throw new HttpsError('failed-precondition', 'No seller');
  const cutoff = Date.now() - 7 * 86400000;
  const orders = await db.collection('orders').where('sellerId', '==', seller.docs[0].id).get();
  let count = 0;
  let amount = 0;
  const batch = db.batch();
  for (const o of orders.docs) {
    const d = o.data();
    const delivered = toDate(d.deliveredAt);
    if (!['delivered', 'return_rejected'].includes(d.status) || d.payoutStatus === 'paid' || !delivered || delivered.getTime() > cutoff) continue;
    batch.update(o.ref, { payoutStatus: 'paid', paidOutAt: FieldValue.serverTimestamp() });
    count++;
    amount += d.payout ?? 0;
  }
  await batch.commit();
  return { count, amount };
});
