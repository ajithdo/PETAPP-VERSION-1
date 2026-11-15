/* The five main tabs: Home, Health, Book, Shop, Me */
const tn = (s, n) => t(s).replace('{n}', n);
const DATA = () => USER.first === 'Ravi'
  ? { n: 'Simba', breed: t('Indian Pariah (Indie)'), age: t('5 months'), kg: '8.5 kg', done: 4, total: 6, attn: 2,
      tasks: [['person-simple-walk', 'Walk', 2, 2, '1:10 PM, Ravi', 'play'], ['fork-knife', 'Meal', 2, 3, '1:50 PM, Ravi', 'plus'], ['tennis-ball', 'Play', 0, 1, t('0 of 40 min'), 'plus']],
      next: [['Nov', '6', 'red', 'DHPPi + Lepto, dose 3', t('Overdue by 2 days'), 'red'], ['Nov', '14', '', 'Anti-rabies, dose 1', t('Due in 6 days'), ''], ['Nov', '20', '', 'Deworming', t('Due in 12 days'), '']],
      allergy: t('No known allergies'), clinic: 'Golconda Gate Pet Clinic', city: 'Banjara Hills, Hyderabad' }
  : { n: 'Bruno', breed: 'Labrador Retriever', age: t('3 yrs 2 mo'), kg: '29 kg', done: 2, total: 5, attn: 3,
      tasks: [['person-simple-walk', 'Walk', 1, 2, '6:50 AM, Priya', 'play'], ['fork-knife', 'Meal', 1, 2, '8:36 AM, Priya', 'plus'], ['tennis-ball', 'Play', 0, 1, t('0 of 30 min'), 'plus']],
      next: [['Nov', '13', 'gold', 'Flea and tick prevention', t('Due in 5 days'), 'gold'], ['Nov', '18', '', 'DHPPi + Lepto booster', t('Due in 10 days'), ''], ['Nov', '18', '', 'Anti-rabies booster', t('Due in 10 days'), '']],
      allergy: 'Chicken', clinic: 'Gulmohar Vet Studio', city: 'Indiranagar, Bengaluru' };

const taskRow = ([icon, name, done, total, meta, act], i) => `<div class="item">${ring(done, total)}<div class="grow"><div class="b2 row gap-2">${ic(icon)}<span>${t(name)}</span>${total > 1 ? `<span class="num dim" style="font-weight:600">${done}/${total}</span>` : ''}</div><div class="c">${meta}</div></div><button class="round ${i === 0 && done < total ? 'primary' : 'soft'}" aria-label="${act === 'play' ? 'Start a walk' : 'Log'}">${ic(act, act === 'play')}</button></div>`;
const nextRow = ([m, d, k, title, due, tone], i) => `<div class="item">${leafdate(t(m), d, k)}<div class="grow"><div class="b2">${t(title)}</div><div class="c ${tone === 'red' ? 'red' : tone === 'gold' ? 'gold' : ''}" style="font-weight:${tone ? 600 : 420}">${due}</div></div>${i === 0 ? `<button class="btn sm ${tone === 'red' ? 'ink' : 'line'}">${tone === 'red' ? t('Book') : t('Mark given')}</button>` : chev()}</div>`;

