/**
 * Phase 6 Cloud Functions: tele-vet consultations and Ask PawSetu limits.
 * The rules mirror lib/features/televet/domain/televet_rules.dart and
 * lib/features/assistant/domain/assistant_engine.dart (unit tested in Dart).
 */
import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';

const db = getFirestore();

type Limits = { perMonth: number; messages: number; words: number; hours: number; video: boolean };

const FREE: Limits = { perMonth: 1, messages: 20, words: 60, hours: 24, video: false };
const PLUS: Limits = { perMonth: 999, messages: 100, words: 300, hours: 72, video: true };

async function config(): Promise<Record<string, any>> {
  return (await db.collection('config').doc('app').get()).data() ?? {};
}

function limitsFor(cfg: Record<string, any>, plus: boolean): Limits {
  const d = plus ? PLUS : FREE;
  const m = cfg.limits?.[plus ? 'plus' : 'free'] ?? {};
  const v = (k: string, def: number) => (typeof m[k] === 'number' ? m[k] : def);
  return { perMonth: v('teleVetPerMonth', d.perMonth), messages: v('teleVetMessages', d.messages), words: v('teleVetWords', d.words), hours: v('teleVetHours', d.hours), video: plus };
}

export function countWords(text: string): number {
  const t = (text ?? '').trim();
  return t ? t.split(/\s+/).filter((w) => w.length > 0).length : 0;
}

const toDate = (v: unknown): Date | null => (v instanceof Timestamp ? v.toDate() : v instanceof Date ? v : null);
const isPlus = (plan: unknown) => plan === 'plus' || plan === 'trial';
const monthStart = (d: Date) => new Date(d.getFullYear(), d.getMonth(), 1);

async function notify(uid: string, title: string, link: string, type = 'messages') {
  if (!uid || uid.startsWith('p_')) return;
  await db.collection('notifications').add({ uid, title, body: '', type, link, read: false, createdAt: FieldValue.serverTimestamp() });
}

