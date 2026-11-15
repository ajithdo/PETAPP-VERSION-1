/* Safety and vet help: SOS, first aid, tele-vet, Ask PawSetu, messages, notifications */
const clinicCall = (v, name, where, tagHtml, phone) => `<div class="item"><span class="tile only-desk" style="--w:3rem">${place(v, { x24: v === 1 })}</span><div class="grow"><div class="b2">${name}</div><div class="c">${tagHtml} ${where}</div></div><button class="round line" aria-label="Map">${ic('navigation-arrow')}</button><button class="btn ink sm">${ic('phone', 1)}Call</button></div>`;

SCREENS.sos = () => shell({ kind: 'focus', page: 'mid', body: `
  <div class="row" style="padding-top:.25rem"><button class="icon-btn tonal" aria-label="Close">${ic('x')}</button><h1 class="d2 grow">Emergency help</h1></div>
  <div class="row mt-4 c">${ic('map-pin-simple-slash')}<span class="grow">Location is off. Showing clinics near <b style="color:var(--ink)">Indiranagar, Bengaluru</b>.</span><a class="link">Change area</a></div>
  <div class="bento mt-4"><div class="s7 stack">
    <section class="sos-card"><div class="row"><span class="round" style="background:#fff;color:var(--sos);width:3.5rem;height:3.5rem;font-size:1.75rem">${ic('phone-call', 1)}</span><div class="grow"><h2 class="d2">Call nearest clinic</h2><div style="opacity:.92">Gulmohar Vet Studio, 394 m, open now</div></div></div>
      <button class="btn block lg mt-4" style="background:#fff;color:var(--sos-ink)">${ic('phone', 1)}Call +91 90000 00024</button></section>
    <section class="panel" style="padding:.375rem 1rem"><div class="list">
      ${clinicCall(1, 'Namma Pet Hospital', 'Koramangala, 6.4 km', tag('24x7', 'green'), '')}
      ${clinicCall(2, 'Whitefield Wag Clinic', 'Whitefield, 10.9 km', tag('Open now', 'green'), '')}</div></section>
    ${note('Demo: this would call +91 90000 00024. No real call is made.', 'flask', 'gold')}</div>
  <div class="s5 stack">
    <section class="card pad-0"><div style="padding:1rem 1rem .75rem"><div class="row"><span class="round ink" style="width:3.5rem;height:3.5rem;font-size:1.625rem">${ic('navigation-arrow', 1)}</span><div class="grow"><h2 class="t1">Get nearest clinic address</h2><div class="c">60, Main Road, Indiranagar, Bengaluru 560038</div></div></div></div>
      <div class="photo" style="border-radius:0;height:7.5rem">${map({ h: 120, pins: [[196, 62, 1]] })}</div>
      <div class="row gap-2" style="padding:.75rem 1rem 1rem">${btn('Open in Maps', 'ink', 'arrow-square-out', 'grow')}<button class="round soft" aria-label="Copy address">${ic('copy')}</button><button class="round soft" aria-label="Share address">${ic('share-network')}</button></div></section>
    <section class="dark" style="border-radius:var(--r-lg)"><div class="b2">Show this to the vet</div><div class="row gap-2 mt-3"><span class="pet-chip on" style="background:var(--marigold);color:#2B1A12;border-color:var(--marigold)">${arch('bruno', '1.75rem')}Bruno</span><span class="pet-chip" style="border-color:var(--espresso-line)">${arch('misty', '1.75rem')}Misty</span></div><div class="c mt-3">Labrador Retriever, 3 yrs 2 mo, 29 kg</div>
      <dl class="kv mt-3"><dt>Allergies</dt><dd style="color:#FFB4A8">Chicken</dd><dt>Medicines</dt><dd>None</dd><dt>Rabies vaccine</dt><dd>Given 18 Nov 2025</dd></dl>
      <div class="row mt-3">${btn('Open medical card', 'cream sm', 'identification-card')}</div></section>
    <a class="panel row">${tile('first-aid-kit', 'red')}<div class="grow"><div class="b2">First-aid guides</div><div class="c">Choking, poisoning, heatstroke and more. Work without internet.</div></div>${chev()}</a>
  </div></div>` });

