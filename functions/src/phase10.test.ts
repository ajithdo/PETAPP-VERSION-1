/**
 * Phase 10 server rules: the same cases as the Dart tests for plans,
 * tickets and privacy, plus plan expiry and account deletion against the
 * Firestore emulator.
 */
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

process.env.GCLOUD_PROJECT ??= 'demo-pawsetu';
import { getApps, initializeApp } from 'firebase-admin/app';
if (getApps().length === 0) initializeApp({ projectId: 'demo-pawsetu' });
// eslint-disable-next-line @typescript-eslint/no-require-imports
const m = require('./phase10') as typeof import('./phase10');

describe('phase 10 rules', () => {
  const now = new Date('2026-10-15T10:00:00Z');
  const later = new Date('2026-10-20T10:00:00Z');
  const earlier = new Date('2026-10-10T10:00:00Z');

  it('an ended trial or paid period counts as free', () => {
    assert.equal(m.effectivePlan('trial', later, null, now), 'trial');
    assert.equal(m.effectivePlan('trial', earlier, null, now), 'free');
    assert.equal(m.effectivePlan('trial', null, null, now), 'free');
    assert.equal(m.effectivePlan('plus', null, later, now), 'plus');
    assert.equal(m.effectivePlan('plus', null, earlier, now), 'free');
    assert.equal(m.effectivePlan('plus', null, null, now), 'plus');
    assert.equal(m.effectivePlan('free', later, later, now), 'free');
  });
  it('the free trial is taken once, from the free plan', () => {
    assert.equal(m.canStartTrial('free', null), true);
    assert.equal(m.canStartTrial('free', earlier), false);
    assert.equal(m.canStartTrial('plus', null), false);
    const p = m.pricesFromConfig({ plans: { plusMonthly: 129, plusYearly: 999, trialDays: 14 } });
    assert.deepEqual(p, { monthly: 129, yearly: 999, trialDays: 14 });
    assert.deepEqual(m.pricesFromConfig(undefined), { monthly: 99, yearly: 799, trialDays: 7 });
    assert.equal(m.trialEnd(now, m.pricesFromConfig({})).toISOString(), '2026-10-22T10:00:00.000Z');
  });
  it('renewals land on the same day next month or year', () => {
    assert.equal(m.renewalDate(new Date('2026-01-15T09:00:00Z'), false).toISOString(), '2026-02-15T09:00:00.000Z');
    assert.equal(m.renewalDate(new Date('2026-01-15T09:00:00Z'), true).toISOString(), '2027-01-15T09:00:00.000Z');
  });
  it('tickets: support replying moves open to in progress; the person replying reopens', () => {
    assert.equal(m.statusAfterMessage('open', true), 'in_progress');
    assert.equal(m.statusAfterMessage('in_progress', true), 'in_progress');
    assert.equal(m.statusAfterMessage('resolved', false), 'open');
    assert.equal(m.statusAfterMessage('in_progress', false), 'in_progress');
    assert.equal(m.ticketRefundAmount(500, 349), 349);
    assert.equal(m.ticketRefundAmount(-5, 349), 0);
    assert.equal(m.ticketRefundAmount(200, 349), 200);
  });
  it('approval decisions, partner roles and family size', () => {
    assert.equal(m.statusForDecision('approve'), 'approved');
    assert.equal(m.statusForDecision('reject'), 'rejected');
    assert.equal(m.statusForDecision('suspend'), 'suspended');
    assert.equal(m.statusForDecision('delete'), null);
    assert.equal(m.roleForListing('clinics', {}), 'clinic_admin');
    assert.equal(m.roleForListing('providers', { type: 'walker' }), 'walker');
    assert.equal(m.roleForListing('sellers', {}), 'seller');
    assert.deepEqual(m.familyOthers({ ownerId: 'a', members: { a: {}, b: {}, c: {} } }), ['b', 'c']);
  });
  it('referral and reward codes', () => {
    let i = 0;
    const rnd = () => [0.1, 0.5, 0.9, 0.3][i++ % 4];
    const code = m.newReferralCode('Priya Sharma', rnd);
    assert.match(code, /^PRIY[A-Z2-9]{4}$/);
    assert.match(m.newReferralCode('రవి'), /^PAWS[A-Z2-9]{4}$/);
    assert.match(m.newReferralCode('Al'), /^ALPA[A-Z2-9]{4}$/);
    assert.match(m.rewardCouponCode(), /^REF[A-Z2-9]{6}$/);
  });
  it('account deletion waits 30 days; the export covers the same parts as the app', () => {
    assert.equal(m.deletionDate(now).toISOString(), '2026-11-14T10:00:00.000Z');
    assert.equal(m.EXPORT_PARTS.length, 27);
    assert.ok(m.EXPORT_PARTS.some((p) => p.collection === 'tickets' && p.field === 'uid'));
    assert.deepEqual(m.plainJson({ a: [1, 'x', null], d: new Date('2026-01-01T00:00:00Z') }), { a: [1, 'x', null], d: '2026-01-01T00:00:00.000Z' });
  });
});

