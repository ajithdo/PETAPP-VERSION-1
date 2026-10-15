/**
 * Phase 9 server rules: the same cases as lib/features/sos/domain tests.
 */
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

process.env.GCLOUD_PROJECT ??= 'demo-pawsetu';
import { getApps, initializeApp } from 'firebase-admin/app';
if (getApps().length === 0) initializeApp({ projectId: 'demo-pawsetu' });
// eslint-disable-next-line @typescript-eslint/no-require-imports
const { nearbyAlertUids, publicPetView, relayAllowed, shouldAlertLeftZone, distanceKm } = require('./phase9') as typeof import('./phase9');

describe('phase 9 rules', () => {
  it('the public view hides the family and medical details', () => {
    const v = publicPetView({ name: 'Bruno', species: 'dog', ownerId: 'u_priya', memberIds: ['u_priya'], allergies: ['chicken'], microchip: '985', lost: { area: 'Indiranagar', reportId: 'r1' } });
    assert.equal(v.name, 'Bruno');
    for (const k of ['ownerId', 'memberIds', 'allergies', 'microchip']) assert.equal(k in v, false, k);
    assert.equal('reportId' in (v.lost as object), false);
  });
  it('nearby alerts reach opted-in people within 5 km, not the family', () => {
    const home = { lat: 12.9784, lng: 77.6408 };
    const uids = nearbyAlertUids(
      [
        { uid: 'near', lat: home.lat + 0.01, lng: home.lng, optIn: true },
        { uid: 'off', lat: home.lat + 0.01, lng: home.lng, optIn: false },
        { uid: 'far', lat: home.lat + 0.2, lng: home.lng, optIn: true },
        { uid: 'family', lat: home.lat, lng: home.lng, optIn: true },
        { uid: 'nohome', optIn: true },
      ],
      home.lat, home.lng, 5, new Set(['family']),
    );
    assert.deepEqual(uids, ['near']);
    assert.ok(Math.abs(distanceKm(home.lat, home.lng, home.lat + 0.01, home.lng) - 1.11) < 0.01);
  });
  it('at most 5 finder messages per tag per hour', () => {
    const now = new Date('2026-10-14T11:00:00Z');
    const recent = [0, 5, 10, 15, 20].map((m) => new Date(now.getTime() - m * 60_000));
    assert.equal(relayAllowed(recent.slice(0, 4), now), true);
    assert.equal(relayAllowed(recent, now), false);
    assert.equal(relayAllowed(recent, new Date(now.getTime() + 2 * 3600_000)), true);
  });
  it('the safe-zone alert fires once, on the way out', () => {
    assert.equal(shouldAlertLeftZone(true, false), true);
    assert.equal(shouldAlertLeftZone(undefined, false), true);
    assert.equal(shouldAlertLeftZone(false, false), false);
    assert.equal(shouldAlertLeftZone(false, true), false);
  });
});