SCREENS['first-aid'] = () => {
  const g = [['wind', 'Choking', 'Pawing at the mouth, gagging, blue gums'], ['flask', 'Poisoning', 'Vomiting, drooling, shaking, wobbly walking'], ['thermometer-hot', 'Heatstroke', 'Heavy panting, thick drool, bright red gums'], ['drop', 'Bleeding', 'Blood from a wound, paw, ear or nose'], ['bone', 'Broken bones', 'Not putting weight on a leg, swelling'], ['lightning', 'Fits (seizures)', 'Falling over, paddling legs, not responding'], ['fire', 'Burns', 'Red or blistered skin, singed fur'], ['bug-beetle', 'Snake or insect bite', 'Sudden swelling, pain, two small puncture marks'], ['bug', 'Tick removal', 'A small grey or brown lump stuck to the skin']];
  return shell({ kind: 'sub', nav: '', title: 'First aid', sos: 1, page: 'mid', body: `
    ${note('<b>Not breathing, collapsed or bleeding heavily?</b> Hold SOS now and go to a clinic. These guides help on the way.', 'asterisk', 'red')}
    <div class="row wrap gap-2 mt-3">${tag('Works without internet', 'green', 'cloud-check')}${tag('Draft, to be reviewed by a vet', 'gold', 'pencil-simple-line')}</div>
    <a class="wash mt-5" style="display:block"><div class="row">${tile('magnifying-glass', 'marigold', '3rem')}<div class="grow"><h2 class="t2">Is it safe?</h2><div class="c" style="color:var(--marigold-ink)">Check a food or plant before your pet eats it.</div></div></div>
      <div class="row wrap gap-2 mt-3">${['Chocolate', 'Grapes', 'Onion', 'Xylitol', 'Lilies'].map((x) => `<span class="chip" style="background:var(--surface);border-color:transparent;height:2.125rem">${x}</span>`).join('')}</div></a>
    <section class="mt-6">${sec('Guides')}<div class="grid g2 dg3">${g.map(([i, tt, s]) => `<a class="card guide"><span class="tile red" style="--w:2.75rem">${ic(i)}</span><div class="b2 mt-3">${tt}</div><div class="c clamp2">${s}</div></a>`).join('')}</div></section>` });
};

const consult = (state, when, text, extra = '') => `<a class="card row start">${arch('bruno', '2.75rem')}<div class="grow"><div class="row gap-2 wrap"><span class="b2">Bruno with Dr. Sameer Khan</span>${tag(state, state === 'Open' ? 'green' : '')}</div><div class="c">${when}</div><div class="b1 clamp2 mt-1">${text}</div>${extra}</div></a>`;
SCREENS.televet = () => shell({ kind: 'sub', nav: 'book', title: 'Tele-vet', sos: 1, page: 'mid', body: `
  <section class="dark"><div class="row start"><div class="grow"><h2 class="d2">Talk to a vet</h2><p class="mt-2" style="color:var(--on-dark-2)">Chat or video with a registered vet, usually within minutes.</p></div><span class="tile marigold" style="--w:3.25rem">${ic('video-camera', 1)}</span></div>
    <div class="row mt-4 gap-2"><span class="faces">${person('SK', '2rem', 'gold')}${person('AN', '2rem')}${person('FR', '2rem', 'gold')}</span><span class="c">4 vets online. First reply in about 3 min.</span></div>
    <div class="grid g2 mt-4">${btn('Chat now', 'primary', 'chat-circle-dots', 'block')}${btn('Book video', 'ghost-dark', 'calendar-plus', 'block')}</div></section>
  <section class="mt-5"><div class="row between"><h2 class="t1">Your Plus plan</h2>${tag('Plus', 'plus', 'crown-simple')}</div>
    <div class="grid g2 dg4 mt-3">${[['infinity', 'Unlimited', 'consultations'], ['chat-text', '100 messages', '300 words each'], ['clock', '72 hours', 'chat stays open'], ['video-camera', 'Video calls', 'with 10% off']].map(([i, a, b]) => `<div class="panel allow">${ic(i)}<div class="b2 mt-2">${a}</div><div class="c">${b}</div></div>`).join('')}</div></section>
  <section class="mt-6">${sec('Open consultations')}${consult('Open', '8 Nov 2026, 1:10 PM. Chat', 'Bruno vomited twice this morning after eating grass in the park. He is drinking water and wants to play.', `<div class="row mt-3">${btn('Open chat', 'ink sm', 'chat-circle-dots')}<span class="c">88 messages left</span></div>`)}</section>
  <a class="panel row mt-4">${tile('sparkle', 'ink')}<div class="grow"><div class="b2">Ask PawSetu</div><div class="c">Everyday questions answered instantly. Unlimited with Plus.</div></div>${chev()}</a>
  <section class="mt-6">${sec('Past consultations')}${consult('Ended', '27 Oct 2026, 10:50 AM. Chat', 'Bruno is limping on his front left leg since running on the beach yesterday.', `<div class="row mt-3 gap-2">${btn('Prescription', 'soft sm', 'file-text')}${btn('Rate', 'soft sm', 'star')}</div>`)}</section>
  <div class="mt-5">${note('<b>Emergency?</b> Do not wait for a chat. Hold SOS and go to the nearest clinic.', 'asterisk', 'red')}</div>` });

