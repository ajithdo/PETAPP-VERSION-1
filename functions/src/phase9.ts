/**
 * Phase 9 Cloud Functions: lost pet mode, QR tags, connected devices, SOS.
 *
 * - openLostPage (callable, no sign-in): the public page behind a pet's QR
 *   tag. Only publicPetView() leaves the server: never the family's phone,
 *   address, medical details or who the family members are.
 * - contactPetFamily, shareFinderLocation (callable, no sign-in): relay a
 *   finder's message or location to the family. At most 5 per tag an hour.
 * - onLostReportWritten: when a pet is marked lost, tells the family and,
 *   if the owner chose, PawSetu users within 5 km who turned on lost-pet
 *   alerts; when the pet is found, tells the family.
 * - onDeviceUpdated: when a collar leaves its safe zone, alerts everyone who
 *   looks after the pet (and tells them when it is back).
 * - onSosLogged: daily SOS counts for admin analytics.
 *
 * publicPetView, nearbyAlertUids, relayAllowed and shouldAlertLeftZone
 * mirror lib/features/sos/domain/ (unit tested in Dart); phase9.test.ts
 * checks the same cases here. Demo mode writes texts to the Demo Outbox.
 */
import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { onDocumentCreated, onDocumentUpdated, onDocumentWritten } from 'firebase-functions/v2/firestore';
import { onCall } from 'firebase-functions/v2/https';

import { bumpDay } from './phase10';

const db = getFirestore();

export const LOST_ALERT_KM = 5;
export const RELAY_PER_HOUR = 5;

// ---------- pure rules (mirrored in Dart) ----------

export function distanceKm(lat1: number, lng1: number, lat2: number, lng2: number): number {
  const r = 6371;
  const rad = (d: number) => (d * Math.PI) / 180;
  const dLat = rad(lat2 - lat1);
  const dLng = rad(lng2 - lng1);
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(rad(lat1)) * Math.cos(rad(lat2)) * Math.sin(dLng / 2) ** 2;
  return 2 * r * Math.asin(Math.sqrt(a));
}

/** What anyone who scans the tag may see. */
export function publicPetView(pet: Record<string, any>): Record<string, unknown> {
  const lost = pet.lost && typeof pet.lost === 'object' ? pet.lost : null;
  return {
    name: pet.name ?? null,
    species: pet.species ?? null,
    breedId: pet.breedId ?? null,
    breedOther: pet.breedOther ?? null,
    colorTag: pet.colorTag ?? null,
    photoUrl: pet.photoUrl ?? null,
    markings: pet.markings ?? null,
    gender: pet.gender ?? null,
    lost: lost ? { since: lost.since ?? null, area: lost.area ?? null, note: lost.note ?? null, lat: lost.lat ?? null, lng: lost.lng ?? null } : null,
  };
}

export type AlertCandidate = { uid: string; lat?: number | null; lng?: number | null; optIn: boolean };

/** Opted-in people within [km] of the last-seen spot, except the family. */
export function nearbyAlertUids(users: AlertCandidate[], lat: number, lng: number, km = LOST_ALERT_KM, except: Set<string> = new Set()): string[] {
  return users
    .filter((u) => u.optIn && typeof u.lat === 'number' && typeof u.lng === 'number' && !except.has(u.uid) && distanceKm(lat, lng, u.lat, u.lng) <= km)
    .map((u) => u.uid);
}

export function relayAllowed(recent: Date[], now: Date): boolean {
  return recent.filter((t) => now.getTime() - t.getTime() < 3600_000).length < RELAY_PER_HOUR;
}

/** The safe-zone alert fires once, when the collar goes from inside (or unknown) to outside. */
export function shouldAlertLeftZone(wasInside: boolean | null | undefined, isInside: boolean): boolean {
  return !isInside && wasInside !== false;
}

// ---------- texts in each person's language ----------

