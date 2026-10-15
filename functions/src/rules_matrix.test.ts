/**
 * Phase 11 security matrix: every collection in firestore.rules, checked for
 * the people who use it: signed out, a stranger, the pet parent and their
 * family (co-owner, carer, viewer, a sitter whose access ended), each
 * partner role (clinic admin, vet, groomer, seller) and the admin. The
 * app's real writes are allowed and the misuse cases are not. The last test
 * fails when a collection in the rules has no cases here.
 *
 * Run with the Firestore emulator:
 *   firebase emulators:exec --only firestore "npm --prefix functions test"
 */
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { after, before, beforeEach, describe, it } from 'node:test';

import { assertFails, assertSucceeds, initializeTestEnvironment, RulesTestEnvironment } from '@firebase/rules-unit-testing';
import {
  addDoc, arrayUnion, collection, deleteDoc, doc, getDoc, getDocs, query, setDoc, updateDoc, where,
} from 'firebase/firestore';

const RULES = readFileSync(resolve(__dirname, '../../firestore.rules'), 'utf8');
let env: RulesTestEnvironment;

before(async () => {
  env = await initializeTestEnvironment({ projectId: 'demo-pawsetu-rules-matrix', firestore: { rules: RULES } });
});
after(async () => env?.cleanup());

const day = 86_400_000;
const soon = () => new Date(Date.now() + 3 * day);
const past = () => new Date(Date.now() - day);

/** One small world: Priya's dog Bruno and his family, Ravi's cat Tiger, a
 *  clinic with two vets, a groomer, a seller and their customers' records. */
beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    const put = (path: string, data: Record<string, unknown>) => setDoc(doc(db, path), data);
    await put('users/priya', { name: 'Priya', role: 'owner', plan: 'free', language: 'en', referralCode: 'PRIYAB2C3' });
    await put('users/ravi', { name: 'Ravi', role: 'owner', plan: 'free', language: 'te' });
    await put('pets/bruno', {
      ownerId: 'priya', name: 'Bruno',
      memberIds: ['priya', 'co', 'rohan', 'viewer', 'old'],
      members: {
        priya: { role: 'owner', expiresAt: null },
        co: { role: 'coowner', expiresAt: null },
        rohan: { role: 'carer', expiresAt: soon() },
        viewer: { role: 'viewer', expiresAt: null },
        old: { role: 'carer', expiresAt: past() },
      },
    });
    await put('pets/tiger', { ownerId: 'ravi', name: 'Tiger', memberIds: ['ravi'], members: { ravi: { role: 'owner', expiresAt: null } } });
    await put('petInvites/tok8x9k2m4p', {
      petId: 'bruno', petName: 'Bruno', invitedBy: 'priya', role: 'carer', status: 'pending', token: 'tok8x9k2m4p', contact: 'meera@example.com',
    });
    await put('activity/a1', { petId: 'bruno', actorId: 'priya', type: 'fed' });
    await put('logs/l1', { petId: 'bruno', byUid: 'rohan', type: 'walk', note: 'Park' });
    await put('vaccinations/v1', { petId: 'bruno', name: 'Rabies' });
    await put('vaccinations/v2', { petId: 'tiger', name: 'FVRCP' });
    await put('medicines/m1', { petId: 'bruno', name: 'Drontal' });
    await put('medicineLogs/ml1', { petId: 'bruno', medicineId: 'm1' });
    await put('healthEvents/h1', { petId: 'bruno', type: 'visit' });
    await put('reminders/r1', { ownerId: 'priya', petId: 'bruno', title: 'Deworm' });
    await put('notifications/n1', { uid: 'priya', title: 'Hi', read: false });

    await put('clinics/clinic1', { name: 'Paws Clinic', status: 'approved', ownerUid: 'clinicadmin', rating: 4.5, reviewCount: 10, commissionPercent: 10 });
    await put('clinics/clinic2', { name: 'Other Clinic', status: 'approved', ownerUid: 'otheradmin' });
    await put('clinics/clinicPending', { name: 'New Clinic', status: 'pending', ownerUid: 'newclinic' });
    await put('vets/vet1', { name: 'Dr Rao', clinicId: 'clinic1', uid: 'vetuid', status: 'approved', teleVet: true, rating: 4.8, reviewCount: 3 });
    await put('vets/vet2', { name: 'Dr Sen', clinicId: 'clinic2', uid: 'othervet', status: 'approved' });
    await put('providers/groom1', { name: 'Lakshmi Groom', type: 'groomer', status: 'approved', uid: 'groomer', rating: 4.5, reviewCount: 8 });
    await put('partnerApplications/groomer', { uid: 'groomer', status: 'approved' });
    await put('sellers/s1', { name: 'Tail Treats', status: 'approved', uid: 'seller' });
    await put('sellers/s2', { name: 'Other Store', status: 'approved', uid: 'otherseller' });
    await put('sellers/s3', { name: 'Paused Store', status: 'suspended', uid: 'seller3' });
    await put('products/p1', { name: 'Dog food', sellerId: 's1', price: 1200, rating: 4, reviewCount: 2, featured: false, active: true });
    await put('partners/pt1', { name: 'Big Pet Store', clicks: 3 });

    const money = { price: 700, travelFee: 0, platformFee: 50, discount: 0, total: 750, commission: 70, payout: 630 };
    await put('bookings/b1', { ownerId: 'priya', petId: 'bruno', kind: 'clinic', providerId: 'clinic1', partnerUids: ['clinicadmin', 'vetuid'], status: 'pending', paymentStatus: 'paid', ...money });
    await put('bookings/b2', { ownerId: 'priya', petId: 'bruno', kind: 'groomer', providerId: 'groom1', partnerUids: ['groomer'], status: 'completed', paymentStatus: 'paid', ...money });
    await put('bookings/b3', { ownerId: 'priya', petId: 'bruno', kind: 'clinic', providerId: 'clinic1', partnerUids: ['clinicadmin'], status: 'suggested', paymentStatus: 'pay_at_visit', ...money });
    await put('bookings/b4', { ownerId: 'priya', petId: 'bruno', kind: 'clinic', providerId: 'clinic1', partnerUids: ['clinicadmin'], status: 'completed', paymentStatus: 'paid', ...money });
    await put('reviews/rc1', { targetType: 'clinic', targetId: 'clinic1', ownerId: 'priya', bookingId: 'b4', rating: 5, status: 'visible' });
    await put('reviews/rp1', { targetType: 'product', targetId: 'p1', sellerId: 's1', ownerId: 'priya', orderId: 'o1', rating: 4, status: 'visible' });
    await put('reviews/rv1', { targetType: 'vet', targetId: 'vet1', ownerId: 'priya', consultationId: 'c1', rating: 5, status: 'visible' });

    const chat = { lastMessage: '', lastAt: new Date(), unread: {}, muted: {}, typing: {} };
    await put('conversations/chat_b1', { type: 'chat', participantIds: ['priya', 'clinicadmin', 'vetuid'], ownerId: 'priya', bookingId: 'b1', providerId: 'clinic1', blockedBy: [], ...chat });
    await put('conversations/tv_c1', { type: 'televet', participantIds: ['priya', 'vetuid'], ownerId: 'priya', blockedBy: [], ...chat });
    await put('conversations/enq_groom1_ravi', { type: 'enquiry', participantIds: ['ravi', 'groomer'], ownerId: 'ravi', providerId: 'groom1', blockedBy: ['groomer'], ...chat });
    await put('messages/msg1', { conversationId: 'chat_b1', senderId: 'clinicadmin', type: 'text', text: 'See you at 5', readBy: ['clinicadmin'] });
    await put('consultations/c1', { ownerId: 'priya', petId: 'bruno', vetId: 'vet1', vetUid: 'vetuid', status: 'active', fee: 199, conversationId: 'tv_c1' });
    await put('consultations/cq', { ownerId: 'ravi', petId: 'tiger', vetUid: null, status: 'queued', fee: 199 });
    await put('consultations/c2', { ownerId: 'ravi', petId: 'tiger', vetId: 'vet2', vetUid: 'othervet', status: 'active', fee: 199 });
    await put('prescriptions/rx1', { consultationId: 'c1', petId: 'bruno', ownerId: 'priya', vetUid: 'vetuid', items: [] });

    await put('documents/d1', { petId: 'bruno', ownerId: 'priya', type: 'lab_report', title: 'Blood test' });
    await put('shareLinks/sh1', { petId: 'bruno', ownerId: 'priya', revoked: false, accessLog: [] });
    await put('insurance/i1', { petId: 'bruno', ownerId: 'priya', provider: 'PetSure' });
    await put('album/al1', { petId: 'bruno', ownerId: 'priya', byUid: 'rohan', caption: 'Beach' });

    await put('orders/o1', { ownerId: 'priya', sellerId: 's1', sellerUids: ['seller'], status: 'delivered', paymentStatus: 'paid', total: 1249, subtotal: 1200, items: [] });
    await put('orders/o2', { ownerId: 'priya', sellerId: 's1', sellerUids: ['seller'], status: 'placed', paymentStatus: 'paid', total: 1249, subtotal: 1200, items: [] });
    await put('affiliateClicks/ac1', { uid: 'priya', partnerId: 'pt1' });
    await put('subscriptions/sub1', { ownerId: 'priya', productId: 'p1', everyWeeks: 4 });
    await put('expenses/e1', { ownerId: 'priya', petId: 'bruno', amount: 750 });
    await put('carts/priya', { items: [] });
    await put('coupons/WELCOME10', { percent: 10, active: true });

    await put('devices/dev1', { petId: 'bruno', ownerId: 'priya', type: 'gps', serial: 'GPS-1', name: 'Collar', pairedBy: 'priya', data: {} });
    await put('sosLogs/sos1', { uid: 'priya', petId: 'bruno', source: 'gps' });
    await put('lostReports/lr1', { petId: 'bruno', ownerId: 'priya', createdBy: 'priya', status: 'lost', alertsSent: 3, sightings: [] });
    await put('tickets/t1', { uid: 'priya', subject: 'Late refund', status: 'open', messages: [{ by: 'priya', admin: false, text: 'Where is my refund?' }] });
    await put('reports/rep1', { reporterId: 'priya', type: 'review', status: 'open' });
    await put('payments/pay1', { uid: 'priya', kind: 'plus', amount: 99, demo: true });
    await put('referrals/ref1', { referrerId: 'priya', referredId: 'ravi', code: 'PRIYAB2C3' });
    await put('banners/ban1', { title: 'Monsoon care', audience: 'all' });
    await put('config/app', { limits: { free: { pets: 2 } } });
    await put('outbox/ob1', { channel: 'sms', to: '+919800000000', body: 'Demo' });
    await put('auditLog/au1', { action: 'config_update', by: 'boss' });
    await put('analyticsDaily/2026-10-15', { newUsers: 3 });
    await put('demoAccounts/u_x', { email: 'x@example.com', password: 'secret1' });
  });
});

