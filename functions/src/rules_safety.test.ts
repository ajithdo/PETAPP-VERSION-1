/**
 * Security-rules tests for devices, SOS logs and lost reports (Phase 9).
 * Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { deleteDoc, doc, getDoc, serverTimestamp, setDoc, updateDoc } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-pawsetu-rules-safety',
    firestore: { rules: readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8') },
  });
});

after(async () => env?.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'pets/max'), {
      ownerId: 'arjun',
      name: 'Max',
      qrToken: 'Mx9LcV5tGp2YqHn7',
      memberIds: ['arjun', 'meera', 'nani'],
      members: { arjun: { role: 'owner', expiresAt: null }, meera: { role: 'carer', expiresAt: null }, nani: { role: 'viewer', expiresAt: null } },
    });
    await setDoc(doc(db, 'devices/collar'), {
      ownerId: 'arjun', petId: 'max', type: 'gps_collar', name: "Max's collar", serial: 'DEMO-1', pairedBy: 'arjun',
      safeZone: { lat: 19.06, lng: 72.83, radiusM: 400 }, data: { inside: true },
    });
    await setDoc(doc(db, 'sosLogs/s1'), { uid: 'arjun', petId: 'max', lat: 19.06, lng: 72.83, area: '', source: 'gps' });
    await setDoc(doc(db, 'lostReports/r1'), { petId: 'max', ownerId: 'arjun', status: 'lost', area: 'Bandra West', alertsSent: 3, sightings: [], createdBy: 'arjun' });
  });
});

const as = (uid: string, role = 'owner') => env.authenticatedContext(uid, { role }).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe('connected devices', () => {
  it('only the family sees a device', async () => {
    await assertSucceeds(getDoc(doc(as('arjun'), 'devices/collar')));
    await assertSucceeds(getDoc(doc(as('nani'), 'devices/collar')));
    await assertFails(getDoc(doc(as('ravi'), 'devices/collar')));
    await assertFails(getDoc(doc(anon(), 'devices/collar')));
  });
  it('carers and up pair devices for the owner; viewers and strangers cannot', async () => {
    const d = { ownerId: 'arjun', petId: 'max', type: 'feeder', name: 'Feeder', serial: 'DEMO-2', data: {} };
    await assertSucceeds(setDoc(doc(as('meera'), 'devices/d2'), { ...d, pairedBy: 'meera' }));
    await assertFails(setDoc(doc(as('nani'), 'devices/d3'), { ...d, pairedBy: 'nani' }));
    await assertFails(setDoc(doc(as('ravi'), 'devices/d4'), { ...d, pairedBy: 'ravi' }));
    // Not under someone else as owner.
    await assertFails(setDoc(doc(as('meera'), 'devices/d5'), { ...d, ownerId: 'meera', pairedBy: 'meera' }));
  });
  it('any family member records a reading; only carers and up change the zone; the pet never changes', async () => {
    await assertSucceeds(updateDoc(doc(as('nani'), 'devices/collar'), { 'data.inside': false }));
    await assertFails(updateDoc(doc(as('nani'), 'devices/collar'), { safeZone: { lat: 1, lng: 1, radiusM: 5000 } }));
    await assertSucceeds(updateDoc(doc(as('meera'), 'devices/collar'), { safeZone: { lat: 19.06, lng: 72.83, radiusM: 600 } }));
    await assertFails(updateDoc(doc(as('arjun'), 'devices/collar'), { petId: 'luna' }));
    await assertFails(deleteDoc(doc(as('nani'), 'devices/collar')));
    await assertSucceeds(deleteDoc(doc(as('meera'), 'devices/collar')));
  });
});

describe('SOS logs', () => {
  it('people log their own activations with a known source', async () => {
    await assertSucceeds(setDoc(doc(as('ravi'), 'sosLogs/s2'), { uid: 'ravi', petId: 'simba', at: serverTimestamp(), lat: 17.41, lng: 78.45, area: 'Banjara Hills', source: 'chosen' }));
    await assertFails(setDoc(doc(as('ravi'), 'sosLogs/s3'), { uid: 'arjun', petId: 'max', at: serverTimestamp(), lat: 1, lng: 1, area: '', source: 'gps' }));
    await assertFails(setDoc(doc(as('ravi'), 'sosLogs/s4'), { uid: 'ravi', petId: null, at: serverTimestamp(), lat: 1, lng: 1, area: '', source: 'guess' }));
    await assertFails(setDoc(doc(anon(), 'sosLogs/s5'), { uid: 'x', petId: null, at: serverTimestamp(), lat: 1, lng: 1, area: '', source: 'gps' }));
  });
  it('only the person and admins read them', async () => {
    await assertSucceeds(getDoc(doc(as('arjun'), 'sosLogs/s1')));
    await assertSucceeds(getDoc(doc(as('boss', 'admin'), 'sosLogs/s1')));
    await assertFails(getDoc(doc(as('ravi'), 'sosLogs/s1')));
  });
});

describe('lost reports', () => {
  it('finders and strangers cannot read reports directly (the public page goes through a function)', async () => {
    await assertSucceeds(getDoc(doc(as('meera'), 'lostReports/r1')));
    await assertFails(getDoc(doc(as('ravi'), 'lostReports/r1')));
    await assertFails(getDoc(doc(anon(), 'lostReports/r1')));
  });
  it('carers can mark the pet lost; nobody can fake alerts or sightings', async () => {
    const r = { petId: 'max', ownerId: 'arjun', status: 'lost', area: 'Bandra West', note: '', createdBy: 'meera', alertsSent: 0, sightings: [] };
    await assertSucceeds(setDoc(doc(as('meera'), 'lostReports/r2'), r));
    await assertFails(setDoc(doc(as('nani'), 'lostReports/r3'), { ...r, createdBy: 'nani' }));
    await assertFails(setDoc(doc(as('meera'), 'lostReports/r4'), { ...r, alertsSent: 500 }));
    await assertFails(setDoc(doc(as('ravi'), 'lostReports/r5'), { ...r, createdBy: 'ravi' }));
    await assertFails(updateDoc(doc(as('arjun'), 'lostReports/r1'), { alertsSent: 999 }));
    await assertFails(updateDoc(doc(as('arjun'), 'lostReports/r1'), { sightings: [{ area: 'fake' }] }));
  });
  it('the family marks the pet found', async () => {
    await assertSucceeds(updateDoc(doc(as('meera'), 'lostReports/r1'), { status: 'found', foundAt: serverTimestamp() }));
    await assertFails(updateDoc(doc(as('nani'), 'lostReports/r1'), { status: 'found' }));
    await assertFails(deleteDoc(doc(as('arjun'), 'lostReports/r1')));
  });
  it('a carer can set the lost flag on the pet, but not change its tag or members', async () => {
    await assertSucceeds(updateDoc(doc(as('meera'), 'pets/max'), { lost: { area: 'Bandra West', reportId: 'r1' } }));
    await assertFails(updateDoc(doc(as('meera'), 'pets/max'), { qrToken: 'guessable' }));
    await assertFails(updateDoc(doc(as('nani'), 'pets/max'), { lost: null }));
  });
  it('relay counters are server-only', async () => {
    await assertFails(getDoc(doc(as('arjun'), 'tagRelays/Mx9LcV5tGp2YqHn7')));
    await assertFails(setDoc(doc(anon(), 'tagRelays/Mx9LcV5tGp2YqHn7'), { times: [] }));
  });
});