const emulator = !!process.env.FIRESTORE_EMULATOR_HOST;

describe('plan expiry and account deletion (Firestore emulator)', { skip: !emulator }, () => {
  // eslint-disable-next-line @typescript-eslint/no-require-imports
  const { getFirestore } = require('firebase-admin/firestore') as typeof import('firebase-admin/firestore');
  const db = getFirestore();
  const now = new Date();
  const day = 86_400_000;

  it('ends trials, ends Plus without auto-renew and renews it with auto-renew (demo payment)', async () => {
    await db.collection('config').doc('app').set({ plans: { plusMonthly: 99, plusYearly: 799, trialDays: 7 } });
    await db.collection('users').doc('x_trial').set({ name: 'T', plan: 'trial', trialEndsAt: new Date(now.getTime() - day), language: 'te' });
    await db.collection('users').doc('x_trial_ok').set({ name: 'T2', plan: 'trial', trialEndsAt: new Date(now.getTime() + day) });
    await db.collection('users').doc('x_plus_off').set({ name: 'P', plan: 'plus', planRenewsAt: new Date(now.getTime() - day), autoRenew: false });
    await db.collection('users').doc('x_plus_on').set({ name: 'R', plan: 'plus', planRenewsAt: new Date(now.getTime() - day), autoRenew: true, planPeriod: 'yearly' });
    await m.runPlanExpiry(now);
    assert.equal((await db.collection('users').doc('x_trial').get()).data()?.plan, 'free');
    assert.equal((await db.collection('users').doc('x_trial_ok').get()).data()?.plan, 'trial');
    assert.equal((await db.collection('users').doc('x_plus_off').get()).data()?.plan, 'free');
    const on = (await db.collection('users').doc('x_plus_on').get()).data()!;
    assert.equal(on.plan, 'plus');
    assert.ok(on.planRenewsAt.toDate().getTime() > now.getTime() + 300 * day);
    const pays = await db.collection('payments').where('uid', '==', 'x_plus_on').get();
    assert.equal(pays.docs[0]?.data().amount, 799);
    const notes = await db.collection('notifications').where('uid', '==', 'x_trial').get();
    assert.equal(notes.docs[0]?.data().title, 'మీ Plus ట్రయల్ ముగిసింది');
  });

  it('deleting an account removes personal records and keeps money records anonymised', async () => {
    await db.collection('users').doc('x_gone').set({ name: 'Gone', plan: 'free' });
    await db.collection('pets').doc('x_pet').set({ ownerId: 'x_gone', name: 'Tommy' });
    await db.collection('vaccinations').doc('x_vac').set({ petId: 'x_pet', name: 'Rabies' });
    await db.collection('orders').doc('x_ord').set({ ownerId: 'x_gone', ownerName: 'Gone', total: 500, address: { line1: 'Somewhere' } });
    await db.collection('tickets').doc('x_tk').set({ uid: 'x_gone', subject: 'Hi' });
    const n = await m.deleteAccountData('x_gone');
    assert.ok(n >= 4);
    assert.equal((await db.collection('users').doc('x_gone').get()).exists, false);
    assert.equal((await db.collection('pets').doc('x_pet').get()).exists, false);
    assert.equal((await db.collection('vaccinations').doc('x_vac').get()).exists, false);
    assert.equal((await db.collection('tickets').doc('x_tk').get()).exists, false);
    const order = (await db.collection('orders').doc('x_ord').get()).data()!;
    assert.equal(order.ownerName, 'Deleted user');
    assert.equal(order.address, null);
    assert.equal(order.total, 500);
  });
});