SCREENS.ask = () => shell({ kind: 'sub', nav: '', title: 'Ask PawSetu', actions: tag('Unlimited with Plus', 'plus', 'infinity'), page: 'narrow', body: `
  <div class="col gap-4">
  <div class="row gap-2 c center" style="justify-content:center">${ic('sparkle')}Care answers for Bruno. Not a diagnosis.</div>
  <div class="bubble me">Can Bruno eat mango?<div class="m" style="opacity:.7;text-align:right;margin-top:.25rem">8:51 AM</div></div>
  <div class="bubble"><div class="row gap-2 m dim">${ic('sparkle', 1)}Ask PawSetu ${tag('Demo', 'gold')}</div><p class="mt-2">Yes, a few small pieces of ripe mango are fine as a treat. Remove the skin and the stone first, because the stone can choke or block the gut.</p></div>
  <div class="bubble me">How do I prevent ticks in the monsoon?<div class="m" style="opacity:.7;text-align:right;margin-top:.25rem">8:54 AM</div></div>
  <div class="bubble"><div class="row gap-2 m dim">${ic('sparkle', 1)}Ask PawSetu ${tag('Demo', 'gold')}</div><p class="mt-2">Use a vet-recommended tick and flea preventive all year: a spot-on, a chewable tablet or a collar. Ticks are common in India, especially in the monsoon.</p><p class="mt-2">Check ears, between the toes and under the collar after walks. Keep bedding clean and dry. Never use dog products on cats.</p><p class="mt-2">If your pet is weak, has pale gums or a fever after tick bites, see a vet quickly.</p>
    <div class="note mt-3">${ic('info')}<span>Not a diagnosis. If your pet seems unwell, talk to a vet.</span></div><div class="row mt-3 gap-2">${btn('Ask a vet', 'primary sm', 'video-camera')}${btn('Set tick reminder', 'soft sm', 'bell')}</div></div>
  <div class="bubble me">He is breathing fast and his belly looks swollen<div class="m" style="opacity:.7;text-align:right;margin-top:.25rem">8:58 AM</div></div>
  <div class="bubble" style="background:var(--sos-wash);box-shadow:none"><div class="row gap-2 b2 red">${ic('warning', 1)}This can be an emergency</div><p class="mt-2">Fast breathing with a swollen belly needs a vet right now. Do not wait and do not give food or water.</p><div class="row mt-3 gap-2">${btn('SOS', 'sos sm', 'asterisk')}${btn('Talk to a vet now', 'ink sm', 'video-camera')}</div></div>
  </div>
  <div class="hscroll mt-5">${['How much should I feed my pet?', 'Which human foods are unsafe?', 'How often should I deworm?'].map((x) => chip(x)).join('')}</div>
  <div class="row mt-3"><div class="field grow"><span>Type your question</span></div><button class="round primary" style="width:3.25rem;height:3.25rem" aria-label="Send">${ic('paper-plane-right', 1)}</button></div>` });

