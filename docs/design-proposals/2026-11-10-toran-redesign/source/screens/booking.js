/* Booking: clinic finder, clinic page, booking details, my bookings */
const CLINICS = [
  { v: 0, name: 'Gulmohar Vet Studio', area: 'Indiranagar', dist: '394 m', r: '4.8', n: 28, slot: 'Mon 9 Nov, 9:00 AM', fee: '750', st: ['Open now', 'green'] },
  { v: 1, name: 'Namma Pet Hospital', area: 'Koramangala', dist: '6.4 km', r: '4.5', n: 22, slot: 'Today, 2:35 PM', fee: '900', st: ['24x7', 'green'] },
  { v: 2, name: 'Whitefield Wag Clinic', area: 'Whitefield', dist: '10.9 km', r: '4.1', n: 12, slot: 'Mon 9 Nov, 9:00 AM', fee: '500', st: ['Open now', 'green'] },
];
const clinicCard = (c) => `<a class="card clinic"><div class="row start"><span class="tile" style="--w:4.5rem">${place(c.v, { x24: c.v === 1 })}</span><div class="grow"><h3 class="t2">${c.name}</h3><div class="c">${c.area}, ${c.dist}</div><div class="row gap-2 mt-1 wrap">${tag(c.st[0], c.st[1], 'circle')}<span class="c">${stars(c.r)} (${c.n})</span></div></div></div>
  <div class="row between mt-3 clinic-meta"><div><div class="c">Next free slot</div><div class="b2">${c.slot}</div></div><div><div class="c">Consultation</div><div class="b2">₹${c.fee}</div></div>${btn('Book', c.v === 0 ? 'primary sm' : 'line sm')}</div></a>`;

SCREENS['clinic-finder'] = () => shell({ kind: 'sub', nav: 'book', title: 'Find a vet near you', actions: `<button class="icon-btn only-phone" aria-label="Map view">${ic('map-trifold')}</button>`, page: '', body: `
  <div class="finder"><div class="finder-list">
    <div class="field">${ic('magnifying-glass')}<span>Search by name or area</span></div>
    <div class="hscroll mt-3">${chip('Indiranagar, Bengaluru', 0, 'map-pin')}${chip('Use my location', 0, 'crosshair')}</div>
    <div class="hscroll mt-2">${chip('Filters', 0, 'sliders-horizontal')}${chip('Nearest', 0, 'arrows-down-up')}${chip('Open now', 1)}${chip('24x7')}${chip('Rating 4+')}${chip('Birds, rabbits')}</div>
    <div class="row between mt-4"><span class="b2">3 clinics within 25 km</span><span class="seg only-phone"><span class="on">${ic('list')}</span><span>${ic('map-trifold')}</span></span></div>
    <div class="photo only-phone mt-3" style="height:9rem">${map({ h: 144 })}</div>
    <div class="stack mt-3">${CLINICS.map(clinicCard).join('')}</div></div>
  <div class="finder-map only-desk"><div class="photo" style="height:100%;border-radius:var(--r-lg)">${map({ h: 420, pins: [[120, 150, 1], [226, 96, 0], [262, 300, 0]] })}</div></div></div>` });