type Claims = { role?: string; email?: string; phone_number?: string };
const as = (uid: string, role = 'owner', extra: Claims = {}) => env.authenticatedContext(uid, { role, ...extra }).firestore();
const signedOut = () => env.unauthenticatedContext().firestore();
const admin = () => as('boss', 'admin');

// Every collection a test below covers; checked against the rules at the end.
const covered = new Set<string>();
const col = (name: string) => {
  covered.add(name);
  return name;
};

describe(col('users'), () => {
  it('you read your own profile; partners open one by id; only admins list everyone', async () => {
    await assertFails(getDoc(doc(signedOut(), 'users/priya')));
    await assertSucceeds(getDoc(doc(as('priya'), 'users/priya')));
    await assertFails(getDoc(doc(as('eve'), 'users/priya')));
    await assertSucceeds(getDoc(doc(as('clinicadmin', 'clinic_admin'), 'users/priya')));
    await assertFails(getDocs(collection(as('clinicadmin', 'clinic_admin'), 'users')));
    await assertFails(getDocs(query(collection(as('eve'), 'users'), where('referralCode', '==', 'PRIYAB2C3'))));
    await assertSucceeds(getDocs(collection(admin(), 'users')));
  });
  it('you edit your own settings, never your role, plan or referral code', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'users/priya'), { language: 'hi', 'consents.marketing': true }));
    await assertFails(updateDoc(doc(as('priya'), 'users/priya'), { role: 'admin' }));
    await assertFails(updateDoc(doc(as('priya'), 'users/priya'), { plan: 'plus' }));
    await assertFails(updateDoc(doc(as('priya'), 'users/priya'), { referralCode: 'VIP' }));
    await assertFails(updateDoc(doc(as('eve'), 'users/priya'), { language: 'hi' }));
    await assertSucceeds(updateDoc(doc(admin(), 'users/priya'), { suspended: true }));
  });
  it('a new profile starts as a free pet parent; only admins delete', async () => {
    const fresh = { name: 'Nina', role: 'owner', plan: 'free' };
    await assertSucceeds(setDoc(doc(as('nina'), 'users/nina'), fresh));
    await assertFails(setDoc(doc(as('nina2'), 'users/nina2'), { ...fresh, referralCode: 'NINAVIP1' }));
    await assertFails(setDoc(doc(as('nina3'), 'users/nina3'), { ...fresh, role: 'admin' }));
    await assertFails(setDoc(doc(as('nina4'), 'users/other'), fresh));
    await assertFails(deleteDoc(doc(as('priya'), 'users/priya')));
    await assertSucceeds(deleteDoc(doc(admin(), 'users/ravi')));
  });
});

describe(col('pets'), () => {
  it('family members read the pet; strangers do not', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'pets/bruno')));
    await assertFails(getDoc(doc(as('eve'), 'pets/bruno')));
    await assertFails(getDoc(doc(signedOut(), 'pets/bruno')));
    await assertSucceeds(getDocs(query(collection(as('rohan'), 'pets'), where('memberIds', 'array-contains', 'rohan'))));
  });
  it('you add your own pet only, with yourself as the only member', async () => {
    await assertSucceeds(setDoc(doc(as('eve'), 'pets/kitty'), { ownerId: 'eve', name: 'Kitty', memberIds: ['eve'], members: { eve: { role: 'owner' } } }));
    await assertFails(setDoc(doc(as('eve'), 'pets/kitty2'), { ownerId: 'eve', name: 'Kitty', memberIds: ['eve', 'priya'] }));
    await assertFails(setDoc(doc(as('eve'), 'pets/kitty3'), { ownerId: 'priya', name: 'Kitty', memberIds: ['priya'] }));
  });
  it('co-owners edit details, carers only log food and weight, viewers and ex-sitters nothing', async () => {
    await assertSucceeds(updateDoc(doc(as('co'), 'pets/bruno'), { name: 'Bruno S' }));
    await assertFails(updateDoc(doc(as('co'), 'pets/bruno'), { memberIds: ['priya', 'co', 'eve'] }));
    await assertSucceeds(updateDoc(doc(as('rohan'), 'pets/bruno'), { weightKg: 31 }));
    await assertFails(updateDoc(doc(as('rohan'), 'pets/bruno'), { name: 'Rocky' }));
    await assertFails(updateDoc(doc(as('viewer'), 'pets/bruno'), { weightKg: 20 }));
    await assertFails(updateDoc(doc(as('old'), 'pets/bruno'), { weightKg: 20 }));
    await assertFails(updateDoc(doc(as('eve'), 'pets/bruno'), { name: 'Mine now' }));
  });
  it('only the owner deletes the pet', async () => {
    await assertFails(deleteDoc(doc(as('co'), 'pets/bruno')));
    await assertSucceeds(deleteDoc(doc(as('priya'), 'pets/bruno')));
  });
});

