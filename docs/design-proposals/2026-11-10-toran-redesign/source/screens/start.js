/* Welcome, sign-in and the demo account picker */
const langChip = () => `<span class="chip">${ic('translate')}English${ic('caret-down')}</span>`;
const duo = (a, b, w = '2.5rem') => `<span class="duo">${arch(a, w)}${b ? arch(b, w) : ''}</span>`;
const acct = (lead, name, sub, tags = []) => `<a class="card acct">${lead}<div class="grow"><div class="b2">${name}</div><div class="c">${sub}</div>${tags.length ? `<div class="row wrap gap-1 mt-2">${tags.join('')}</div>` : ''}</div>${chev()}</a>`;
const PARENTS = () => [
  acct(duo('bruno', 'misty'), 'Priya Sharma', 'Bengaluru. Bruno the Labrador and Misty the Persian cat', [tag('Plus', 'plus', 'crown-simple')]),
  acct(duo('simba', 'kiwi'), 'Ravi Teja', 'Hyderabad. Simba the Indie puppy and Kiwi the cockatiel', [tag('Free'), tag('తెలుగు', 'sky')]),
  acct(duo('coco', 'tiger'), 'Anjali Verma', 'Delhi NCR. Coco the rabbit and Tiger the senior cat', [tag('Free'), tag('हिन्दी', 'sky'), tag('Easy mode', 'green')]),
  acct(duo('max', 'luna'), 'Arjun Mehta', 'Mumbai. Max the German Shepherd and Luna the Beagle puppy', [tag('Plus', 'plus', 'crown-simple')]),
];
const FAMILY = () => [
  acct(person('RS', '2.75rem'), 'Rohan Sharma', "Priya's husband. Carer for Bruno and Misty"),
  acct(person('MP', '2.75rem'), 'Meera Pillai', 'Pet sitter for Arjun. Access ends in 3 days'),
];
const PARTNERS = () => [
  acct(tile('first-aid', 'gold'), 'Kavya Rao', 'Clinic admin, Golconda Gate Pet Clinic, Hyderabad'),
  acct(tile('stethoscope', 'green'), 'Dr. Sameer Khan', 'Vet. Bookings, tele-vet queue and prescriptions'),
  acct(tile('scissors', 'sky'), 'Lakshmi Groom Studio', 'Groomer. Accepts booking requests'),
  acct(tile('graduation-cap'), 'Vikram Desai', 'Dog trainer'),
  acct(tile('person-simple-walk', 'green'), 'Nisha Kumar', 'Dog walker. Live route and photo updates'),
  acct(tile('storefront', 'gold'), 'Tail Treats Traders', 'Seller. Products, orders, returns and payouts'),
];

SCREENS.welcome = () => shell({ kind: 'focus', page: 'narrow', body: `
  <div class="row between" style="padding-top:.5rem">${brand()}${langChip()}</div>
  <div class="colonnade">${arch('misty', '5.25rem')}<span class="dark" style="padding:.75rem .75rem 0;border-radius:6rem 6rem 1.5rem 1.5rem;display:block">${toran('bruno', 5, 5, '10.5rem')}</span>${arch('simba', '5.25rem')}</div>
  <div class="center" style="text-align:center"><h1 class="d1">Every care your pet needs, in one place</h1><p class="b1 dim mt-3" style="max-width:20rem;margin-inline:auto">Track walks, meals and moods for every pet in your home.</p></div>
  <div class="row center gap-2 mt-6" aria-label="Slide 1 of 3"><i style="width:1.75rem;height:.375rem;border-radius:1rem;background:var(--ink)"></i><i style="width:.375rem;height:.375rem;border-radius:1rem;background:var(--line-2)"></i><i style="width:.375rem;height:.375rem;border-radius:1rem;background:var(--line-2)"></i></div>
  <div class="row between mt-6"><a class="link">Skip</a>${btn('Next', 'primary', 'arrow-right')}</div>
  <button class="btn line block mt-4">${ic('flask')}Explore as demo user</button>
  <p class="c center mt-4" style="text-align:center">English, हिन्दी and తెలుగు. Change any time in Settings.</p>` });

SCREENS.signin = () => shell({ kind: 'focus', page: '', body: `
  <div class="row between" style="padding-top:.5rem">${brand()}${langChip()}</div>
  <div class="bento mt-6"><div class="s5">
    <h1 class="d1">Welcome to PawSetu</h1><p class="b1 dim mt-2">Sign in to look after your pets.</p>
    <div class="col gap-3 mt-5"><div class="field sq">${ic('envelope-simple')}<span>Email</span></div><div class="field sq">${ic('lock-key')}<span class="grow">Password</span>${ic('eye')}</div>
    <div class="row between"><a class="link">Forgot password?</a><a class="link">Create account</a></div>
    ${btn('Sign in', 'ink', 'sign-in', 'block')}
    <div class="row gap-3 c"><hr class="rule grow">or continue with<hr class="rule grow"></div>
    <div class="grid g3">${btn('Google', 'soft', 'google-logo', 'block')}${btn('Apple', 'soft', 'apple-logo', 'block')}${btn('Phone', 'soft', 'device-mobile', 'block')}</div>
    <p class="c">Run a clinic, salon or shop? <a class="link">Apply as a partner</a></p></div></div>
  <div class="s7"><div class="wash"><div class="row gap-2">${ic('flask')}<h2 class="t1">Demo accounts</h2></div><p class="c mt-1" style="color:var(--marigold-ink)">Tap any account to sign in. No password needed. Nothing here is real and no money is charged.</p>
    <div class="b2 mt-4">Pet parents</div><div class="grid dg2 mt-2">${PARENTS().join('')}</div>
    <div class="b2 mt-4">Family and pet sitter</div><div class="grid dg2 mt-2">${FAMILY().join('')}</div>
    <div class="row between mt-4"><span class="b2">Partners and the PawSetu team</span><a class="link">See all 13</a></div><div class="grid dg2 mt-2">${PARTNERS().slice(0, 2).join('')}</div></div></div></div>` });

SCREENS.demo = () => shell({ kind: 'focus', page: '', body: `
  <div class="row" style="padding-top:.5rem"><button class="icon-btn tonal" aria-label="Back">${ic('arrow-left')}</button><h1 class="d2 grow">Explore as demo user</h1></div>
  <div class="mt-4">${note('These are demo accounts with made-up people, clinics and data. Nothing here is real, no money is charged and no messages are sent.', 'flask', 'gold')}</div>
  <section class="mt-6">${sec('Pet parents')}<div class="grid dg2">${PARENTS().join('')}</div></section>
  <section class="mt-6">${sec('Family and pet sitter')}<div class="grid dg2">${FAMILY().join('')}</div></section>
  <section class="mt-6">${sec('Partners')}<div class="grid dg2">${PARTNERS().join('')}</div></section>
  <section class="mt-6">${sec('PawSetu team')}<div class="grid dg2">${acct(tile('shield-star', 'ink'), 'PawSetu Admin', 'Approvals, complaints, plans, Demo Outbox and the audit log')}</div></section>` });
