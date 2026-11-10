/* One pet: profile, routine, medical card, document vault, memory album */
SCREENS['pet-profile'] = () => {
  const care = (icon, cls, title, sub) => `<a class="card live"><span class="tile ${cls}" style="--w:2.75rem">${ic(icon)}</span><div class="b2 mt-3">${title}</div><div class="c">${sub}</div></a>`;
  return shell({ kind: 'sub', nav: 'me', title: 'Bruno', actions: `<button class="icon-btn" aria-label="Edit">${ic('pencil-simple')}</button><button class="icon-btn" aria-label="More: archive, share">${ic('dots-three-vertical')}</button>`, page: '', body: `
  <div class="bento"><div class="s5 stack-lg">
    <section class="petcover"><div class="petcover-arch">${arch('bruno', '9.5rem')}</div><h1 class="d1 mt-4">Bruno</h1><div class="b1 dim">Labrador Retriever, 3 yrs 2 mo</div><div class="row wrap gap-2 mt-3 center">${tag('Adult')}${tag('You are the owner', 'gold', 'user')}${tag('Birthday 5 Sept', '', 'cake')}</div></section>
    <section class="statgrid"><div><div class="c">${ic('cake')} Age</div><div class="num">3 yrs 2 mo</div></div><div><div class="c">${ic('scales')} Weight</div><div class="num">29 kg</div></div><div><div class="c">${ic('gender-male')} Gender</div><div class="num">Male</div></div><div><div class="c">${ic('shield-check')} Neutered</div><div class="num">Yes</div></div></section>
    <a class="panel row">${qr('3.25rem')}<div class="grow"><div class="b2">QR tag is active</div><div class="c">Anyone who finds Bruno can reach you. Your number stays hidden.</div></div>${chev()}</a></div>
  <div class="s7 stack-lg">
    <section>${sec('Care')}<div class="grid g2 dg4">${care('heartbeat', 'red', 'Health', 'Vaccines, medicines, vet visits')}${care('person-simple-walk', 'green', 'Routine', 'Walks, meals, play, mood')}${care('lock-key', 'gold', 'Document vault', 'Certificates, insurance, reports')}${care('images', 'sky', 'Memory album', 'Photos, videos, milestones')}</div></section>
    <section>${sec('Details', 'Edit')}<div class="panel"><dl class="kv"><dt>Colour and markings</dt><dd>Yellow coat, white chest patch</dd><dt>Microchip ID</dt><dd>DEMO-985-000-111</dd><dt>Allergies</dt><dd class="red">${ic('warning', 1)} Chicken</dd><dt>Diet</dt><dd>Dry food, twice a day, 220 g</dd><dt>Regular clinic</dt><dd>Gulmohar Vet Studio</dd><dt>Insurance</dt><dd>PawCover Gold, renews 3 Jan 2027</dd><dt>Temperament</dt><dd style="font-weight:420">Friendly with dogs. Nervous of fireworks.</dd></dl></div></section>
    <section>${sec('Who looks after Bruno', 'Family and sharing')}<div class="row gap-4">${[['PS', 'Priya', 'Owner', 'ink'], ['RS', 'Rohan', 'Carer', '']].map(([i, n, r, c]) => `<div class="row gap-2">${person(i, '2.5rem', c)}<div><div class="b2">${n}</div><div class="c">${r}</div></div></div>`).join('')}<button class="round line" aria-label="Invite">${ic('plus')}</button></div></section></div></div>` });
};

