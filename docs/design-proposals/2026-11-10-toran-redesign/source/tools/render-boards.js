/* Saves each presentation board as a PNG.  node render-boards.js [outDir] [onlyId] */
const path = require('path');
const fs = require('fs');
const { chromium } = require('playwright');
const IDS = ['01-overview', '02-before-and-after', '03-main-tabs', '04-start-and-safety', '05-vets-and-booking', '06-bookings-and-shop', '07-your-pet', '08-account-and-partners', '09-desktop-main-tabs', '10-desktop-flows', '11-desktop-partners-and-admin', '12-dark-mode', '13-easy-mode', '14-telugu'];
(async () => {
  const out = process.argv[2] || path.resolve(__dirname, '../../boards');
  const only = process.argv[3];
  fs.mkdirSync(out, { recursive: true });
  const browser = await chromium.launch();
  for (const id of IDS) {
    if (only && !id.includes(only)) continue;
    const page = await browser.newPage({ viewport: { width: 1200, height: 800 }, deviceScaleFactor: 1.5 });
    page.on('pageerror', (e) => console.log('ERR', id, String(e)));
    await page.goto('file://' + path.resolve(__dirname, '../boards.html') + '?b=' + id);
    await page.evaluate(() => document.fonts.ready);
    await page.evaluate(() => window.boardsReady);
    const b = await page.evaluate(() => { const r = document.querySelector('.board').getBoundingClientRect(); return { w: Math.ceil(r.width), h: Math.ceil(r.height) }; });
    await page.setViewportSize({ width: b.w, height: b.h });
    await page.waitForTimeout(150);
    const b2 = await page.evaluate(() => { const r = document.querySelector('.board').getBoundingClientRect(); return { w: Math.ceil(r.width), h: Math.ceil(r.height) }; });
    await page.setViewportSize({ width: b2.w, height: b2.h });
    await page.waitForTimeout(100);
    await page.screenshot({ path: path.join(out, id + '.png') });
    console.log(id, b2);
    await page.close();
  }
  await browser.close();
})();