const T = {
  lostFamilyTitle: { en: "{pet} is lost", hi: "{pet} लापता है", te: "{pet} తప్పిపోయింది" },
  lostFamilyBody: { en: "{name} marked them lost near {area}. Open the lost page to share it.", hi: "{name} ने {area} के पास लापता मार्क किया। शेयर करने के लिए लापता पेज खोलें।", te: "{name} {area} దగ్గర తప్పిపోయిందని గుర్తించారు. పంచుకోవడానికి పేజీ తెరవండి." },
  lostNearbyTitle: { en: "Have you seen {pet}? A pet is lost near you", hi: "क्या आपने {pet} को देखा? आपके पास एक पालतू लापता है", te: "{pet}ని చూశారా? మీ దగ్గర ఒక పెంపుడు జంతువు తప్పిపోయింది" },
  lostNearbyBody: { en: "Last seen near {area}. Tap to see the photo and tell the family.", hi: "आख़िरी बार {area} के पास दिखा। फ़ोटो देखने और परिवार को बताने के लिए टैप करें।", te: "చివరిగా {area} దగ్గర కనిపించింది. ఫోటో చూసి కుటుంబానికి చెప్పడానికి ట్యాప్ చేయండి." },
  lostFoundTitle: { en: "Good news: {pet} is home safe", hi: "अच्छी ख़बर: {pet} सुरक्षित घर आ गया", te: "శుభవార్త: {pet} క్షేమంగా ఇంటికి వచ్చింది" },
  finderMessageTitle: { en: "Message about {pet} from someone who scanned the tag", hi: "टैग स्कैन करने वाले से {pet} के बारे में संदेश", te: "ట్యాగ్ స్కాన్ చేసినవారి నుంచి {pet} గురించి మెసేజ్" },
  finderFrom: { en: "from {from}", hi: "भेजने वाले: {from}", te: "పంపినవారు: {from}" },
  finderSightingTitle: { en: "Someone shared where they saw {pet}", hi: "किसी ने बताया कि {pet} कहाँ दिखा", te: "{pet} ఎక్కడ కనిపించిందో ఎవరో పంచుకున్నారు" },
  zoneLeftTitle: { en: "{pet} has left the safe zone", hi: "{pet} सेफ़ ज़ोन से बाहर चला गया", te: "{pet} సేఫ్ జోన్ దాటి వెళ్లింది" },
  zoneLeftBody: { en: "{device}: now {metres} m from home. Tap to see where.", hi: "{device}: अभी घर से {metres} मीटर दूर। देखने के लिए टैप करें।", te: "{device}: ఇప్పుడు ఇంటి నుంచి {metres} మీ. దూరంలో ఉంది. ఎక్కడో చూడటానికి ట్యాప్ చేయండి." },
  zoneBackTitle: { en: "{pet} is back in the safe zone", hi: "{pet} सेफ़ ज़ोन में वापस आ गया", te: "{pet} సేఫ్ జోన్‌లోకి తిరిగి వచ్చింది" },
} as const;

type Lang = 'en' | 'hi' | 'te';

function fill(text: string, vars: Record<string, string | number>): string {
  let s = text;
  for (const [k, v] of Object.entries(vars)) s = s.split(`{${k}}`).join(String(v));
  return s;
}

async function notify(
  uids: Iterable<string>,
  title: keyof typeof T,
  body: keyof typeof T | null,
  vars: Record<string, string | number>,
  type: 'lost' | 'device',
  link: string,
  sms = false,
  extraBody?: (lang: Lang) => string,
): Promise<number> {
  let n = 0;
  for (const uid of new Set(uids)) {
    const u = (await db.collection('users').doc(uid).get()).data();
    const lang = (['hi', 'te'].includes(u?.language) ? u!.language : 'en') as Lang;
    const t = fill(T[title][lang], vars);
    const b = extraBody ? extraBody(lang) : body ? fill(T[body][lang], vars) : '';
    await db.collection('notifications').add({ uid, title: t, body: b, type, link, read: false, createdAt: FieldValue.serverTimestamp() });
    await db.collection('outbox').add({ channel: 'push', to: uid, subject: t, body: b || t, uid, type, createdAt: FieldValue.serverTimestamp() });
    if (sms && u?.phone) {
      await db.collection('outbox').add({ channel: 'sms', to: u.phone, body: b ? `${t} ${b}` : t, uid, type, createdAt: FieldValue.serverTimestamp() });
    }
    n++;
  }
  return n;
}

// ---------- the public page and the finder relay ----------

function cleanToken(v: unknown): string | null {
  const t = String(v ?? '');
  return /^[A-Za-z0-9]{12,40}$/.test(t) ? t : null;
}

async function petByToken(token: string): Promise<{ id: string; data: Record<string, any> } | null> {
  const q = await db.collection('pets').where('qrToken', '==', token).limit(1).get();
  if (q.empty || q.docs[0].data().archived === true) return null;
  return { id: q.docs[0].id, data: q.docs[0].data() };
}

function plain(v: unknown): unknown {
  if (v instanceof Timestamp) return v.toDate().toISOString();
  if (Array.isArray(v)) return v.map(plain);
  if (v && typeof v === 'object') return Object.fromEntries(Object.entries(v).map(([k, x]) => [k, plain(x)]));
  return v;
}

/** Records one relay for the tag, unless it already had 5 this hour. */
async function takeRelaySlot(token: string): Promise<boolean> {
  const ref = db.collection('tagRelays').doc(token);
  return db.runTransaction(async (tx) => {
    const now = new Date();
    const times = ((await tx.get(ref)).data()?.times ?? []).map((t: Timestamp) => t.toDate()) as Date[];
    const recent = times.filter((t) => now.getTime() - t.getTime() < 3600_000);
    if (!relayAllowed(recent, now)) return false;
    tx.set(ref, { times: [...recent, now] });
    return true;
  });
}

export const openLostPage = onCall(async (req) => {
  const token = cleanToken(req.data?.token);
  const pet = token ? await petByToken(token) : null;
  if (!pet) return { status: 'notFound' };
  return { status: 'ok', pet: plain(publicPetView(pet.data)) };
});