const logRow = (time, icon, cls, title, sub) => `<li><time class="m dim">${time}</time>${tile(icon, cls, '2.5rem')}<div class="grow"><div class="b2">${title}</div><div class="c">${sub}</div></div><button class="icon-btn" aria-label="More">${ic('dots-three-vertical')}</button></li>`;
SCREENS.routine = () => {
  const d = DATA();
  const kinds = [['person-simple-walk', 'Walk'], ['tennis-ball', 'Play'], ['fork-knife', 'Meal'], ['drop', 'Water'], ['toilet-paper', 'Potty'], ['moon', 'Sleep'], ['scissors', 'Grooming'], ['graduation-cap', 'Training'], ['smiley', 'Mood'], ['scales', 'Weight']];
  return shell({ kind: 'sub', nav: 'home', title: "Bruno's routine", page: '', body: `
  <div class="tabs"><span class="on">Log</span><span>Charts</span><span>Behaviour</span><span>Daily plan</span></div>
  <div class="bento mt-5"><div class="s6 stack-lg">
    <section class="dark hero">${toran('bruno', 2, 5, '8rem')}<div class="grow hero-text"><h2 class="d2">Bruno's day</h2><div class="b1 mt-1" style="color:var(--on-dark-2)">3 things left today</div><div class="mt-3">${tag('30 days in a row', 'on-dark', 'fire')}</div></div></section>
    <section class="week">${[['M', 1], ['T', 1], ['W', 1], ['T', 1], ['F', 1], ['S', 1], ['S', 0]].map(([l, done], i) => `<div class="${i === 6 ? 'now' : ''}"><span class="m dim">${l}</span>${done ? bloom('1.75rem') : ring(2, 5, '1.75rem')}</div>`).join('')}</section>
    <section class="card today"><div class="list">${d.tasks.map(taskRow).join('')}</div></section>
    <section>${sec('Log something')}<div class="logs">${kinds.map(([i, l]) => `<button><span class="tile" style="--w:3rem;border-radius:50%">${ic(i)}</span><span class="m">${l}</span></button>`).join('')}</div></section></div>
  <div class="s6"><section>${sec('Today', 'See all')}<ol class="timeline">
      ${logRow('12:19 PM', 'drop', 'sky', 'Water', 'Bowl refilled, by Priya')}${logRow('10:00 AM', 'scales', '', 'Weight, 29 kg', 'By Priya')}${logRow('8:36 AM', 'fork-knife', 'gold', 'Meal, 220 g', 'Lamb & Rice, by Priya')}${logRow('7:34 AM', 'toilet-paper', '', 'Potty', 'Normal, by Priya')}${logRow('6:50 AM', 'person-simple-walk', 'green', 'Walk, 1.8 km', '24 min around Defence Colony park, by Priya')}</ol>
      <div class="photo mt-3" style="height:8rem">${map({ h: 128, pins: [], you: false })}<svg viewBox="0 0 320 128" style="position:absolute;inset:0;width:100%;height:100%" preserveAspectRatio="xMidYMid slice"><path d="M40 96h80V40q60 20 100 0v56h50" fill="none" stroke="#DC2626" stroke-width="3.500" stroke-linecap="round" stroke-linejoin="round" stroke-dasharray="1 0"/><circle cx="40" cy="96" r="5" fill="#2C6A43" stroke="#fff" stroke-width="2"/><circle cx="270" cy="96" r="5" fill="#DC2626" stroke="#fff" stroke-width="2"/></svg></div></section></div></div>
  <button class="btn primary fab only-phone">${ic('plus')}Log</button>` });
};

SCREENS['medical-card'] = () => shell({ kind: 'sub', nav: 'health', title: 'Medical card', sos: 1, page: 'mid', body: `
  <div class="bento"><div class="s7">
  <section class="idcard"><div class="row between"><span class="row gap-2 m" style="color:var(--on-dark-2)">${mark(true)}<span>PawSetu medical card</span></span>${tag('Works offline', 'on-dark', 'cloud-check')}</div>
    <div class="row start mt-4 gap-4">${arch('bruno', '5.5rem', { ring: 1 })}<div class="grow"><h1 class="d1">Bruno</h1><div style="color:var(--on-dark-2)">Dog, Labrador Retriever<br>Male, 3 yrs 2 mo, 29 kg</div></div></div>
    <div class="allergy mt-4">${ic('warning', 1)}<div><div class="m">Allergies</div><div class="t2">Chicken</div></div></div>
    <dl class="kv mt-4"><dt>Current medicines</dt><dd>None</dd><dt>Rabies vaccine</dt><dd>Given 18 Nov 2025</dd><dt>Microchip ID</dt><dd>DEMO-985-000-111</dd><dt>Regular clinic</dt><dd>Gulmohar Vet Studio<br><span style="font-weight:420;color:var(--on-dark-2)">+91 90000 00024</span></dd><dt>Owner</dt><dd>Priya Sharma<br><span style="font-weight:420;color:var(--on-dark-2)">+91 90000 00001</span></dd></dl>
    <hr class="rule" style="margin:1rem 0 .75rem"><div class="row between"><span class="m" style="color:var(--on-dark-2)">Updated 8 Nov 2026, 1:48 PM</span>${qr('3.5rem')}</div></section></div>
  <div class="s5 stack">
    ${note('This card works without internet. Show it to a vet, a boarding centre or at the airport.', 'lightning')}
    <div class="grid g2">${btn('Share', 'ink', 'share-network', 'block')}${btn('Save PDF', 'soft', 'file-pdf', 'block')}</div>
    <section class="panel" style="padding:.375rem 1rem"><div class="list">${item(tile('file-text'), 'Full health report', 'Vaccines, medicines, visits, weight chart')}${item(tile('pencil-simple'), 'Edit details', 'Allergies, medicines, clinic')}</div></section></div></div>` });