/** Starts a consultation after checking the plan's monthly allowance and video access. */
export const startConsultation = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  const uid = req.auth.uid;
  const d = req.data as { petId: string; problem: string; mode: string; photos?: string[]; vetId?: string; scheduledAt?: string; redFlag?: string; petSnapshot?: Record<string, unknown> };
  const [userSnap, petSnap, cfg] = await Promise.all([db.collection('users').doc(uid).get(), db.collection('pets').doc(d.petId).get(), config()]);
  const user = userSnap.data() ?? {};
  const pet = petSnap.data();
  if (!pet) throw new HttpsError('not-found', 'Pet not found.');
  const role = pet.members?.[uid]?.role ?? (pet.ownerId === uid ? 'owner' : undefined);
  if (!['owner', 'coowner', 'carer'].includes(role)) throw new HttpsError('permission-denied', 'You cannot start a consultation for this pet.');
  const plus = isPlus(user.plan);
  const limits = limitsFor(cfg, plus);
  const video = d.mode === 'video';
  if (video && !limits.video) throw new HttpsError('failed-precondition', 'Video calls need Plus.', { reason: 'video_needs_plus' });
  const now = new Date();
  const used = (await db.collection('consultations').where('ownerId', '==', uid).where('createdAt', '>=', monthStart(now)).get()).size;
  if (used >= limits.perMonth) throw new HttpsError('resource-exhausted', 'Monthly consultations used.', { reason: 'monthly_limit' });

  const vetSnap = d.vetId ? await db.collection('vets').doc(d.vetId).get() : null;
  const vet = vetSnap?.data();
  const commission = cfg.commission ?? {};
  const fee = video ? Number(vet?.videoFee ?? 399) : 0;
  const discount = video && plus ? Math.round((fee * Number(commission.videoDiscountPercent ?? 10)) / 100) : 0;
  const total = fee - discount;
  const commissionAmount = Math.round((total * Number(commission.bookingPercent ?? 10)) / 100);
  const ref = db.collection('consultations').doc();
  const convId = `tv_${ref.id}`;
  const vetUid: string | null = vet?.uid ?? null;
  await ref.set({
    ownerId: uid, ownerName: user.name ?? '', petId: d.petId, petName: pet.name, petSpecies: pet.species,
    petSnapshot: d.petSnapshot ?? {}, vetId: d.vetId ?? null, vetUid, vetName: vet?.name ?? null,
    clinicId: vet?.clinicId ?? null, clinicName: vet?.clinicName ?? null, status: 'queued', mode: video ? 'video' : 'chat',
    problem: String(d.problem ?? '').slice(0, 4000), photos: d.photos ?? [], plan: user.plan ?? 'free', priority: plus,
    limits, messagesUsed: 0, createdAt: now, scheduledAt: d.scheduledAt ? new Date(d.scheduledAt) : null,
    startedAt: null, endsAt: null, consentAt: now, fee, discount, total, commission: commissionAmount, payout: total - commissionAmount,
    // Version 1 has no real payments; Version 2 marks video paid from the Razorpay webhook.
    paymentStatus: total > 0 ? 'paid' : 'included', conversationId: convId, redFlag: d.redFlag ?? null, privateNotes: '',
  });
  const participants: Record<string, unknown> = { [uid]: { name: user.name ?? '', role: 'owner' } };
  if (vetUid) participants[vetUid] = { name: vet?.name, role: 'vet' };
  await db.collection('conversations').doc(convId).set({
    type: 'televet', participantIds: vetUid ? [uid, vetUid] : [uid], participants, ownerId: uid, ownerName: user.name ?? '',
    providerName: vet?.name ?? '', providerId: d.vetId ?? null, providerKind: 'vet', petId: d.petId, petName: pet.name,
    petSpecies: pet.species, consultationId: ref.id, lastMessage: d.problem, lastType: 'text', lastSenderId: uid,
    lastAt: now, createdAt: now, unread: vetUid ? { [vetUid]: 1 } : {}, muted: {}, blockedBy: [], typing: {},
  });
  const msgs = db.collection('messages');
  await msgs.add({ conversationId: convId, senderId: 'system', senderName: '', type: 'system', event: 'tv_started', meta: { mode: video ? 'video' : 'chat' }, text: '', createdAt: now, readBy: [uid] });
  await msgs.add({ conversationId: convId, senderId: uid, senderName: user.name ?? '', type: 'text', text: d.problem, meta: { problem: true }, createdAt: new Date(now.getTime() + 1), readBy: [uid] });
  if (total > 0) {
    await db.collection('expenses').doc(`exp_${ref.id}`).set({ ownerId: uid, petId: d.petId, category: 'vet', amount: total, date: now, note: `${vet?.name ?? ''} · tele-vet`, source: 'televet', sourceId: ref.id });
  }
  const vets = vetUid ? [vetUid] : (await db.collection('vets').where('teleVet', '==', true).get()).docs.map((v) => v.data().uid).filter(Boolean);
  for (const v of vets) await notify(v, `New tele-vet request: ${pet.name} (${user.name ?? ''})`, '/partner/televet');
  return { id: ref.id };
});

