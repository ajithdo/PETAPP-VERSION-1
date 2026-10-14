/**
 * Loads the PawSetu demo data into the Firebase emulators (BACKEND=emulator).
 *
 *   1. Start the emulators:   firebase emulators:start
 *   2. In another window:     npm --prefix functions run seed
 *
 * Running it again resets everything (Firestore, Auth and Storage) and
 * reloads fresh demo data, with dates relative to today.
 */
const { execFileSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const PROJECT = process.env.GCLOUD_PROJECT || 'demo-pawsetu';
const HOST = process.env.EMULATOR_HOST || '127.0.0.1';
process.env.FIRESTORE_EMULATOR_HOST = `${HOST}:8080`;
process.env.FIREBASE_AUTH_EMULATOR_HOST = `${HOST}:9099`;
process.env.FIREBASE_STORAGE_EMULATOR_HOST = `${HOST}:9199`;

const root = path.resolve(__dirname, '..', '..');
const req = (m) => require(require.resolve(m, { paths: [path.join(root, 'functions')] }));
const { initializeApp } = req('firebase-admin/app');
const { getAuth } = req('firebase-admin/auth');
const { getFirestore, Timestamp } = req('firebase-admin/firestore');

async function main() {
  console.log('1/4 Building demo data (dart run tools/seed/export_seed.dart)...');
  const tmp = path.join(os.tmpdir(), `pawsetu-seed-${Date.now()}.json`);
  execFileSync('dart', ['run', 'tools/seed/export_seed.dart', tmp], { cwd: root, stdio: 'inherit', shell: process.platform === 'win32' });
  const seed = JSON.parse(fs.readFileSync(tmp, 'utf8'));
  fs.unlinkSync(tmp);

  console.log('2/4 Clearing the emulators...');
  await fetch(`http://${HOST}:8080/emulator/v1/projects/${PROJECT}/databases/(default)/documents`, { method: 'DELETE' });
  await fetch(`http://${HOST}:9099/emulator/v1/projects/${PROJECT}/accounts`, { method: 'DELETE' });

  initializeApp({ projectId: PROJECT });
  const auth = getAuth();
  const db = getFirestore();

  console.log('3/4 Creating demo accounts with roles...');
  const accounts = seed.demoAccounts || {};
  for (const [uid, a] of Object.entries(accounts)) {
    const user = seed.users[uid];
    await auth.createUser({
      uid,
      email: a.email,
      password: a.password,
      phoneNumber: a.phone ? a.phone.replace(/\s/g, '') : undefined,
      displayName: user?.name,
      emailVerified: true,
    });
    await auth.setCustomUserClaims(uid, { role: user?.role || 'owner' });
  }

  console.log('4/4 Writing documents...');
  const revive = (v) => {
    if (v && typeof v === 'object' && !Array.isArray(v)) {
      if ('__date' in v) return Timestamp.fromDate(new Date(v.__date));
      return Object.fromEntries(Object.entries(v).map(([k, x]) => [k, revive(x)]));
    }
    if (Array.isArray(v)) return v.map(revive);
    return v;
  };
  let count = 0;
  for (const [col, docs] of Object.entries(seed)) {
    if (col === 'demoAccounts') continue;
    let batch = db.batch();
    let n = 0;
    for (const [id, data] of Object.entries(docs)) {
      batch.set(db.collection(col).doc(id), revive(data));
      if (++n % 400 === 0) {
        await batch.commit();
        batch = db.batch();
      }
    }
    await batch.commit();
    count += n;
  }
  console.log(`Done: ${Object.keys(accounts).length} accounts and ${count} documents. Demo password: demo1234, phone code: 123456.`);
}

main().catch((e) => {
  console.error('Seeding failed. Are the emulators running? (firebase emulators:start)');
  console.error(e);
  process.exit(1);
});
