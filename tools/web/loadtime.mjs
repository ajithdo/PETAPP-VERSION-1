// Cold-load measurement of the served web build: optional network and CPU
// throttling through the Chrome DevTools Protocol, every response's transfer
// size, and the time until Flutter draws its first frame.
//
// Usage: node tools/web/loadtime.mjs [url=http://127.0.0.1:8090] [profile=slow4g|desktop] [runs=3]
// Uses $CHROME_EXECUTABLE when set (the cloud startup script sets it).
import { chromium } from '@playwright/test';

const [base = 'http://127.0.0.1:8090', profileName = 'slow4g', runsArg = '3'] = process.argv.slice(2);
const profiles = {
  // Lighthouse mobile ("Slow 4G"): 150 ms latency, 1.6 Mbps down, 750 kbps up, 4x slower CPU.
  slow4g: { latency: 150, down: 1.6e6 / 8, up: 750e3 / 8, cpu: 4, viewport: { width: 390, height: 844 } },
  // Desktop broadband: 40 ms latency, 10 Mbps down, 5 Mbps up, no CPU slowdown.
  desktop: { latency: 40, down: 10e6 / 8, up: 5e6 / 8, cpu: 1, viewport: { width: 1280, height: 800 } },
};
const profile = profiles[profileName];
if (!profile) throw new Error(`Unknown profile ${profileName}; use ${Object.keys(profiles).join(' or ')}`);

const browser = await chromium.launch(process.env.CHROME_EXECUTABLE ? { executablePath: process.env.CHROME_EXECUTABLE } : {});
const runs = [];
for (let i = 0; i < Number(runsArg); i++) {
  const context = await browser.newContext({ viewport: profile.viewport });
  const page = await context.newPage();
  const cdp = await context.newCDPSession(page);
  await cdp.send('Network.enable');
  await cdp.send('Network.setCacheDisabled', { cacheDisabled: true });
  await cdp.send('Network.emulateNetworkConditions', { offline: false, latency: profile.latency, downloadThroughput: profile.down, uploadThroughput: profile.up });
  await cdp.send('Emulation.setCPUThrottlingRate', { rate: profile.cpu });
  const urls = new Map();
  const bytes = new Map();
  const errors = [];
  cdp.on('Network.requestWillBeSent', (e) => urls.set(e.requestId, e.request.url));
  cdp.on('Network.loadingFinished', (e) => bytes.set(e.requestId, e.encodedDataLength));
  page.on('console', (m) => { if (m.type() === 'error') errors.push(m.text()); });
  page.on('pageerror', (e) => errors.push(e.message));
  await page.addInitScript(() => {
    window.__firstFrame = new Promise((resolve) => window.addEventListener('flutter-first-frame', () => resolve(performance.now()), { once: true }));
  });
  await page.goto(`${base}/`, { waitUntil: 'commit' });
  const firstFrameMs = Math.round(await page.evaluate(() => window.__firstFrame));
  await page.waitForTimeout(3000); // let late fonts and images finish before counting bytes
  const files = [...bytes].map(([id, b]) => ({ url: (urls.get(id) ?? '').replace(base, ''), kb: Math.round(b / 1024) })).sort((a, b) => b.kb - a.kb);
  runs.push({ run: i + 1, firstFrameMs, transferKB: files.reduce((sum, f) => sum + f.kb, 0), requests: files.length, files, consoleErrors: errors });
  await context.close();
}
await browser.close();

const sorted = runs.map((r) => r.firstFrameMs).sort((a, b) => a - b);
console.log(JSON.stringify({ profile: profileName, medianFirstFrameMs: sorted[Math.floor(sorted.length / 2)], runs }, null, 1));