SCREENS.home = () => {
  const d = DATA(), n = d.n, k = USER.pet;
  const hero = `<section class="dark hero">${toran(k, d.done, d.total, EASY ? '7.5rem' : '9.5rem')}<div class="grow hero-text">
      <h2 class="d2">${tn("{n}'s day", n)}</h2>
      <div class="b1 mt-2" style="color:var(--on-dark-2)">${t('{a} of {b} done').replace('{a}', `<b class="num" style="color:var(--marigold);font-size:1.5rem">${d.done}</b>`).replace('{b}', d.total)}</div>
      <div class="mt-3">${tag(t('30 days in a row'), 'on-dark', 'fire')}</div></div>
      <div class="hero-aside only-desk"><div class="grow"><div class="b2" style="color:var(--on-dark)">${t('Evening walk is next')}</div>${tn('Cooler for {n} after 6:15 pm.', n)}</div>${btn(t('Start walk'), 'primary sm', 'play')}</div></section>`;
  const today = `<section class="card today"><div class="sec"><h2 class="t1">${t('Today')}</h2><span class="c">${t('{x} left').replace('{x}', d.total - d.done)}</span></div>
      <div class="list">${d.tasks.map(taskRow).join('')}</div>
      <div class="row between mt-3">${btn(t('Log'), 'soft sm', 'plus')}<a class="link">${t('See all')}</a></div></section>`;
  const next = `<section><div class="sec"><h2 class="t1">${t('Next up')}</h2><a class="link">${t('See all')}</a></div><div class="panel"><div class="list tight">${d.next.map(nextRow).join('')}</div></div></section>`;
  const qa = [['stethoscope', 'Book vet', 'gold'], ['person-simple-walk', 'Log walk', 'green'], ['video-camera', 'Ask a vet', 'sky'], ['camera-plus', 'Add photo', '']];
  const quick = `<section><div class="sec"><h2 class="t1">${t('Quick actions')}</h2></div><div class="qa">${qa.map(([i, l, c]) => `<button><span class="tile ${c}" style="--w:3.5rem">${ic(i)}</span><span>${t(l)}</span></button>`).join('')}</div></section>`;
  if (EASY) return shell({ nav: 'home', body: `<p class="c">${t('Sun, 8 Nov')}</p><h1 class="d1 mt-1">${t('Good afternoon')}, ${USER.first}</h1><div class="stack-lg mt-5">${hero}${today}${next}${quick}<button class="btn sos block lg">${ic('asterisk')}${t('SOS, emergency help')}</button></div>` });
  const weather = `<section class="wash sky weather"><div class="row start"><div class="num" style="font-size:2.25rem;line-height:1;color:var(--sky-ink)">31°</div><div class="grow"><div class="b2">${tn('Too warm for {n} to walk right now', n)}</div><div class="c">${t('Pavements are hot. Best before 8 am or after 6:15 pm.')}</div></div></div>
      <div class="walkbar mt-3"><i style="flex:2;background:var(--leaf)"></i><i style="flex:2;background:var(--marigold)"></i><i style="flex:7;background:#E9756C"></i><i style="flex:1.2;background:var(--marigold)"></i><i style="flex:2.8;background:var(--leaf)"></i><b style="left:55%"></b></div>
      <div class="row between m dim mt-1"><span>6 am</span><span>${t('Now')}, 2 pm</span><span>9 pm</span></div></section>`;
  const food = `<section class="wash food"><div class="row start"><span class="tile" style="--w:4.25rem">${packOf('lamb')}</span><div class="grow"><div class="b2">${tn("{n}'s food may run out in about 5 days", n)}</div><div class="c">Lamb & Rice 10 kg, ${t('about 1.4 kg left')}</div><div class="bar mt-2" style="background:rgba(43,26,18,.12)"><i style="width:14%;background:var(--sos)"></i></div></div></div>
      <div class="row wrap mt-3">${btn(`${t('Reorder')} ₹3,899`, 'primary sm', 'arrow-clockwise')}<a class="link">${t('Change daily portion')}</a></div></section>`;
  const memory = `<section><div class="sec"><h2 class="t1">${t('A year ago today')}</h2><a class="link">${t('Album')}</a></div><div class="row start gap-4"><div class="print" style="width:9.5rem;transform:rotate(-2.5deg)"><div class="photo" style="aspect-ratio:1;border-radius:.25rem">${snap(k, 'beach', { mood: 'joy' })}</div><div class="m" style="position:absolute;left:0;right:0;bottom:.3rem;text-align:center;color:#66554A">8 Nov 2025</div></div><div class="grow"><div class="b2">${tn("{n}'s first beach day", n)}</div><div class="c mt-1">${t('Gokarna, with Rohan. 6 photos and 1 video.')}</div><div class="row mt-3">${btn(t('Add photo'), 'soft sm', 'camera-plus')}</div></div></div></section>`;
  const near = `<section><div class="sec"><h2 class="t1">${t('Near you')}</h2><a class="link">${t('Map')}</a></div>
      <div class="panel" style="padding:.375rem 1rem"><div class="list">
      <div class="item"><span class="tile" style="--w:3.25rem">${place(0)}</span><div class="grow"><div class="b2">${d.clinic}</div><div class="c"><span class="green" style="font-weight:600">${t('Open now')}</span>, 394 m</div></div>${btn(t('Book'), 'line sm')}</div>
      <div class="item"><span class="tile" style="--w:3.25rem">${place(1, { x24: 1 })}</span><div class="grow"><div class="b2">Namma Pet Hospital</div><div class="c"><span class="green" style="font-weight:600">24x7</span>, 6.4 km</div></div>${btn(t('Book'), 'line sm')}</div>
      </div></div><div class="row mt-3 gap-2"><span class="chip">${ic('map-pin')}${d.city}${ic('caret-down')}</span></div></section>`;
  return shell({ nav: 'home', body: `<p class="c">${t('Sunday, 8 November')}</p><h1 class="d1 mt-1">${t('Good afternoon')}, ${USER.first}</h1>
    <div class="bento mt-5"><div class="s7 stack-lg">${hero}${today}</div><div class="s5 stack-lg">${next}${quick}${weather}</div><div class="s4">${food}</div><div class="s4">${memory}</div><div class="s4">${near}</div></div>` });
};