describe(col('petInvites'), () => {
  const invite = { petId: 'bruno', petName: 'Bruno', invitedBy: 'priya', role: 'carer', status: 'pending', contact: null };
  it('owners and co-owners invite with the token as the id, never as owner', async () => {
    await assertSucceeds(setDoc(doc(as('priya'), 'petInvites/abcd2345ef'), { ...invite, token: 'abcd2345ef' }));
    await assertSucceeds(setDoc(doc(as('co'), 'petInvites/zz12345678'), { ...invite, invitedBy: 'co', token: 'zz12345678' }));
    await assertFails(setDoc(doc(as('priya'), 'petInvites/abcd2345eg'), { ...invite, role: 'owner', token: 'abcd2345eg' }));
    await assertFails(setDoc(doc(as('priya'), 'petInvites/abcd2345eh'), { ...invite, token: 'different1' }));
    await assertFails(setDoc(doc(as('rohan'), 'petInvites/abcd2345ei'), { ...invite, invitedBy: 'rohan', token: 'abcd2345ei' }));
    await assertFails(setDoc(doc(as('eve'), 'petInvites/abcd2345ej'), { ...invite, invitedBy: 'eve', token: 'abcd2345ej' }));
  });
  it('people with the link open it; the list is for the pet\'s owners and the invited email', async () => {
    await assertSucceeds(getDoc(doc(as('eve'), 'petInvites/tok8x9k2m4p')));
    await assertFails(getDoc(doc(signedOut(), 'petInvites/tok8x9k2m4p')));
    await assertFails(getDocs(collection(as('eve'), 'petInvites')));
    await assertSucceeds(getDocs(query(collection(as('priya'), 'petInvites'), where('petId', '==', 'bruno'), where('status', '==', 'pending'))));
    const meera = as('meera', 'owner', { email: 'Meera@Example.com' });
    await assertSucceeds(getDocs(query(collection(meera, 'petInvites'), where('contact', 'in', ['meera@example.com']), where('status', '==', 'pending'))));
    await assertFails(getDocs(query(collection(as('eve', 'owner', { email: 'eve@example.com' }), 'petInvites'), where('contact', 'in', ['meera@example.com']))));
  });
  it('the invited person can decline, but nobody accepts or upgrades an invite from the app', async () => {
    await assertSucceeds(updateDoc(doc(as('meera'), 'petInvites/tok8x9k2m4p'), { status: 'declined' }));
    await env.withSecurityRulesDisabled((ctx) => updateDoc(doc(ctx.firestore(), 'petInvites/tok8x9k2m4p'), { status: 'pending' }));
    await assertFails(updateDoc(doc(as('meera'), 'petInvites/tok8x9k2m4p'), { status: 'accepted', acceptedBy: 'meera' }));
    await assertFails(updateDoc(doc(as('meera'), 'petInvites/tok8x9k2m4p'), { role: 'coowner' }));
  });
  it('joining a pet from the app alone is refused (acceptPetInvite does it)', async () => {
    await assertFails(updateDoc(doc(as('meera'), 'pets/bruno'), { memberIds: arrayUnion('meera'), 'members.meera': { role: 'carer', name: 'Meera', expiresAt: null } }));
  });
  it('owners cancel invites', async () => {
    await assertFails(deleteDoc(doc(as('rohan'), 'petInvites/tok8x9k2m4p')));
    await assertSucceeds(deleteDoc(doc(as('priya'), 'petInvites/tok8x9k2m4p')));
  });
});

describe(col('activity'), () => {
  it('the family feed is for the family; you post as yourself', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'activity/a1')));
    await assertFails(getDoc(doc(as('eve'), 'activity/a1')));
    await assertFails(getDoc(doc(as('old'), 'activity/a1')));
    await assertSucceeds(addDoc(collection(as('rohan'), 'activity'), { petId: 'bruno', actorId: 'rohan', type: 'walk' }));
    await assertFails(addDoc(collection(as('rohan'), 'activity'), { petId: 'bruno', actorId: 'priya', type: 'walk' }));
    await assertFails(addDoc(collection(as('eve'), 'activity'), { petId: 'bruno', actorId: 'eve', type: 'walk' }));
    await assertFails(updateDoc(doc(as('priya'), 'activity/a1'), { type: 'changed' }));
  });
});

describe(col('logs'), () => {
  it('the family logs routine as themselves; an ended sitter can\'t', async () => {
    await assertSucceeds(addDoc(collection(as('viewer'), 'logs'), { petId: 'bruno', byUid: 'viewer', type: 'meal' }));
    await assertFails(addDoc(collection(as('viewer'), 'logs'), { petId: 'bruno', byUid: 'priya', type: 'meal' }));
    await assertFails(addDoc(collection(as('old'), 'logs'), { petId: 'bruno', byUid: 'old', type: 'meal' }));
    await assertFails(addDoc(collection(as('eve'), 'logs'), { petId: 'bruno', byUid: 'eve', type: 'meal' }));
  });
  it('carers correct entries but never move them to another pet', async () => {
    await assertSucceeds(updateDoc(doc(as('rohan'), 'logs/l1'), { note: 'Big park' }));
    await assertFails(updateDoc(doc(as('rohan'), 'logs/l1'), { petId: 'tiger' }));
    await assertFails(updateDoc(doc(as('viewer'), 'logs/l1'), { note: 'x' }));
    await assertSucceeds(getDoc(doc(admin(), 'logs/l1')));
    await assertFails(getDoc(doc(as('eve'), 'logs/l1')));
  });
});

describe(col('vaccinations'), () => {
  it('the family and vets read vaccines; groomers, sellers and strangers do not', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'vaccinations/v1')));
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'vaccinations/v1')));
    await assertSucceeds(getDoc(doc(as('clinicadmin', 'clinic_admin'), 'vaccinations/v1')));
    await assertFails(getDoc(doc(as('groomer', 'groomer'), 'vaccinations/v1')));
    await assertFails(getDoc(doc(as('seller', 'seller'), 'vaccinations/v1')));
    await assertFails(getDoc(doc(as('eve'), 'vaccinations/v1')));
    await assertFails(getDoc(doc(as('old'), 'vaccinations/v1')));
  });
  it('carers add and fix records; nobody moves another family\'s record to their pet', async () => {
    await assertSucceeds(addDoc(collection(as('rohan'), 'vaccinations'), { petId: 'bruno', name: 'DHPP' }));
    await assertFails(addDoc(collection(as('viewer'), 'vaccinations'), { petId: 'bruno', name: 'DHPP' }));
    await assertSucceeds(updateDoc(doc(as('rohan'), 'vaccinations/v1'), { name: 'Rabies (booster)' }));
    await assertFails(updateDoc(doc(as('rohan'), 'vaccinations/v1'), { petId: 'tiger' }));
    await assertFails(updateDoc(doc(as('ravi'), 'vaccinations/v1'), { petId: 'tiger', name: 'Mine now' }));
    await assertFails(deleteDoc(doc(as('ravi'), 'vaccinations/v1')));
    await assertSucceeds(deleteDoc(doc(as('ravi'), 'vaccinations/v2')));
  });
});

describe(col('medicines'), () => {
  it('only the family sees medicines; carers manage them', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'medicines/m1')));
    await assertFails(getDoc(doc(as('vetuid', 'vet'), 'medicines/m1')));
    await assertSucceeds(updateDoc(doc(as('rohan'), 'medicines/m1'), { dose: '1 tablet' }));
    await assertFails(updateDoc(doc(as('ravi'), 'medicines/m1'), { petId: 'tiger' }));
    await assertFails(addDoc(collection(as('viewer'), 'medicines'), { petId: 'bruno', name: 'X' }));
  });
});

describe(col('medicineLogs'), () => {
  it('carers tick doses; viewers and strangers can\'t', async () => {
    await assertSucceeds(addDoc(collection(as('rohan'), 'medicineLogs'), { petId: 'bruno', medicineId: 'm1' }));
    await assertFails(addDoc(collection(as('viewer'), 'medicineLogs'), { petId: 'bruno', medicineId: 'm1' }));
    await assertSucceeds(getDoc(doc(as('viewer'), 'medicineLogs/ml1')));
    await assertFails(getDoc(doc(as('eve'), 'medicineLogs/ml1')));
  });
});

describe(col('healthEvents'), () => {
  it('health history: family and vets read; records stay with their pet', async () => {
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'healthEvents/h1')));
    await assertFails(getDoc(doc(as('groomer', 'groomer'), 'healthEvents/h1')));
    await assertSucceeds(addDoc(collection(as('co'), 'healthEvents'), { petId: 'bruno', type: 'weight' }));
    await assertFails(updateDoc(doc(as('ravi'), 'healthEvents/h1'), { petId: 'tiger' }));
  });
});

