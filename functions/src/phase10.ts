/**
 * Phase 10 Cloud Functions: admin panel, PawSetu Plus, referrals, help and
 * complaints, privacy centre.
 *
 * - reviewPartner (admin): approve, reject (with a reason) or suspend a
 *   listing. Approval gives the partner's sign-in its role (custom claim).
 * - setUserSuspended (admin): pauses an account (sign-in disabled) or
 *   restores it.
 * - startTrial, buyPlus: the 7-day free trial (once per person) and the
 *   demo purchase. Prices and trial length come from config/app, never from
 *   the app. Payments in Version 1 are simulated.
 * - redeemReferral: both friends get a coupon; one referral per person.
 * - exportMyData: "Download my data" as JSON.
 * - expirePlans (nightly): ends trials and paid periods, or renews them
 *   (demo) when auto-renew is on.
 * - purgeDeletedAccounts (nightly): deletes accounts 30 days after the
 *   person asked; money records are kept but anonymised.
 * - Plan limits on the server: onPetCreatedLimit (pets), onPetMembersLimit
 *   (family size), onAlbumVideoLimit (video length). Tele-vet, Ask PawSetu
 *   and storage limits are in phase6.ts and phase7.ts.
 * - onTicketWritten: tells support about new tickets and the person about
 *   replies, resolution and refunds, in their own language.
 *
 * The pure rules mirror lib/features/plans/domain/plan_rules.dart,
 * lib/features/admin/domain/support.dart and privacy.dart (unit tested in
 * Dart); phase10.test.ts checks the same cases here.
 */
