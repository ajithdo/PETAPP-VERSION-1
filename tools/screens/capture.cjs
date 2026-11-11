// Screenshots of the Flutter web build with Playwright, signed in as a demo
// account, for design reviews (UI Design 5 run, Nov 2026).
//
//   node tools/screens/capture.cjs <web-build-dir> <shots.json> <out-dir>
//
// shots.json: [{ "name": "phone-home", "route": "/home", "width": 360,
//   "height": 800, "account": "Priya Sharma", "theme": "light|dark",
//   "easy": false, "scroll": 0 }]
// The demo starts signed out, so each shot taps the demo account by name
// (through Flutter's accessibility tree), then opens the route. The account's
// language, theme, Easy mode and high contrast come from the saved settings
// ("locale": "en|hi|te", "easy": true, "highContrast": true).
// "account": null leaves the app signed out (sign-in screens).
const { chromium } = require('playwright');
const http = require('http');
const fs = require('fs');
const path = require('path');

const [dir, shotsFile, outDir] = process.argv.slice(2);
const types = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.json': 'application/json',
  '.wasm': 'application/wasm', '.png': 'image/png', '.jpg': 'image/jpeg', '.ttf': 'font/ttf', '.otf': 'font/otf',
  '.css': 'text/css', '.svg': 'image/svg+xml', '.ico': 'image/x-icon', '.webp': 'image/webp' };
const server = http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0]);
  if (p === '/' || !path.extname(p)) p = '/index.html';
  const f = path.join(dir, p);
  fs.readFile(f, (err, data) => {
    if (err) { res.writeHead(404); res.end(); return; }
    res.writeHead(200, { 'Content-Type': types[path.extname(f)] || 'application/octet-stream' });
    res.end(data);
  });
});

(async () => {
  await new Promise((r) => server.listen(0, r));
  const port = server.address().port;
  const shots = JSON.parse(fs.readFileSync(shotsFile, 'utf8'));
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  const errors = [];
  for (const s of shots) {
    const ctx = await browser.newContext({ viewport: { width: s.width, height: s.height || 800 }, deviceScaleFactor: s.scale || 1 });
    const prefs = {
      'flutter.onboardingSeen': 'true',
      'flutter.languageChosen': 'true',
      'flutter.locale': JSON.stringify(s.locale || 'en'),
      'flutter.themeMode': String(s.theme === 'dark' ? 2 : 1),
      'flutter.easyMode': String(!!s.easy),
      'flutter.highContrast': String(!!s.highContrast),
    };
    await ctx.addInitScript((p) => { for (const [k, v] of Object.entries(p)) localStorage.setItem(k, v); }, prefs);
    const page = await ctx.newPage();
    page.on('console', (m) => { if (m.type() === 'error') errors.push(`${s.name}: ${m.text().slice(0, 200)}`); });
    page.on('pageerror', (e) => errors.push(`${s.name}: ${String(e).slice(0, 200)}`));
    const settle = (ms) => page.waitForTimeout(ms);
    const go = async (route) => { await page.evaluate((r) => { location.hash = '#' + r; }, route); await settle(1800); };
    const tap = async (name, role) => {
      const loc = role ? page.getByRole(role, { name }) : page.getByText(name, { exact: false });
      await loc.first().click({ timeout: 15000 });
      await settle(1500);
    };
    await page.goto(`http://localhost:${port}/#/signin`, { waitUntil: 'load' });
    await page.waitForSelector('flutter-view, flt-glass-pane', { timeout: 60000 }).catch(() => {});
    await settle(3500);
    await page.evaluate(() => { const b = document.querySelector('flt-semantics-placeholder'); if (b) b.click(); });
    await settle(800);
    try {
      if (s.account !== null) {
        await tap(new RegExp(s.account || 'Priya Sharma'), 'button');
        await settle(2500);
      }
      for (const st of s.steps || []) {
        if (st.go) await go(st.go);
        if (st.tap) await tap(new RegExp(st.tap), st.role);
      }
      if (s.route) await go(s.route);
    } catch (e) { errors.push(`${s.name}: STEP FAILED ${String(e).split('\n')[0]}`); }
    await settle(s.wait || 2500);
    if (s.scroll) {
      await page.mouse.move(s.width / 2, (s.height || 800) / 2);
      await page.mouse.wheel(0, s.scroll);
      await page.waitForTimeout(1200);
    }
    const ext = s.ext || 'png';
    await page.screenshot({ path: path.join(outDir, `${s.name}.${ext}`), ...(ext === 'jpg' ? { type: 'jpeg', quality: 82 } : {}) });
    await ctx.close();
    process.stdout.write(`${s.name} `);
  }
  await browser.close();
  server.close();
  fs.writeFileSync(path.join(outDir, '_console-errors.txt'), errors.join('\n') + '\n');
  console.log(`\n${shots.length} shots, ${errors.length} console errors`);
})();