describe(col('reminders'), () => {
  it('reminders are private and can\'t be taken over', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'reminders/r1')));
    await assertFails(getDoc(doc(as('rohan'), 'reminders/r1')));
    await assertSucceeds(updateDoc(doc(as('priya'), 'reminders/r1'), { title: 'Deworm Bruno' }));
    await assertFails(updateDoc(doc(as('eve'), 'reminders/r1'), { ownerId: 'eve' }));
    await assertFails(addDoc(collection(as('eve'), 'reminders'), { ownerId: 'priya', title: 'Spam' }));
    await assertSucceeds(addDoc(collection(as('eve'), 'reminders'), { ownerId: 'eve', title: 'Mine' }));
  });
});

describe(col('notifications'), () => {
  const note = { title: 'Your booking is confirmed', body: '', type: 'bookings', link: '/book/bookings/b1', read: false };
  it('only the recipient reads one and may only mark it read', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'notifications/n1')));
    await assertFails(getDoc(doc(as('ravi'), 'notifications/n1')));
    await assertSucceeds(updateDoc(doc(as('priya'), 'notifications/n1'), { read: true }));
    await assertFails(updateDoc(doc(as('priya'), 'notifications/n1'), { title: 'Changed' }));
  });
  it('you notify yourself, the other side of your booking or chat; strangers can\'t message anyone', async () => {
    await assertSucceeds(addDoc(collection(as('priya'), 'notifications'), { ...note, uid: 'priya' }));
    await assertSucceeds(addDoc(collection(as('clinicadmin', 'clinic_admin'), 'notifications'), { ...note, uid: 'priya', bookingId: 'b1' }));
    await assertSucceeds(addDoc(collection(as('priya'), 'notifications'), { ...note, uid: 'vetuid', bookingId: 'b1' }));
    await assertSucceeds(addDoc(collection(as('priya'), 'notifications'), { ...note, uid: 'clinicadmin', conversationId: 'chat_b1' }));
    await assertSucceeds(addDoc(collection(admin(), 'notifications'), { ...note, uid: 'ravi' }));
    await assertFails(addDoc(collection(as('eve'), 'notifications'), { ...note, uid: 'priya' }));
    await assertFails(addDoc(collection(as('eve'), 'notifications'), { ...note, uid: 'priya', bookingId: 'b1' }));
    await assertFails(addDoc(collection(as('groomer', 'groomer'), 'notifications'), { ...note, uid: 'priya', bookingId: 'b1' }));
    await assertFails(addDoc(collection(as('eve'), 'notifications'), { ...note, uid: 'priya', conversationId: 'chat_b1' }));
    await assertFails(addDoc(collection(as('priya'), 'notifications'), { ...note, uid: 'priya', read: true }));
  });
});

describe(col('clinics'), () => {
  it('approved clinics are public; pending ones only for their owner and admins', async () => {
    await assertSucceeds(getDoc(doc(signedOut(), 'clinics/clinic1')));
    await assertFails(getDoc(doc(as('eve'), 'clinics/clinicPending')));
    await assertSucceeds(getDoc(doc(as('newclinic'), 'clinics/clinicPending')));
    await assertSucceeds(getDoc(doc(admin(), 'clinics/clinicPending')));
  });
  it('a clinic edits its details, never its approval, rating or commission', async () => {
    const me = as('clinicadmin', 'clinic_admin');
    await assertSucceeds(updateDoc(doc(me, 'clinics/clinic1'), { phone: '+914012345678', openHours: '9-9' }));
    await assertFails(updateDoc(doc(me, 'clinics/clinic1'), { commissionPercent: 0 }));
    await assertFails(updateDoc(doc(me, 'clinics/clinic1'), { status: 'approved', rating: 5 }));
    await assertFails(updateDoc(doc(me, 'clinics/clinic1'), { featured: true }));
    await assertFails(updateDoc(doc(me, 'clinics/clinic1'), { ownerUid: 'someoneelse' }));
    await assertFails(updateDoc(doc(me, 'clinics/clinic2'), { phone: '1' }));
    await assertSucceeds(updateDoc(doc(admin(), 'clinics/clinic1'), { commissionPercent: 12 }));
  });
  it('a new clinic signs up pending, without setting its own commission', async () => {
    await assertSucceeds(setDoc(doc(as('newbie'), 'clinics/cn1'), { name: 'N', status: 'pending', ownerUid: 'newbie' }));
    await assertFails(setDoc(doc(as('newbie'), 'clinics/cn2'), { name: 'N', status: 'pending', ownerUid: 'newbie', commissionPercent: 0 }));
    await assertFails(setDoc(doc(as('newbie'), 'clinics/cn3'), { name: 'N', status: 'approved', ownerUid: 'newbie' }));
  });
});

describe(col('partnerApplications'), () => {
  it('you apply for yourself, pending; only admins decide', async () => {
    await assertSucceeds(setDoc(doc(as('newbie'), 'partnerApplications/newbie'), { uid: 'newbie', status: 'pending' }));
    await assertFails(setDoc(doc(as('newbie2'), 'partnerApplications/newbie2'), { uid: 'newbie2', status: 'approved' }));
    await assertFails(setDoc(doc(as('newbie3'), 'partnerApplications/someone'), { uid: 'someone', status: 'pending' }));
    await assertSucceeds(getDoc(doc(as('groomer', 'groomer'), 'partnerApplications/groomer')));
    await assertFails(getDoc(doc(as('eve'), 'partnerApplications/groomer')));
    await assertFails(updateDoc(doc(as('groomer', 'groomer'), 'partnerApplications/groomer'), { status: 'approved' }));
    await assertSucceeds(updateDoc(doc(admin(), 'partnerApplications/groomer'), { status: 'suspended' }));
  });
});

describe(col('vets'), () => {
  const vet = { clinicId: 'clinic1', clinicName: 'Paws Clinic', name: 'Dr New', regNo: 'TS-1', teleVet: false, status: 'pending' };
  it('signed-in people see vets', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'vets/vet1')));
    await assertFails(getDoc(doc(signedOut(), 'vets/vet1')));
  });
  it('a clinic admin adds vets to their own clinic, pending until approved', async () => {
    const me = as('clinicadmin', 'clinic_admin');
    await assertSucceeds(addDoc(collection(me, 'vets'), vet));
    await assertFails(addDoc(collection(me, 'vets'), { ...vet, clinicId: 'clinic2' }));
    await assertFails(addDoc(collection(me, 'vets'), { ...vet, status: 'approved' }));
    await assertFails(addDoc(collection(as('groomer', 'groomer'), 'vets'), vet));
  });
  it('the clinic and the vet edit the profile, not its approval, clinic or rating', async () => {
    await assertSucceeds(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'vets/vet1'), { languages: ['te', 'en'] }));
    await assertSucceeds(updateDoc(doc(as('vetuid', 'vet'), 'vets/vet1'), { teleVet: false }));
    await assertFails(updateDoc(doc(as('vetuid', 'vet'), 'vets/vet1'), { rating: 5 }));
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'vets/vet1'), { clinicId: 'clinic2' }));
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'vets/vet2'), { name: 'Not mine' }));
    await assertFails(updateDoc(doc(as('othervet', 'vet'), 'vets/vet1'), { teleVet: false }));
    await assertFails(deleteDoc(doc(as('clinicadmin', 'clinic_admin'), 'vets/vet2')));
    await assertSucceeds(deleteDoc(doc(as('clinicadmin', 'clinic_admin'), 'vets/vet1')));
  });
});

describe(col('providers'), () => {
  it('a groomer edits their listing, never approval, rating or commission', async () => {
    const me = as('groomer', 'groomer');
    await assertSucceeds(updateDoc(doc(me, 'providers/groom1'), { about: 'Gentle grooming' }));
    await assertFails(updateDoc(doc(me, 'providers/groom1'), { commissionPercent: 1 }));
    await assertFails(updateDoc(doc(me, 'providers/groom1'), { reviewCount: 99 }));
    await assertFails(updateDoc(doc(as('eve', 'groomer'), 'providers/groom1'), { about: 'x' }));
    await assertSucceeds(getDoc(doc(signedOut(), 'providers/groom1')));
  });
});