SCREENS.health = () => {
  const d = DATA(), n = d.n, k = USER.pet, R = USER.first === 'Ravi';
  const head = `<section class="dark"><div class="row">${arch(k, '4rem', { ring: 1 })}<div class="grow"><h1 class="d2">${tn("{n}'s health", n)}</h1><div class="c">${d.breed}</div></div></div>
    <div class="row wrap gap-2 mt-3">${tag(t('{x} need attention').replace('{x}', d.attn), 'plus', 'clock')}${R ? '' : tag(t('Vaccines up to date'), 'on-dark', 'check-circle')}</div>
    <div class="stats3 mt-4"><div><div class="c">${t('Age')}</div><div class="num">${d.age}</div></div><div><div class="c">${t('Weight')}</div><div class="num">${d.kg}</div></div><div><div class="c">${t('Microchip ID')}</div><div class="num" style="font-size:.8125rem;line-height:1.5rem">${R ? t('Not added') : '985-000-111'}</div></div></div>
    <div class="grid g2 stack-easy mt-4">${btn(t('Medical card'), 'cream', 'identification-card', 'block')}${btn(t('Health report'), 'ghost-dark', 'file-pdf', 'block')}</div></section>`;
  const emergency = `<section class="panel"><div class="row gap-2 b2">${ic('first-aid-kit')}${t('Emergency info')}</div><dl class="kv mt-3"><dt>${t('Allergies')}</dt><dd class="${R ? '' : 'red'}">${R ? '' : ic('warning', 1) + ' '}${d.allergy}</dd><dt>${t('Regular clinic')}</dt><dd>${d.clinic}</dd></dl></section>`;
  const next = `<section><div class="sec"><h2 class="t1">${t('Next up')}</h2></div><div class="panel"><div class="list tight">${d.next.map(nextRow).join('')}</div></div></section>`;
  const dose = (state, label, when, meta) => `<li class="${state}"><span class="b2">${label}</span><span class="c">${when}${meta ? `<br>${meta}` : ''}</span></li>`;
  const vax = R
    ? `<div class="card"><div class="row between"><h3 class="t2">DHPPi + Lepto</h3>${tag(t('Overdue'), 'red', 'warning')}</div><ol class="doses mt-3">${dose('done', t('Dose 1'), t('Given') + ' 12 Aug 2026', 'Vaxipet (sample), Golconda Gate Pet Clinic')}${dose('done', t('Dose 2'), t('Given') + ' 4 Sept 2026', 'Vaxipet (sample), Golconda Gate Pet Clinic')}${dose('late', t('Dose 3'), t('Was due') + ' 6 Nov 2026')}</ol><div class="row mt-3">${btn(t('Book'), 'primary sm', 'calendar-plus')}${btn(t('Record'), 'soft sm', 'plus')}</div></div>
       <div class="card"><div class="row between"><h3 class="t2">${t('Anti-rabies')}</h3>${tag(t('Due soon'), 'gold', 'clock')}</div><ol class="doses mt-3">${dose('due', t('Dose 1'), t('Due') + ' 14 Nov 2026')}</ol></div>`
    : `<div class="card"><div class="row between"><h3 class="t2">DHPPi + Lepto</h3>${tag(t('Due soon'), 'gold', 'clock')}</div><ol class="doses mt-3">${dose('done', 'Dose 1', 'Given 23 Oct 2023', 'Vaxipet (sample), Gulmohar Vet Studio')}${dose('done', 'Dose 2', 'Given 15 Nov 2023')}${dose('done', 'Dose 3', 'Given 8 Dec 2023')}${dose('done', 'Booster', 'Given 20 Nov 2025')}${dose('due', 'Booster', 'Due 18 Nov 2026')}</ol><div class="row mt-3">${btn('Book', 'primary sm', 'calendar-plus')}${btn('Record', 'soft sm', 'plus')}</div></div>
       <div class="card"><div class="row between"><h3 class="t2">Anti-rabies</h3>${tag('Due soon', 'gold', 'clock')}</div><ol class="doses mt-3">${dose('done', 'Dose 1', 'Given 15 Dec 2023', 'Rabivet (sample), Gulmohar Vet Studio')}${dose('done', 'Booster', 'Given 18 Nov 2025')}${dose('due', 'Booster', 'Due 18 Nov 2026')}</ol></div>`;
  const vaccines = `<section><div class="sec"><h2 class="t1">${t('Vaccinations')}</h2><a class="link">${t('Record')}</a></div><div class="stack">${vax}</div><p class="c mt-3">${t('Indicative schedule. Always confirm with your vet.')}</p></section>`;
  const weight = `<section><div class="sec"><h2 class="t1">${t('Weight')}</h2><a class="link">${t('Add')}</a></div><div class="card"><div class="row between"><div><span class="num" style="font-size:1.75rem">${d.kg}</span> <span class="c green" style="font-weight:600">${t('in the healthy range')}</span></div></div><div class="mt-2">${R ? lineChart([3.2, 4.6, 6.1, 7.4, 8.5], { min: 0, max: 14, band: [6, 11], grid: [4, 8, 12], xl: ['Jul', 'Aug', 'Sept', 'Oct', 'Nov'] }) : lineChart([28, 28.4, 28.2, 28.7, 29, 28.9], { min: 22, max: 40, band: [25, 36], grid: [25, 30, 35, 40], xl: ['10 Aug', '15 Sept', '21 Oct', '8 Nov'] })}</div><p class="c mt-2">${t('Green band: indicative healthy range. Always confirm with your vet.')}</p></div></section>`;
  const more = `<section><div class="sec"><h2 class="t1">${t('Records')}</h2></div><div class="panel" style="padding:.375rem 1rem"><div class="list">
      ${item(tile('pill', 'sky'), t('Medicines'), R ? t('None right now') : 'None right now. Reminders: Given, Skip, Snooze')}
      ${item(tile('bug', 'gold'), t('Deworming and flea, tick'), R ? t('Deworming due 20 Nov') : 'Dewormed 7 Nov by Rohan. Tick drops due 13 Nov')}
      ${item(tile('stethoscope', 'green'), t('Vet visits'), R ? '2' : '18 Oct, Gulmohar Vet Studio: limping, front left leg')}
      ${item(tile('notepad', 'red'), t('Symptom diary'), R ? t('Nothing logged') : '8 Nov: vomited twice, mild. Shared with Dr. Sameer')}
      ${item(tile('bell-ringing'), t('Reminders'), R ? t('Licence renewal') : 'Nail trim 22 Nov, insurance renewal 3 Jan')}
      </div></div></section>`;
  return shell({ nav: 'health', body: `<div class="bento"><div class="s5 stack-lg">${head}${emergency}${next}${weight}</div><div class="s7 stack-lg">${vaccines}${more}</div></div>` });
};

