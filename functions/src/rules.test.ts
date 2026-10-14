/**
 * Security-rules tests. Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  RulesTestEnvironment,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc, updateDoc, deleteDoc, collection, addDoc } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-pawsetu-rules',
    firestore: { rules: readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8') },
  });
});

after(async () => env?.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    const inThreeDays = new Date(Date.now() + 3 * 86400000);
    const yesterday = new Date(Date.now() - 86400000);
    await setDoc(doc(db, 'users/priya'), { name: 'Priya', role: 'owner', plan: 'free' });
    await setDoc(doc(db, 'pets/bruno'), {
      ownerId: 'priya',
      name: 'Bruno',
      memberIds: ['priya', 'rohan', 'meera', 'old', 'viewer'],
      members: {
        priya: { role: 'owner', expiresAt: null },
        rohan: { role: 'carer', expiresAt: null },
        meera: { role: 'carer', expiresAt: inThreeDays },
        old: { role: 'carer', expiresAt: yesterday },
        viewer: { role: 'viewer', expiresAt: null },
      },
    });
    await setDoc(doc(db, 'clinics/ok'), { name: 'Approved clinic', status: 'approved', ownerUid: 'clinicadmin' });
    await setDoc(doc(db, 'clinics/pending'), { name: 'Pending clinic', status: 'pending', ownerUid: 'other' });
    await setDoc(doc(db, 'config/app'), { limits: {} });
    await setDoc(doc(db, 'bookings/b1'), { ownerId: 'priya', petId: 'bruno', price: 750, platformFee: 0, commission: 75, payout: 675, partnerUids: ['vet'] });
  });
});

const as = (uid: string, role = 'owner') => env.authenticatedContext(uid, { role }).firestore();

describe('users', () => {
  it('a user reads their own profile but not someone else\'s', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'users/priya')));
    await assertFails(getDoc(doc(as('ravi'), 'users/priya')));
  });
  it('a user cannot make themselves admin or Plus', async () => {
    await assertFails(updateDoc(doc(as('priya'), 'users/priya'), { role: 'admin' }));
    await assertFails(updateDoc(doc(as('priya'), 'users/priya'), { plan: 'plus' }));
    await assertSucceeds(updateDoc(doc(as('priya'), 'users/priya'), { language: 'te' }));
  });
});

describe('pets and family roles', () => {
  it('members read, strangers do not', async () => {
    await assertSucceeds(getDoc(doc(as('rohan'), 'pets/bruno')));
    await assertFails(getDoc(doc(as('stranger'), 'pets/bruno')));
  });
  it('a carer cannot delete or rename the pet', async () => {
    await assertFails(deleteDoc(doc(as('rohan'), 'pets/bruno')));
    await assertFails(updateDoc(doc(as('rohan'), 'pets/bruno'), { name: 'Bruno 2' }));
  });
  it('the owner can edit and delete', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'pets/bruno'), { name: 'Bruno' }));
    await assertSucceeds(deleteDoc(doc(as('priya'), 'pets/bruno')));
  });
  it('a sitter can log until access expires', async () => {
    await assertSucceeds(addDoc(collection(as('meera'), 'logs'), { petId: 'bruno', byUid: 'meera', type: 'walk' }));
    await assertFails(addDoc(collection(as('old'), 'logs'), { petId: 'bruno', byUid: 'old', type: 'walk' }));
  });
  it('nobody can log as someone else', async () => {
    await assertFails(addDoc(collection(as('rohan'), 'logs'), { petId: 'bruno', byUid: 'priya', type: 'walk' }));
  });
});

describe('partners and admin', () => {
  it('everyone sees approved clinics, only admin sees pending ones', async () => {
    await assertSucceeds(getDoc(doc(as('ravi'), 'clinics/ok')));
    await assertFails(getDoc(doc(as('ravi'), 'clinics/pending')));
    await assertSucceeds(getDoc(doc(as('boss', 'admin'), 'clinics/pending')));
  });
  it('a clinic admin cannot approve their own clinic', async () => {
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'clinics/ok'), { status: 'approved', rating: 5 }));
  });
  it('only admins change app settings', async () => {
    await assertFails(setDoc(doc(as('priya'), 'config/app'), { limits: { free: { pets: 99 } } }));
    await assertSucceeds(setDoc(doc(as('boss', 'admin'), 'config/app'), { limits: { free: { pets: 3 } } }));
  });
  it('nobody edits booking money on the client', async () => {
    await assertFails(updateDoc(doc(as('priya'), 'bookings/b1'), { price: 1 }));
    await assertFails(updateDoc(doc(as('vet', 'vet'), 'bookings/b1'), { payout: 999 }));
    await assertSucceeds(updateDoc(doc(as('vet', 'vet'), 'bookings/b1'), { status: 'confirmed' }));
  });
  it('the demo outbox is admin-only', async () => {
    await assertFails(getDoc(doc(as('priya'), 'outbox/x')));
  });
});