const thread = (lead, name, when, tagHtml, text, on, unread) => `<a class="item thread${on ? ' on' : ''}">${lead}<div class="grow"><div class="row between gap-2"><span class="b2 clamp1">${name}</span><span class="m ${unread ? 'gold' : 'dim'}">${when}</span></div><div class="row gap-2">${tagHtml}<span class="c clamp1 grow">${text}</span>${unread ? `<span class="badge" style="position:static;border:0;background:var(--marigold);color:#2B1A12">${unread}</span>` : ''}</div></div></a>`;
SCREENS.messages = () => shell({ kind: 'sub', nav: '', title: 'Messages', page: '', body: `
  <div class="chat-split"><div class="chat-list">
    <div class="field">${ic('magnifying-glass')}<span>Search chats and messages</span></div>
    <div class="row gap-2 mt-3">${chip('All', 1)}${chip('Unread')}${chip('Tele-vet')}</div>
    <a class="wash row mt-4" style="padding:.75rem">${tile('sparkle', 'marigold')}<div class="grow"><div class="b2">Ask PawSetu</div><div class="c" style="color:var(--marigold-ink)">Everyday questions answered instantly.</div></div>${chev()}</a>
    <div class="list mt-2">
      ${thread(person('SK', '2.75rem', 'gold'), 'Dr. Sameer Khan', '1:22 PM', tag('Tele-vet', 'green'), 'How is Bruno eating today?', 1, 2)}
      ${thread(`<span class="tile" style="--w:2.75rem">${place(0)}</span>`, 'Gulmohar Vet Studio', 'Sat', '', 'Got it, thank you! See you at the appointment.')}
      ${thread(`<span class="tile" style="--w:2.75rem">${place(3, { sign: 'scissors' })}</span>`, 'Bubble Paws Salon', '2 Nov', tag('Enquiry'), 'Yes! We do a gentle cat groom for Persians.')}
      ${thread(person('SK', '2.75rem', 'gold'), 'Dr. Sameer Khan', '27 Oct', tag('Ended'), 'You: Thank you, doctor!')}
    </div>
    <button class="btn primary fab only-phone">${ic('video-camera')}Ask a vet</button></div>
  <div class="chat-pane only-desk"><div class="row" style="padding:0 0 .875rem;border-bottom:1px solid var(--line)">${person('SK', '2.75rem', 'gold')}<div class="grow"><div class="b2">Dr. Sameer Khan</div><div class="c">Tele-vet for Bruno. 88 messages left, open for 71 hours</div></div><button class="icon-btn tonal" aria-label="Call">${ic('phone')}</button><button class="icon-btn tonal" aria-label="More">${ic('dots-three-vertical')}</button></div>
    <div class="col gap-3" style="padding:1rem 0">
      <div class="bubble me">Bruno vomited twice this morning after eating grass in the park. He is drinking water and wants to play.<div class="m" style="opacity:.7;text-align:right;margin-top:.25rem">1:10 PM ${ic('checks')}</div></div>
      <div class="bubble me" style="padding:.375rem"><div class="photo" style="width:11rem;height:8rem">${snap('bruno', 'park')}</div></div>
      <div class="bubble">Thanks, Priya. Was there any blood, and what did he eat for breakfast?<div class="m dim" style="margin-top:.25rem">1:16 PM</div></div>
      <div class="bubble me"><div class="row gap-2">${ic('play', 1)}<svg viewBox="0 0 120 20" style="width:8rem;height:1.25rem">${Array.from({ length: 30 }, (_, i) => `<rect x="${i * 4}" y="${10 - (3 + ((i * 7) % 8))}" width="2.200" height="${2 * (3 + ((i * 7) % 8))}" rx="1" fill="currentColor" opacity="${i < 11 ? 1 : 0.45}"/>`).join('')}</svg><span class="m">0:14</span></div></div>
      <div class="bubble me">Breakfast at 8. Nothing unusual, no blood.<div class="m" style="opacity:.7;text-align:right;margin-top:.25rem">1:21 PM ${ic('checks')}</div></div>
      <div class="bubble">How is Bruno eating today?<div class="m dim" style="margin-top:.25rem">1:22 PM</div></div>
      <div class="row gap-2 c">${ic('dots-three')}Dr. Sameer is typing</div></div>
    ${note('Pay only inside PawSetu. Phone numbers stay hidden in chats.', 'shield-check')}
    <div class="row mt-3"><button class="round soft" aria-label="Attach">${ic('paperclip')}</button><div class="field grow"><span>Message Dr. Sameer</span></div><button class="round soft" aria-label="Voice note">${ic('microphone')}</button><button class="round primary" aria-label="Send">${ic('paper-plane-right', 1)}</button></div></div></div>` });

const notif = (icon, cls, title, when, action, unread) => `<div class="item">${tile(icon, cls)}<div class="grow"><div class="${unread ? 'b2' : 'b1'}">${title}</div><div class="c">${when}</div>${action ? `<div class="mt-2">${action}</div>` : ''}</div>${unread ? '<span class="dot gold" style="color:var(--marigold)"></span>' : ''}</div>`;
SCREENS.notifications = () => shell({ kind: 'sub', nav: '', title: 'Notifications', actions: `<a class="link">Mark all read</a><button class="icon-btn" aria-label="Notification settings">${ic('sliders-horizontal')}</button>`, page: 'narrow', body: `
  <div class="hscroll">${chip('All', 1)}${chip('Unread')}${chip('Health')}${chip('Bookings')}${chip('Orders')}${chip('Family')}</div>
  <section class="mt-5">${sec('Today', '', 't2')}<div class="list">
    ${notif('bug', 'gold', "Bruno's flea and tick prevention is due soon", '10:52 AM', btn('Mark given', 'line sm') + ' ' + btn('Snooze', 'soft sm'), 1)}
    ${notif('truck', 'sky', 'No-pull Harness (M/L) is on the way', '10:52 AM', btn('Track order', 'soft sm', 'map-trifold'), 1)}</div></section>
  <section class="mt-5">${sec('Yesterday', '', 't2')}<div class="list">
    ${notif('pill', 'green', 'Rohan gave Bruno his deworming tablet', '7 Nov, 5:52 PM')}
    ${notif('calendar-check', '', "Misty's vaccination is confirmed for Wed 11 Nov, 11:00 AM", '7 Nov, 9:15 AM')}</div></section>
  <section class="mt-5">${sec('Earlier', '', 't2')}<div class="list">
    ${notif('file-text', '', 'Dr. Sameer Khan sent a prescription for Bruno', '27 Oct, 11:27 AM', btn('View prescription', 'soft sm'))}
    ${notif('gift', 'gold', 'Your friend joined. You both got ₹100 off', '21 Oct, 4:02 PM')}</div></section>` });
