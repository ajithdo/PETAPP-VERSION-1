/**
 * Unit tests for the Phase 7 share-link checks (no emulator needed):
 *   npm --prefix functions test
 * The PIN hash below was made by the app (lib/features/vault/domain/pin_hash.dart,
 * the seeded family album link) so the app and the server must agree.
 */
import assert from 'node:assert/strict';
import { describe, it } from 'node:test';

process.env.GCLOUD_PROJECT ??= 'demo-pawsetu';
import { initializeApp } from 'firebase-admin/app';
initializeApp({ projectId: 'demo-pawsetu' });
// eslint-disable-next-line @typescript-eslint/no-require-imports
const { checkShare, verifyPin } = require('./phase7') as typeof import('./phase7');

const APP_HASH = 'pbkdf2$1000$CzBVep/E6Q4zWH2ix+wRNg==$kLYhXiEs6+eIC4XBYSJh8qUlT0TO5pJY1cOG2rOJm8U=';

describe('share links (server)', () => {
  const now = new Date('2026-10-14T05:30:00Z');

  it('accepts the PIN hashed by the app and nothing else', () => {
    assert.equal(verifyPin('2580', APP_HASH), true);
    assert.equal(verifyPin('2581', APP_HASH), false);
    assert.equal(verifyPin('2580', 'plain'), false);
    assert.equal(verifyPin('2580', undefined), false);
  });

  it('revoked beats expired, then the PIN is checked', () => {
    const past = new Date(now.getTime() - 1000);
    assert.equal(checkShare(undefined, null, now), 'notFound');
    assert.equal(checkShare({ revoked: true, expiresAt: past }, null, now), 'revoked');
    assert.equal(checkShare({ expiresAt: past }, null, now), 'expired');
    assert.equal(checkShare({ expiresAt: new Date(now.getTime() + 60000) }, null, now), 'ok');
    assert.equal(checkShare({ pinHash: APP_HASH }, null, now), 'needsPin');
    assert.equal(checkShare({ pinHash: APP_HASH }, '1111', now), 'wrongPin');
    assert.equal(checkShare({ pinHash: APP_HASH }, '2580', now), 'ok');
  });

  it('five wrong PINs in 15 minutes lock the link', () => {
    const wrong = Array.from({ length: 5 }, (_, i) => ({ at: new Date(now.getTime() - i * 60000), ok: false }));
    assert.equal(checkShare({ pinHash: APP_HASH, accessLog: wrong }, '2580', now), 'locked');
    assert.equal(checkShare({ pinHash: APP_HASH, accessLog: wrong }, '2580', new Date(now.getTime() + 20 * 60000)), 'ok');
  });
});