SCREENS.vault = () => shell({ kind: 'sub', nav: 'me', title: 'Document vault', page: 'narrow', body: `
  <div class="empty" style="padding:1rem 0 0"><svg viewBox="0 0 120 120" style="width:7.5rem;height:7.5rem" aria-hidden="true"><circle cx="60" cy="62" r="54" fill="var(--marigold-wash)"/><path d="M30 104V56a30 30 0 0 1 60 0v48z" fill="#2F1D14"/><path d="M38 104V57a22 22 0 0 1 44 0v47z" fill="none" stroke="#F8A80C" stroke-width="2.500"/><circle cx="60" cy="68" r="7" fill="#F8A80C"/><path d="M57 72h6l2.500 14h-11z" fill="#F8A80C"/><rect x="22" y="102" width="76" height="6" rx="3" fill="#2F1D14"/></svg>
    <h1 class="d2 mt-3">Protect your vault</h1><p class="dim" style="max-width:19rem">Choose a 4 to 6 digit PIN. You'll enter it each time you open the vault.</p>
    <div class="b2 mt-4">Choose a PIN</div><div class="row gap-3 mt-2" aria-label="2 of 4 digits entered">${[1, 1, 0, 0].map((f) => `<span class="pin${f ? ' on' : ''}"></span>`).join('')}<span class="pin opt"></span><span class="pin opt"></span></div>
    <div class="keypad mt-5">${[1, 2, 3, 4, 5, 6, 7, 8, 9].map((n) => `<button>${n}</button>`).join('')}<button class="alt" aria-label="Use fingerprint">${ic('fingerprint')}</button><button>0</button><button class="alt" aria-label="Delete">${ic('backspace')}</button></div>
    <p class="c mt-4" style="max-width:19rem">${ic('lock-key')} Locks itself after 2 minutes. Forgot your PIN? Sign in again to reset it.</p></div>` });

SCREENS['vault-open'] = () => {
  const doc = (icon, cls, title, sub, tg = '') => `<a class="card doc"><div class="sheet ${cls}">${ic(icon)}<i></i><i></i><i style="width:55%"></i>${tg}</div><div class="b2 mt-2 clamp1">${title}</div><div class="c clamp1">${sub}</div></a>`;
  return shell({ kind: 'sub', nav: 'me', title: 'Document vault', actions: `<button class="icon-btn" aria-label="Share links">${ic('link')}</button><button class="icon-btn" aria-label="Lock now">${ic('lock-key-open')}</button>`, page: '', body: `
  <div class="field">${ic('magnifying-glass')}<span>Search documents and tags</span></div>
  <div class="hscroll mt-3"><span class="pet-chip on">${arch('bruno', '1.75rem')}Bruno</span><span class="pet-chip">${arch('misty', '1.75rem')}Misty</span>${chip('Certificates')}${chip('Insurance')}${chip('Lab reports')}${chip('Prescriptions')}</div>
  <div class="mt-4">${note('<b>Rabies certificate expires on 18 Nov.</b> Add the new one after Bruno’s booster.', 'clock', 'gold')}</div>
  <div class="grid g2 dg4 mt-4">${doc('syringe', 'green', 'Rabies certificate', 'Expires 18 Nov 2026', `<span class="stamp">SAMPLE</span>`)}${doc('shield-check', 'sky', 'PawCover Gold policy', 'Renews 3 Jan 2027')}${doc('flask', '', 'Blood test report', '18 Oct 2026')}${doc('file-text', 'gold', 'Prescription, Dr. Sameer', '27 Oct 2026')}${doc('receipt', '', 'Invoice, Gulmohar', '18 Oct 2026')}${doc('identification-badge', '', 'KCI registration', 'No expiry')}</div>
  <section class="mt-6">${sec('Shared with a vet', 'All links')}<div class="panel row">${tile('link', 'gold')}<div class="grow"><div class="b2">Blood test report, view only</div><div class="c">Dr. Sameer Khan. Link ends in 22 hours. Opened twice.</div></div>${btn('Revoke', 'line sm')}</div></section>
  <section class="mt-6">${sec('Insurance')}<div class="panel row">${tile('shield-check', 'sky')}<div class="grow"><div class="b2">PawCover Gold, ₹2,00,000 cover</div><div class="c">1 claim in review: ₹4,200, 2 of 3 documents added</div></div>${chev()}</div></section>
  <button class="btn primary fab only-phone">${ic('scan')}Scan or upload</button>` });
};