describe(col('bookings'), () => {
  it('the owner, the family and the booked partners read a booking; nobody creates one from the app', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'bookings/b1')));
    await assertSucceeds(getDoc(doc(as('rohan'), 'bookings/b1')));
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'bookings/b1')));
    await assertFails(getDoc(doc(as('groomer', 'groomer'), 'bookings/b1')));
    await assertFails(getDoc(doc(as('eve'), 'bookings/b1')));
    await assertFails(setDoc(doc(as('priya'), 'bookings/new'), { ownerId: 'priya', petId: 'bruno', total: 1, partnerUids: [] }));
    await assertFails(setDoc(doc(admin(), 'bookings/new2'), { ownerId: 'priya', petId: 'bruno', total: 1, partnerUids: [] }));
  });
  it('the pet parent cancels, reschedules or takes a suggested time, and can\'t confirm or pay themselves', async () => {
    const me = as('priya');
    await assertSucceeds(updateDoc(doc(me, 'bookings/b1'), { start: soon(), end: soon() }));
    await assertSucceeds(updateDoc(doc(me, 'bookings/b3'), { status: 'confirmed', start: soon(), end: soon() }));
    await assertFails(updateDoc(doc(me, 'bookings/b1'), { status: 'confirmed' }));
    await assertFails(updateDoc(doc(me, 'bookings/b1'), { status: 'completed' }));
    await assertFails(updateDoc(doc(as('priya'), 'bookings/b3'), { paymentStatus: 'paid' }));
    await assertFails(updateDoc(doc(me, 'bookings/b1'), { status: 'cancelled', refund: 750, cancelledBy: 'partner' }));
    await assertFails(updateDoc(doc(me, 'bookings/b1'), { status: 'cancelled', refund: 5000, cancelledBy: 'owner' }));
    await assertSucceeds(updateDoc(doc(me, 'bookings/b1'), { status: 'cancelled', refund: 375, cancelledBy: 'owner' }));
  });
  it('nobody changes the money, the people or the pet', async () => {
    await assertFails(updateDoc(doc(as('priya'), 'bookings/b1'), { total: 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'bookings/b1'), { partnerUids: ['clinicadmin', 'eve'] }));
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'bookings/b1'), { payout: 750 }));
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'bookings/b1'), { petId: 'tiger' }));
    await assertFails(updateDoc(doc(as('eve'), 'bookings/b1'), { status: 'cancelled' }));
  });
  it('the partner answers, completes and posts updates', async () => {
    const clinic = as('clinicadmin', 'clinic_admin');
    await assertSucceeds(updateDoc(doc(clinic, 'bookings/b1'), { status: 'confirmed', start: soon(), end: soon(), respondBy: null }));
    await assertSucceeds(updateDoc(doc(clinic, 'bookings/b1'), { updates: arrayUnion({ text: 'Bruno is doing well' }) }));
    await assertSucceeds(updateDoc(doc(clinic, 'bookings/b3'), { status: 'completed', paymentStatus: 'paid' }));
    await assertFails(updateDoc(doc(clinic, 'bookings/b1'), { status: 'cancelled', refund: 0, cancelledBy: 'owner' }));
    await assertSucceeds(updateDoc(doc(clinic, 'bookings/b1'), { status: 'declined', refund: 750 }));
  });
});

describe(col('reviews'), () => {
  it('reviews are public; product and vet reviews need your own delivered order or consultation', async () => {
    await assertSucceeds(getDoc(doc(signedOut(), 'reviews/rc1')));
    const product = { targetType: 'product', targetId: 'p1', sellerId: 's1', ownerId: 'priya', orderId: 'o1', rating: 5, text: 'Tasty', status: 'visible' };
    await assertSucceeds(addDoc(collection(as('priya'), 'reviews'), product));
    await assertFails(addDoc(collection(as('priya'), 'reviews'), { ...product, orderId: 'o2' }));
    await assertFails(addDoc(collection(as('ravi'), 'reviews'), { ...product, ownerId: 'ravi' }));
    const vet = { targetType: 'vet', targetId: 'vet1', ownerId: 'priya', consultationId: 'c1', rating: 5, text: 'Kind', status: 'visible' };
    await assertSucceeds(addDoc(collection(as('priya'), 'reviews'), vet));
    await assertFails(addDoc(collection(as('priya'), 'reviews'), { ...vet, targetId: 'vet2' }));
    await assertFails(addDoc(collection(as('ravi'), 'reviews'), { ...vet, ownerId: 'ravi' }));
    await assertFails(addDoc(collection(as('priya'), 'reviews'), { ...vet, status: 'hidden' }));
  });
  it('only the business reviewed replies; only admins hide; nobody edits the stars', async () => {
    await assertSucceeds(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'reviews/rc1'), { reply: 'Thank you!', replyAt: new Date() }));
    await assertFails(updateDoc(doc(as('otheradmin', 'clinic_admin'), 'reviews/rc1'), { reply: 'Try us' }));
    await assertFails(updateDoc(doc(as('groomer', 'groomer'), 'reviews/rc1'), { reply: 'Try us' }));
    await assertSucceeds(updateDoc(doc(as('seller', 'seller'), 'reviews/rp1'), { reply: 'Thanks' }));
    await assertFails(updateDoc(doc(as('otherseller', 'seller'), 'reviews/rp1'), { reply: 'Buy ours' }));
    await assertSucceeds(updateDoc(doc(as('vetuid', 'vet'), 'reviews/rv1'), { reply: 'Glad to help' }));
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'reviews/rc1'), { rating: 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'reviews/rc1'), { status: 'hidden' }));
    await assertSucceeds(updateDoc(doc(admin(), 'reviews/rc1'), { status: 'hidden' }));
  });
});

describe(col('conversations'), () => {
  const base = { lastMessage: '', lastAt: new Date(), unread: {}, muted: {}, blockedBy: [], typing: {} };
  it('people in a chat read it; nobody else', async () => {
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'conversations/chat_b1')));
    await assertFails(getDoc(doc(as('eve'), 'conversations/chat_b1')));
    await assertFails(getDoc(doc(as('groomer', 'groomer'), 'conversations/chat_b1')));
    await assertSucceeds(getDoc(doc(admin(), 'conversations/chat_b1')));
  });
  it('a booking chat holds only the people on the booking', async () => {
    const chat = { ...base, type: 'chat', bookingId: 'b2', ownerId: 'priya', providerId: 'groom1', participantIds: ['priya', 'groomer'] };
    await assertFails(setDoc(doc(as('priya'), 'conversations/chat_b2'), { ...chat, participantIds: ['priya', 'groomer', 'eve'] }));
    await assertFails(setDoc(doc(as('eve'), 'conversations/chat_b2'), { ...chat, participantIds: ['eve', 'groomer'] }));
    await assertFails(setDoc(doc(as('priya'), 'conversations/chat_other'), chat));
    await assertSucceeds(setDoc(doc(as('priya'), 'conversations/chat_b2'), chat));
  });
  it('an enquiry is between you and the business; Ask PawSetu is yours alone; tele-vet chats come from the server', async () => {
    const enq = { ...base, type: 'enquiry', ownerId: 'priya', providerId: 'groom1', providerKind: 'groomer', participantIds: ['priya', 'groomer'] };
    await assertSucceeds(setDoc(doc(as('priya'), 'conversations/enq_groom1_priya'), enq));
    await assertFails(setDoc(doc(as('eve'), 'conversations/enq_groom1_eve'), { ...enq, ownerId: 'eve', participantIds: ['eve', 'priya'] }));
    await assertFails(setDoc(doc(as('eve'), 'conversations/enq_groom1_priya'), { ...enq, ownerId: 'eve', participantIds: ['eve', 'groomer'] }));
    await assertSucceeds(setDoc(doc(as('eve'), 'conversations/ai_eve'), { ...base, type: 'assistant', ownerId: 'eve', participantIds: ['eve'] }));
    await assertFails(setDoc(doc(as('eve'), 'conversations/ai_priya'), { ...base, type: 'assistant', ownerId: 'eve', participantIds: ['eve'] }));
    await assertFails(setDoc(doc(as('priya'), 'conversations/tv_new'), { ...base, type: 'televet', ownerId: 'priya', participantIds: ['priya', 'vetuid'] }));
  });
  it('people in the chat update previews, unread and their own block, never who is in it or its kind', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'conversations/chat_b1'), { lastMessage: 'Thanks', lastAt: new Date(), 'unread.clinicadmin': 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'conversations/tv_c1'), { type: 'chat' }));
    await assertFails(updateDoc(doc(as('priya'), 'conversations/chat_b1'), { participantIds: ['priya', 'clinicadmin', 'vetuid', 'eve'] }));
    await assertFails(updateDoc(doc(as('ravi'), 'conversations/enq_groom1_ravi'), { blockedBy: [] }));
    await assertSucceeds(updateDoc(doc(as('groomer', 'groomer'), 'conversations/enq_groom1_ravi'), { blockedBy: [] }));
    await assertFails(updateDoc(doc(as('eve'), 'conversations/chat_b1'), { lastMessage: 'Spam' }));
  });
});

