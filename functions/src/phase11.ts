/**
 * Phase 11 Cloud Functions: server halves of writes the security rules no
 * longer allow from the app.
 *
 * - acceptPetInvite: joins a pet's family from an invite link. The app can't
 *   add itself to someone else's pet, so the server checks the invite and
 *   adds the person with the invited role (never owner).
 * - syncBookingExpense: keeps the pet parent's expense for a booking in step
 *   with the booking (paid online, completed and paid at the visit,
 *   cancelled with a partial refund, declined or expired). The partner's app
 *   can't write the pet parent's expenses.
 * - expireFamilyAccess (hourly): a sitter's access ends on its date. The
 *   rules already hide the pet's records then; this also takes the pet off
 *   their list. They stay in the family list as "Access ended" so the owner
 *   can extend it.
 *
 * Ratings for clinics, groomers, vets and products are updated by
 * onReviewCreated in phase8.ts.
 */
import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';

const db = getFirestore();

// ---------- pure rules (mirrored in Dart) ----------

/** Roles an invite may give. Ownership never moves through an invite. */
export const INVITE_ROLES = ['coowner', 'carer', 'viewer'];

/** Invite tokens: lower-case letters and digits (family_repository.dart). */
export function tokenLooksValid(token: unknown): token is string {
  return typeof token === 'string' && /^[a-z0-9]{8,40}$/.test(token);
}

/** Expense category for a booking kind (booking_repository.dart _expense). */
export function expenseCategory(kind: unknown): string {
  switch (kind) {
    case 'clinic':
      return 'vet';
    case 'groomer':
      return 'grooming';
    case 'trainer':
      return 'training';
    case 'boarder':
      return 'boarding';
    default:
      return 'walking';
  }
}

/**
 * What the pet parent paid for a booking, after any refund: nothing until
 * it is paid, nothing for declined or expired requests.
 */
export function bookingExpenseAmount(b: Record<string, any> | undefined): number {
  if (!b || b.paymentStatus !== 'paid') return 0;
  if (b.status === 'declined' || b.status === 'expired') return 0;
  const total = Number(b.total ?? 0);
  const refund = b.status === 'cancelled' ? Number(b.refund ?? 0) : 0;
  return Math.max(0, total - refund);
}

/** Family members whose access ended (never the owner). */
export function expiredMemberIds(pet: Record<string, any>, now: Date): string[] {
  const members = (pet.members ?? {}) as Record<string, { expiresAt?: unknown }>;
  return ((pet.memberIds ?? []) as string[]).filter((uid) => {
    if (uid === pet.ownerId) return false;
    const at = members[uid]?.expiresAt;
    const end = at instanceof Timestamp ? at.toDate() : at instanceof Date ? at : null;
    return end !== null && end.getTime() <= now.getTime();
  });
}

// ---------- functions ----------

export const acceptPetInvite = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  return acceptInvite(req.auth.uid, req.data?.token);
});

/** Adds [uid] to the invite's pet with the invited role. */
export async function acceptInvite(uid: string, token: unknown): Promise<{ petId: string }> {
  if (!tokenLooksValid(token)) throw new HttpsError('invalid-argument', 'This invite link is not valid.');
  const inviteRef = db.collection('petInvites').doc(token);
  return db.runTransaction(async (tx) => {
    const invite = await tx.get(inviteRef);
    const i = invite.data();
    if (!i) throw new HttpsError('not-found', 'This invite link is not valid.');
    if (i.status !== 'pending') throw new HttpsError('failed-precondition', 'This invite was already used.');
    if (!INVITE_ROLES.includes(i.role)) throw new HttpsError('failed-precondition', 'This invite is not valid.');
    const petRef = db.collection('pets').doc(String(i.petId));
    const pet = await tx.get(petRef);
    if (!pet.exists) throw new HttpsError('not-found', 'This pet is no longer on PawSetu.');
    const profile = await tx.get(db.collection('users').doc(uid));
    const name = String(profile.data()?.name ?? '');
    const already = ((pet.data()?.memberIds ?? []) as string[]).includes(uid);
    if (!already) {
      tx.update(petRef, {
        memberIds: FieldValue.arrayUnion(uid),
        [`members.${uid}`]: { role: i.role, name, expiresAt: i.expiresAt ?? null },
      });
      tx.set(db.collection('activity').doc(), {
        petId: i.petId, actorId: uid, actorName: name, type: 'member_joined', detail: i.role, createdAt: FieldValue.serverTimestamp(),
      });
    }
    tx.update(inviteRef, { status: 'accepted', acceptedBy: uid, acceptedAt: FieldValue.serverTimestamp() });
    return { petId: String(i.petId) };
  });
}

export const syncBookingExpense = onDocumentWritten('bookings/{id}', async (event) => {
  await syncExpenseFor(event.params.id, event.data?.after.data());
});

/** Writes, updates or removes the expense for booking [id]. */
export async function syncExpenseFor(id: string, b: Record<string, any> | undefined): Promise<void> {
  const ref = db.collection('expenses').doc(`exp_${id}`);
  const amount = bookingExpenseAmount(b);
  const current = await ref.get();
  if (amount <= 0 || !b) {
    if (current.exists) await ref.delete();
    return;
  }
  const c = current.data();
  if (c && c.amount === amount && c.ownerId === b.ownerId) return;
  await ref.set({
    ownerId: b.ownerId,
    petId: b.petId,
    category: expenseCategory(b.kind),
    amount,
    date: b.start ?? FieldValue.serverTimestamp(),
    note: b.serviceName ?? '',
    source: 'booking',
    sourceId: id,
  });
}

/**
 * Takes expired sitters off pets' member lists. Version 1 reads every pet
 * (demo scale); Version 2 keeps a list of pets with expiring access.
 */
export async function runMemberExpiry(now: Date): Promise<number> {
  const pets = await db.collection('pets').select('ownerId', 'memberIds', 'members').get();
  let removed = 0;
  for (const p of pets.docs) {
    const gone = expiredMemberIds(p.data(), now);
    if (gone.length === 0) continue;
    await p.ref.update({ memberIds: FieldValue.arrayRemove(...gone) });
    removed += gone.length;
  }
  return removed;
}

export const expireFamilyAccess = onSchedule({ schedule: 'every 1 hours', timeZone: 'Asia/Kolkata' }, async () => {
  await runMemberExpiry(new Date());
});