SCREENS.book = () => {
  const d = DATA();
  const big = (icon, cls, title, sub, meta) => `<a class="card svc big"><span class="tile ${cls}" style="--w:3.25rem">${ic(icon)}</span><div class="t2 mt-3">${t(title)}</div><div class="c">${t(sub)}</div><div class="m mt-2 ${cls === 'gold' ? 'gold' : 'green'} row gap-1">${ic('circle', 1)}<span>${t(meta)}</span></div></a>`;
  const small = (icon, title, sub) => `<a class="svc sm"><span class="tile" style="--w:2.75rem">${ic(icon)}</span><div class="grow"><div class="b2">${t(title)}</div><div class="c only-desk">${t(sub)}</div></div></a>`;
  const services = `<div class="grid g2 svc-grid">${big('first-aid', 'gold', 'Vet clinic', 'Check-ups, vaccines, surgery', 'Next slot today, 2:35 pm')}${big('video-camera', 'green', 'Tele-vet', 'Chat or video with a vet', '4 vets online now')}</div>
    <div class="grid g2 stack-easy mt-3">${small('scissors', 'Grooming', 'Salon or home visit')}${small('graduation-cap', 'Training', 'Puppy basics to behaviour')}${small('house-line', 'Boarding', 'Boarding and pet sitting')}${small('person-simple-walk', 'Dog walking', 'Live route and photos')}</div>`;
  const mapCard = `<a class="card pad-0 mapcard"><div class="photo" style="border-radius:0;height:8.5rem">${map({ h: 136 })}</div><div class="row" style="padding:.875rem 1rem"><div class="grow"><div class="b2">${t('Clinics on the map')}</div><div class="c">${t('See open clinics and 24x7 emergency care around you.')}</div></div>${chev()}</div></a>`;
  const ticket = `<div class="ticket"><div class="row start">${leafdate(t('Nov'), '11', 'gold')}<div class="grow"><div class="b2">${USER.first === 'Ravi' ? 'Golconda Gate Pet Clinic' : 'Gulmohar Vet Studio'}</div><div class="c">${t('Vaccination')}, ${USER.first === 'Ravi' ? 'Simba' : 'Misty'}</div><div class="c">${t('Wed')} 11:00 AM, ${t('in 3 days')}</div><div class="mt-2">${tag(t('Confirmed'), 'green', 'check-circle')}</div></div></div><hr class="rule dash" style="margin:.875rem 0"><div class="row wrap gap-2">${btn(t('Directions'), 'soft sm', 'navigation-arrow')}${btn(t('Reschedule'), 'soft sm', 'calendar-dots')}</div></div>`;
  return shell({ nav: 'book', body: `<h1 class="d1">${t('Book care')}</h1><p class="c mt-1">${t('Vets, groomers, trainers, boarding and walkers near')} ${d.city.split(',')[0]}.</p>
    <div class="bento mt-5"><div class="s7">${services}</div><div class="s5 stack-lg"><section><div class="sec"><h2 class="t1">${t('My bookings')}</h2><a class="link">${t('See all')}</a></div>${ticket}</section>${mapCard}</div></div>` });
};