describe(col('messages'), () => {
  const msg = { conversationId: 'chat_b1', senderId: 'priya', senderName: 'Priya', type: 'text', text: 'Hello', readBy: ['priya'] };
  it('you send as yourself into a chat you are in', async () => {
    await assertSucceeds(addDoc(collection(as('priya'), 'messages'), msg));
    await assertFails(addDoc(collection(as('priya'), 'messages'), { ...msg, senderId: 'clinicadmin' }));
    await assertFails(addDoc(collection(as('eve'), 'messages'), { ...msg, senderId: 'eve' }));
    await assertSucceeds(addDoc(collection(as('priya'), 'messages'), { ...msg, senderId: 'system', type: 'system', event: 'booking_chat', text: '' }));
    await assertFails(addDoc(collection(as('priya'), 'messages'), { ...msg, senderId: 'system', type: 'system', event: 'tv_ended', text: '' }));
  });
  it('tele-vet messages go through the server, and nobody writes into a blocked chat', async () => {
    await assertFails(addDoc(collection(as('priya'), 'messages'), { ...msg, conversationId: 'tv_c1' }));
    await assertFails(addDoc(collection(as('ravi'), 'messages'), { ...msg, conversationId: 'enq_groom1_ravi', senderId: 'ravi' }));
  });
  it('people in the chat read it and only add themselves to "read by"', async () => {
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'messages/msg1')));
    await assertFails(getDoc(doc(as('eve'), 'messages/msg1')));
    await assertSucceeds(updateDoc(doc(as('priya'), 'messages/msg1'), { readBy: arrayUnion('priya') }));
    await assertFails(updateDoc(doc(as('priya'), 'messages/msg1'), { readBy: ['clinicadmin', 'priya', 'vetuid'] }));
    await assertFails(updateDoc(doc(as('priya'), 'messages/msg1'), { text: 'Edited' }));
    await assertFails(updateDoc(doc(as('eve'), 'messages/msg1'), { readBy: arrayUnion('eve') }));
  });
});

describe(col('consultations'), () => {
  it('the pet parent, the assigned vet and admins read it; other vets only see the waiting queue', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'consultations/c1')));
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'consultations/c1')));
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'consultations/cq')));
    await assertFails(getDoc(doc(as('vetuid', 'vet'), 'consultations/c2')));
    await assertFails(getDoc(doc(as('groomer', 'groomer'), 'consultations/cq')));
    await assertFails(getDoc(doc(as('eve'), 'consultations/c1')));
    await assertSucceeds(getDocs(query(collection(as('vetuid', 'vet'), 'consultations'), where('status', '==', 'queued'))));
    await assertSucceeds(getDocs(query(collection(as('vetuid', 'vet'), 'consultations'), where('vetUid', '==', 'vetuid'))));
  });
  it('the assigned vet keeps notes; the pet parent rates; nothing else changes from the app', async () => {
    await assertSucceeds(updateDoc(doc(as('vetuid', 'vet'), 'consultations/c1'), { privateNotes: 'Mild otitis', notesAt: new Date() }));
    await assertFails(updateDoc(doc(as('othervet', 'vet'), 'consultations/c1'), { privateNotes: 'x' }));
    await assertFails(updateDoc(doc(as('vetuid', 'vet'), 'consultations/c2'), { privateNotes: 'x' }));
    await assertFails(updateDoc(doc(as('vetuid', 'vet'), 'consultations/c1'), { fee: 0 }));
    await assertSucceeds(updateDoc(doc(as('priya'), 'consultations/c1'), { rating: 5, ratingText: 'Kind' }));
    await assertFails(updateDoc(doc(as('priya'), 'consultations/c1'), { status: 'ended' }));
  });
});

describe(col('prescriptions'), () => {
  const rx = { consultationId: 'c1', petId: 'bruno', ownerId: 'priya', vetUid: 'vetuid', items: [] };
  it('the family and the vet who wrote it read it', async () => {
    await assertSucceeds(getDoc(doc(as('rohan'), 'prescriptions/rx1')));
    await assertSucceeds(getDoc(doc(as('vetuid', 'vet'), 'prescriptions/rx1')));
    await assertFails(getDoc(doc(as('othervet', 'vet'), 'prescriptions/rx1')));
    await assertFails(getDoc(doc(as('eve'), 'prescriptions/rx1')));
  });
  it('only the vet on the consultation writes it, for that pet and family', async () => {
    await assertSucceeds(addDoc(collection(as('vetuid', 'vet'), 'prescriptions'), rx));
    await assertFails(addDoc(collection(as('othervet', 'vet'), 'prescriptions'), { ...rx, vetUid: 'othervet' }));
    await assertFails(addDoc(collection(as('vetuid', 'vet'), 'prescriptions'), { ...rx, consultationId: 'c2', petId: 'tiger', ownerId: 'ravi' }));
    await assertFails(addDoc(collection(as('vetuid', 'vet'), 'prescriptions'), { ...rx, petId: 'tiger' }));
    await assertFails(addDoc(collection(as('priya'), 'prescriptions'), { ...rx, vetUid: 'priya' }));
  });
});

describe(col('documents'), () => {
  it('the vault is for the family; carers file under the owner', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'documents/d1')));
    await assertFails(getDoc(doc(as('eve'), 'documents/d1')));
    await assertSucceeds(addDoc(collection(as('rohan'), 'documents'), { petId: 'bruno', ownerId: 'priya', type: 'vaccination' }));
    await assertFails(addDoc(collection(as('eve'), 'documents'), { petId: 'bruno', ownerId: 'eve', type: 'other' }));
    await assertFails(updateDoc(doc(as('priya'), 'documents/d1'), { petId: 'tiger' }));
    await assertFails(deleteDoc(doc(as('rohan'), 'documents/d1')));
  });
});

describe(col('shareLinks'), () => {
  it('only the owner sees a link; revoking is final', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'shareLinks/sh1')));
    await assertFails(getDoc(doc(as('vetuid', 'vet'), 'shareLinks/sh1')));
    await assertSucceeds(updateDoc(doc(as('priya'), 'shareLinks/sh1'), { revoked: true, revokedAt: new Date() }));
    await assertFails(updateDoc(doc(as('priya'), 'shareLinks/sh1'), { revoked: false }));
    await assertFails(addDoc(collection(as('priya'), 'shareLinks'), { petId: 'bruno', ownerId: 'priya', revoked: false, accessLog: [{ at: new Date() }] }));
  });
});

describe(col('insurance'), () => {
  it('owners and co-owners manage policies; the family reads them', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'insurance/i1')));
    await assertFails(addDoc(collection(as('rohan'), 'insurance'), { petId: 'bruno', ownerId: 'rohan' }));
    await assertSucceeds(addDoc(collection(as('co'), 'insurance'), { petId: 'bruno', ownerId: 'co' }));
    await assertFails(updateDoc(doc(as('co'), 'insurance/i1'), { petId: 'tiger' }));
  });
});

