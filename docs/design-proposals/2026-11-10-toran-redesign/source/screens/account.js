/* Account: family and sharing, PawSetu Plus, settings */
const member = (i, name, role, cls, you) => `<div class="item">${person(i, '2.5rem', cls)}<div class="grow"><div class="b2">${name}${you ? ' <span class="dim" style="font-weight:420">(you)</span>' : ''}</div><div class="c">${role === 'Owner' ? 'Can do everything' : 'Logs routine, gives medicines, books services'}</div></div>${tag(role, role === 'Owner' ? 'gold' : '')}${you ? '' : `<button class="icon-btn" aria-label="Change access">${ic('dots-three-vertical')}</button>`}</div>`;
const petFamily = (k) => `<section class="card"><div class="row">${arch(k, '3rem', { ring: 1 })}<div class="grow"><h2 class="t2">${PETS[k].name}</h2><div class="c">2 of 8 people</div></div>${btn('Invite', 'primary sm', 'user-plus')}</div><div class="list mt-2">${member('PS', 'Priya Sharma', 'Owner', 'ink', 1)}${member('RS', 'Rohan Sharma', 'Carer', '')}</div></section>`;
SCREENS.family = () => shell({ kind: 'sub', nav: 'me', title: 'Family and sharing', page: '', body: `
  <div class="tabs"><span class="on">People</span><span>Activity</span></div>
  <div class="bento mt-5"><div class="s7 stack">
    <section class="roles">${[['eye', 'Viewer', 'Sees everything and can log routine.'], ['hand-heart', 'Carer', 'Also gives medicines and books services.'], ['users', 'Co-owner', 'Everything except deleting the pet.']].map(([i, r, d]) => `<div>${ic(i)}<div class="b2 mt-1">${r}</div><div class="c">${d}</div></div>`).join('')}</section>
    ${petFamily('bruno')}${petFamily('misty')}
    <section class="panel row">${tile('calendar-x', 'gold')}<div class="grow"><div class="b2">Going away?</div><div class="c">Give a pet sitter or walker Carer access that ends by itself on a date you choose.</div></div>${chev()}</section></div>
  <div class="s5"><section>${sec('Latest activity', 'See all')}<ol class="timeline feed">
      <li><time class="m dim">5:52 PM<br>7 Nov</time>${person('RS', '2.25rem')}<div class="grow"><div class="b1"><b>Rohan</b> gave Bruno his deworming tablet</div></div></li>
      <li><time class="m dim">8:36 AM<br>today</time>${person('PS', '2.25rem', 'ink')}<div class="grow"><div class="b1"><b>You</b> logged Bruno's meal, 220 g</div></div></li>
      <li><time class="m dim">6:50 AM<br>today</time>${person('PS', '2.25rem', 'ink')}<div class="grow"><div class="b1"><b>You</b> walked Bruno for 24 min</div></div></li>
      <li><time class="m dim">7:10 PM<br>6 Nov</time>${person('RS', '2.25rem')}<div class="grow"><div class="b1"><b>Rohan</b> booked Misty's vaccination for 11 Nov</div></div></li></ol></section></div></div>` });

SCREENS.plus = () => {
  const rows = [['paw-print', 'Pets', '3', 'Unlimited'], ['users-three', 'Family members', '2', '8'], ['video-camera', 'Video vet calls', '', 'Yes'], ['chat-circle-dots', 'Tele-vet chats', '1 a month', 'Unlimited'], ['text-align-left', 'Chat length', '20 messages, 60 words each', '100 messages, 300 words each'], ['sparkle', 'Ask PawSetu', '5 a month', 'Unlimited'], ['cloud', 'Photo and document storage', '1 GB', '25 GB'], ['film-strip', 'Video length in album', '1 min', '3 min'], ['tag', 'Off vet video fees', '', '10%'], ['truck', 'Free delivery', 'above ₹999', 'above ₹499'], ['headset', 'Support', 'Standard', 'Priority']];
  return shell({ kind: 'sub', nav: 'me', title: 'PawSetu Plus', page: 'mid', body: `
  <div class="bento"><div class="s5 stack">
    <section class="pluscard"><div class="row between"><span class="row gap-2 b2">${mark()}PawSetu Plus</span>${ic('crown-simple', 1)}</div><h1 class="d1 mt-5">You have Plus</h1><div class="mt-1" style="opacity:.8">Priya Sharma, member since Dec 2025</div><hr class="rule" style="background:rgba(43,26,18,.2);margin:1rem 0 .75rem"><div class="row between"><div><div class="m" style="opacity:.75">Renews on</div><div class="b2">1 Dec 2026</div></div><div style="text-align:right"><div class="m" style="opacity:.75">Yearly plan</div><div class="b2">₹799 a year</div></div></div></section>
    <section class="panel"><div class="row"><div class="grow"><div class="b2">Renew automatically</div><div class="c">Next payment ₹799 on 1 Dec 2026</div></div><span class="switch on"></span></div><hr class="rule" style="margin:.875rem 0"><div class="row between wrap"><span class="seg"><span>₹99 a month</span><span class="on">₹799 a year</span></span><a class="link">Cancel plan</a></div></section>
    ${note('Demo: no money is charged and nothing renews for real.', 'flask', 'gold')}
    <section class="panel row">${tile('gift', 'gold')}<div class="grow"><div class="b2">New here? 7 days free</div><div class="c">Free plan members can try Plus before paying.</div></div></section></div>
  <div class="s7"><section class="card" style="padding:.5rem 1rem 1rem"><table class="table plans"><thead><tr><th>What you get</th><th>Free</th><th class="plus-col">Plus</th></tr></thead><tbody>${rows.map(([i, l, f, p]) => `<tr><td><span class="row gap-2">${ic(i)}<span>${l}</span></span></td><td class="dim">${f || '<span class="dim3">No</span>'}</td><td class="plus-col"><b>${p}</b></td></tr>`).join('')}</tbody></table></section></div></div>` });
};