export const contactPetFamily = onCall(async (req) => {
  const token = cleanToken(req.data?.token);
  const message = String(req.data?.message ?? '').trim().slice(0, 500);
  const name = String(req.data?.name ?? '').trim().slice(0, 60);
  const phone = String(req.data?.phone ?? '').replace(/[^0-9+ ]/g, '').trim().slice(0, 20);
  if (!token || !message) return { status: 'notFound' };
  const pet = await petByToken(token);
  if (!pet) return { status: 'notFound' };
  if (!(await takeRelaySlot(token))) return { status: 'tooMany' };
  const from = [name, phone].filter((s) => s.length > 0).join(', ');
  await notify(pet.data.memberIds ?? [pet.data.ownerId], 'finderMessageTitle', null, { pet: pet.data.name }, 'lost', `/me/lost/${pet.id}`, true, (lang) =>
    from ? `${message} (${fill(T.finderFrom[lang], { from })})` : message,
  );
  return { status: 'ok' };
});

export const shareFinderLocation = onCall(async (req) => {
  const token = cleanToken(req.data?.token);
  const lat = typeof req.data?.lat === 'number' && Math.abs(req.data.lat) <= 90 ? req.data.lat : null;
  const lng = typeof req.data?.lng === 'number' && Math.abs(req.data.lng) <= 180 ? req.data.lng : null;
  const area = String(req.data?.area ?? '').trim().slice(0, 80);
  const note = String(req.data?.note ?? '').trim().slice(0, 200);
  if (!token || (lat === null && !area)) return { status: 'notFound' };
  const pet = await petByToken(token);
  if (!pet) return { status: 'notFound' };
  if (!(await takeRelaySlot(token))) return { status: 'tooMany' };
  const reportId = pet.data.lost?.reportId;
  if (typeof reportId === 'string') {
    await db.collection('lostReports').doc(reportId).update({
      sightings: FieldValue.arrayUnion({ at: Timestamp.now(), lat, lng, area, note, name: '' }),
    });
  }
  const where = [area, lat !== null && lng !== null ? `${lat.toFixed(4)}, ${lng.toFixed(4)}` : '', note].filter((s) => s).join(' · ');
  await notify(pet.data.memberIds ?? [pet.data.ownerId], 'finderSightingTitle', null, { pet: pet.data.name }, 'lost', `/me/lost/${pet.id}`, true, () => where);
  return { status: 'ok' };
});

// ---------- lost reports, devices and SOS ----------

export const onLostReportWritten = onDocumentWritten('lostReports/{id}', async (event) => {
  const before = event.data?.before?.data();
  const after = event.data?.after?.data();
  if (!after) return;
  const pet = (await db.collection('pets').doc(after.petId).get()).data();
  const members: string[] = pet?.memberIds ?? [after.ownerId];
  if (!before && after.status === 'lost') {
    const by = (await db.collection('users').doc(after.createdBy).get()).data();
    await notify(members.filter((u) => u !== after.createdBy), 'lostFamilyTitle', 'lostFamilyBody',
      { pet: after.petName, name: String(by?.name ?? '').split(' ')[0], area: after.area }, 'lost', `/me/lost/${after.petId}`);
    if (after.alert === true && typeof after.lat === 'number' && typeof after.lng === 'number') {
      const users = await db.collection('users').where('consents.lostPetAlerts', '==', true).get();
      const uids = nearbyAlertUids(
        users.docs.map((d) => ({ uid: d.id, lat: d.data().homeLat, lng: d.data().homeLng, optIn: true })),
        after.lat, after.lng, LOST_ALERT_KM, new Set([...members, after.createdBy]),
      );
      const n = await notify(uids, 'lostNearbyTitle', 'lostNearbyBody', { pet: after.petName, area: after.area }, 'lost', `/lost/${after.qrToken}`);
      await event.data!.after!.ref.update({ alertsSent: n });
    }
  } else if (before?.status === 'lost' && after.status === 'found') {
    await notify(members, 'lostFoundTitle', null, { pet: after.petName }, 'lost', `/pets/${after.petId}`);
  }
});

export const onDeviceUpdated = onDocumentUpdated('devices/{id}', async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  const was = before?.data?.inside as boolean | undefined;
  const isInside = after?.data?.inside as boolean | undefined | null;
  if (!after || typeof isInside !== 'boolean' || was === isInside) return;
  const pet = (await db.collection('pets').doc(after.petId).get()).data();
  const members: string[] = pet?.memberIds ?? [after.ownerId];
  const link = `/me/devices/${event.params.id}`;
  if (shouldAlertLeftZone(was, isInside)) {
    await notify(members, 'zoneLeftTitle', 'zoneLeftBody', { pet: pet?.name ?? '', device: after.name, metres: Math.round(after.data?.metersFromHome ?? 0) }, 'device', link, true);
  } else if (was === false && isInside) {
    await notify(members, 'zoneBackTitle', null, { pet: pet?.name ?? '' }, 'device', link);
  }
});

export const onSosLogged = onDocumentCreated('sosLogs/{id}', async (event) => {
  const d = event.data?.data();
  if (!d) return;
  const at = d.at instanceof Timestamp ? d.at.toDate() : new Date();
  await bumpDay(at, { sos: 1 });
});