const productCard = (k, o = {}) => { const p = PRODUCTS[k]; return `<a class="product"><div class="photo" style="aspect-ratio:1.08">${packOf(k)}${o.badge ? `<span class="over">${tag(o.badge, 'ink')}</span>` : ''}</div><div class="m dim mt-2">${p.brand}</div><div class="b2 clamp2" style="font-size:.875rem;line-height:1.3;min-height:2.275rem">${p.name}</div><div class="row gap-2 mt-1" style="align-items:baseline"><span class="price">₹${p.price}</span><span class="strike">₹${p.mrp}</span><span class="m green">${p.off} off</span></div><div class="row gap-2 c mt-1">${stars(p.rating)}<span>(${p.n})</span><span class="grow"></span><span class="only-desk">${ic('truck')} 10 Nov</span></div></a>`; };

SCREENS.shop = () => {
  const d = DATA(), n = d.n;
  const cats = [['bowl-food', 'Food'], ['bone', 'Treats'], ['tennis-ball', 'Toys'], ['scissors', 'Grooming'], ['first-aid-kit', 'Health'], ['couch', 'Beds'], ['dog', 'Collars'], ['bowl-steam', 'Bowls'], ['cat', 'Litter'], ['bird', 'Birds'], ['rabbit', 'Rabbits'], ['t-shirt', 'Clothing'], ['suitcase-rolling', 'Travel']];
  const again = (k) => { const p = PRODUCTS[k]; return `<div class="card again"><span class="tile" style="--w:4rem">${packOf(k)}</span><div class="grow"><div class="b2 clamp2" style="font-size:.875rem">${p.short}</div><div class="c">₹${p.price}</div></div><button class="round primary" aria-label="Reorder">${ic('arrow-clockwise')}</button></div>`; };
  return shell({ nav: 'shop', body: `<div class="row"><h1 class="d1 grow">${t('Shop')}</h1><button class="icon-btn tonal" aria-label="My orders">${ic('receipt')}<span class="badge">1</span></button><button class="icon-btn tonal" aria-label="Cart">${ic('shopping-cart-simple')}</button></div>
    <div class="field mt-4">${ic('magnifying-glass')}<span>${t('Search food, toys, beds…')}</span></div>
    <div class="row gap-2 mt-3 c">${ic('map-pin')}<span>${t('Delivering to')} <b style="color:var(--ink)">${USER.first === 'Ravi' ? 'Banjara Hills 500034' : 'Indiranagar 560038'}</b></span></div>
    <div class="hscroll cats mt-4">${cats.map(([i, l], x) => `<a class="cat"><span class="tile ${x === 0 ? 'marigold' : ''}" style="--w:3.5rem">${ic(i)}</span><span class="m">${t(l)}</span></a>`).join('')}</div>
    <section class="mt-6"><div class="sec"><h2 class="t1">${t('Buy again')}</h2><a class="link">${t('My orders')}</a></div><div class="hscroll">${again('lamb')}${again('chews')}${again('catfood')}</div></section>
    <section class="mt-6"><div class="sec" style="margin-bottom:.25rem"><h2 class="t1">${tn('For {n}', n)}</h2><a class="link">${t('See all')}</a></div><p class="c">${USER.first === 'Ravi' ? t('Indie puppy, 5 months. Small bites, puppy food.') : 'Labrador Retriever, adult. Avoiding chicken.'}</p>
      <div class="grid g2 dg6 mt-3" style="gap:1rem .75rem">${productCard('lamb', { badge: t('Running low') })}${productCard('joint')}${productCard('bites')}${productCard('bed')}${productCard('harness')}${productCard('rope')}</div></section>
    <a class="wash row mt-6">${tile('video-camera', 'marigold')}<div class="grow"><div class="b2">${tn('Not sure what suits {n}?', n)}</div><div class="c" style="color:var(--marigold-ink)">${t('Ask a vet')}</div></div>${chev()}</a>
    <section class="mt-6"><div class="sec" style="margin-bottom:.25rem"><h2 class="t1">${t('From partner stores')}</h2></div><p class="c">${t('These open the partner’s website. You pay there.')}</p><div class="grid dg2 mt-3"><div class="panel row"><span class="tile sky" style="--w:3.25rem">${pack('bottle', '#1F7FA8', '#DDECF5')}</span><div class="grow"><div class="b2">Travel water bottle 500 ml</div><div class="c">₹449, ${t('you will buy on')} TripTails</div></div>${ic('arrow-square-out')}</div><div class="panel row"><span class="tile" style="--w:3.25rem">${pack('bed', '#2C6A43', '#DDEDDD')}</span><div class="grow"><div class="b2">Monsoon raincoat (L)</div><div class="c">₹799, ${t('you will buy on')} MonsoonMutt</div></div>${ic('arrow-square-out')}</div></div></section>` });
};