const svc = (name, mins, mode, price, on) => `<label class="svc-row${on ? ' on' : ''}"><span class="radio${on ? ' on' : ''}"></span><div class="grow"><div class="b2">${name}</div><div class="c">${mins} min, ${mode}</div></div><span class="price" style="font-size:1.0625rem">₹${price}</span></label>`;
SCREENS['clinic-page'] = () => shell({ kind: 'sub', nav: 'book', title: 'Gulmohar Vet Studio', actions: `<button class="icon-btn" aria-label="Share">${ic('share-network')}</button>`, page: '', body: `
  <div class="bento"><div class="s7">
    <section><div class="photo" style="height:11.5rem;border-radius:var(--r-xl)">${place(0)}<span class="over">${tag('Today 10:00 AM to 2:00 PM', 'green', 'clock')}</span></div>
      <h1 class="d1 mt-4 only-phone">Gulmohar Vet Studio</h1><div class="b1 dim mt-1">Vet clinic in Indiranagar, Bengaluru. 394 m away.</div>
      <div class="row wrap gap-2 mt-3">${tag('Open now', 'green', 'circle')}<span class="row gap-1">${stars('4.8')}<span class="c">28 reviews</span></span><span class="c">Tele-vet, dogs, cats</span></div>
      <div class="grid g3 mt-4">${btn('Call', 'soft', 'phone', 'block')}${btn('Directions', 'soft', 'navigation-arrow', 'block')}${btn('Message', 'soft', 'chat-circle-dots', 'block')}</div></section></div>
  <div class="s5 booker-col"><section class="card booker"><div class="row between"><h2 class="t1">Book a visit</h2>${tag('Instant booking', 'green', 'lightning')}</div>
      <div class="b2 mt-4">Which pet?</div><div class="row gap-2 mt-2"><span class="pet-chip on">${arch('bruno', '1.75rem')}Bruno</span><span class="pet-chip">${arch('misty', '1.75rem')}Misty</span></div>
      <div class="b2 mt-4">Which service?</div><div class="col gap-2 mt-2">${svc('Consultation', 20, 'instant booking', '750', 1)}${svc('Vaccination', 30, 'instant booking', '650')}${svc('Lab tests', 30, 'instant booking', '1,200')}${svc('Surgery consult', 120, 'request to book', '6,500')}${svc('Dental cleaning', 30, 'instant booking', '2,200')}${svc('X-ray', 30, 'instant booking', '1,500')}${svc('Home visit', 30, 'instant booking', '1,200')}</div>
      <div class="b2 mt-4">When?</div><div class="hscroll mt-2">${[['Mon', 9, 1], ['Tue', 10], ['Wed', 11], ['Thu', 12], ['Fri', 13], ['Sat', 14]].map(([d, n, on]) => `<span class="day${on ? ' on' : ''}"><small>${d}</small><b>${n}</b></span>`).join('')}</div>
      <div class="row wrap gap-2 mt-3">${['9:00', '9:20', '10:40', '11:00', '5:20', '6:00'].map((x, i) => chip(x + (i < 4 ? ' AM' : ' PM'), i === 0)).join('')}</div>
      <hr class="rule" style="margin:1.125rem 0 .875rem"><div class="row between"><div><div class="c">Consultation for Bruno</div><div class="b2">Mon 9 Nov, 9:00 AM</div></div><div class="price">₹750</div></div>
      <div class="mt-3">${btn('Continue', 'primary lg', 'arrow-right', 'block')}</div><p class="c mt-2" style="text-align:center">Pay online or at the clinic. Free to cancel up to 2 hours before.</p></section></div>
  <div class="s7 stack-lg">
    <section>${sec('Vets here')}<div class="panel" style="padding:.375rem 1rem"><div class="list">
      ${item(person('FR', '3rem', 'gold'), 'Dr. Farhan Reddy', 'BVSc & AH, PG Dip. Small Animal Practice<br>17 years. Reg. no. DEMO-VC-0007', '')}
      ${item(person('AN', '3rem'), 'Dr. Asha Nair', 'BVSc & AH, MVSc Surgery<br>9 years. Reg. no. DEMO-VC-0008', '')}</div></div></section>
    <section>${sec('Reviews', 'See all 28')}<div class="card"><div class="row start gap-5"><div style="text-align:center"><div class="num" style="font-size:2.5rem;line-height:1">4.8</div><div class="stars mt-1">${ic('star', 1).repeat(5)}</div><div class="c">28 verified visits</div></div><div class="grow col gap-1">${[[5, 82], [4, 12], [3, 4], [2, 2], [1, 0]].map(([n, w]) => `<div class="row gap-2 m dim"><span>${n}</span><div class="bar grow"><i style="width:${w}%"></i></div></div>`).join('')}</div></div>
      <hr class="rule" style="margin:1rem 0"><div class="row">${person('LP', '2.25rem')}<div class="grow"><div class="b2">Lakshmi Prasad ${tag('Verified visit', 'green', 'seal-check')}</div><div class="c">Rocky, 2 Nov 2026</div></div></div><p class="mt-2">Dr. Farhan explained everything patiently and Rocky was calm the whole time. No waiting.</p><div class="note mt-3">${ic('arrow-bend-down-right')}<span><b>Reply from the clinic:</b> Thank you, Lakshmi. See you and Rocky at the booster.</span></div></div></section>
    <section>${sec('Where to find us')}<div class="card pad-0"><div class="photo" style="height:8rem;border-radius:0">${map({ h: 128, pins: [[150, 70, 1]], you: false })}</div><div style="padding:.875rem 1rem"><div class="b2">60, Main Road, Indiranagar, Bengaluru 560038</div><div class="c">Mon to Sat 10:00 AM to 2:00 PM, 5:00 PM to 8:30 PM. Closed Sunday.</div></div></div></section></div></div>` });

