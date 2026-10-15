/**
 * Security-rules tests for Phase 10: profiles (plan, trial, suspension),
 * help tickets, payments, referrals, banners, reports and admin-only data.
 * Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import { addDoc, arrayUnion, collection, doc, getDoc, getDocs, query, setDoc, updateDoc, where } from 'firebase/firestore';

let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-pawsetu-rules-admin',
    firestore: { rules: readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8') },
  });
});

after(async () => env?.cleanup());

const first = { by: 'ravi', byName: 'Ravi Teja', admin: false, text: 'The walker came late.', at: new Date('2026-10-15T08:00:00Z') };

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'users/ravi'), { name: 'Ravi Teja', role: 'owner', plan: 'free', referralCode: 'PAWRAV2', consents: { marketing: false } });
    await setDoc(doc(db, 'users/priya'), { name: 'Priya Sharma', role: 'owner', plan: 'plus', referralCode: 'PAWPRI1' });
    await setDoc(doc(db, 'tickets/t1'), {
      uid: 'ravi', name: 'Ravi Teja', role: 'owner', topic: 'late', subject: 'Late walker', status: 'open', assignee: null, refund: null, messages: [first],
    });
    await setDoc(doc(db, 'tickets/t2'), {
      uid: 'ravi', name: 'Ravi Teja', role: 'owner', topic: 'late', subject: 'Old one', status: 'resolved', assignee: 'Admin', refund: null, messages: [first],
    });
    await setDoc(doc(db, 'payments/p1'), { uid: 'priya', kind: 'plus', amount: 99, demo: true });
    await setDoc(doc(db, 'referrals/r1'), { referrerId: 'priya', referredId: 'rohan', code: 'PAWPRI1' });
    await setDoc(doc(db, 'banners/b1'), { title: 'Try Plus', placement: 'home', active: true });
  });
});

const as = (uid: string, role = 'owner') => env.authenticatedContext(uid, { role }).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe('profiles: plan, trial and suspension are not self-service', () => {
  it('people change their consents, auto-renew and deletion request', async () => {
    const db = as('ravi');
    await assertSucceeds(updateDoc(doc(db, 'users/ravi'), { 'consents.marketing': true }));
    await assertSucceeds(updateDoc(doc(db, 'users/ravi'), { autoRenew: false }));
    await assertSucceeds(updateDoc(doc(db, 'users/ravi'), { deletionRequestedAt: new Date() }));
    await assertSucceeds(updateDoc(doc(db, 'users/ravi'), { deletionRequestedAt: null }));
  });
  it('but not their plan, trial, suspension or referral code', async () => {
    const db = as('ravi');
    await assertFails(updateDoc(doc(db, 'users/ravi'), { plan: 'plus' }));
    await assertFails(updateDoc(doc(db, 'users/ravi'), { plan: 'trial', trialEndsAt: new Date('2030-01-01') }));
    await assertFails(updateDoc(doc(db, 'users/ravi'), { trialUsedAt: null }));
    await assertFails(updateDoc(doc(db, 'users/ravi'), { planPeriod: 'yearly' }));
    await assertFails(updateDoc(doc(db, 'users/ravi'), { suspended: false }));
    await assertFails(updateDoc(doc(db, 'users/ravi'), { referralCode: 'PAWPRI1' }));
  });
  it('a new profile starts free and cannot carry a trial or suspension', async () => {
    await assertSucceeds(setDoc(doc(as('new1'), 'users/new1'), { name: 'New', role: 'owner', plan: 'free' }));
    await assertFails(setDoc(doc(as('new2'), 'users/new2'), { name: 'New', role: 'owner', plan: 'free', trialEndsAt: new Date('2030-01-01') }));
    await assertFails(setDoc(doc(as('new3'), 'users/new3'), { name: 'New', role: 'owner', plan: 'free', suspended: false }));
  });
  it('admins suspend people and change plans', async () => {
    await assertSucceeds(updateDoc(doc(as('boss', 'admin'), 'users/ravi'), { suspended: true, suspendReason: 'Fake account' }));
  });
});

describe('help tickets', () => {
  it('people raise tickets for themselves only, open, with one message', async () => {
    const t = { uid: 'ravi', name: 'Ravi', role: 'owner', topic: 'app', subject: 'Hi', status: 'open', assignee: null, refund: null, messages: [first] };
    await assertSucceeds(setDoc(doc(as('ravi'), 'tickets/new1'), t));
    await assertFails(setDoc(doc(as('ravi'), 'tickets/new2'), { ...t, uid: 'priya' }));
    await assertFails(setDoc(doc(as('ravi'), 'tickets/new3'), { ...t, status: 'resolved' }));
    await assertFails(setDoc(doc(as('ravi'), 'tickets/new4'), { ...t, refund: { amount: 500 } }));
    await assertFails(setDoc(doc(as('ravi'), 'tickets/new5'), { ...t, messages: [{ ...first, admin: true }] }));
  });
  it('only the person and support read a ticket', async () => {
    await assertSucceeds(getDoc(doc(as('ravi'), 'tickets/t1')));
    await assertSucceeds(getDoc(doc(as('boss', 'admin'), 'tickets/t1')));
    await assertFails(getDoc(doc(as('priya'), 'tickets/t1')));
    await assertFails(getDoc(doc(anon(), 'tickets/t1')));
    await assertSucceeds(getDocs(query(collection(as('ravi'), 'tickets'), where('uid', '==', 'ravi'))));
  });
  it('the person adds their own reply; a reply to a resolved ticket reopens it', async () => {
    const mine = { by: 'ravi', byName: 'Ravi Teja', admin: false, text: 'Any news?', at: new Date('2026-10-15T09:00:00Z') };
    await assertSucceeds(updateDoc(doc(as('ravi'), 'tickets/t1'), { messages: arrayUnion(mine), status: 'open', updatedAt: new Date() }));
    await assertSucceeds(updateDoc(doc(as('ravi'), 'tickets/t2'), { messages: arrayUnion(mine), status: 'open', updatedAt: new Date() }));
  });
  it('but cannot pose as support, resolve, assign or refund', async () => {
    const fake = { by: 'ravi', byName: 'PawSetu Admin', admin: true, text: 'Refunded!', at: new Date() };
    await assertFails(updateDoc(doc(as('ravi'), 'tickets/t1'), { messages: arrayUnion(fake), updatedAt: new Date() }));
    await assertFails(updateDoc(doc(as('ravi'), 'tickets/t1'), { status: 'resolved' }));
    await assertFails(updateDoc(doc(as('ravi'), 'tickets/t1'), { assignee: 'Me' }));
    await assertFails(updateDoc(doc(as('ravi'), 'tickets/t1'), { refund: { amount: 999, status: 'refunded' } }));
    await assertFails(updateDoc(doc(as('ravi'), 'tickets/t1'), { messages: [], updatedAt: new Date() }));
    await assertFails(updateDoc(doc(as('priya'), 'tickets/t1'), { messages: arrayUnion({ ...first, by: 'priya', text: 'x' }), updatedAt: new Date() }));
  });
  it('support replies, assigns, resolves and records demo refunds', async () => {
    const db = as('boss', 'admin');
    await assertSucceeds(updateDoc(doc(db, 'tickets/t1'), { status: 'resolved', assignee: 'Boss', refund: { amount: 349, status: 'refunded' } }));
    await assertSucceeds(addDoc(collection(db, 'payments'), { uid: 'ravi', kind: 'refund', amount: -349, demo: true, ticketId: 't1' }));
  });
});

describe('payments, referrals, banners and reports', () => {
  it('people see their own payments and cannot write any', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'payments/p1')));
    await assertFails(getDoc(doc(as('ravi'), 'payments/p1')));
    await assertFails(addDoc(collection(as('ravi'), 'payments'), { uid: 'ravi', kind: 'plus', amount: 0, demo: true }));
    await assertFails(addDoc(collection(as('ravi'), 'payments'), { uid: 'ravi', kind: 'refund', amount: -5000, demo: true }));
  });
  it('referrals are read by the two friends and written by the server only', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'referrals/r1')));
    await assertSucceeds(getDoc(doc(as('rohan'), 'referrals/r1')));
    await assertFails(getDoc(doc(as('ravi'), 'referrals/r1')));
    await assertFails(setDoc(doc(as('ravi'), 'referrals/r2'), { referrerId: 'ravi', referredId: 'priya', code: 'PAWRAV2' }));
  });
  it('banners are read by signed-in people and changed by admins', async () => {
    await assertSucceeds(getDoc(doc(as('ravi'), 'banners/b1')));
    await assertFails(getDoc(doc(anon(), 'banners/b1')));
    await assertFails(updateDoc(doc(as('ravi'), 'banners/b1'), { active: false }));
    await assertSucceeds(updateDoc(doc(as('boss', 'admin'), 'banners/b1'), { active: false }));
  });
  it('anyone can report, as themselves; only admins read or act on reports', async () => {
    const r = { type: 'review', targetId: 'rev1', reporterId: 'ravi', reason: 'spam', status: 'open' };
    await assertSucceeds(addDoc(collection(as('ravi'), 'reports'), r));
    await assertFails(addDoc(collection(as('ravi'), 'reports'), { ...r, reporterId: 'priya' }));
    await assertFails(addDoc(collection(as('ravi'), 'reports'), { ...r, status: 'dismissed' }));
    await assertFails(getDocs(collection(as('ravi'), 'reports')));
  });
  it('the audit log and dashboard numbers are for admins only', async () => {
    await assertFails(getDocs(collection(as('ravi'), 'auditLog')));
    await assertFails(addDoc(collection(as('ravi'), 'auditLog'), { action: 'x' }));
    await assertFails(getDocs(collection(as('ravi'), 'analyticsDaily')));
    await assertSucceeds(getDocs(collection(as('boss', 'admin'), 'auditLog')));
  });
  it('plan prices and limits are public to read but only admins change them', async () => {
    await env.withSecurityRulesDisabled(async (ctx) => setDoc(doc(ctx.firestore(), 'config/app'), { limits: { free: { teleVetMessages: 20 } } }));
    await assertSucceeds(getDoc(doc(anon(), 'config/app')));
    await assertFails(updateDoc(doc(as('ravi'), 'config/app'), { 'limits.free.teleVetMessages': 999 }));
    await assertSucceeds(updateDoc(doc(as('boss', 'admin'), 'config/app'), { 'limits.free.teleVetMessages': 30 }));
  });
});