describe(col('album'), () => {
  it('the family adds memories as themselves; strangers see nothing', async () => {
    await assertSucceeds(addDoc(collection(as('viewer'), 'album'), { petId: 'bruno', ownerId: 'priya', byUid: 'viewer' }));
    await assertFails(addDoc(collection(as('viewer'), 'album'), { petId: 'bruno', ownerId: 'priya', byUid: 'priya' }));
    await assertFails(getDoc(doc(as('eve'), 'album/al1')));
    await assertFails(updateDoc(doc(as('viewer'), 'album/al1'), { byUid: 'viewer' }));
  });
});

describe(col('products'), () => {
  it('anyone browses; a seller edits their own products, never ratings or the featured spot', async () => {
    await assertSucceeds(getDoc(doc(signedOut(), 'products/p1')));
    await assertSucceeds(updateDoc(doc(as('seller', 'seller'), 'products/p1'), { price: 1150, stock: 20 }));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'products/p1'), { featured: true }));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'products/p1'), { rating: 5 }));
    await assertFails(updateDoc(doc(as('otherseller', 'seller'), 'products/p1'), { price: 1 }));
    await assertFails(addDoc(collection(as('seller', 'seller'), 'products'), { sellerId: 's1', name: 'Toy', price: 99, featured: true }));
    await assertSucceeds(addDoc(collection(as('seller', 'seller'), 'products'), { sellerId: 's1', name: 'Toy', price: 99 }));
    await assertFails(deleteDoc(doc(as('seller', 'seller'), 'products/p1')));
    await assertSucceeds(updateDoc(doc(admin(), 'products/p1'), { featured: true }));
  });
});

describe(col('sellers'), () => {
  it('a seller edits their store, not approval or commission', async () => {
    await assertSucceeds(updateDoc(doc(as('seller', 'seller'), 'sellers/s1'), { about: 'Fresh treats' }));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'sellers/s1'), { commissionPercent: 0 }));
    await assertFails(updateDoc(doc(as('seller3', 'seller'), 'sellers/s3'), { status: 'approved' }));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'sellers/s2'), { about: 'x' }));
    await assertFails(setDoc(doc(as('newbie'), 'sellers/s3'), { name: 'S', status: 'pending', uid: 'newbie', commissionPercent: 1 }));
    await assertSucceeds(setDoc(doc(as('newbie'), 'sellers/s4'), { name: 'S', status: 'pending', uid: 'newbie' }));
  });
});

describe(col('partners'), () => {
  it('partner stores are public and admin-managed', async () => {
    await assertSucceeds(getDoc(doc(signedOut(), 'partners/pt1')));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'partners/pt1'), { clicks: 1000 }));
    await assertSucceeds(updateDoc(doc(admin(), 'partners/pt1'), { name: 'Big Pet Store India' }));
  });
});

describe(col('orders'), () => {
  it('the buyer, the seller and admins see an order; nobody creates one from the app', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'orders/o1')));
    await assertSucceeds(getDoc(doc(as('seller', 'seller'), 'orders/o1')));
    await assertFails(getDoc(doc(as('otherseller', 'seller'), 'orders/o1')));
    await assertFails(setDoc(doc(as('priya'), 'orders/new'), { ownerId: 'priya', total: 1, items: [] }));
  });
  it('the buyer cancels; the seller ships; nobody touches the money', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'orders/o2'), { status: 'cancelled' }));
    await assertFails(updateDoc(doc(as('priya'), 'orders/o1'), { total: 1 }));
    await assertFails(updateDoc(doc(as('priya'), 'orders/o2'), { status: 'delivered' }));
    await assertSucceeds(updateDoc(doc(as('seller', 'seller'), 'orders/o1'), { status: 'shipped' }));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'orders/o1'), { payout: 2000 }));
  });
});

describe(col('affiliateClicks'), () => {
  it('clicks are recorded as yourself and read by admins only', async () => {
    await assertSucceeds(addDoc(collection(as('priya'), 'affiliateClicks'), { uid: 'priya', partnerId: 'pt1' }));
    await assertFails(addDoc(collection(as('priya'), 'affiliateClicks'), { uid: 'ravi', partnerId: 'pt1' }));
    await assertFails(getDoc(doc(as('priya'), 'affiliateClicks/ac1')));
    await assertSucceeds(getDoc(doc(admin(), 'affiliateClicks/ac1')));
  });
});

describe(col('subscriptions'), () => {
  it('auto-reorders are private and can\'t be taken over', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'subscriptions/sub1'), { everyWeeks: 6 }));
    await assertFails(getDoc(doc(as('ravi'), 'subscriptions/sub1')));
    await assertFails(updateDoc(doc(as('ravi'), 'subscriptions/sub1'), { ownerId: 'ravi' }));
    await assertFails(deleteDoc(doc(as('ravi'), 'subscriptions/sub1')));
  });
});

describe(col('expenses'), () => {
  it('expenses are private; nobody else writes yours', async () => {
    await assertSucceeds(updateDoc(doc(as('priya'), 'expenses/e1'), { amount: 700 }));
    await assertFails(getDoc(doc(as('rohan'), 'expenses/e1')));
    await assertFails(updateDoc(doc(as('ravi'), 'expenses/e1'), { ownerId: 'ravi', amount: 1 }));
    await assertFails(setDoc(doc(as('clinicadmin', 'clinic_admin'), 'expenses/exp_b1'), { ownerId: 'priya', amount: 750, source: 'booking', sourceId: 'b1' }));
    await assertSucceeds(addDoc(collection(as('ravi'), 'expenses'), { ownerId: 'ravi', amount: 300 }));
  });
});

describe(col('carts'), () => {
  it('your cart is yours', async () => {
    await assertSucceeds(setDoc(doc(as('priya'), 'carts/priya'), { items: [{ productId: 'p1', qty: 1 }] }));
    await assertFails(getDoc(doc(as('ravi'), 'carts/priya')));
    await assertFails(setDoc(doc(as('ravi'), 'carts/priya'), { items: [] }));
  });
});

describe(col('coupons'), () => {
  it('signed-in people check coupons; only admins make them', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'coupons/WELCOME10')));
    await assertFails(getDoc(doc(signedOut(), 'coupons/WELCOME10')));
    await assertFails(setDoc(doc(as('priya'), 'coupons/FREE100'), { percent: 100 }));
    await assertFails(setDoc(doc(as('seller', 'seller'), 'coupons/FREE100'), { percent: 100 }));
    await assertSucceeds(setDoc(doc(admin(), 'coupons/DIWALI20'), { percent: 20 }));
  });
});

describe(col('devices'), () => {
  it('the family sees devices; carers pair and edit; any family app records readings', async () => {
    await assertSucceeds(getDoc(doc(as('viewer'), 'devices/dev1')));
    await assertFails(getDoc(doc(as('eve'), 'devices/dev1')));
    await assertSucceeds(updateDoc(doc(as('viewer'), 'devices/dev1'), { 'data.lat': 17.4 }));
    await assertFails(updateDoc(doc(as('viewer'), 'devices/dev1'), { name: 'Mine' }));
    await assertSucceeds(updateDoc(doc(as('rohan'), 'devices/dev1'), { name: 'Blue collar' }));
    await assertFails(updateDoc(doc(as('rohan'), 'devices/dev1'), { petId: 'tiger' }));
    await assertSucceeds(addDoc(collection(as('rohan'), 'devices'), { petId: 'bruno', ownerId: 'priya', pairedBy: 'rohan', type: 'gps', serial: 'GPS-2' }));
    await assertFails(addDoc(collection(as('eve'), 'devices'), { petId: 'bruno', ownerId: 'priya', pairedBy: 'eve', type: 'gps', serial: 'GPS-3' }));
  });
});

describe(col('sosLogs'), () => {
  it('SOS taps are logged as yourself, with only the expected details', async () => {
    await assertSucceeds(addDoc(collection(as('priya'), 'sosLogs'), { uid: 'priya', petId: 'bruno', at: new Date(), source: 'gps' }));
    await assertFails(addDoc(collection(as('priya'), 'sosLogs'), { uid: 'ravi', petId: 'bruno', source: 'gps' }));
    await assertFails(addDoc(collection(as('priya'), 'sosLogs'), { uid: 'priya', petId: 'bruno', source: 'gps', phone: '+91999' }));
    await assertSucceeds(getDoc(doc(as('priya'), 'sosLogs/sos1')));
    await assertFails(getDoc(doc(as('rohan'), 'sosLogs/sos1')));
    await assertSucceeds(getDoc(doc(admin(), 'sosLogs/sos1')));
  });
});