SCREENS.me = () => {
  const R = USER.first === 'Ravi';
  const live = (icon, cls, title, status) => `<a class="card live"><span class="tile ${cls}" style="--w:2.75rem">${ic(icon)}</span><div class="b2 mt-3">${t(title)}</div><div class="c">${status}</div></a>`;
  const li = (icon, title, sub, trail) => item(tile(icon), t(title), sub, (trail || '') + chev());
  return shell({ nav: 'me', body: `<div class="bento"><div class="s5 stack-lg">
    <section class="card profile"><div class="row">${person(USER.initials, '4rem', 'ink')}<div class="grow"><h1 class="d2">${USER.name}</h1><div class="c">${R ? 'Hyderabad' : 'Bengaluru'}, ${R ? 'ravi' : 'priya'}@example.com</div></div>${R ? tag('Free') : tag('Plus', 'plus', 'crown-simple')}</div>
      <hr class="rule" style="margin:1rem 0 .875rem"><div class="row between"><span class="b2">${t('My pets')}</span><a class="link">${t('Manage')}</a></div>
      <div class="row gap-4 mt-3">${USER.pets.map((k) => `<a class="col" style="align-items:center;gap:.375rem">${arch(k, '3.75rem', { ring: 1 })}<span class="m">${PETS[k].name}</span></a>`).join('')}<a class="col" style="align-items:center;gap:.375rem"><span class="arch" style="--w:3.75rem;background:none;border:1.5px dashed var(--line-2);display:grid;place-items:center;font-size:1.25rem">${ic('plus')}</span><span class="m dim">${t('Add pet')}</span></a></div></section>
    <section><div class="sec"><h2 class="t1">${t('Pets and family')}</h2></div><div class="grid g2">
      ${live('lock-key', 'gold', 'Document vault', R ? t('4 documents') : '7 documents, 1 expires soon')}${live('images', 'sky', 'Memory album', R ? t('18 photos') : '124 photos, 6 videos')}
      ${live('qr-code', 'green', 'Lost pet mode and QR tag', t('Tags ready. No pet is lost.'))}${live('watch', '', 'Connected devices', R ? t('None yet') : "Bruno's collar, 82%")}</div>
      <div class="panel mt-3" style="padding:.25rem 1rem">${li('users-three', 'Family and sharing', R ? t('Only you') : 'Rohan can care for Bruno and Misty')}</div></section></div>
    <div class="s7 stack-lg"><section><div class="sec"><h2 class="t1">${t('Orders and money')}</h2></div><div class="panel" style="padding:.375rem 1rem"><div class="list">
      ${li('receipt', 'My orders', R ? '' : 'No-pull Harness is on the way', R ? '' : tag('1', 'gold'))}${li('wallet', 'Expenses', R ? '' : '₹6,240 this month')}${li('map-pin', 'Saved addresses', R ? 'Banjara Hills 500034' : 'Home, Indiranagar 560038')}${li('crown-simple', 'PawSetu Plus', R ? t('Try 7 days free') : 'Renews on 1 Dec 2026')}${li('gift', 'Refer a friend', t('You both get ₹100'))}</div></div></section>
    <section><div class="sec"><h2 class="t1">${t('App and support')}</h2></div><div class="panel" style="padding:.375rem 1rem"><div class="list">
      ${li('gear-six', 'Settings', t('Language, appearance, Easy mode'))}${li('headset', 'Help and complaints', '')}${li('shield-check', 'Privacy centre', t('Your data and consents'))}</div></div>
      <button class="btn line block mt-4">${ic('sign-out')}${t('Sign out')}</button></section></div></div>` });
};
