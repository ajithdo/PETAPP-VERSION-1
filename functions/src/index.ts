/**
 * PawSetu Cloud Functions. Region asia-south1 (Mumbai).
 *
 * In Version 1 these run on the Firebase Local Emulator Suite
 * (BACKEND=emulator). The standalone demo runs the same rules on the
 * device (see lib/features/<feature>/domain).
 */
import { initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { setGlobalOptions } from 'firebase-functions/v2';
import { HttpsError, onCall } from 'firebase-functions/v2/https';

initializeApp();
setGlobalOptions({ region: 'asia-south1', maxInstances: 10 });

const db = getFirestore();

export const ROLES = [
  'owner',
  'vet',
  'clinic_admin',
  'groomer',
  'trainer',
  'boarder',
  'walker',
  'seller',
  'admin',
] as const;
type Role = (typeof ROLES)[number];

/**
 * Called by the app right after sign-in. Creates the user's profile the
 * first time and gives new accounts the "owner" role. Roles live in custom
 * claims so security rules can trust them.
 */
export const ensureProfile = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  const uid = req.auth.uid;
  const ref = db.collection('users').doc(uid);
  const snap = await ref.get();
  const claimsRole = req.auth.token.role as Role | undefined;
  const role: Role = claimsRole ?? 'owner';
  if (!claimsRole) {
    await getAuth().setCustomUserClaims(uid, { role });
  }
  if (!snap.exists) {
    const data = req.data ?? {};
    await ref.set({
      name: String(data.name ?? req.auth.token.name ?? ''),
      email: req.auth.token.email ?? null,
      phone: req.auth.token.phone_number ?? null,
      role,
      plan: 'free',
      language: String(data.language ?? 'en'),
      createdAt: FieldValue.serverTimestamp(),
    });
  }
  return { role };
});

/** Platform admin changes a user's role. */
export const setUserRole = onCall(async (req) => {
  if (req.auth?.token.role !== 'admin') {
    throw new HttpsError('permission-denied', 'Only admins can change roles.');
  }
  const { uid, role } = req.data as { uid: string; role: Role };
  if (!ROLES.includes(role)) throw new HttpsError('invalid-argument', 'Unknown role.');
  await getAuth().setCustomUserClaims(uid, { role });
  await db.collection('users').doc(uid).update({ role });
  await db.collection('auditLog').add({
    actorId: req.auth.uid,
    action: 'setUserRole',
    targetId: uid,
    details: { role },
    createdAt: FieldValue.serverTimestamp(),
  });
  return { ok: true };
});

/**
 * Creates a booking with server-side prices (spec 7.6). The app sends what
 * the owner chose; prices, commission and the partner list come from the
 * clinic or provider listing and config/app, never from the client.
 */
export const createBooking = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  const uid = req.auth.uid;
  const d = req.data as {
    placeId: string; serviceId: string; petId: string; vetId?: string;
    start: string; proposedTimes?: string[]; paymentOption: string;
    paidOnline?: boolean; homeVisit?: boolean; notes?: string; photos?: string[];
  };
  const placeRef = db.collection(d.placeId.startsWith('clinic') ? 'clinics' : 'providers').doc(d.placeId);
  const [placeSnap, petSnap, userSnap, cfgSnap] = await Promise.all([
    placeRef.get(),
    db.collection('pets').doc(d.petId).get(),
    db.collection('users').doc(uid).get(),
    db.collection('config').doc('app').get(),
  ]);
  const place = placeSnap.data();
  const pet = petSnap.data();
  if (!place || place.status !== 'approved') throw new HttpsError('not-found', 'This listing is not available.');
  if (!pet) throw new HttpsError('not-found', 'Pet not found.');
  const role = (pet.members?.[uid]?.role as string | undefined) ?? (pet.ownerId === uid ? 'owner' : undefined);
  if (!role || !['owner', 'coowner', 'carer'].includes(role)) {
    throw new HttpsError('permission-denied', 'You cannot book for this pet.');
  }
  const service = (place.services as Array<Record<string, unknown>>).find((s) => s.id === d.serviceId);
  if (!service) throw new HttpsError('invalid-argument', 'Unknown service.');
  const payments = (service.payments as string[]) ?? ['at_clinic'];
  if (!payments.includes(d.paymentOption)) throw new HttpsError('invalid-argument', 'Payment option not offered.');

  const commissionPct = Number(cfgSnap.data()?.commission?.bookingPercent ?? 10);
  const price = Number(service.price ?? 0);
  const travelFee = d.homeVisit ? Number(place.kind === 'clinic' ? place.homeVisitFee ?? 0 : place.travelFee ?? 0) : 0;
  const commission = Math.round((price * commissionPct) / 100);
  const instant = service.mode === 'instant';
  const start = new Date(d.start);
  const partnerUids = new Set<string>();
  const ownerUid = (place.ownerUid ?? place.uid) as string | undefined;
  if (ownerUid) partnerUids.add(ownerUid);
  let vetName: string | null = null;
  if (d.vetId) {
    const vet = (await db.collection('vets').doc(d.vetId).get()).data();
    if (vet?.uid) partnerUids.add(vet.uid as string);
    vetName = (vet?.name as string) ?? null;
  }
  const ref = db.collection('bookings').doc();
  await ref.set({
    ownerId: uid,
    ownerName: userSnap.data()?.name ?? '',
    petId: d.petId,
    petName: pet.name,
    petSpecies: pet.species,
    kind: placeSnap.ref.parent.id === 'clinics' ? 'clinic' : place.type,
    providerId: d.placeId,
    providerName: place.name,
    providerPhone: place.phone ?? null,
    providerAddress: place.address ?? null,
    vetId: d.vetId ?? null,
    vetName,
    serviceId: d.serviceId,
    start,
    end: new Date(start.getTime() + Number(service.durationMin ?? 30) * 60000),
    mode: service.mode,
    status: instant ? 'confirmed' : 'pending',
    proposedTimes: instant ? [] : (d.proposedTimes ?? [d.start]).map((t) => new Date(t)),
    respondBy: instant ? null : new Date(Date.now() + Number(place.requestWindowHours ?? 2) * 3600000),
    paymentOption: d.paymentOption,
    // Version 1 has no real payments; Version 2 marks it paid from the Razorpay webhook.
    paymentStatus: d.paidOnline ? 'paid' : 'pay_at_visit',
    price,
    travelFee,
    platformFee: 0,
    discount: 0,
    total: price + travelFee,
    commission,
    payout: price + travelFee - commission,
    homeVisit: !!d.homeVisit,
    notes: d.notes ?? null,
    photos: d.photos ?? [],
    partnerUids: [...partnerUids],
    reviewed: false,
    updates: [],
    createdAt: FieldValue.serverTimestamp(),
  });
  return { id: ref.id };
});
