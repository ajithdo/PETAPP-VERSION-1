/**
 * Phase 7 Cloud Functions: opening vault/album share links and the storage
 * quota. The share rules mirror lib/features/vault/domain/share_rules.dart
 * and the PIN hash lib/features/vault/domain/pin_hash.dart (unit tested in
 * Dart): PBKDF2-HMAC-SHA256, `pbkdf2$<iterations>$<salt b64>$<hash b64>`.
 */
import { pbkdf2Sync, timingSafeEqual } from 'node:crypto';

import { FieldValue, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { onObjectFinalized } from 'firebase-functions/v2/storage';

const db = getFirestore();

const MAX_WRONG_PINS = 5;
const WRONG_PIN_WINDOW_MS = 15 * 60 * 1000;
const FILE_URL_TTL_MS = 15 * 60 * 1000;

const toDate = (v: unknown): Date | null => (v instanceof Timestamp ? v.toDate() : v instanceof Date ? v : null);
const iso = (v: unknown) => toDate(v)?.toISOString() ?? null;

export function verifyPin(pin: string, stored: unknown): boolean {
  if (typeof stored !== 'string' || typeof pin !== 'string') return false;
  const parts = stored.split('$');
  if (parts.length !== 4 || parts[0] !== 'pbkdf2') return false;
  const iterations = Number.parseInt(parts[1], 10);
  if (!Number.isFinite(iterations) || iterations < 1) return false;
  const salt = Buffer.from(parts[2], 'base64');
  const expected = Buffer.from(parts[3], 'base64');
  const got = pbkdf2Sync(Buffer.from(pin, 'utf8'), salt, iterations, expected.length, 'sha256');
  return expected.length > 0 && timingSafeEqual(expected, got);
}

type Access = { at: unknown; device?: string; ok?: boolean };

/** Same order as checkShare(): revoked, expired, locked, needs PIN, wrong PIN, ok. */
export function checkShare(link: Record<string, any> | undefined, pin: string | null, now: Date): string {
  if (!link) return 'notFound';
  if (link.revoked === true) return 'revoked';
  const expires = toDate(link.expiresAt);
  if (expires && expires.getTime() <= now.getTime()) return 'expired';
  if (link.pinHash) {
    const log: Access[] = Array.isArray(link.accessLog) ? link.accessLog : [];
    const recentWrong = log.filter((a) => a.ok === false && now.getTime() - (toDate(a.at)?.getTime() ?? 0) < WRONG_PIN_WINDOW_MS).length;
    if (recentWrong >= MAX_WRONG_PINS) return 'locked';
    if (!pin) return 'needsPin';
    if (!verifyPin(pin, link.pinHash)) return 'wrongPin';
  }
  return 'ok';
}

/** A short-lived URL for a stored file; the saved URL when signing is not possible (emulator). */
async function fileUrl(storagePath: unknown, saved: unknown): Promise<string | null> {
  if (typeof storagePath === 'string' && storagePath) {
    try {
      const [url] = await getStorage().bucket().file(storagePath).getSignedUrl({ action: 'read', expires: Date.now() + FILE_URL_TTL_MS });
      return url;
    } catch {
      // The emulator cannot sign URLs; fall through to the saved one.
    }
  }
  return typeof saved === 'string' ? saved : null;
}

/**
 * Opens a share link for someone who is not signed in. Security rules keep
 * shareLinks and the vault private, so this is the only way in: it checks
 * revocation, expiry and the PIN, writes the access log, and returns only
 * what the link covers, with file URLs that expire in 15 minutes.
 */
export const openShareLink = onCall({ region: 'asia-south1' }, async (req) => {
  const token = typeof req.data?.token === 'string' ? req.data.token : '';
  const pin = typeof req.data?.pin === 'string' && req.data.pin ? String(req.data.pin) : null;
  if (!/^[A-Za-z0-9_-]{8,64}$/.test(token)) throw new HttpsError('invalid-argument', 'Bad link');
  const ref = db.collection('shareLinks').doc(token);
  const snap = await ref.get();
  const link = snap.data();
  const now = new Date();
  const status = checkShare(link, pin, now);
  if (!link) return { status };
  if (status === 'ok' || status === 'wrongPin') {
    const device = req.rawRequest?.headers?.['user-agent']?.toString().includes('Mobile') ? 'Mobile browser' : 'Web browser';
    await ref.update({ accessLog: FieldValue.arrayUnion({ at: Timestamp.fromDate(now), device, ok: status === 'ok' }) });
  }
  const base = { status, kind: link.kind ?? 'docs', petName: link.petName ?? '', ownerName: link.ownerName ?? '', expiresAt: iso(link.expiresAt) };
  if (status !== 'ok') return base;

  const pet = (await db.collection('pets').doc(link.petId).get()).data();
  const docs: Record<string, unknown>[] = [];
  const items: Record<string, unknown>[] = [];
  if (link.kind === 'album') {
    const s = await db.collection('album').where('petId', '==', link.petId).get();
    for (const d of s.docs) {
      const a = d.data();
      if (a.type === 'milestone' || !a.url) continue;
      if (link.albumName && !(a.albums ?? []).includes(link.albumName)) continue;
      items.push({
        id: d.id,
        type: a.type,
        url: await fileUrl(a.storagePath, a.url),
        contentType: a.contentType ?? null,
        caption: a.caption ?? '',
        takenAt: iso(a.takenAt),
        milestone: a.milestone ?? null,
        milestoneTitle: a.milestoneTitle ?? null,
        durationSec: a.durationSec ?? 0,
      });
    }
  } else {
    for (const id of (link.docIds ?? []) as string[]) {
      const d = await db.collection('documents').doc(id).get();
      const v = d.data();
      // Only documents that still belong to this pet.
      if (!v || v.petId !== link.petId) continue;
      docs.push({
        id: d.id,
        type: v.type,
        title: v.title ?? '',
        url: await fileUrl(v.storagePath, v.url),
        contentType: v.contentType ?? null,
        fileName: v.fileName ?? null,
        expiry: iso(v.expiry),
        createdAt: iso(v.createdAt),
        sampleIssuedOn: iso(v.sampleIssuedOn),
        readStatus: v.readStatus ?? 'none',
        extracted: v.readStatus === 'confirmed' && v.extracted ? JSON.parse(JSON.stringify(v.extracted, (_, x) => (x instanceof Timestamp ? x.toDate().toISOString() : x))) : null,
      });
    }
  }
  return { ...base, species: pet?.species ?? 'dog', docs, items };
});

/**
 * Storage quota (spec 7.11, 8): free 1 GB, Plus 25 GB (config/app
 * limits.storageGb). When an upload takes a person over their limit the file
 * is removed and they get a notification.
 */
export const enforceStorageQuota = onObjectFinalized({ region: 'asia-south1' }, async (event) => {
  const name = event.data.name ?? '';
  const m = /^users\/([^/]+)\//.exec(name);
  if (!m) return;
  const uid = m[1];
  const [user, cfg] = await Promise.all([db.collection('users').doc(uid).get(), db.collection('config').doc('app').get()]);
  const plan = user.data()?.plan;
  const plus = plan === 'plus' || plan === 'trial';
  const gb = cfg.data()?.limits?.[plus ? 'plus' : 'free']?.storageGb ?? (plus ? 25 : 1);
  const limit = gb * 1024 * 1024 * 1024;
  const [files] = await getStorage().bucket(event.data.bucket).getFiles({ prefix: `users/${uid}/` });
  const used = files.reduce((sum, f) => sum + Number(f.metadata.size ?? 0), 0);
  if (used <= limit) return;
  await getStorage().bucket(event.data.bucket).file(name).delete({ ignoreNotFound: true });
  await db.collection('notifications').add({
    uid,
    title: 'Storage full: the last file was not saved',
    body: '',
    type: 'vault',
    link: '/me/vault',
    read: false,
    createdAt: FieldValue.serverTimestamp(),
  });
});