describe(col('lostReports'), () => {
  it('carers report a lost pet; alert counts and sightings come from the server', async () => {
    const report = { petId: 'bruno', ownerId: 'priya', createdBy: 'rohan', status: 'lost', alertsSent: 0, sightings: [] };
    await assertSucceeds(addDoc(collection(as('rohan'), 'lostReports'), report));
    await assertFails(addDoc(collection(as('rohan'), 'lostReports'), { ...report, alertsSent: 500 }));
    await assertFails(addDoc(collection(as('viewer'), 'lostReports'), { ...report, createdBy: 'viewer' }));
    await assertSucceeds(updateDoc(doc(as('rohan'), 'lostReports/lr1'), { status: 'found', foundAt: new Date() }));
    await assertFails(updateDoc(doc(as('rohan'), 'lostReports/lr1'), { sightings: [{ area: 'Fake' }] }));
    await assertFails(getDoc(doc(as('eve'), 'lostReports/lr1')));
  });
});

describe(col('tickets'), () => {
  it('you open and reply to your own tickets; support decides status and refunds', async () => {
    const first = { by: 'ravi', admin: false, text: 'Help' };
    await assertSucceeds(addDoc(collection(as('ravi'), 'tickets'), { uid: 'ravi', subject: 'Help', status: 'open', messages: [first] }));
    await assertFails(addDoc(collection(as('ravi'), 'tickets'), { uid: 'ravi', subject: 'Help', status: 'open', messages: [first], refund: { amount: 500 } }));
    await assertFails(addDoc(collection(as('ravi'), 'tickets'), { uid: 'ravi', subject: 'Help', status: 'open', messages: [{ ...first, admin: true }] }));
    const reply = { by: 'priya', admin: false, text: 'Any news?' };
    await assertSucceeds(updateDoc(doc(as('priya'), 'tickets/t1'), {
      messages: [{ by: 'priya', admin: false, text: 'Where is my refund?' }, reply], updatedAt: new Date(),
    }));
    await assertFails(updateDoc(doc(as('priya'), 'tickets/t1'), { status: 'resolved' }));
    await assertFails(getDoc(doc(as('ravi'), 'tickets/t1')));
    await assertSucceeds(updateDoc(doc(admin(), 'tickets/t1'), { status: 'in_progress' }));
  });
});

describe(col('reports'), () => {
  it('anyone signed in reports as themselves; only admins see reports', async () => {
    await assertSucceeds(addDoc(collection(as('ravi'), 'reports'), { reporterId: 'ravi', type: 'chat', status: 'open' }));
    await assertFails(addDoc(collection(as('ravi'), 'reports'), { reporterId: 'priya', type: 'chat' }));
    await assertFails(addDoc(collection(as('ravi'), 'reports'), { reporterId: 'ravi', type: 'chat', status: 'handled' }));
    await assertFails(getDoc(doc(as('priya'), 'reports/rep1')));
    await assertSucceeds(updateDoc(doc(admin(), 'reports/rep1'), { status: 'handled' }));
  });
});

describe(col('payments'), () => {
  it('you see your own payments; only admins record demo refunds; Plus payments come from the server', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'payments/pay1')));
    await assertFails(getDoc(doc(as('ravi'), 'payments/pay1')));
    await assertFails(addDoc(collection(as('priya'), 'payments'), { uid: 'priya', kind: 'plus', amount: 0, demo: true }));
    await assertFails(addDoc(collection(admin(), 'payments'), { uid: 'priya', kind: 'plus', amount: 99, demo: true }));
    await assertSucceeds(addDoc(collection(admin(), 'payments'), { uid: 'priya', kind: 'refund', amount: 99, demo: true }));
  });
});

describe(col('referrals'), () => {
  it('the two friends see their referral; nobody writes one from the app', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'referrals/ref1')));
    await assertSucceeds(getDoc(doc(as('ravi'), 'referrals/ref1')));
    await assertFails(getDoc(doc(as('eve'), 'referrals/ref1')));
    await assertFails(addDoc(collection(as('eve'), 'referrals'), { referrerId: 'eve', referredId: 'priya' }));
  });
});

describe(col('banners'), () => {
  it('signed-in people see banners; admins manage them', async () => {
    await assertSucceeds(getDoc(doc(as('priya'), 'banners/ban1')));
    await assertFails(getDoc(doc(signedOut(), 'banners/ban1')));
    await assertFails(updateDoc(doc(as('seller', 'seller'), 'banners/ban1'), { title: 'Buy from us' }));
    await assertSucceeds(updateDoc(doc(admin(), 'banners/ban1'), { title: 'Winter care' }));
  });
});

describe(col('config'), () => {
  it('settings are readable; only admins change limits and prices', async () => {
    await assertSucceeds(getDoc(doc(signedOut(), 'config/app')));
    await assertFails(updateDoc(doc(as('priya'), 'config/app'), { 'limits.free.pets': 99 }));
    await assertFails(updateDoc(doc(as('clinicadmin', 'clinic_admin'), 'config/app'), { 'commission.clinic': 0 }));
    await assertSucceeds(updateDoc(doc(admin(), 'config/app'), { 'limits.free.pets': 3 }));
  });
});

describe(col('outbox'), () => {
  it('the Demo Outbox takes simulated messages; only admins read it', async () => {
    await assertSucceeds(addDoc(collection(as('priya'), 'outbox'), { channel: 'sms', to: '+919800000001', body: 'Demo' }));
    await assertFails(addDoc(collection(signedOut(), 'outbox'), { channel: 'sms', to: '+919800000001', body: 'Demo' }));
    await assertFails(getDoc(doc(as('priya'), 'outbox/ob1')));
    await assertSucceeds(getDoc(doc(admin(), 'outbox/ob1')));
  });
});

describe(col('auditLog'), () => {
  it('only admins write and read the audit log; nobody edits it', async () => {
    await assertFails(addDoc(collection(as('priya'), 'auditLog'), { action: 'x' }));
    await assertSucceeds(addDoc(collection(admin(), 'auditLog'), { action: 'banner_update', by: 'boss' }));
    await assertFails(getDoc(doc(as('clinicadmin', 'clinic_admin'), 'auditLog/au1')));
    await assertFails(updateDoc(doc(admin(), 'auditLog/au1'), { action: 'nothing happened' }));
    await assertFails(deleteDoc(doc(admin(), 'auditLog/au1')));
  });
});

describe(col('analyticsDaily'), () => {
  it('dashboard numbers are for admins and written only by the server', async () => {
    await assertSucceeds(getDoc(doc(admin(), 'analyticsDaily/2026-10-15')));
    await assertFails(getDoc(doc(as('priya'), 'analyticsDaily/2026-10-15')));
    await assertFails(updateDoc(doc(admin(), 'analyticsDaily/2026-10-15'), { newUsers: 1000 }));
  });
});

describe(col('demoAccounts'), () => {
  it('demo passwords are never readable, not even by admins', async () => {
    await assertFails(getDoc(doc(admin(), 'demoAccounts/u_x')));
    await assertFails(getDoc(doc(signedOut(), 'demoAccounts/u_x')));
    await assertFails(setDoc(doc(as('eve'), 'demoAccounts/u_eve'), { password: 'x' }));
  });
});

describe('anything else', () => {
  it('collections that are not in the rules are closed', async () => {
    await assertFails(setDoc(doc(admin(), 'secrets/x'), { a: 1 }));
    await assertFails(getDoc(doc(as('priya'), 'pets/bruno/private/x')));
  });
  it('every collection in firestore.rules has cases in this file', () => {
    const inRules = new Set([...RULES.matchAll(/match \/(\w+)\/\{/g)].map((m) => m[1]).filter((n) => n !== 'databases'));
    const missing = [...inRules].filter((n) => !covered.has(n));
    assert.deepEqual(missing, []);
    assert.ok(inRules.size >= 45, `found only ${inRules.size} collections in the rules`);
  });
});