import { getAuth } from 'firebase-admin/auth';
import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { onDocumentCreated, onDocumentUpdated, onDocumentWritten } from 'firebase-functions/v2/firestore';
import { CallableRequest, HttpsError, onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';

const db = getFirestore();

// ---------- pure rules (mirrored in Dart) ----------

export const DELETION_GRACE_DAYS = 30;
export const PARTNER_COLLECTIONS = ['clinics', 'vets', 'providers', 'sellers'] as const;

export type Prices = { monthly: number; yearly: number; trialDays: number };

export function pricesFromConfig(cfg: Record<string, any> | undefined): Prices {
  const p = cfg?.plans ?? {};
  return { monthly: Number(p.plusMonthly ?? 99), yearly: Number(p.plusYearly ?? 799), trialDays: Number(p.trialDays ?? 7) };
}

const toDate = (v: unknown): Date | null => (v instanceof Timestamp ? v.toDate() : v instanceof Date ? v : null);

/** The plan that applies now: an ended trial or paid period counts as free. */
export function effectivePlan(plan: unknown, trialEndsAt: unknown, planRenewsAt: unknown, now: Date): 'free' | 'trial' | 'plus' {
  if (plan === 'trial') {
    const end = toDate(trialEndsAt);
    return end && end.getTime() > now.getTime() ? 'trial' : 'free';
  }
  if (plan === 'plus') {
    const end = toDate(planRenewsAt);
    return !end || end.getTime() > now.getTime() ? 'plus' : 'free';
  }
  return 'free';
}

/** The free trial can be taken once per person. */
export function canStartTrial(plan: string, trialUsedAt: unknown): boolean {
  return plan === 'free' && trialUsedAt == null;
}

export function trialEnd(start: Date, p: Prices): Date {
  return new Date(start.getTime() + p.trialDays * 86_400_000);
}

/** The next renewal for a paid period starting at [start] (same day next month or year). */
export function renewalDate(start: Date, yearly: boolean): Date {
  const d = new Date(start.getTime());
  if (yearly) d.setFullYear(d.getFullYear() + 1);
  else d.setMonth(d.getMonth() + 1);
  return d;
}

export function deletionDate(requestedAt: Date): Date {
  return new Date(requestedAt.getTime() + DELETION_GRACE_DAYS * 86_400_000);
}

/** approve → approved, reject → rejected, suspend → suspended. */
export function statusForDecision(decision: string): 'approved' | 'rejected' | 'suspended' | null {
  return ({ approve: 'approved', reject: 'rejected', suspend: 'suspended' } as Record<string, 'approved' | 'rejected' | 'suspended'>)[decision] ?? null;
}

/** open → in_progress when support replies; resolved → open when the person replies. */
export function statusAfterMessage(current: string, fromAdmin: boolean): string {
  if (fromAdmin) return current === 'open' ? 'in_progress' : current;
  return current === 'resolved' ? 'open' : current;
}

/** Refunds are simulated in Version 1 and can't exceed what was paid. */
export function ticketRefundAmount(requested: number, paid: number): number {
  return requested < 0 ? 0 : Math.min(requested, paid);
}

const CODE_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

/** Up to four letters of the name and four random characters, e.g. PRIY7K2Q. */
export function newReferralCode(name: string, rnd: () => number = Math.random): string {
  const letters = String(name ?? '').toUpperCase().replace(/[^A-Z]/g, '');
  const head = `${letters}PAWS`.slice(0, 4);
  let tail = '';
  for (let i = 0; i < 4; i++) tail += CODE_CHARS[Math.floor(rnd() * CODE_CHARS.length) % CODE_CHARS.length];
  return head + tail;
}

/** A one-person reward coupon code, e.g. REF7KQ2PA. */
export function rewardCouponCode(rnd: () => number = Math.random): string {
  let s = 'REF';
  for (let i = 0; i < 6; i++) s += CODE_CHARS[Math.floor(rnd() * CODE_CHARS.length) % CODE_CHARS.length];
  return s;
}

/** The partner role a listing gives its owner on approval. */
export function roleForListing(collection: string, listing: Record<string, any>): string {
  if (collection === 'clinics') return 'clinic_admin';
  if (collection === 'vets') return 'vet';
  if (collection === 'sellers') return 'seller';
  return ['groomer', 'trainer', 'boarder', 'walker'].includes(listing.type) ? listing.type : 'groomer';
}

/** Family members besides the owner (spec 8: free 2, Plus 8). */
export function familyOthers(pet: Record<string, any>): string[] {
  return Object.keys(pet.members ?? {}).filter((u) => u !== pet.ownerId);
}

/** What "Download my data" collects (mirrors lib/features/admin/domain/privacy.dart). */
export const EXPORT_PARTS: { collection: string; field: string; byPet?: boolean; arrayContains?: boolean }[] = [
  { collection: 'pets', field: 'ownerId' },
  { collection: 'logs', field: 'byUid' },
  { collection: 'vaccinations', field: 'petId', byPet: true },
  { collection: 'medicines', field: 'petId', byPet: true },
  { collection: 'medicineLogs', field: 'petId', byPet: true },
  { collection: 'healthEvents', field: 'petId', byPet: true },
  { collection: 'reminders', field: 'ownerId' },
  { collection: 'notifications', field: 'uid' },
  { collection: 'bookings', field: 'ownerId' },
  { collection: 'reviews', field: 'ownerId' },
  { collection: 'conversations', field: 'participantIds', arrayContains: true },
  { collection: 'messages', field: 'senderId' },
  { collection: 'consultations', field: 'ownerId' },
  { collection: 'prescriptions', field: 'petId', byPet: true },
  { collection: 'documents', field: 'ownerId' },
  { collection: 'insurance', field: 'ownerId' },
  { collection: 'album', field: 'ownerId' },
  { collection: 'shareLinks', field: 'ownerId' },
  { collection: 'orders', field: 'ownerId' },
  { collection: 'subscriptions', field: 'ownerId' },
  { collection: 'expenses', field: 'ownerId' },
  { collection: 'devices', field: 'ownerId' },
  { collection: 'sosLogs', field: 'uid' },
  { collection: 'lostReports', field: 'ownerId' },
  { collection: 'tickets', field: 'uid' },
  { collection: 'referrals', field: 'referrerId' },
  { collection: 'payments', field: 'uid' },
];

/** Money and booking records are kept for accounts but lose the person's details. */
export const KEEP_ANONYMISED = new Set(['bookings', 'orders', 'payments', 'reviews', 'messages', 'conversations', 'consultations', 'prescriptions']);

/** Firestore values as plain JSON (timestamps as ISO text). */
export function plainJson(v: unknown): unknown {
  if (v == null || typeof v === 'string' || typeof v === 'number' || typeof v === 'boolean') return v ?? null;
  if (v instanceof Timestamp) return v.toDate().toISOString();
  if (v instanceof Date) return v.toISOString();
  if (Array.isArray(v)) return v.map(plainJson);
  if (typeof v === 'object') {
    const ctor = (v as object).constructor?.name;
    if (ctor === 'GeoPoint') return { lat: (v as any).latitude, lng: (v as any).longitude };
    if (ctor === 'DocumentReference') return (v as any).path;
    return Object.fromEntries(Object.entries(v as Record<string, unknown>).map(([k, x]) => [k, plainJson(x)]));
  }
  return String(v);
}

// ---------- texts in each person's language ----------

const T = {
  approved: { en: '{name} is approved and now visible to pet parents', hi: '{name} को मंज़ूरी मिली, अब पालतू माता-पिता को दिखेगा', te: '{name} ఆమోదం పొందింది, ఇప్పుడు పెట్ పేరెంట్స్‌కి కనిపిస్తుంది' },
  rejected: { en: '{name} was not approved', hi: '{name} को मंज़ूरी नहीं मिली', te: '{name}కి ఆమోదం రాలేదు' },
  suspended: { en: '{name} is paused', hi: '{name} को रोका गया है', te: '{name} నిలిపివేయబడింది' },
  supportReply: { en: 'Support replied: {subject}', hi: 'सहायता टीम का जवाब: {subject}', te: 'సహాయ బృందం జవాబు: {subject}' },
  supportResolved: { en: 'Resolved: {subject}', hi: 'हल हो गया: {subject}', te: 'పరిష్కారమైంది: {subject}' },
  refundTitle: { en: 'Refund of ₹{amount} is on its way', hi: '₹{amount} का रिफ़ंड आ रहा है', te: '₹{amount} రిఫండ్ వస్తోంది' },
  refundBody: { en: 'Demo refund: no real money moved.', hi: 'डेमो रिफ़ंड: असली पैसे नहीं गए।', te: 'డెమో రిఫండ్: నిజమైన డబ్బు కదలలేదు.' },
  newForSupport: { en: 'New message from {name}', hi: '{name} का नया संदेश', te: '{name} నుండి కొత్త సందేశం' },
  trialEnded: { en: 'Your Plus trial has ended', hi: 'आपका Plus ट्रायल ख़त्म हो गया', te: 'మీ Plus ట్రయల్ ముగిసింది' },
  trialEndedBody: { en: 'Choose a plan to keep video vet calls, unlimited pets and more.', hi: 'वीडियो डॉक्टर कॉल, असीमित पालतू और बहुत कुछ रखने के लिए प्लान चुनें।', te: 'వీడియో వెట్ కాల్స్, అపరిమిత పెట్స్ కొనసాగించడానికి ప్లాన్ ఎంచుకోండి.' },
  plusEnded: { en: 'PawSetu Plus has ended', hi: 'PawSetu Plus ख़त्म हो गया', te: 'PawSetu Plus ముగిసింది' },
  plusRenewed: { en: 'PawSetu Plus renewed till {date} (demo)', hi: 'PawSetu Plus {date} तक रिन्यू हुआ (डेमो)', te: 'PawSetu Plus {date} వరకు రెన్యూ అయింది (డెమో)' },
  petLimit: { en: 'Pet limit reached', hi: 'पालतू की सीमा पूरी', te: 'పెట్స్ పరిమితి చేరుకుంది' },
  petLimitBody: { en: 'Your plan allows {limit} pets. Upgrade to PawSetu Plus for unlimited pets.', hi: 'आपके प्लान में {limit} पालतू हो सकते हैं। असीमित पालतू के लिए PawSetu Plus लें।', te: 'మీ ప్లాన్‌లో {limit} పెట్స్ మాత్రమే. అపరిమిత పెట్స్ కోసం PawSetu Plus తీసుకోండి.' },
  familyLimit: { en: 'Family limit reached for {pet}', hi: '{pet} के परिवार की सीमा पूरी', te: '{pet} కుటుంబ పరిమితి చేరుకుంది' },
  familyLimitBody: { en: 'The plan allows {limit} family members besides the owner.', hi: 'प्लान में मालिक के अलावा {limit} परिवार सदस्य हो सकते हैं।', te: 'ప్లాన్‌లో యజమాని కాకుండా {limit} కుటుంబ సభ్యులు మాత్రమే.' },
  videoLimit: { en: 'Video too long for your plan', hi: 'वीडियो आपके प्लान के लिए बहुत लंबा है', te: 'మీ ప్లాన్‌కి వీడియో చాలా పొడవుగా ఉంది' },
  videoLimitBody: { en: 'Videos can be up to {limit} seconds. Plus allows longer videos.', hi: 'वीडियो {limit} सेकंड तक हो सकते हैं। Plus में लंबे वीडियो।', te: 'వీడియోలు {limit} సెకన్ల వరకు. Plusలో పొడవైన వీడియోలు.' },
} as const;

type Lang = 'en' | 'hi' | 'te';

function fill(text: string, vars: Record<string, string | number>): string {
  let s = text;
  for (const [k, v] of Object.entries(vars)) s = s.split(`{${k}}`).join(String(v));
  return s;
}

function dateText(d: Date, lang: Lang): string {
  return d.toLocaleDateString(lang === 'en' ? 'en-IN' : `${lang}-IN`, { day: 'numeric', month: 'short', year: 'numeric', timeZone: 'Asia/Kolkata' });
}

/** Notification (and Demo Outbox push) for each person, in their language. */
async function notify(
  uids: Iterable<string>,
  title: keyof typeof T,
  body: keyof typeof T | ((lang: Lang) => string) | null,
  vars: Record<string, string | number>,
  type: string,
  link: string,
  sms = false,
): Promise<void> {
  for (const uid of new Set(uids)) {
    const u = (await db.collection('users').doc(uid).get()).data();
    const lang = (['hi', 'te'].includes(u?.language) ? u!.language : 'en') as Lang;
    const t = fill(T[title][lang], vars);
    const b = typeof body === 'function' ? body(lang) : body ? fill(T[body][lang], vars) : '';
    await db.collection('notifications').add({ uid, title: t, body: b, type, link, read: false, createdAt: FieldValue.serverTimestamp() });
    await db.collection('outbox').add({ channel: 'push', to: uid, subject: t, body: b || t, uid, type, createdAt: FieldValue.serverTimestamp() });
    if (sms && u?.phone) await db.collection('outbox').add({ channel: 'sms', to: u.phone, body: b ? `${t} ${b}` : t, uid, type, createdAt: FieldValue.serverTimestamp() });
  }
}

function requireAdmin(req: CallableRequest): string {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  if (req.auth.token.role !== 'admin') throw new HttpsError('permission-denied', 'Admins only.');
  return req.auth.uid;
}

function requireUser(req: CallableRequest): string {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  return req.auth.uid;
}

async function audit(actorId: string, action: string, targetId: string, details: Record<string, unknown>): Promise<void> {
  const actor = (await db.collection('users').doc(actorId).get()).data();
  await db.collection('auditLog').add({ actorId, actorName: actor?.name ?? '', action, targetId, details, createdAt: FieldValue.serverTimestamp() });
}

async function config(): Promise<Record<string, any>> {
  return (await db.collection('config').doc('app').get()).data() ?? {};
}

function limitFor(cfg: Record<string, any>, plan: string, key: string, fallback: number): number {
  const v = cfg.limits?.[plan === 'free' ? 'free' : 'plus']?.[key];
  return typeof v === 'number' ? v : fallback;
}

// ---------- admin ----------

export const reviewPartner = onCall(async (req) => {
  const adminUid = requireAdmin(req);
  const { collection, id, decision } = (req.data ?? {}) as { collection: string; id: string; decision: string };
  const reason = String(req.data?.reason ?? '').trim().slice(0, 500);
  if (!(PARTNER_COLLECTIONS as readonly string[]).includes(collection) || !id) throw new HttpsError('invalid-argument', 'Unknown listing.');
  const status = statusForDecision(decision);
  if (!status) throw new HttpsError('invalid-argument', 'Unknown decision.');
  if (decision !== 'approve' && !reason) throw new HttpsError('invalid-argument', 'A reason is needed.');
  const ref = db.collection(collection).doc(id);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError('not-found', 'Listing not found.');
  const listing = snap.data()!;
  await ref.update({ status, reviewReason: reason, reviewedAt: FieldValue.serverTimestamp(), reviewedBy: adminUid });
  const owner: string | undefined = listing.ownerUid ?? listing.uid ?? undefined;
  if (owner) {
    if (status === 'approved') {
      const app = (await db.collection('partnerApplications').doc(owner).get()).data();
      const role = app?.role ?? roleForListing(collection, listing);
      await getAuth().setCustomUserClaims(owner, { role });
      await db.collection('users').doc(owner).set({ role, partnerId: id }, { merge: true });
    }
    const appRef = db.collection('partnerApplications').doc(owner);
    if ((await appRef.get()).exists) await appRef.update({ status, reason });
    await notify([owner], status, reason ? () => reason : null, { name: listing.name ?? '' }, 'account', '/partner');
  }
  await audit(adminUid, `partner_${decision}`, `${collection}/${id}`, { name: listing.name ?? '', reason });
  return { status };
});

export const setUserSuspended = onCall(async (req) => {
  const adminUid = requireAdmin(req);
  const uid = String(req.data?.uid ?? '');
  const suspended = req.data?.suspended === true;
  const reason = String(req.data?.reason ?? '').trim().slice(0, 500);
  if (!uid) throw new HttpsError('invalid-argument', 'Who?');
  if (uid === adminUid) throw new HttpsError('failed-precondition', "You can't pause your own account.");
  if (suspended && !reason) throw new HttpsError('invalid-argument', 'A reason is needed.');
  await db.collection('users').doc(uid).update({ suspended, suspendReason: suspended ? reason : null });
  try {
    await getAuth().updateUser(uid, { disabled: suspended });
    if (suspended) await getAuth().revokeRefreshTokens(uid);
  } catch {
    // Demo accounts made by the seed tool may not exist in Auth.
  }
  await audit(adminUid, suspended ? 'user_suspend' : 'user_unsuspend', `users/${uid}`, { reason });
  return { suspended };
});

// ---------- PawSetu Plus ----------

export const startTrial = onCall(async (req) => {
  const uid = requireUser(req);
  const prices = pricesFromConfig(await config());
  return db.runTransaction(async (tx) => {
    const ref = db.collection('users').doc(uid);
    const u = (await tx.get(ref)).data() ?? {};
    const now = new Date();
    const plan = effectivePlan(u.plan, u.trialEndsAt, u.planRenewsAt, now);
    if (!canStartTrial(plan, u.trialUsedAt ?? null)) throw new HttpsError('failed-precondition', 'trial-used');
    const ends = trialEnd(now, prices);
    tx.update(ref, { plan: 'trial', trialEndsAt: ends, trialUsedAt: now });
    return { trialEndsAt: ends.toISOString() };
  });
});

/** Called after the (demo) payment succeeded. The price is taken from config, not the app. */
export const buyPlus = onCall(async (req) => {
  const uid = requireUser(req);
  const yearly = req.data?.yearly === true;
  const prices = pricesFromConfig(await config());
  const amount = yearly ? prices.yearly : prices.monthly;
  return db.runTransaction(async (tx) => {
    const ref = db.collection('users').doc(uid);
    const u = (await tx.get(ref)).data() ?? {};
    const now = new Date();
    // Buying during a trial or an active period starts after it ends.
    const from = [toDate(u.trialEndsAt), toDate(u.planRenewsAt)].filter((d): d is Date => !!d && d > now).reduce((a, b) => (b > a ? b : a), now);
    const renews = renewalDate(from, yearly);
    tx.update(ref, { plan: 'plus', planRenewsAt: renews, autoRenew: true, planPeriod: yearly ? 'yearly' : 'monthly' });
    tx.set(db.collection('payments').doc(), {
      uid, kind: 'plus', period: yearly ? 'yearly' : 'monthly', amount, tax: 0, status: 'paid', demo: true, at: now,
    });
    return { renewsAt: renews.toISOString(), amount };
  });
});

export const redeemReferral = onCall(async (req) => {
  const uid = requireUser(req);
  const code = String(req.data?.code ?? '').trim().toUpperCase();
  const cfg = await config();
  if (cfg.flags?.referrals === false) throw new HttpsError('failed-precondition', 'paused');
  const reward = Number(cfg.referral?.reward ?? 100);
  if (!/^[A-Z0-9]{6,10}$/.test(code)) return { coupon: null };
  const q = await db.collection('users').where('referralCode', '==', code).limit(1).get();
  if (q.empty || q.docs[0].id === uid) return { coupon: null };
  const referrerId = q.docs[0].id;
  return db.runTransaction(async (tx) => {
    const already = await tx.get(db.collection('referrals').where('referredId', '==', uid).limit(1));
    if (!already.empty) return { coupon: null };
    const now = new Date();
    const mine = rewardCouponCode();
    const theirs = rewardCouponCode();
    for (const [c, forUid] of [[mine, uid], [theirs, referrerId]] as const) {
      tx.set(db.collection('coupons').doc(c), {
        flat: reward, minOrder: 299, validTill: new Date(now.getTime() + 60 * 86_400_000), uses: 0, maxUses: 1, active: true, forUid, description: 'Referral reward',
      });
    }
    tx.set(db.collection('referrals').doc(), { referrerId, referredId: uid, code, reward, coupons: { [uid]: mine, [referrerId]: theirs }, createdAt: now });
    return { coupon: mine };
  });
});

// ---------- privacy ----------

async function collectPart(uid: string, petIds: string[], part: (typeof EXPORT_PARTS)[number]) {
  const col = db.collection(part.collection);
  if (part.byPet) {
    const out: FirebaseFirestore.QueryDocumentSnapshot[] = [];
    for (const id of petIds) out.push(...(await col.where(part.field, '==', id).get()).docs);
    return out;
  }
  return (await (part.arrayContains ? col.where(part.field, 'array-contains', uid) : col.where(part.field, '==', uid)).get()).docs;
}

export const exportMyData = onCall(async (req) => {
  const uid = requireUser(req);
  const out: Record<string, unknown> = { exportedAt: new Date().toISOString(), app: 'PawSetu' };
  out.profile = plainJson((await db.collection('users').doc(uid).get()).data() ?? {});
  const petIds = (await db.collection('pets').where('ownerId', '==', uid).get()).docs.map((d) => d.id);
  for (const part of EXPORT_PARTS) {
    const docs = await collectPart(uid, petIds, part);
    if (docs.length) out[part.collection] = docs.map((d) => plainJson({ id: d.id, ...d.data() }));
  }
  await db.collection('users').doc(uid).update({ lastExportAt: FieldValue.serverTimestamp() });
  return out;
});

/** Deletes (or anonymises) everything about [uid]. Exported for tests. */
export async function deleteAccountData(uid: string): Promise<number> {
  const petIds = (await db.collection('pets').where('ownerId', '==', uid).get()).docs.map((d) => d.id);
  let n = 0;
  for (const part of EXPORT_PARTS) {
    for (const d of await collectPart(uid, petIds, part)) {
      if (KEEP_ANONYMISED.has(part.collection)) {
        await d.ref.update({ ownerName: 'Deleted user', notes: null, address: null, deletedOwner: true });
      } else {
        await d.ref.delete();
      }
      n++;
    }
  }
  await db.collection('carts').doc(uid).delete().catch(() => undefined);
  await db.collection('users').doc(uid).delete();
  try {
    await getAuth().deleteUser(uid);
  } catch {
    // Already gone, or a seed-only demo account.
  }
  return n;
}

export const purgeDeletedAccounts = onSchedule({ schedule: 'every day 02:30', timeZone: 'Asia/Kolkata' }, async () => {
  const cutoff = new Date(Date.now() - DELETION_GRACE_DAYS * 86_400_000);
  const due = await db.collection('users').where('deletionRequestedAt', '<=', cutoff).get();
  for (const u of due.docs) {
    const n = await deleteAccountData(u.id);
    await db.collection('auditLog').add({ actorId: 'system', actorName: 'PawSetu', action: 'account_deleted', targetId: `users/${u.id}`, details: { records: n }, createdAt: FieldValue.serverTimestamp() });
  }
});

/** Ends trials and paid periods; renews (demo payment) when auto-renew is on. Exported for tests. */
export async function runPlanExpiry(now: Date): Promise<{ ended: number; renewed: number }> {
  let ended = 0, renewed = 0;
  const prices = pricesFromConfig(await config());
  for (const d of (await db.collection('users').where('plan', '==', 'trial').get()).docs) {
    if (effectivePlan('trial', d.data().trialEndsAt, null, now) === 'free') {
      await d.ref.update({ plan: 'free' });
      await notify([d.id], 'trialEnded', 'trialEndedBody', {}, 'plan', '/me/plus');
      ended++;
    }
  }
  for (const d of (await db.collection('users').where('plan', '==', 'plus').get()).docs) {
    const u = d.data();
    const end = toDate(u.planRenewsAt);
    if (!end || end > now) continue;
    if (u.autoRenew !== false) {
      const yearly = u.planPeriod === 'yearly';
      const next = renewalDate(end, yearly);
      await d.ref.update({ planRenewsAt: next });
      await db.collection('payments').add({ uid: d.id, kind: 'plus', period: yearly ? 'yearly' : 'monthly', amount: yearly ? prices.yearly : prices.monthly, tax: 0, status: 'paid', demo: true, renewal: true, at: now });
      const lang = (['hi', 'te'].includes(u.language) ? u.language : 'en') as Lang;
      await notify([d.id], 'plusRenewed', null, { date: dateText(next, lang) }, 'plan', '/me/plus');
      renewed++;
    } else {
      await d.ref.update({ plan: 'free' });
      await notify([d.id], 'plusEnded', 'trialEndedBody', {}, 'plan', '/me/plus');
      ended++;
    }
  }
  return { ended, renewed };
}

export const expirePlans = onSchedule({ schedule: 'every day 01:15', timeZone: 'Asia/Kolkata' }, async () => {
  await runPlanExpiry(new Date());
});

// ---------- plan limits on the server ----------

async function ownerPlan(uid: string): Promise<{ plan: string; cfg: Record<string, any> }> {
  const u = (await db.collection('users').doc(uid).get()).data() ?? {};
  return { plan: effectivePlan(u.plan, u.trialEndsAt, u.planRenewsAt, new Date()), cfg: await config() };
}

/** A pet over the plan's limit is removed again (the app also checks first). */
export const onPetCreatedLimit = onDocumentCreated('pets/{petId}', async (event) => {
  const pet = event.data?.data();
  if (!pet?.ownerId) return;
  const { plan, cfg } = await ownerPlan(pet.ownerId);
  const limit = limitFor(cfg, plan, 'pets', plan === 'free' ? 3 : 999);
  const pets = await db.collection('pets').where('ownerId', '==', pet.ownerId).get();
  const active = pets.docs.filter((d) => d.data().archived !== true);
  if (active.length <= limit) return;
  await event.data!.ref.delete();
  await notify([pet.ownerId], 'petLimit', 'petLimitBody', { limit }, 'plan', '/me/plus');
});

/** New family members over the owner's plan limit are taken off again. */
export const onPetMembersLimit = onDocumentUpdated('pets/{petId}', async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after?.ownerId) return;
  const added = familyOthers(after).filter((u) => !familyOthers(before).includes(u));
  if (!added.length) return;
  const { plan, cfg } = await ownerPlan(after.ownerId);
  const limit = limitFor(cfg, plan, 'family', plan === 'free' ? 2 : 8);
  const over = familyOthers(after).length - limit;
  if (over <= 0) return;
  const remove = added.slice(-over);
  const update: Record<string, unknown> = { memberIds: FieldValue.arrayRemove(...remove) };
  for (const u of remove) update[`members.${u}`] = FieldValue.delete();
  await event.data!.after.ref.update(update);
  await notify([after.ownerId, ...remove], 'familyLimit', 'familyLimitBody', { pet: after.name ?? '', limit }, 'plan', '/me/plus');
});

