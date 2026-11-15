// Draws the demo pictures (pets, album scenes, clinics and providers) from
// the UI Design 6 kit, so the demo data looks exactly like the design.
//
//   node tools/drawings/render.cjs            # writes assets/images/demo/
//   python3 tools/drawings/shrink.py          # then makes the files small
//
// Needs Node with Playwright. The drawings come from
// docs/design-proposals/2026-11-10-toran-redesign/source/kit.js.
const { chromium } = require('playwright');
const path = require('path');
(async () => {
  const root = path.resolve(__dirname, '../..');
  const out = path.join(root, 'assets/images/demo');
  const b = await chromium.launch();
  const p = await b.newPage({ deviceScaleFactor: 1 });
  await p.goto('file://' + path.join(__dirname, 'render.html'));
  const shot = async (file, w, h, js) => {
    await p.setViewportSize({ width: w, height: h });
    await p.evaluate(([w, h, js]) => { const box = document.getElementById('box'); box.style.width = w + 'px'; box.style.height = h + 'px'; box.innerHTML = eval(js); }, [w, h, js]);
    await p.locator('#box').screenshot({ path: path.join(out, file), omitBackground: false });
  };
  const pets = ['bruno', 'misty', 'simba', 'kiwi', 'coco', 'tiger', 'max', 'luna', 'sheru'];
  for (const k of pets) await shot(`pets/${k}.png`, 400, 496, `petSvg('${k}')`);
  // Album: nine scenes per pet, with the moods and extras the design uses.
  const scenes = [['park', ''], ['beach', 'joy'], ['festive', '', 'garland'], ['home', 'sleep'], ['rain', '', 'bandana'], ['party', 'joy', 'hat'], ['bath', ''], ['night', 'sleep'], ['vet', '']];
  for (const k of pets) {
    for (let i = 0; i < scenes.length; i++) {
      const [sc, mood, acc] = scenes[i];
      await shot(`album/${k}_${i}.png`, 480, 480, `snap('${k}', '${sc}', {mood: '${mood}', acc: '${acc || ''}'})`);
    }
  }
  // Places: the kit's five shopfronts. Clinics have a cross on the sign
  // (clinic24_* also show "24" for round-the-clock clinics); providers
  // (groomers, trainers, boarders, walkers) have scissors.
  for (let i = 0; i < 5; i++) {
    await shot(`places/clinic_${i}.png`, 640, 400, `place(${i})`);
    await shot(`places/clinic24_${i}.png`, 640, 400, `place(${i}, {x24: 1})`);
    await shot(`places/provider_${i}.png`, 640, 400, `place(${(i + 2) % 5}, {sign: 'scissors'})`);
  }
  await b.close();
  console.log('done');
})();
