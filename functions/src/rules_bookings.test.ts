/**
 * Security-rules tests for bookings, reviews, partner sign-up,
 * notifications and expenses (Phase 5). Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { addDoc, collection, doc, getDoc, setDoc, updateDoc } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-pawsetu-rules-bookings',
    firestore: { rules: readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8') },
  });
});

after(async () => env?.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'pets/simba'), { ownerId: 'ravi', name: 'Simba', memberIds: ['ravi'], members: { ravi: { role: 'owner', expiresAt: null } } });
    await setDoc(doc(db, 'bookings/g1'), {
      ownerId: 'ravi', petId: 'simba', providerId: 'prov_groom_1', partnerUids: ['groomer'],
      status: 'pending', price: 1499, platformFee: 0, commission: 150, payout: 1349,
    });
    await setDoc(doc(db, 'providers/prov_groom_1'), { name: 'Lakshmi Groom Studio', status: 'approved', uid: 'groomer', rating: 4.5, reviewCount: 10 });
    await setDoc(doc(db, 'providers/prov_new'), { name: 'New groomer', status: 'pending', uid: 'newbie' });
    await setDoc(doc(db, 'reviews/r1'), { targetId: 'prov_groom_1', ownerId: 'ravi', rating: 5, text: 'Great', status: 'visible' });
    await setDoc(doc(db, 'notifications/n1'), { uid: 'ravi', title: 'Hi', read: false });
    await setDoc(doc(db, 'expenses/e1'), { ownerId: 'ravi', petId: 'simba', amount: 1499 });
  });
});

const as = (uid: string, role = 'owner') => env.authenticatedContext(uid, { role }).firestore();

describe('bookings', () => {
  it('the owner and the booked partner read a booking; others do not', async () => {
    await assertSucceeds(getDoc(doc(as('ravi'), 'bookings/g1')));
    await assertSucceeds(getDoc(doc(as('groomer', 'groomer'), 'bookings/g1')));
    await assertFails(getDoc(doc(as('priya'), 'bookings/g1')));
    await assertFails(getDoc(doc(as('othergroomer', 'groomer'), 'bookings/g1')));
  });
  it('clients cannot create bookings directly (the createBooking function prices them)', async () => {
    await assertFails(setDoc(doc(as('ravi'), 'bookings/new'), { ownerId: 'ravi', petId: 'simba', price: 1, partnerUids: [] }));
  });
  it('the partner accepts, but nobody changes the money or the owner', async () => {
    await assertSucceeds(updateDoc(doc(as('groomer', 'groomer'), 'bookings/g1'), { status: 'confirmed' }));
    await assertFails(updateDoc(doc(as('groomer', 'groomer'), 'bookings/g1'), { commission: 0 }));
    await assertFails(updateDoc(doc(as('ravi'), 'bookings/g1'), { ownerId: 'priya' }));
  });
});

describe('reviews', () => {
  it('anyone reads reviews; you can only post as yourself', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'reviews/r1')));
    await assertSucceeds(addDoc(collection(as('ravi'), 'reviews'), { targetId: 'prov_groom_1', ownerId: 'ravi', rating: 4 }));
    await assertFails(addDoc(collection(as('ravi'), 'reviews'), { targetId: 'prov_groom_1', ownerId: 'priya', rating: 1 }));
  });
  it('partners may only add a reply', async () => {
    await assertSucceeds(updateDoc(doc(as('groomer', 'groomer'), 'reviews/r1'), { reply: 'Thank you!', replyAt: new Date() }));
    await assertFails(updateDoc(doc(as('groomer', 'groomer'), 'reviews/r1'), { rating: 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'reviews/r1'), { reply: 'Fake reply' }));
  });
});

describe('partner sign-up', () => {
  it('a new partner applies for themselves with status pending only', async () => {
    await assertSucceeds(setDoc(doc(as('newbie'), 'partnerApplications/newbie'), { uid: 'newbie', status: 'pending' }));
    await assertFails(setDoc(doc(as('newbie'), 'partnerApplications/other'), { uid: 'other', status: 'pending' }));
    await assertFails(setDoc(doc(as('sneaky'), 'partnerApplications/sneaky'), { uid: 'sneaky', status: 'approved' }));
  });
  it('applicants cannot approve their own listing; pending listings stay hidden', async () => {
    await assertFails(updateDoc(doc(as('newbie', 'groomer'), 'providers/prov_new'), { status: 'approved' }));
    await assertSucceeds(getDoc(doc(as('newbie'), 'providers/prov_new')));
    await assertFails(getDoc(doc(as('ravi'), 'providers/prov_new')));
    await assertSucceeds(getDoc(doc(as('ravi'), 'providers/prov_groom_1')));
  });
  it('a pending listing must belong to its creator', async () => {
    await assertSucceeds(setDoc(doc(as('newbie'), 'providers/prov_x'), { name: 'X', status: 'pending', uid: 'newbie' }));
    await assertFails(setDoc(doc(as('newbie'), 'providers/prov_y'), { name: 'Y', status: 'pending', uid: 'someone' }));
    await assertFails(setDoc(doc(as('newbie'), 'providers/prov_z'), { name: 'Z', status: 'approved', uid: 'newbie' }));
  });
});

describe('notifications and expenses', () => {
  it('only the recipient reads a notification and may only mark it read', async () => {
    await assertSucceeds(getDoc(doc(as('ravi'), 'notifications/n1')));
    await assertFails(getDoc(doc(as('priya'), 'notifications/n1')));
    await assertSucceeds(updateDoc(doc(as('ravi'), 'notifications/n1'), { read: true }));
    await assertFails(updateDoc(doc(as('ravi'), 'notifications/n1'), { title: 'Changed' }));
  });
  it('expenses are private to their owner', async () => {
    await assertSucceeds(getDoc(doc(as('ravi'), 'expenses/e1')));
    await assertFails(getDoc(doc(as('priya'), 'expenses/e1')));
    await assertFails(addDoc(collection(as('priya'), 'expenses'), { ownerId: 'ravi', amount: 1 }));
  });
});