/** Sends a tele-vet message. Owners are limited by message count, words and the chat window. */
export const sendTeleVetMessage = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  const uid = req.auth.uid;
  const d = req.data as { consultationId: string; type?: string; text?: string; url?: string; fileName?: string; sizeBytes?: number; durationSec?: number; event?: string; meta?: unknown; prescriptionId?: string };
  const ref = db.collection('consultations').doc(d.consultationId);
  return db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const c = snap.data();
    if (!c) throw new HttpsError('not-found', 'Consultation not found.');
    const fromOwner = c.ownerId === uid;
    if (!fromOwner && c.vetUid !== uid) throw new HttpsError('permission-denied', 'Not part of this consultation.');
    const type = d.type ?? 'text';
    const counted = fromOwner && type !== 'system' && type !== 'call';
    const limits: Limits = { ...(isPlus(c.plan) ? PLUS : FREE), ...(c.limits ?? {}) };
    const used = Number(c.messagesUsed ?? 0);
    const left = Math.max(0, limits.messages - used);
    const words = countWords(d.text ?? '');
    const endsAt = toDate(c.endsAt);
    const result = (block: string, extra: Record<string, number> = {}) => ({ block, words, maxWords: limits.words, messagesLeft: left, ...extra });
    if (c.status === 'ended') return result('ended');
    if (fromOwner && endsAt && Date.now() > endsAt.getTime()) return result('chatClosed');
    if (words === 0 && type === 'text') return result('empty');
    if (counted && used >= limits.messages) return result('noMessagesLeft');
    if (counted && words > limits.words) return result('tooManyWords');
    const now = new Date();
    const convRef = db.collection('conversations').doc(c.conversationId ?? `tv_${snap.id}`);
    const conv = (await tx.get(convRef)).data() ?? {};
    const msgRef = db.collection('messages').doc();
    tx.set(msgRef, {
      conversationId: convRef.id, senderId: type === 'system' ? 'system' : uid, senderName: type === 'system' ? '' : (conv.participants?.[uid]?.name ?? ''),
      type, text: d.text ?? '', url: d.url ?? null, fileName: d.fileName ?? null, sizeBytes: d.sizeBytes ?? null, durationSec: d.durationSec ?? null,
      event: d.event ?? null, meta: d.meta ?? null, prescriptionId: d.prescriptionId ?? null, demo: false, masked: false, createdAt: now, readBy: [uid],
    });
    const update: Record<string, unknown> = type === 'system' ? { lastAt: now } : { lastMessage: d.text ?? d.fileName ?? '', lastType: type, lastSenderId: uid, lastAt: now };
    for (const p of (conv.participantIds ?? []) as string[]) update[`unread.${p}`] = p === uid ? 0 : FieldValue.increment(1);
    tx.update(convRef, update);
    if (counted) tx.update(ref, { messagesUsed: FieldValue.increment(1) });
    return result('none', { messagesLeft: counted ? left - 1 : left });
  });
});

/** A vet accepts a queued consultation; the chat window starts now. */
export const acceptConsultation = onCall(async (req) => {
  if (req.auth?.token.role !== 'vet') throw new HttpsError('permission-denied', 'Only vets can accept consultations.');
  const uid = req.auth.uid;
  const ref = db.collection('consultations').doc(String(req.data?.consultationId));
  const vetDoc = (await db.collection('vets').where('uid', '==', uid).limit(1).get()).docs[0];
  const vet = vetDoc?.data() ?? {};
  const now = new Date();
  const c = await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const data = snap.data();
    if (!data) throw new HttpsError('not-found', 'Consultation not found.');
    if (data.status !== 'queued') throw new HttpsError('failed-precondition', 'Already taken.');
    const limits: Limits = { ...(isPlus(data.plan) ? PLUS : FREE), ...(data.limits ?? {}) };
    tx.update(ref, { status: 'active', vetId: vetDoc?.id ?? null, vetUid: uid, vetName: vet.name ?? null, clinicId: vet.clinicId ?? null, clinicName: vet.clinicName ?? null, startedAt: now, endsAt: new Date(now.getTime() + limits.hours * 3600000) });
    tx.update(db.collection('conversations').doc(data.conversationId), { participantIds: FieldValue.arrayUnion(uid), [`participants.${uid}`]: { name: vet.name ?? '', role: 'vet' }, providerName: vet.name ?? '', providerId: vetDoc?.id ?? null });
    return data;
  });
  await db.collection('messages').add({ conversationId: c.conversationId, senderId: 'system', senderName: '', type: 'system', event: 'tv_joined', meta: { name: vet.name ?? '' }, text: '', createdAt: now, readBy: [uid] });
  await notify(c.ownerId, `${vet.name ?? 'A vet'} joined your chat about ${c.petName}`, `/messages/${c.conversationId}`);
  return { ok: true };
});

/** The vet (or the owner) ends a consultation. */
export const endConsultation = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  const uid = req.auth.uid;
  const ref = db.collection('consultations').doc(String(req.data?.consultationId));
  const c = (await ref.get()).data();
  if (!c) throw new HttpsError('not-found', 'Consultation not found.');
  if (c.ownerId !== uid && c.vetUid !== uid) throw new HttpsError('permission-denied', 'Not part of this consultation.');
  const now = new Date();
  await ref.update({ status: 'ended', endedAt: now, endedBy: uid });
  await db.collection('messages').add({ conversationId: c.conversationId, senderId: 'system', senderName: '', type: 'system', event: 'tv_ended', meta: {}, text: '', createdAt: now, readBy: [uid] });
  if (uid !== c.ownerId) await notify(c.ownerId, `Tele-vet consultation for ${c.petName} has ended`, `/messages/${c.conversationId}`);
  return { ok: true };
});

