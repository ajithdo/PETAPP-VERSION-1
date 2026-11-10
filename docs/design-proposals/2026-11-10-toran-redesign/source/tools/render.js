/* Renders every mock screen to PNG files in ../../screens.
   Needs Node and Playwright with Chromium:  node render.js
   Each screen is the page source/app.html?screen=<name>, with optional
   &theme=dark, &easy=1 and &lang=te&user=ravi. */
const path = require('path');
const fs = require('fs');
const { chromium } = require('playwright');

const SCREENS = ['home', 'health', 'book', 'shop', 'me', 'welcome', 'signin', 'demo', 'sos', 'first-aid', 'televet', 'ask', 'messages', 'notifications', 'clinic-finder', 'clinic-page', 'booking-details', 'my-bookings', 'product', 'cart', 'cart-empty', 'pet-profile', 'routine', 'medical-card', 'vault', 'vault-open', 'album', 'family', 'plus', 'settings', 'portal-clinic', 'portal-vet', 'portal-seller', 'admin'];
const TABS = SCREENS.slice(0, 5);
const num = (s) => String(SCREENS.indexOf(s) + 1).padStart(2, '0');
const jobs = [];
for (const s of SCREENS) { jobs.push({ out: `phone/${num(s)}-${s}`, w: 360, h: 800, dpr: 2, q: `screen=${s}` }); jobs.push({ out: `desktop/${num(s)}-${s}`, w: 1280, h: 860, dpr: 1.5, q: `screen=${s}` }); }
for (const s of TABS) {
  jobs.push({ out: `dark-mode/${num(s)}-${s}-phone`, w: 360, h: 800, dpr: 2, q: `screen=${s}&theme=dark` });
  jobs.push({ out: `dark-mode/${num(s)}-${s}-desktop`, w: 1280, h: 860, dpr: 1.5, q: `screen=${s}&theme=dark` });
  jobs.push({ out: `easy-mode/${num(s)}-${s}`, w: 360, h: 800, dpr: 2, q: `screen=${s}&easy=1` });
  jobs.push({ out: `telugu/${num(s)}-${s}`, w: 360, h: 800, dpr: 2, q: `screen=${s}&lang=te&user=ravi` });
  jobs.push({ out: `first-view/${num(s)}-${s}`, w: 360, h: 800, dpr: 2, q: `screen=${s}`, fold: true });
}
(async () => {
  const outRoot = process.argv[2] || path.resolve(__dirname, '../../screens');
  const only = process.argv[3];
  const app = 'file://' + path.resolve(__dirname, '../app.html');
  const browser = await chromium.launch();
  for (const j of jobs) {
    if (only && !j.out.includes(only)) continue;
    const page = await browser.newPage({ viewport: { width: j.w, height: j.h }, deviceScaleFactor: j.dpr });
    const errs = []; page.on('pageerror', (e) => errs.push(String(e)));
    await page.goto(`${app}?${j.q}`);
    await page.evaluate(() => document.fonts.ready);
    if (!j.fold) for (let i = 0; i < 2; i++) { const h = await page.evaluate(() => document.documentElement.scrollHeight); await page.setViewportSize({ width: j.w, height: Math.max(h, j.h) }); await page.waitForTimeout(90); }
    const m = await page.evaluate(() => ({ sw: document.documentElement.scrollWidth, cw: document.documentElement.clientWidth }));
    const file = path.join(outRoot, j.out + '.png');
    fs.mkdirSync(path.dirname(file), { recursive: true });
    await page.screenshot({ path: file });
    if (m.sw > m.cw || errs.length) console.log('CHECK', j.out, m, errs);
    await page.close();
  }
  await browser.close();
  console.log('done', jobs.length);
})();