/** Album videos longer than the plan allows are removed (the app checks first). */
export const onAlbumVideoLimit = onDocumentCreated('album/{itemId}', async (event) => {
  const item = event.data?.data();
  if (item?.type !== 'video' || !item.ownerId) return;
  const { plan, cfg } = await ownerPlan(item.ownerId);
  const limit = limitFor(cfg, plan, 'videoSeconds', plan === 'free' ? 60 : 180);
  if (Number(item.durationSec ?? 0) <= limit + 1) return;
  await event.data!.ref.delete();
  await notify([item.byUid ?? item.ownerId], 'videoLimit', 'videoLimitBody', { limit }, 'plan', '/me/plus');
});

// ---------- help and complaints ----------

export const onTicketWritten = onDocumentWritten('tickets/{ticketId}', async (event) => {
  const id = event.params.ticketId;
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!after) return;
  const link = after.role === 'owner' ? `/me/help/${id}` : `/help/${id}`;
  const msgsBefore: any[] = before?.messages ?? [];
  const msgsAfter: any[] = after.messages ?? [];
  const admins = async () => (await db.collection('users').where('role', '==', 'admin').get()).docs.map((d) => d.id);
  if (!before) {
    await notify(await admins(), 'newForSupport', () => String(after.subject ?? ''), { name: after.name ?? '' }, 'support', `/admin/complaints/${id}`);
    return;
  }
  for (const m of msgsAfter.slice(msgsBefore.length)) {
    if (m.admin) {
      await notify([after.uid], 'supportReply', () => String(m.text ?? ''), { subject: after.subject ?? '' }, 'support', link);
    } else {
      await notify(await admins(), 'newForSupport', () => String(after.subject ?? ''), { name: after.name ?? '' }, 'support', `/admin/complaints/${id}`);
    }
  }
  if (before.status !== 'resolved' && after.status === 'resolved' && !msgsAfter.slice(msgsBefore.length).some((m) => m.admin)) {
    await notify([after.uid], 'supportResolved', null, { subject: after.subject ?? '' }, 'support', link);
  }
  if (!before.refund && after.refund) {
    await notify([after.uid], 'refundTitle', 'refundBody', { amount: Number(after.refund.amount ?? 0) }, 'support', link, true);
  }
});