SCREENS['booking-details'] = () => shell({ kind: 'sub', nav: 'book', title: 'Booking details', page: 'mid', body: `
  <div class="bento"><div class="s7 stack">
  <section class="ticket"><div class="row start"><span class="tile" style="--w:3.5rem">${place(0)}</span><div class="grow"><h1 class="t1">Gulmohar Vet Studio</h1><div class="c">Consultation with Dr. Farhan Reddy</div></div>${tag('Completed', 'green', 'check-circle')}</div>
    <div class="steps mt-4"><span class="done">Booked</span><span class="done">Confirmed</span><span class="done">Visited</span></div>
    <hr class="rule dash" style="margin:1rem 0"><dl class="kv"><dt>When</dt><dd>Sun 18 Oct 2026, 11:00 AM</dd><dt>Pet</dt><dd class="row gap-2">${arch('bruno', '1.5rem')}Bruno</dd><dt>Notes</dt><dd style="font-weight:420">Limping on the front left leg after a run.</dd><dt>Booking ID</dt><dd>PS-BK-204518</dd></dl>
    <hr class="rule dash" style="margin:1rem 0"><dl class="kv"><dt>Consultation</dt><dd>₹750</dd><dt>Platform fee</dt><dd>₹0</dd><dt>Total</dt><dd class="price">₹750</dd><dt>Payment</dt><dd>Paid online</dd></dl></section>
  <div class="grid g2">${btn('Call', 'soft', 'phone', 'block')}${btn('Message', 'soft', 'chat-circle-dots', 'block')}</div></div>
  <div class="s5 stack">
  <section class="wash"><div class="b2">How was the visit?</div><div class="row gap-2 mt-2" style="font-size:2rem;color:var(--marigold-lo)">${ic('star').repeat(5)}</div><p class="c mt-2" style="color:var(--marigold-ink)">Only people who visited can review. The clinic can reply.</p></section>
  <section class="panel" style="padding:.375rem 1rem"><div class="list">${item(tile('arrow-clockwise', 'gold'), 'Book again', 'Same clinic, same service')}${item(tile('file-pdf'), 'Invoice', 'Download the PDF')}${item(tile('file-text'), 'Prescription', 'Saved to Bruno’s health and vault')}${item(tile('headset'), 'Get help with this booking', 'Raise a complaint or ask for a refund')}</div></section></div></div>` });

SCREENS['my-bookings'] = () => shell({ kind: 'sub', nav: 'book', title: 'My bookings', page: 'mid', body: `
  <div class="tabs"><span class="on">Upcoming ${tag('1', 'gold')}</span><span>Requests ${tag('1')}</span><span>Past</span></div>
  <div class="bento mt-5"><div class="s7 stack">
  <div class="ticket"><div class="row start">${leafdate('Nov', '11', 'gold')}<div class="grow"><div class="b2">Gulmohar Vet Studio</div><div class="c">Vaccination for Misty</div><div class="c">Wed 11:00 AM, in 3 days</div><div class="mt-2">${tag('Confirmed', 'green', 'check-circle')}</div></div>${arch('misty', '2.5rem')}</div>
    <hr class="rule dash" style="margin:.875rem 0"><div class="row gap-2 wrap">${btn('Directions', 'soft sm', 'navigation-arrow')}${btn('Reschedule', 'soft sm', 'calendar-dots')}${btn('Add to calendar', 'soft sm', 'calendar-plus')}</div></div>
  <div class="ticket" style="box-shadow:none;border:1px dashed var(--line-2)"><div class="row start">${leafdate('Nov', '15')}<div class="grow"><div class="b2">Bubble Paws Salon</div><div class="c">Full groom for Misty, home visit</div><div class="c">Sun 4:00 PM</div><div class="mt-2">${tag('Waiting for the salon', 'gold', 'hourglass-medium')}</div></div>${arch('misty', '2.5rem')}</div><p class="c mt-3">They reply within 2 hours, or the request cancels itself.</p></div></div>
  <div class="s5"><div class="wash"><div class="b2">Bruno's boosters are due on 18 Nov</div><p class="c mt-1" style="color:var(--marigold-ink)">Book both in one visit at Gulmohar Vet Studio.</p><div class="row mt-3">${btn('Book boosters', 'primary sm', 'calendar-plus')}</div></div></div></div>` });
