/**
 * Security-rules tests for the vault, insurance, share links and album
 * (Phase 7). Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { deleteDoc, doc, getDoc, setDoc, updateDoc } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-pawsetu-rules-vault',
    firestore: { rules: readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8') },
  });
});

after(async () => env?.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'pets/bruno'), {
      ownerId: 'priya',
      name: 'Bruno',
      memberIds: ['priya', 'rohan', 'nani'],
      members: { priya: { role: 'owner', expiresAt: null }, rohan: { role: 'carer', expiresAt: null }, nani: { role: 'viewer', expiresAt: null } },
    });
    await setDoc(doc(db, 'documents/d1'), { ownerId: 'priya', petId: 'bruno', type: 'vaccination', title: 'Rabies' });
    await setDoc(doc(db, 'insurance/i1'), { ownerId: 'priya', petId: 'bruno', provider: 'Shield', claims: [] });
    await setDoc(doc(db, 'shareLinks/tok1'), { ownerId: 'priya', petId: 'bruno', kind: 'docs', docIds: ['d1'], revoked: false, accessLog: [], pinHash: 'pbkdf2$1000$x$y' });
    await setDoc(doc(db, 'album/a1'), { ownerId: 'priya', petId: 'bruno', type: 'photo', url: 'x', byUid: 'priya', favourite: false });
  });
});

const as = (uid: string, role = 'owner') => env.authenticatedContext(uid, { role }).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe('vault documents', () => {
  it('family on the pet can read; strangers and signed-out people cannot', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'documents/d1')));
    await assertSucceeds(getDoc(doc(as('rohan'), 'documents/d1')));
    await assertFails(getDoc(doc(as('ravi'), 'documents/d1')));
    await assertFails(getDoc(doc(anon(), 'documents/d1')));
  });
  it('a carer can file a certificate under the owner; strangers cannot add to the pet', async () => {
    await assertSucceeds(setDoc(doc(as('rohan'), 'documents/d2'), { ownerId: 'priya', petId: 'bruno', type: 'vaccination', title: 'DHPPi' }));
    await assertFails(setDoc(doc(as('ravi'), 'documents/d3'), { ownerId: 'ravi', petId: 'bruno', type: 'other', title: 'x' }));
    await assertFails(setDoc(doc(as('nani'), 'documents/d4'), { ownerId: 'nani', petId: 'bruno', type: 'other', title: 'x' }));
  });
  it('documents cannot be moved to another owner or pet', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'documents/d1'), { title: 'Anti-rabies' }));
    await assertFails(updateDoc(doc(as('priya'), 'documents/d1'), { petId: 'simba' }));
    await assertFails(deleteDoc(doc(as('rohan'), 'documents/d1')));
    await assertSucceeds(deleteDoc(doc(as('priya'), 'documents/d1')));
  });
});

describe('share links', () => {
  it('only the owner sees a link; the public opens it through the function', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'shareLinks/tok1')));
    await assertFails(getDoc(doc(anon(), 'shareLinks/tok1')));
    await assertFails(getDoc(doc(as('rohan'), 'shareLinks/tok1')));
  });
  it('links start un-revoked with an empty log', async () => {
    const ok = { ownerId: 'priya', petId: 'bruno', kind: 'docs', docIds: ['d1'], revoked: false, accessLog: [] };
    await assertSucceeds(setDoc(doc(as('priya'), 'shareLinks/tok2'), ok));
    await assertFails(setDoc(doc(as('priya'), 'shareLinks/tok3'), { ...ok, accessLog: [{ at: 1, ok: true }] }));
    await assertFails(setDoc(doc(as('ravi'), 'shareLinks/tok4'), { ...ok, ownerId: 'ravi' }));
  });
  it('revoking is final and nothing else can change', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'shareLinks/tok1'), { revoked: true, revokedAt: new Date() }));
    await assertFails(updateDoc(doc(as('priya'), 'shareLinks/tok1'), { revoked: false }));
    await assertFails(updateDoc(doc(as('priya'), 'shareLinks/tok1'), { docIds: ['d1', 'd9'] }));
    await assertFails(updateDoc(doc(anon(), 'shareLinks/tok1'), { accessLog: [{ at: 1, ok: true }] }));
  });
});

describe('insurance', () => {
  it('family reads; only the owner or co-owner changes policies and claims', async () => {
    await assertSucceeds(getDoc(doc(as('rohan'), 'insurance/i1')));
    await assertFails(getDoc(doc(as('ravi'), 'insurance/i1')));
    await assertSucceeds(updateDoc(doc(as('priya'), 'insurance/i1'), { claims: [{ id: 'c1', status: 'draft' }] }));
    await assertFails(updateDoc(doc(as('rohan'), 'insurance/i1'), { claims: [] }));
    await assertFails(setDoc(doc(as('ravi'), 'insurance/i2'), { ownerId: 'ravi', petId: 'bruno' }));
  });
});

describe('album', () => {
  it('family adds photos as themselves and can favourite them', async () => {
    await assertSucceeds(setDoc(doc(as('rohan'), 'album/a2'), { ownerId: 'priya', petId: 'bruno', type: 'photo', url: 'y', byUid: 'rohan' }));
    await assertFails(setDoc(doc(as('rohan'), 'album/a3'), { ownerId: 'priya', petId: 'bruno', type: 'photo', url: 'y', byUid: 'priya' }));
    await assertSucceeds(updateDoc(doc(as('rohan'), 'album/a1'), { favourite: true }));
    await assertFails(updateDoc(doc(as('rohan'), 'album/a1'), { petId: 'simba' }));
  });
  it('strangers cannot see or add to the album', async () => {
    await assertFails(getDoc(doc(as('ravi'), 'album/a1')));
    await assertFails(setDoc(doc(as('ravi'), 'album/a4'), { ownerId: 'priya', petId: 'bruno', type: 'photo', url: 'z', byUid: 'ravi' }));
  });
});
