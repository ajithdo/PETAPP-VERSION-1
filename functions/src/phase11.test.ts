/**
 * Phase 11 server rules: invite links, booking expenses and sitter access,
 * plus the same functions against the Firestore emulator.
 */
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

process.env.GCLOUD_PROJECT ??= 'demo-pawsetu';
import { getApps, initializeApp } from 'firebase-admin/app';
if (getApps().length === 0) initializeApp({ projectId: 'demo-pawsetu' });
// eslint-disable-next-line @typescript-eslint/no-require-imports
const m = require('./phase11') as typeof import('./phase11');

describe('phase 11 rules', () => {
  const now = new Date('2026-10-15T10:00:00Z');

  it('invite tokens look like the app makes them; nobody is invited as owner', () => {
    assert.equal(m.tokenLooksValid('k3m9x2p7qa'), true);
    assert.equal(m.tokenLooksValid('short'), false);
    assert.equal(m.tokenLooksValid('../pets/bruno'), false);
    assert.equal(m.tokenLooksValid(42), false);
    assert.deepEqual(m.INVITE_ROLES, ['coowner', 'carer', 'viewer']);
  });
  it('a booking costs what was paid, less any refund', () => {
    const b = { paymentStatus: 'paid', status: 'confirmed', total: 750 };
    assert.equal(m.bookingExpenseAmount(b), 750);
    assert.equal(m.bookingExpenseAmount({ ...b, status: 'cancelled', refund: 375 }), 375);
    assert.equal(m.bookingExpenseAmount({ ...b, status: 'cancelled', refund: 750 }), 0);
    assert.equal(m.bookingExpenseAmount({ ...b, status: 'declined', refund: 750 }), 0);
    assert.equal(m.bookingExpenseAmount({ ...b, status: 'expired' }), 0);
    assert.equal(m.bookingExpenseAmount({ ...b, paymentStatus: 'pay_at_visit' }), 0);
    assert.equal(m.bookingExpenseAmount(undefined), 0);
    assert.equal(m.expenseCategory('clinic'), 'vet');
    assert.equal(m.expenseCategory('groomer'), 'grooming');
    assert.equal(m.expenseCategory('walker'), 'walking');
  });
  it('a sitter\'s access ends on its date; the owner and open-ended members stay', () => {
    const pet = {
      ownerId: 'priya',
      memberIds: ['priya', 'rohan', 'sitter', 'later'],
      members: {
        priya: { role: 'owner', expiresAt: null },
        rohan: { role: 'carer', expiresAt: null },
        sitter: { role: 'carer', expiresAt: new Date('2026-10-15T09:00:00Z') },
        later: { role: 'carer', expiresAt: new Date('2026-10-18T09:00:00Z') },
      },
    };
    assert.deepEqual(m.expiredMemberIds(pet, now), ['sitter']);
    assert.deepEqual(m.expiredMemberIds({ ...pet, memberIds: ['priya', 'rohan'] }, now), []);
  });
});

const emulator = !!process.env.FIRESTORE_EMULATOR_HOST;

describe('invites, booking expenses and access expiry (Firestore emulator)', { skip: !emulator }, () => {
  // eslint-disable-next-line @typescript-eslint/no-require-imports
  const { getFirestore } = require('firebase-admin/firestore') as typeof import('firebase-admin/firestore');
  const db = getFirestore();

  it('accepting an invite adds the person with the invited role, once', async () => {
    await db.collection('users').doc('p11_meera').set({ name: 'Meera' });
    await db.collection('pets').doc('p11_bruno').set({ ownerId: 'p11_priya', name: 'Bruno', memberIds: ['p11_priya'], members: { p11_priya: { role: 'owner' } } });
    await db.collection('petInvites').doc('p11tok1234').set({ petId: 'p11_bruno', role: 'carer', status: 'pending', token: 'p11tok1234', expiresAt: null });
    assert.deepEqual(await m.acceptInvite('p11_meera', 'p11tok1234'), { petId: 'p11_bruno' });
    const pet = (await db.collection('pets').doc('p11_bruno').get()).data()!;
    assert.deepEqual(pet.memberIds, ['p11_priya', 'p11_meera']);
    assert.equal(pet.members.p11_meera.role, 'carer');
    assert.equal(pet.members.p11_meera.name, 'Meera');
    assert.equal((await db.collection('petInvites').doc('p11tok1234').get()).data()?.status, 'accepted');
    await assert.rejects(m.acceptInvite('p11_eve', 'p11tok1234'), /already used/);
    await assert.rejects(m.acceptInvite('p11_eve', 'nosuchtoken1'), /not valid/);
  });

  it('an invite can never make someone the owner', async () => {
    await db.collection('petInvites').doc('p11tok9999').set({ petId: 'p11_bruno', role: 'owner', status: 'pending', token: 'p11tok9999' });
    await assert.rejects(m.acceptInvite('p11_eve', 'p11tok9999'), /not valid/);
  });

  it('the pet parent\'s expense follows the booking', async () => {
    const b = { ownerId: 'p11_priya', petId: 'p11_bruno', kind: 'groomer', serviceName: 'Full groom', paymentStatus: 'paid', status: 'confirmed', total: 1499, start: new Date() };
    await m.syncExpenseFor('p11_b1', b);
    let e = (await db.collection('expenses').doc('exp_p11_b1').get()).data()!;
    assert.equal(e.amount, 1499);
    assert.equal(e.category, 'grooming');
    assert.equal(e.ownerId, 'p11_priya');
    await m.syncExpenseFor('p11_b1', { ...b, status: 'cancelled', refund: 500 });
    e = (await db.collection('expenses').doc('exp_p11_b1').get()).data()!;
    assert.equal(e.amount, 999);
    await m.syncExpenseFor('p11_b1', { ...b, status: 'declined', refund: 1499 });
    assert.equal((await db.collection('expenses').doc('exp_p11_b1').get()).exists, false);
  });

  it('ended sitter access takes the pet off their list', async () => {
    const past = new Date(Date.now() - 3_600_000);
    const future = new Date(Date.now() + 86_400_000);
    await db.collection('pets').doc('p11_luna').set({
      ownerId: 'p11_arjun', name: 'Luna', memberIds: ['p11_arjun', 'p11_sitter', 'p11_walker'],
      members: { p11_arjun: { role: 'owner', expiresAt: null }, p11_sitter: { role: 'carer', expiresAt: past }, p11_walker: { role: 'carer', expiresAt: future } },
    });
    assert.ok((await m.runMemberExpiry(new Date())) >= 1);
    const pet = (await db.collection('pets').doc('p11_luna').get()).data()!;
    assert.deepEqual(pet.memberIds, ['p11_arjun', 'p11_walker']);
    assert.ok(pet.members.p11_sitter, 'stays in the family list as "Access ended"');
  });
});