SCREENS.settings = () => {
  const lang = (glyph, name, sub, on, f) => `<label class="pick${on ? ' on' : ''}"><span class="glyph" style="font-family:${f}">${glyph}</span><div class="b2">${name}</div><div class="c">${sub}</div><span class="radio${on ? ' on' : ''}"></span></label>`;
  const look = (name, a, b, on) => `<label class="pick${on ? ' on' : ''}"><span class="mini" style="background:linear-gradient(135deg,${a} 50%,${b} 50%)"><i></i><i></i></span><div class="b2">${name}</div><span class="radio${on ? ' on' : ''}"></span></label>`;
  return shell({ kind: 'sub', nav: 'me', title: 'Settings', page: 'mid', body: `
  <div class="bento"><div class="s6 stack-lg">
    <section>${sec('Language')}<div class="grid g3">${lang('Aa', 'English', 'English', 1, 'inherit')}${lang('अ', 'हिन्दी', 'Hindi', 0, 'Noto Sans Devanagari')}${lang('అ', 'తెలుగు', 'Telugu', 0, 'Noto Sans Telugu')}</div><p class="c mt-2">Changes the whole app at once, including reminders and PDFs.</p></section>
    <section>${sec('Appearance')}<div class="grid g3">${look('System', '#FBF7F1', '#17100C')}${look('Light', '#FBF7F1', '#FBF7F1', 1)}${look('Dark', '#17100C', '#17100C')}</div></section>
    <section>${sec('Notifications')}<div class="panel" style="padding:.375rem 1rem"><div class="list">${item(tile('bell-ringing', 'gold'), 'Reminder channels', 'Push, email, SMS and WhatsApp for each reminder')}${item(tile('moon', 'sky'), 'Quiet hours', '10:00 PM to 7:00 AM')}</div></div></section></div>
  <div class="s6 stack-lg">
    <section>${sec('Accessibility')}<div class="panel" style="padding:.375rem 1rem"><div class="list">
      <div class="item">${tile('person-arms-spread', 'green')}<div class="grow"><div class="b2">Easy mode</div><div class="c">Bigger text and buttons, a simpler Home and plain words.</div></div><span class="switch"></span></div>
      <div class="item" style="display:block;padding:1rem 0"><div class="row between"><span class="b2">Text size</span><span class="num">100%</span></div><div class="row gap-3 mt-3"><span style="font-size:.8125rem;font-weight:700">A</span><div class="slider grow"><i style="width:25%"></i><b style="left:25%"></b>${[0, 25, 50, 75, 100].map((x) => `<s style="left:${x}%"></s>`).join('')}</div><span style="font-size:1.5rem;font-weight:700;line-height:1">A</span></div><div class="c mt-2">Layouts stay tidy up to 200%.</div></div>
      <div class="item">${tile('circle-half')}<div class="grow"><div class="b2">High contrast</div><div class="c">Stronger text and outlines.</div></div><span class="switch"></span></div>
      <div class="item">${tile('hand-tap')}<div class="grow"><div class="b2">Tap to confirm SOS</div><div class="c">Instead of holding for 2 seconds. On with Easy mode.</div></div><span class="switch"></span></div></div></div></section>
    <section>${sec('Account')}<div class="panel" style="padding:.375rem 1rem"><div class="list">${item(tile('envelope-simple'), 'Email and password', 'priya@example.com')}${item(tile('device-mobile'), 'Phone', '+91 90000 00001')}${item(tile('info'), 'About PawSetu', 'Version 1.0, demo mode')}</div></div></section></div></div>` });
};
