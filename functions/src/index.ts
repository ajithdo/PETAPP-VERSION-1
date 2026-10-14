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