/** Ask PawSetu: counts questions per month on the server (red flags are free). */
export const askPawSetu = onCall(async (req) => {
  if (!req.auth) throw new HttpsError('unauthenticated', 'Please sign in.');
  const uid = req.auth.uid;
  const d = req.data as { question: string; topic?: string | null; redFlag?: string | null };
  const [userSnap, cfg] = await Promise.all([db.collection('users').doc(uid).get(), config()]);
  const plan = isPlus(userSnap.data()?.plan) ? 'plus' : 'free';
  const limit = Number(cfg.limits?.[plan]?.aiQuestions ?? (plan === 'plus' ? 9999 : 5));
  const convId = `ai_${uid}`;
  const now = new Date();
  if (!d.redFlag && limit < 999) {
    const asked = await db.collection('messages').where('conversationId', '==', convId).where('type', '==', 'question').get();
    const used = asked.docs.filter((m) => !m.data().redFlag && (toDate(m.data().createdAt) ?? now) >= monthStart(now)).length;
    if (used >= limit) throw new HttpsError('resource-exhausted', 'Monthly questions used.');
  }
  const conv = db.collection('conversations').doc(convId);
  if (!(await conv.get()).exists) {
    await conv.set({ type: 'assistant', participantIds: [uid], participants: { [uid]: { name: userSnap.data()?.name ?? '', role: 'owner' } }, ownerId: uid, providerName: 'Ask PawSetu', providerKind: 'assistant', unread: {}, createdAt: now, lastAt: now });
  }
  const base = { conversationId: convId, topic: d.topic ?? null, redFlag: d.redFlag ?? null, readBy: [uid] };
  await db.collection('messages').add({ ...base, senderId: uid, senderName: userSnap.data()?.name ?? '', type: 'question', text: String(d.question ?? '').slice(0, 1000), createdAt: now });
  await db.collection('messages').add({ ...base, senderId: 'pawsetu_ai', senderName: 'Ask PawSetu', type: 'answer', text: '', createdAt: new Date(now.getTime() + 5) });
  await conv.update({ lastMessage: d.question, lastAt: now });
  return { ok: true };
});

/** When a vet issues a prescription, put it in the pet parent's records. */
export const onPrescriptionCreated = onDocumentCreated({ document: 'prescriptions/{id}', region: 'asia-south1' }, async (event) => {
  const rx = event.data?.data();
  if (!rx) return;
  const id = event.params.id;
  const at = toDate(rx.createdAt) ?? new Date();
  const followUp = toDate(rx.followUp);
  const meds = ((rx.items ?? []) as Array<{ medicine?: string }>).map((i) => i.medicine).filter(Boolean).join(', ');
  const link = `/prescriptions/${id}`;
  await db.collection('documents').doc(`doc_${id}`).set({
    ownerId: rx.ownerId, petId: rx.petId, type: 'prescription', title: `Prescription for ${rx.petName}`, tags: ['prescription', 'tele-vet'],
    url: rx.url ?? null, contentType: 'application/pdf', expiry: null, extracted: { vetName: rx.vetName, regNo: rx.regNo, date: at, medicines: meds },
    prescriptionId: id, consultationId: rx.consultationId, link, createdAt: at,
  });
  await db.collection('healthEvents').doc(`he_${id}`).set({
    petId: rx.petId, type: 'vet_visit', date: at, nextDue: followUp, title: `Tele-vet consultation with ${rx.vetName}`, clinicName: rx.clinicName,
    diagnosis: rx.diagnosis, notes: meds ? `Prescribed: ${meds}` : rx.notes ?? '', prescriptionId: id, consultationId: rx.consultationId,
    docId: `doc_${id}`, link, source: 'televet', byUid: rx.vetUid ?? null, createdAt: at,
  });
  if (followUp) {
    await db.collection('reminders').add({ ownerId: rx.ownerId, petId: rx.petId, type: 'custom', title: `Follow-up for ${rx.petName} with ${rx.vetName}`, at: new Date(followUp.getFullYear(), followUp.getMonth(), followUp.getDate(), 10), repeat: 'none', channels: ['push'], done: false, createdAt: at });
  }
  await notify(rx.ownerId, `${rx.vetName} sent a prescription for ${rx.petName}`, link, 'health');
});