const pic = (k, scene, o = {}) => `<div class="photo" style="aspect-ratio:1;${o.span ? 'grid-column:span 2;grid-row:span 2;' : ''}">${snap(k, scene, o)}${o.fav ? `<span class="heart">${ic('heart', 1)}</span>` : ''}${o.vid ? `<span class="over">${tag(o.vid, 'ink', 'play')}</span>` : ''}</div>`;
SCREENS.album = () => shell({ kind: 'sub', nav: 'me', titleHtml: `<span class="row gap-2">${arch('bruno', '1.75rem')}Bruno's memories ${ic('caret-down')}</span>`, title: "Bruno's memories", actions: `<button class="icon-btn" aria-label="Share with family">${ic('users')}</button><button class="icon-btn" aria-label="Milestones">${ic('cake')}</button>`, page: '', body: `
  <div class="tabs"><span class="on">Photos</span><span>Timeline</span><span>Albums</span><span>Favourites</span></div>
  <div class="bento mt-5"><div class="s4 stack-lg">
    <section class="wash"><div class="row gap-2 b2">${ic('clock-counter-clockwise')}On this day, 1 year ago</div><div class="row mt-3" style="justify-content:center;padding:.5rem 0 .25rem"><div class="print" style="width:8.5rem;transform:rotate(-4deg)"><div class="photo" style="aspect-ratio:1;border-radius:.25rem">${snap('bruno', 'beach', { mood: 'joy' })}<span class="over">${tag('0:24', 'ink', 'play')}</span></div></div><div class="print" style="width:8.5rem;transform:rotate(3deg);margin-left:-1.25rem;margin-top:.75rem"><div class="photo" style="aspect-ratio:1;border-radius:.25rem">${snap('bruno', 'park')}<span class="heart">${ic('heart', 1)}</span></div></div></div><div class="c mt-3" style="color:var(--marigold-ink);text-align:center">Bruno's first beach day, Gokarna</div></section>
    <section class="panel"><div class="row between"><span class="b2">Storage</span><span class="c">12.4 GB of 25 GB</span></div><div class="bar mt-2"><i style="width:50%"></i></div><div class="c mt-2">Videos up to 3 min with Plus.</div></section></div>
  <div class="s8 stack-lg">
    <section><div class="sec"><h2 class="t1">November 2026</h2><span class="c">3 memories</span></div><div class="grid g3 dg6 pics">${pic('bruno', 'festive', { acc: 'garland', span: 1, fav: 1 })}${pic('bruno', 'bath')}${pic('bruno', 'home', { mood: 'sleep' })}</div><div class="row gap-2 mt-2">${tag('Milestone: Diwali at home', 'gold', 'flower-lotus')}</div></section>
    <section><div class="sec"><h2 class="t1">October 2026</h2><span class="c">3 memories</span></div><div class="grid g3 dg6 pics">${pic('bruno', 'rain', { acc: 'bandana' })}${pic('bruno', 'night', { mood: 'sleep', fav: 1 })}${pic('bruno', 'vet', { vid: '0:18' })}</div></section>
    <section><div class="sec"><h2 class="t1">September 2026</h2><span class="c">5 memories</span></div><div class="grid g3 dg6 pics">${pic('bruno', 'party', { acc: 'hat', mood: 'joy', fav: 1 })}${pic('bruno', 'beach')}${pic('bruno', 'park', { mood: 'joy' })}</div><div class="row gap-2 mt-2">${tag('Milestone: 3rd birthday', 'gold', 'cake')}</div></section></div></div>
  <button class="btn primary fab only-phone">${ic('camera-plus')}Add photos or videos</button>` });
