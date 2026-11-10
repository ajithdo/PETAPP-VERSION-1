/* PawSetu "Toran" mock kit: small helpers shared by every screen.
   Plain browser JavaScript so the mocks open straight from the folder. */
const Q = new URLSearchParams(location.search);
const LANG = Q.get('lang') || 'en';
const EASY = Q.get('easy') === '1';
const THEME = Q.get('theme') || 'light';
const SCREENS = {};
const T_TE = {};
const t = (s) => (LANG === 'te' && T_TE[s]) || s;

const ic = (name, fill) => `<i class="${fill ? 'ph-fill' : 'ph'} ph-${name}"></i>`;
const INK = '#2B1A12';

/* ---------- Brand mark: a bridge arch over a paw ---------- */
const mark = (dark) => `<svg viewBox="0 0 40 40" aria-hidden="true"><rect width="40" height="40" rx="12" fill="${dark ? '#F8A80C' : '#2F1D14'}"/><path d="M9 25.5v-4a11 11 0 0 1 22 0v4" fill="none" stroke="${dark ? '#2F1D14' : '#F8A80C'}" stroke-width="3.6" stroke-linecap="round"/><g fill="${dark ? '#2F1D14' : '#FBF2E3'}"><ellipse cx="20" cy="27.6" rx="4.3" ry="3.5"/><circle cx="14.6" cy="23.4" r="1.75"/><circle cx="18.1" cy="20.6" r="1.85"/><circle cx="21.9" cy="20.6" r="1.85"/><circle cx="25.4" cy="23.4" r="1.75"/></g></svg>`;
const brand = (dark) => `<span class="brand">${mark(dark)}<span>PawSetu</span></span>`;

/* ---------- Marigold ---------- */
function bloomShape(cx, cy, r, o = {}) {
  const hi = o.hi || '#FFCB52', mid = o.mid || '#F8A80C', lo = o.lo || '#E08600';
  let s = '';
  const ring = (n, rad, pr, fill, off) => { for (let i = 0; i < n; i++) { const a = (i / n) * Math.PI * 2 + off; s += `<circle cx="${(cx + Math.cos(a) * rad).toFixed(2)}" cy="${(cy + Math.sin(a) * rad).toFixed(2)}" r="${pr.toFixed(2)}" fill="${fill}"/>`; } };
  ring(12, r * 0.72, r * 0.3, mid, 0);
  ring(9, r * 0.44, r * 0.27, hi, 0.2);
  s += `<circle cx="${cx}" cy="${cy}" r="${(r * 0.3).toFixed(2)}" fill="${lo}"/>`;
  return s;
}
const bloom = (size = '1.5rem') => `<svg viewBox="0 0 40 40" style="width:${size};height:${size}" aria-hidden="true">${bloomShape(20, 20, 19)}</svg>`;
/* Task ring: empty, part done, or a full marigold when done */
function ring(done, total, size) {
  const st = size ? ` style="width:${size};height:${size}"` : '';
  if (done >= total) return `<svg class="tick" viewBox="0 0 40 40"${st} role="img" aria-label="Done">${bloomShape(20, 20, 19)}</svg>`;
  const c = 2 * Math.PI * 15, f = (done / total) * c;
  return `<svg class="tick" viewBox="0 0 40 40"${st} role="img" aria-label="${done} of ${total}"><circle cx="20" cy="20" r="15" fill="none" stroke="var(--line-2)" stroke-width="3.5"/>${done ? `<circle cx="20" cy="20" r="15" fill="none" stroke="var(--marigold)" stroke-width="3.5" stroke-linecap="round" stroke-dasharray="${f.toFixed(1)} ${c.toFixed(1)}" transform="rotate(-90 20 20)"/>` : ''}</svg>`;
}

/* ---------- Pets ---------- */
const PETS = {
  bruno: { name: 'Bruno', kind: 'dog', ears: 'drop', coat: '#E9B565', ear: '#C98B3A', muzzle: '#F8E3B8', collar: '#2C6A43', tongue: 1, bg: '#F9D9A8', halo: '#FCE7C6', tag: '#F4A261' },
  misty: { name: 'Misty', kind: 'cat', coat: '#F7EFE3', shade: '#E4D8C6', iris: '#E0A12A', fluffy: 1, collar: '#9B8AFB', bg: '#D9D2FB', halo: '#E9E4FD', tag: '#9B8AFB' },
  simba: { name: 'Simba', kind: 'dog', ears: 'erect', coat: '#D89A5B', ear: '#B9783A', muzzle: '#FBF0DC', blaze: 1, pup: 1, collar: '#DC2626', bg: '#BFE3F5', halo: '#DBF0FA', tag: '#38BDF8' },
  kiwi: { name: 'Kiwi', kind: 'bird', bg: '#BFEBD6', halo: '#DBF5E8', tag: '#34D399' },
  coco: { name: 'Coco', kind: 'rabbit', coat: '#DDB78E', ear: '#C19566', bg: '#F9CFE2', halo: '#FCE3EE', tag: '#F472B6' },
  tiger: { name: 'Tiger', kind: 'cat', coat: '#D9A05E', shade: '#B97C3A', iris: '#7FA650', stripes: 1, muzzleW: 1, collar: '#2C6A43', bg: '#E9DCC3', halo: '#F3EBDA', tag: '#D6B98C' },
  max: { name: 'Max', kind: 'dog', ears: 'erect', coat: '#C98A4B', ear: '#3E2B21', muzzle: '#3E2B21', mask: 1, big: 1, collar: '#F8A80C', bg: '#E9DCC3', halo: '#F3EBDA', tag: '#D6B98C' },
  luna: { name: 'Luna', kind: 'dog', ears: 'drop', coat: '#A8683A', ear: '#7C4824', muzzle: '#FBF0DC', blaze: 1, pup: 1, collar: '#F472B6', bg: '#F9CFE2', halo: '#FCE3EE', tag: '#F472B6' },
  rocky: { name: 'Rocky', kind: 'dog', ears: 'drop', coat: '#5A4336', ear: '#3E2B21', muzzle: '#8A6A55', collar: '#F8A80C', bg: '#BFEBD6', halo: '#DBF5E8', tag: '#34D399' },
  kitty: { name: 'Kitty', kind: 'cat', coat: '#8E8580', shade: '#6F6660', iris: '#E0A12A', muzzleW: 1, collar: '#DC2626', bg: '#BFE3F5', halo: '#DBF0FA', tag: '#38BDF8' },
};
const mirror = (d) => `<g transform="translate(100 0) scale(-1 1)">${d}</g>`;
const both = (d) => d + mirror(d);
function eyes(y, dx, r, mood, extra = '') {
  if (mood === 'sleep') return both(`<path d="M${50 - dx - r} ${y} q${r} ${r * 0.9} ${2 * r} 0" fill="none" stroke="${INK}" stroke-width="1.7" stroke-linecap="round"/>`);
  if (mood === 'joy') return both(`<path d="M${50 - dx - r} ${y + 1} q${r} ${-r * 1.1} ${2 * r} 0" fill="none" stroke="${INK}" stroke-width="1.8" stroke-linecap="round"/>`);
  return both(`<circle cx="${50 - dx}" cy="${y}" r="${r}" fill="${INK}"/><circle cx="${50 - dx + r * 0.35}" cy="${y - r * 0.35}" r="${r * 0.3}" fill="#fff"/>`) + extra;
}
const DRAW = {
  dog(p, o) {
    const pup = p.pup, ey = pup ? 60 : 58, er = pup ? 3.2 : 2.9;
    let s = `<path d="M11 124C11 104 28 92 50 92s39 12 39 32z" fill="${p.coat}"/>`;
    if (p.mask) s += `<path d="M11 124C11 108 20 98 34 94c-6 10-9 20-9 30z" fill="${p.ear}"/>${mirror(`<path d="M11 124C11 108 20 98 34 94c-6 10-9 20-9 30z" fill="${p.ear}"/>`)}`;
    if (p.blaze) s += `<path d="M36 124c0-14 5-24 14-24s14 10 14 24z" fill="${p.muzzle}"/>`;
    s += `<ellipse cx="50" cy="91" rx="17" ry="5" fill="${INK}" opacity=".16"/>`;
    if (p.ears === 'erect') s += both(`<path d="M30 48 25.5 ${p.big ? 13 : 20}q1-4 4.6-1.6L47 35z" fill="${p.ear}"/><path d="M31.5 43 29 ${p.big ? 21 : 26}l11 10.5z" fill="#E8A99A" opacity=".75"/>`);
    s += `<path d="M50 33c14 0 25 10 25 25 0 17-10 31-25 31S25 75 25 58c0-15 11-25 25-25z" fill="${p.coat}"/>`;
    if (p.blaze) s += `<path d="M45.5 34.500q4.5-1.6 9 0l2.5 30h-14z" fill="${p.muzzle}"/>`;
    s += `<ellipse cx="50" cy="74" rx="15" ry="12.5" fill="${p.muzzle}"/>`;
    if (p.ears === 'drop') s += both(`<path d="M34 36.500c-11-2.500-21 8-21 23.500 0 12 5 21.500 12 20.500 6-1 7-10 7-20 0-9 1.500-17 4.500-21.500z" fill="${p.ear}"/>`);
    if (p.tongue && o.mood !== 'sleep') s += `<path d="M46.300 79h7.400v5a3.700 3.700 0 0 1-7.400 0z" fill="#E9756C"/><path d="M50 80.500v4.500" stroke="#C4534C" stroke-width=".9" stroke-linecap="round"/>`;
    s += `<path d="M44.300 66.200q5.700-2.700 11.400 0 .9 4.600-5.700 7.100-6.600-2.500-5.700-7.100z" fill="${p.mask ? '#17100C' : INK}"/><ellipse cx="48.300" cy="66.600" rx="1.700" ry=".8" fill="#fff" opacity=".35"/>`;
    s += `<path d="M50 73.300v3.200m0 0q-3.400 4-7 1.600m7-1.600q3.400 4 7 1.600" fill="none" stroke="${p.mask ? '#17100C' : INK}" stroke-width="1.6" stroke-linecap="round"/>`;
    s += eyes(ey, 10.5, er, o.mood, p.mask ? both(`<ellipse cx="39.500" cy="51.800" rx="2.800" ry="1.900" fill="${p.coat}" opacity=".9"/>`) : '');
    return s;
  },
  cat(p, o) {
    let s = `<path d="M13 124C13 105 29 93 50 93s37 12 37 31z" fill="${p.coat}"/>`;
    if (p.fluffy) s += `<path d="M30 106q4 8 10 3 5 8 10 2 5 6 10-2 6 5 10-3-8-11-20-11t-20 11z" fill="#fff" opacity=".85"/>`;
    s += `<ellipse cx="50" cy="92" rx="16" ry="4.500" fill="${INK}" opacity=".14"/>`;
    s += both(`<path d="M27 57 23.500 30.500q.5-4 4-2L46 43z" fill="${p.coat}"/><path d="M29 50.500 27.300 35l12 9.300z" fill="#EDB3A4"/>`);
    if (p.fluffy) s += both(`<path d="M24 62l-9-2 6 8-8 3 9 4-6 6 11-1z" fill="${p.coat}"/>`);
    s += `<path d="M50 41c17 0 28 10 28 24S66 89 50 89 22 79 22 65s11-24 28-24z" fill="${p.coat}"/>`;
    if (p.stripes) s += `<path d="M44 43.500v6.500m6-7.500V50m6-6.500V50" stroke="${p.shade}" stroke-width="2.600" stroke-linecap="round"/>` + both(`<path d="M24 61.500l7.500 1.500M24.500 68l7 .2" stroke="${p.shade}" stroke-width="2.400" stroke-linecap="round"/>`);
    if (p.muzzleW) s += `<ellipse cx="50" cy="76" rx="11" ry="8.500" fill="#FBF3E6"/>`;
    if (o.mood === 'sleep' || o.mood === 'joy') s += eyes(64, 11, 3.6, o.mood);
    else s += both(`<ellipse cx="39" cy="64" rx="4.100" ry="4.500" fill="${p.iris}"/><ellipse cx="39" cy="64" rx="1.350" ry="3.500" fill="${INK}"/><circle cx="40.300" cy="62.300" r=".9" fill="#fff"/>`);
    s += `<path d="M47.700 70.800h4.600L50 73.600z" fill="#E48C82"/><path d="M50 73.600v1.700m0 0q-2.400 3.200-5.200 1.300m5.200-1.300q2.400 3.200 5.200 1.300" fill="none" stroke="${INK}" stroke-width="1.300" stroke-linecap="round"/>`;
    s += both(`<path d="M37.500 73.500 21.500 71M37.500 76l-16 1.500M38 78.500l-14 5" stroke="${INK}" stroke-width=".7" stroke-linecap="round" opacity=".38"/>`);
    return s;
  },
  rabbit(p, o) {
    let s = `<path d="M15 124C15 106 30 94 50 94s35 12 35 30z" fill="${p.coat}"/><path d="M36 124c0-12 5-21 14-21s14 9 14 21z" fill="#FFF8EE"/>`;
    s += `<ellipse cx="50" cy="92" rx="15" ry="4.500" fill="${INK}" opacity=".14"/>`;
    s += `<path d="M50 40c14 0 23 11 23 24S63 88 50 88 27 77 27 64s9-24 23-24z" fill="${p.coat}"/>`;
    s += `<path d="M44 41q6-5 12 0-1 5-6 5t-6-5z" fill="${p.ear}"/>`;
    s += both(`<path d="M36 44.500c-11-3.500-21 7-21 25.500 0 15 7 24 13 21.500 5-2 5-14 6-24 .8-9 3-16 6-20z" fill="${p.ear}"/><path d="M31 53c-6 1-10 9-10 18 0 8 3 13 5.500 12 3-1.500 2.500-9 3.500-17 .6-5 1.500-9 3-12z" fill="#F2C7B8" opacity=".7"/>`);
    s += `<circle cx="45" cy="74.500" r="6.800" fill="#FFF8EE"/><circle cx="55" cy="74.500" r="6.800" fill="#FFF8EE"/>`;
    s += `<path d="M47.600 69.300q2.400-1.700 4.800 0L50 72z" fill="#E48C82"/><path d="M50 72v2.800" stroke="${INK}" stroke-width="1.300" stroke-linecap="round"/>`;
    s += eyes(62, 10.5, 2.9, o.mood);
    return s;
  },
  bird(p, o) {
    let s = `<path d="M27 124c0-21 9-33 23-33s23 12 23 33z" fill="#C9C3BA"/><path d="M27 124c0-14 3-23 9-29 1 10 1 20-1 29zM73 124c0-14-3-23-9-29-1 10-1 20 1 29z" fill="#9D968D"/>`;
    s += `<path d="M47 46c-5-13-2-25 8-34-1 11-.5 23-1.500 34zM53.500 47c-1-12 4-22 13.500-28-3 9-5 19-7 29zM43 47.500c-6-9-6-19-.5-28 1 9 2.500 18 6 27.500z" fill="#F2C53D"/>`;
    s += `<circle cx="50" cy="65" r="21.500" fill="#F8D75E"/>`;
    s += both(`<circle cx="34.500" cy="70.500" r="6.600" fill="#F08A3C"/>`);
    s += `<path d="M45 66.500q5-4.500 10 0 0 7.500-5 11.500-5-4-5-11.500z" fill="#CDBBAA"/><path d="M46.500 69.500q3.500 2.200 7 0" fill="none" stroke="#8E7B6B" stroke-width="1" stroke-linecap="round"/>`;
    s += eyes(59.500, 9.500, 2.700, o.mood);
    return s;
  },
};
function accessories(p, o) {
  let s = '';
  const a = o.acc;
  if (a === 'hat') s += `<path d="M50 ${p.kind === 'cat' ? 16 : 9} 62 ${p.kind === 'cat' ? 42 : 35}H38z" fill="#DC2626"/><path d="M44.200 ${p.kind === 'cat' ? 28.5 : 21.5}h11.600l2.800 6H41.400z" fill="#FBF2E3" opacity=".9"/><circle cx="50" cy="${p.kind === 'cat' ? 15 : 8}" r="3.600" fill="#F8A80C"/>`;
  if (a === 'garland') { for (let i = 0; i < 7; i++) { const a2 = Math.PI * (0.12 + 0.76 * i / 6); s += bloomShape(50 - Math.cos(a2) * 21, 91 + Math.sin(a2) * 11, 5.2); } }
  else if (a === 'bandana') s += `<path d="M30 92q20 9 40 0l-4 6q-8 4-10 4L50 114l-6-12q-6-1-10-4z" fill="${o.accColor || '#DC2626'}"/>`;
  else if (p.collar && p.kind !== 'bird' && p.kind !== 'rabbit') s += `<path d="M31 92.500q19 8.500 38 0l.6 5.800q-19.600 9-39.200 0z" fill="${p.collar}"/><circle cx="50" cy="104.500" r="3.700" fill="#F8A80C" stroke="#E08600" stroke-width=".8"/>`;
  return s;
}
const SCENES = {
  park: () => `<rect width="100" height="124" fill="#CDE9F2"/><circle cx="78" cy="24" r="10" fill="#FFD772"/><path d="M-5 96q28-34 60-8 22-18 50-2v40H-5z" fill="#9CCB8B"/><path d="M-5 108q30-18 55-6 28-12 55 2v22H-5z" fill="#7DB56F"/>`,
  beach: () => `<rect width="100" height="124" fill="#FBD9A5"/><rect width="100" height="62" fill="#BFE3F5"/><circle cx="24" cy="26" r="11" fill="#FFF1C4"/><path d="M0 62q12-5 25 0t25 0 25 0 25 0v16H0z" fill="#6DB6D6"/><path d="M0 76q12-4 25 0t25 0 25 0 25 0v6H0z" fill="#F7E3C0"/>`,
  home: () => `<rect width="100" height="124" fill="#F2E3CF"/><rect x="12" y="14" width="34" height="42" rx="3" fill="#CDE9F2" stroke="#fff" stroke-width="3"/><path d="M29 14v42M12 35h34" stroke="#fff" stroke-width="2.500"/><rect y="98" width="100" height="26" fill="#D9BF9F"/><path d="M58 20h30v26H58z" fill="#fff" opacity=".6"/><circle cx="73" cy="33" r="7" fill="#F8A80C" opacity=".8"/>`,
  night: () => `<rect width="100" height="124" fill="#2E2A4A"/><circle cx="76" cy="24" r="10" fill="#FFF1C4"/><circle cx="72" cy="21" r="9" fill="#2E2A4A"/><g fill="#FFF1C4"><circle cx="18" cy="18" r="1.300"/><circle cx="34" cy="30" r="1"/><circle cx="52" cy="14" r="1.200"/><circle cx="88" cy="46" r="1"/><circle cx="12" cy="44" r="1"/></g><path d="M0 100q50-12 100 0v24H0z" fill="#4A4470"/>`,
  rain: () => `<rect width="100" height="124" fill="#C9D6DE"/><g stroke="#8FA9B8" stroke-width="2" stroke-linecap="round"><path d="M14 12l-3 9M32 22l-3 9M52 8l-3 9M72 20l-3 9M90 10l-3 9M22 42l-3 9M84 40l-3 9M8 30l-2 6"/></g><rect y="104" width="100" height="20" fill="#A9BCC7"/>`,
  party: () => `<rect width="100" height="124" fill="#FDEFCC"/><path d="M-2 6q52 22 104 0" fill="none" stroke="${INK}" stroke-width="1"/><g><path d="M8 10l10 3-7 12z" fill="#DC2626"/><path d="M27 16.500l10 2-6 13z" fill="#2C6A43"/><path d="M46 19.500h10l-5 13z" fill="#F8A80C"/><path d="M64 18.500l10-2-4 14z" fill="#9B8AFB"/><path d="M82 13l10-3-3 15z" fill="#DC2626"/></g><g fill="#F8A80C"><circle cx="14" cy="58" r="2"/><circle cx="88" cy="50" r="2.500"/></g><g fill="#F472B6"><circle cx="84" cy="72" r="2"/><circle cx="10" cy="80" r="2.500"/></g>`,
  bath: () => `<rect width="100" height="124" fill="#D6ECEF"/><g fill="#fff" opacity=".9"><circle cx="16" cy="30" r="7"/><circle cx="84" cy="22" r="9"/><circle cx="74" cy="44" r="4"/><circle cx="24" cy="52" r="4"/><circle cx="90" cy="60" r="5"/></g><path d="M0 98h100v26H0z" fill="#fff"/><g fill="#fff"><circle cx="10" cy="98" r="9"/><circle cx="28" cy="96" r="11"/><circle cx="72" cy="96" r="11"/><circle cx="90" cy="98" r="9"/></g>`,
  festive: () => `<rect width="100" height="124" fill="#5A1F2B"/><path d="M-2 8q52 26 104 0" fill="none" stroke="#2C6A43" stroke-width="1.500"/>${[0, 1, 2, 3, 4, 5, 6].map((i) => bloomShape(6 + i * 14.6, 8 + Math.sin((i / 6) * Math.PI) * 12.500, 5.500)).join('')}<g fill="#FFCB52"><path d="M14 98q4-9 0-14-4 5 0 14z"/><path d="M86 98q4-9 0-14-4 5 0 14z"/></g><path d="M7 99h14l-3 6h-8zM79 99h14l-3 6h-8z" fill="#C0703A"/>`,
  vet: () => `<rect width="100" height="124" fill="#DDEDDD"/><rect x="10" y="16" width="26" height="26" rx="6" fill="#fff"/><path d="M23 21.500v15M15.500 29h15" stroke="#2C6A43" stroke-width="4.500" stroke-linecap="round"/><rect y="100" width="100" height="24" fill="#C3DEC6"/>`,
};
function petSvg(key, o = {}) {
  const p = PETS[key];
  const bg = o.scene ? SCENES[o.scene]() : `<rect width="100" height="124" fill="${p.bg}"/><circle cx="50" cy="70" r="40" fill="${p.halo}"/>`;
  return `<svg viewBox="${o.vb || '0 0 100 124'}" preserveAspectRatio="xMidYMid slice" role="img" aria-label="${p.name}">${bg}${DRAW[p.kind](p, o)}${accessories(p, o)}</svg>`;
}
/* Pets always sit in an arch */
const arch = (key, w = '3rem', o = {}) => `<span class="arch${o.ring ? ' ring' : ''}" style="--w:${w};${o.ring ? `--ring:${PETS[key].tag}` : ''}">${petSvg(key, o)}</span>`;
/* Album "photos" (square or any ratio) */
const snap = (key, scene, o = {}) => petSvg(key, { scene, vb: '0 12 100 100', ...o });
/* People are circles with initials */
const person = (initials, w = '2.75rem', cls = '') => `<span class="person ${cls}" style="--w:${w}">${initials}</span>`;
/* Places and things are rounded tiles */
const tile = (icon, cls = '', w = '2.75rem') => `<span class="tile ${cls}" style="--w:${w}">${ic(icon)}</span>`;

/* The toran: a garland over the pet's doorway. One marigold per task; done ones are in bloom. */
function toran(key, done, total, w = '9.25rem', o = {}) {
  const cx = 74, cy = 82, r = 52, R = 66, H = 152;
  let s = `<svg class="toran" viewBox="0 0 148 ${H}" style="width:${w};height:auto" role="img" aria-label="${done} of ${total} done"><defs><clipPath id="tor-${key}"><path d="M${cx - r} ${H}V${cy}a${r} ${r} 0 0 1 ${2 * r} 0V${H}z"/></clipPath></defs>`;
  for (const k of [1.44, 1.78]) s += `<path d="M${cx - r * k} ${H}V${cy}a${r * k} ${r * k} 0 0 1 ${2 * r * k} 0V${H}" fill="none" stroke="#FBF2E3" stroke-opacity=".08" stroke-width="1.200"/>`;
  s += `<g clip-path="url(#tor-${key})"><svg x="${cx - r}" y="${cy - r}" width="${2 * r}" height="${H - cy + r}" viewBox="0 0 100 124" preserveAspectRatio="xMidYMin slice">${petSvg(key, o).replace(/^<svg[^>]*>/, '').replace(/<\/svg>$/, '')}</svg></g>`;
  const a0 = (-158 * Math.PI) / 180, a1 = (-22 * Math.PI) / 180;
  const P = (a, rad = R) => [cx + Math.cos(a) * rad, cy + Math.sin(a) * rad];
  const [sx, sy] = P(a0 - 0.2), [ex, ey] = P(a1 + 0.2);
  s += `<path d="M${sx.toFixed(1)} ${sy.toFixed(1)}A${R} ${R} 0 0 1 ${ex.toFixed(1)} ${ey.toFixed(1)}" fill="none" stroke="#7DB56F" stroke-width="1.600" stroke-linecap="round"/>`;
  const leafPair = (a, big) => { const [x, y] = P(a); const L = big ? 15 : 12, W = big ? 5.4 : 4.6; const one = (rot) => `<path d="M0 0q${W} ${L * 0.45} 0 ${L}q${-W} ${-L * 0.55} 0 ${-L}z" fill="#6DA862" transform="translate(${x.toFixed(1)} ${(y + 0.5).toFixed(1)}) rotate(${rot})"/>`; return one(-16) + one(16); };
  for (let i = 0; i < total - 1; i++) s += leafPair(a0 + ((a1 - a0) * (i + 0.5)) / (total - 1));
  s += leafPair(a0 - 0.2, 1) + leafPair(a1 + 0.2, 1);
  for (let i = 0; i < total; i++) {
    const a = total === 1 ? -Math.PI / 2 : a0 + ((a1 - a0) * i) / (total - 1); const [x, y] = P(a);
    s += i < done ? bloomShape(+x.toFixed(1), +y.toFixed(1), 12.5) : `<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="8" fill="#4A3224" stroke="#FBF2E3" stroke-opacity=".7" stroke-width="1.500"/><circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="2.200" fill="#FBF2E3" opacity=".7"/>`;
  }
  return s + '</svg>';
}

/* ---------- Products: drawn pack shots ---------- */
function pack(kind, c = '#F8A80C', bg = 'var(--paper-2)') {
  const lab = '#FBF2E3';
  const art = {
    bag: `<path d="M31 24h38l4 62a4 4 0 0 1-4 4H31a4 4 0 0 1-4-4z" fill="${c}"/><path d="M30 14h40v11H30z" fill="${c}"/><path d="M30 14h40v11H30z" fill="#000" opacity=".14"/><path d="M30 19.500h40" stroke="#fff" stroke-opacity=".5" stroke-dasharray="2 2"/><rect x="36" y="38" width="28" height="32" rx="6" fill="${lab}"/><path d="M44 54q6-8 12 0-6 8-12 0zm12 0 4-3.500v7z" fill="${c}"/><path d="M40 78h20" stroke="${lab}" stroke-width="3" stroke-linecap="round" opacity=".7"/>`,
    can: `<ellipse cx="50" cy="76" rx="24" ry="8" fill="${c}"/><path d="M26 40h48v36H26z" fill="${c}"/><ellipse cx="50" cy="40" rx="24" ry="8" fill="#D9D2C8"/><ellipse cx="50" cy="40" rx="18" ry="5.500" fill="#EFEAE2"/><path d="M26 50q24 9 48 0v18q-24 9-48 0z" fill="${lab}"/><path d="M43 62q7-7 14 0-7 7-14 0z" fill="${c}"/>`,
    pouch: `<path d="M30 20h40l5 66a4 4 0 0 1-4 4H29a4 4 0 0 1-4-4z" fill="${c}"/><path d="M30 20h40v8H30z" fill="#000" opacity=".14"/><circle cx="50" cy="60" r="15" fill="${lab}"/><g fill="${c}"><rect x="42" y="56" width="16" height="4.500" rx="2.200" transform="rotate(-24 50 58)"/><rect x="42" y="62" width="16" height="4.500" rx="2.200" transform="rotate(18 50 64)"/></g><path d="M38 36h24" stroke="${lab}" stroke-width="3" stroke-linecap="round" opacity=".7"/>`,
    harness: `<path d="M20 58q30 22 60 0" fill="none" stroke="${c}" stroke-width="9" stroke-linecap="round"/><path d="M33 31q17-9 34 0l7 30q-24 17-48 0z" fill="${c}"/><ellipse cx="50" cy="30" rx="11" ry="6" fill="${bg}"/><rect x="41" y="44" width="18" height="13" rx="4" fill="${lab}"/><rect x="70" y="52" width="9" height="12" rx="2.500" fill="#2B1A12" transform="rotate(-24 74 58)"/><circle cx="50" cy="19" r="4.500" fill="none" stroke="#9A897C" stroke-width="2.500"/><path d="M36 70q14 6 28 0" stroke="#000" stroke-opacity=".12" stroke-width="2" fill="none"/>`,
    rope: `<path d="M22 64q14-30 28-12t28-14" fill="none" stroke="${c}" stroke-width="11" stroke-linecap="round"/><path d="M22 64q14-30 28-12t28-14" fill="none" stroke="${lab}" stroke-width="11" stroke-linecap="butt" stroke-dasharray="3 7" opacity=".75"/><circle cx="22" cy="64" r="9" fill="${c}"/><circle cx="78" cy="38" r="9" fill="${c}"/><path d="M14 72l-5 9M19 75l-2 10M82 30l6-8M86 35l9-4" stroke="${c}" stroke-width="2.500" stroke-linecap="round"/>`,
    bed: `<ellipse cx="50" cy="60" rx="34" ry="22" fill="${c}"/><ellipse cx="50" cy="56" rx="24" ry="13" fill="${lab}"/><path d="M16 60q0 14 34 16t34-16" fill="none" stroke="#000" stroke-opacity=".12" stroke-width="3"/><path d="M40 55q10-6 20 0" fill="none" stroke="${c}" stroke-width="2" stroke-linecap="round" opacity=".6"/>`,
    bottle: `<rect x="34" y="40" width="32" height="48" rx="9" fill="${c}"/><rect x="43" y="28" width="14" height="13" rx="2" fill="#2B1A12"/><path d="M50 28v-8h14" fill="none" stroke="#2B1A12" stroke-width="4" stroke-linecap="round"/><rect x="39" y="52" width="22" height="22" rx="5" fill="${lab}"/><circle cx="50" cy="63" r="5" fill="${c}"/>`,
  };
  return `<svg viewBox="0 0 100 100" preserveAspectRatio="xMidYMid slice" aria-hidden="true"><rect width="100" height="100" fill="${bg}"/><ellipse cx="50" cy="91" rx="26" ry="3.500" fill="#2B1A12" opacity=".08"/>${art[kind]}</svg>`;
}
const PRODUCTS = {
  lamb: { name: 'Adult Large Breed Dry Food, Chicken-free Lamb & Rice 10 kg', short: 'Lamb & Rice Dry Food 10 kg', brand: 'Gharelu Paws', price: '3,899', mrp: '4,499', off: '13%', rating: '4.5', n: 59, art: ['bag', '#C2552D', '#F9E2D2'] },
  joint: { name: 'Senior Joint Care Dry Food 7 kg', short: 'Senior Joint Care 7 kg', brand: 'BhojanBuddy', price: '3,299', mrp: '3,799', off: '13%', rating: '3.8', n: 39, art: ['bag', '#2C6A43', '#DDEDDD'] },
  bites: { name: 'Training Bites Peanut Butter 200 g', short: 'Training Bites 200 g', brand: 'WagWorks', price: '249', mrp: '299', off: '17%', rating: '3.9', n: 15, art: ['pouch', '#F8A80C', '#FDEFCC'] },
  bed: { name: 'Orthopaedic Dog Bed Large', short: 'Orthopaedic Bed L', brand: 'NestNook', price: '3,999', mrp: '4,999', off: '20%', rating: '4.6', n: 47, art: ['bed', '#7C6FD0', '#E7E3FB'] },
  harness: { name: 'No-pull Harness (M/L)', short: 'No-pull Harness M/L', brand: 'WagWorks', price: '899', mrp: '1,099', off: '18%', rating: '3.7', n: 7, art: ['harness', '#DC2626', '#FCE4E0'] },
  rope: { name: 'Cotton Rope Tug Toy', short: 'Cotton Rope Tug Toy', brand: 'WagWorks', price: '199', mrp: '249', off: '20%', rating: '4.7', n: 31, art: ['rope', '#1F7FA8', '#DDECF5'] },
  chews: { name: 'Dental Chew Sticks (28 pcs)', short: 'Dental Chew Sticks', brand: 'Tail Treats', price: '399', mrp: '449', off: '11%', rating: '4.4', n: 88, art: ['pouch', '#2C6A43', '#DDEDDD'] },
  catfood: { name: 'Indoor Cat Dry Food Ocean Fish 3 kg', short: 'Indoor Cat Ocean Fish 3 kg', brand: 'Gharelu Paws', price: '1,599', mrp: '1,799', off: '11%', rating: '4.3', n: 26, art: ['bag', '#1F7FA8', '#DDECF5'] },
  shampoo: { name: 'Oatmeal Coat Shampoo 300 ml', short: 'Oatmeal Shampoo', brand: 'NestNook', price: '349', mrp: '399', off: '13%', rating: '4.2', n: 18, art: ['bottle', '#F8A80C', '#FDEFCC'] },
};
const packOf = (k) => pack(...PRODUCTS[k].art);

/* ---------- Places: drawn shopfronts, each with an arched door ---------- */
function place(v = 0, o = {}) {
  const V = [
    { sky: '#F9E2D2', wall: '#FBF2E3', awn: '#C2552D', door: '#2F1D14', tree: '#E0552D' },
    { sky: '#D5E9F4', wall: '#8CC3DE', awn: '#1F5B80', door: '#17384B', tree: '#5FA06A' },
    { sky: '#DDEDDD', wall: '#FBF7F1', awn: '#2C6A43', door: '#1F4A30', tree: '#7DB56F' },
    { sky: '#E9E4FD', wall: '#FBF2E3', awn: '#7C6FD0', door: '#3B3470', tree: '#F472B6' },
    { sky: '#FDEFCC', wall: '#FFF8EA', awn: '#E08600', door: '#5A3A12', tree: '#7DB56F' },
  ][v % 5];
  const sign = o.sign === 'scissors' ? `<path d="M73 23l14 8m0-8-14 8" stroke="${V.awn}" stroke-width="2.200" stroke-linecap="round"/><circle cx="72" cy="22.500" r="2.300" fill="none" stroke="${V.awn}" stroke-width="1.800"/><circle cx="72" cy="31.500" r="2.300" fill="none" stroke="${V.awn}" stroke-width="1.800"/>` : `<path d="M80 21v12m-6-6h12" stroke="${V.awn}" stroke-width="3.600" stroke-linecap="round"/>`;
  let s = `<svg viewBox="0 0 160 100" preserveAspectRatio="xMidYMid slice" aria-hidden="true"><rect width="160" height="100" fill="${V.sky}"/><circle cx="134" cy="20" r="9" fill="#fff" opacity=".7"/>`;
  s += `<rect x="126" y="54" width="5" height="30" fill="#7C5A45"/><circle cx="128" cy="46" r="15" fill="${V.tree}"/><circle cx="141" cy="54" r="10" fill="${V.tree}"/><circle cx="118" cy="55" r="9" fill="${V.tree}"/>`;
  s += `<rect x="32" y="14" width="80" height="70" rx="3" fill="${V.wall}"/><rect x="62" y="16" width="36" height="22" rx="5" fill="#fff"/>${sign}`;
  s += `<path d="M28 42h88v9q-5.500 6-11 0-5.500 6-11 0-5.500 6-11 0-5.500 6-11 0-5.500 6-11 0-5.500 6-11 0-5.500 6-11 0-5.500 6-11 0z" fill="${V.awn}"/>`;
  s += `<path d="M62 84V68a10 10 0 0 1 20 0v16z" fill="${V.door}"/><circle cx="78" cy="74" r="1.300" fill="#F8A80C"/><rect x="40" y="60" width="15" height="15" rx="3" fill="#CDE9F2"/><rect x="89" y="60" width="15" height="15" rx="3" fill="#CDE9F2"/>`;
  if (o.x24) s += `<rect x="38" y="19" width="19" height="13" rx="4" fill="${V.awn}"/><text x="47.500" y="28.700" text-anchor="middle" font-size="7.500" font-weight="800" fill="#fff" font-family="Bricolage Grotesque">24</text>`;
  s += `<rect y="84" width="160" height="16" fill="#2B1A12" opacity=".12"/></svg>`;
  return s;
}

/* ---------- Map ---------- */
function map(o = {}) {
  const pins = o.pins || [[96, 70, 1], [214, 52, 0], [262, 128, 0]];
  let s = `<svg viewBox="0 0 320 ${o.h || 180}" preserveAspectRatio="xMidYMid slice" role="img" aria-label="Map"><rect width="320" height="240" fill="#EFE7DA"/>`;
  s += `<path d="M-10 150q60-30 110 0t120-10 110 20v90H-10z" fill="#D9E9CF"/><path d="M230-10q-10 40 30 60t70 0V-10z" fill="#CFE3EE"/><rect x="24" y="18" width="52" height="34" rx="8" fill="#D9E9CF"/>`;
  s += `<g fill="none" stroke="#fff" stroke-linecap="round"><path d="M-10 96h340M120-10v260" stroke-width="11"/><path d="M-10 40q120 30 170 0t170 20M40-10q20 110 0 250M214-10q-30 120 10 250M-10 200q170-50 340-20" stroke-width="6"/><path d="M70 96v60h50M170 96V30M250 96v70" stroke-width="3.500"/></g>`;
  if (o.you !== false) s += `<circle cx="150" cy="104" r="16" fill="#1F7FA8" opacity=".16"/><circle cx="150" cy="104" r="6" fill="#1F7FA8" stroke="#fff" stroke-width="2.500"/>`;
  for (const [x, y, on] of pins) s += `<g transform="translate(${x} ${y})"><path d="M0 0c-9-11-14-17-14-24a14 14 0 0 1 28 0c0 7-5 13-14 24z" fill="${on ? '#F8A80C' : '#2F1D14'}" stroke="#fff" stroke-width="2"/><path d="M0-30v11m-5.500-5.500h11" stroke="${on ? '#2F1D14' : '#FBF2E3'}" stroke-width="3" stroke-linecap="round"/></g>`;
  return s + `<text x="314" y="${(o.h || 180) - 6}" text-anchor="end" font-size="7" fill="#66554A" font-family="Bricolage Grotesque">© OpenStreetMap contributors</text></svg>`;
}

/* ---------- Charts ---------- */
function lineChart(vals, o = {}) {
  const W = 320, H = o.h || 150, pl = 30, pr = 8, pt = 10, pb = 22;
  const min = o.min ?? Math.min(...vals) - 1, max = o.max ?? Math.max(...vals) + 1;
  const X = (i) => pl + (i * (W - pl - pr)) / (vals.length - 1), Y = (v) => pt + ((max - v) * (H - pt - pb)) / (max - min);
  let s = `<svg viewBox="0 0 ${W} ${H}" style="width:100%;height:auto" role="img" aria-label="${o.label || 'Chart'}">`;
  if (o.band) s += `<rect x="${pl}" y="${Y(o.band[1])}" width="${W - pl - pr}" height="${Y(o.band[0]) - Y(o.band[1])}" fill="var(--leaf-wash)" rx="4"/>`;
  for (const g of o.grid || []) s += `<path d="M${pl} ${Y(g)}H${W - pr}" stroke="var(--line)" stroke-width="1"/><text x="${pl - 6}" y="${Y(g) + 3.500}" text-anchor="end" font-size="9.500" fill="var(--ink-2)" font-family="Bricolage Grotesque">${g}${o.unit || ''}</text>`;
  const series = o.series || [{ vals, color: 'var(--ink)' }];
  for (const sr of series) {
    const d = sr.vals.map((v, i) => `${i ? 'L' : 'M'}${X(i).toFixed(1)} ${Y(v).toFixed(1)}`).join('');
    s += `<path d="${d}" fill="none" stroke="${sr.color}" stroke-width="2.500" stroke-linejoin="round" stroke-linecap="round"/>`;
    if (!o.noDots) sr.vals.forEach((v, i) => { const last = i === sr.vals.length - 1; s += `<circle cx="${X(i).toFixed(1)}" cy="${Y(v).toFixed(1)}" r="${last ? 5 : 3}" fill="${last ? 'var(--marigold)' : 'var(--surface)'}" stroke="${sr.color}" stroke-width="2"/>`; });
  }
  (o.xl || []).forEach((l, i, a) => { s += `<text x="${X((i * (vals.length - 1)) / (a.length - 1)).toFixed(1)}" y="${H - 5}" text-anchor="${i === 0 ? 'start' : i === a.length - 1 ? 'end' : 'middle'}" font-size="9.500" fill="var(--ink-2)" font-family="Bricolage Grotesque">${l}</text>`; });
  return s + '</svg>';
}
function barChart(sets, o = {}) {
  const W = 320, H = o.h || 150, pl = 26, pr = 4, pt = 8, pb = 20, n = sets[0].vals.length;
  const max = o.max || Math.max(...sets.flatMap((x) => x.vals)) * 1.1;
  const gw = (W - pl - pr) / n, bw = Math.min(9, (gw - 4) / sets.length);
  let s = `<svg viewBox="0 0 ${W} ${H}" style="width:100%;height:auto" role="img" aria-label="${o.label || 'Chart'}">`;
  for (const g of o.grid || []) { const y = pt + ((max - g) * (H - pt - pb)) / max; s += `<path d="M${pl} ${y}H${W - pr}" stroke="var(--line)"/><text x="${pl - 5}" y="${y + 3.500}" text-anchor="end" font-size="9" fill="var(--ink-2)" font-family="Bricolage Grotesque">${o.fmt ? o.fmt(g) : g}</text>`; }
  sets.forEach((st, k) => st.vals.forEach((v, i) => { const h = (v * (H - pt - pb)) / max; const x = pl + i * gw + (gw - bw * sets.length - (sets.length - 1) * 2) / 2 + k * (bw + 2); s += `<rect x="${x.toFixed(1)}" y="${(H - pb - h).toFixed(1)}" width="${bw}" height="${h.toFixed(1)}" rx="${Math.min(3, bw / 2)}" fill="${st.color}"/>`; }));
  (o.xl || []).forEach((l, i, a) => { s += `<text x="${(pl + ((i * (n - 1)) / (a.length - 1) + 0.5) * gw).toFixed(1)}" y="${H - 5}" text-anchor="middle" font-size="9" fill="var(--ink-2)" font-family="Bricolage Grotesque">${l}</text>`; });
  return s + '</svg>';
}
/* A stand-in QR pattern (not a real code) */
function qr(size = '6rem') {
  let s = `<svg viewBox="0 0 25 25" style="width:${size};height:${size}" shape-rendering="crispEdges" role="img" aria-label="QR code"><rect width="25" height="25" fill="#fff"/>`;
  let seed = 7; const rnd = () => ((seed = (seed * 16807) % 2147483647) % 100) / 100;
  const finder = (x, y) => `<rect x="${x}" y="${y}" width="7" height="7" fill="${INK}"/><rect x="${x + 1}" y="${y + 1}" width="5" height="5" fill="#fff"/><rect x="${x + 2}" y="${y + 2}" width="3" height="3" fill="${INK}"/>`;
  for (let y = 1; y < 24; y++) for (let x = 1; x < 24; x++) { const inF = (x < 9 && y < 9) || (x > 15 && y < 9) || (x < 9 && y > 15); if (!inF && rnd() > 0.52) s += `<rect x="${x}" y="${y}" width="1" height="1" fill="${INK}"/>`; }
  return s + finder(1, 1) + finder(17, 1) + finder(1, 17) + '</svg>';
}

/* ---------- Small builders ---------- */
const btn = (label, kind = 'primary', icon, extra = '') => `<button class="btn ${kind} ${extra}">${icon ? ic(icon) : ''}<span>${label}</span></button>`;
const tag = (label, kind = '', icon) => `<span class="tag ${kind}">${icon ? ic(icon, 1) : ''}${label}</span>`;
const chip = (label, on, icon) => `<span class="chip${on ? ' on' : ''}">${icon ? ic(icon) : ''}${label}</span>`;
const sec = (title, action, cls = 't1') => `<div class="sec"><h2 class="${cls}">${title}</h2>${action ? `<a class="link">${action}</a>` : ''}</div>`;
const leafdate = (mon, day, kind = '') => `<span class="leafdate ${kind}"><b>${mon}</b><span>${day}</span></span>`;
const chev = () => `<i class="ph ph-caret-right chev"></i>`;
const stars = (r, n) => `<span class="stars">${ic('star', 1)}${r}</span>${n !== undefined ? `<span class="c"> (${n})</span>` : ''}`;
const item = (lead, title, sub, trail = chev(), cls = '') => `<div class="item ${cls}">${lead}<div class="grow"><div class="b2">${title}</div>${sub ? `<div class="c">${sub}</div>` : ''}</div>${trail}</div>`;
const note = (text, icon = 'info', kind = '') => `<div class="note ${kind}">${ic(icon)}<span>${text}</span></div>`;
const rupee = (v) => `₹${v}`;

/* ---------- App chrome ---------- */
const TABS = [['home', 'Home', 'house'], ['health', 'Health', 'heartbeat'], ['book', 'Book', 'calendar-dots'], ['shop', 'Shop', 'bag'], ['me', 'Me', 'user']];
const USER = { name: 'Priya Sharma', first: 'Priya', initials: 'PS', pets: ['bruno', 'misty'], pet: 'bruno' };
function rail(cls = '') {
  return `<div class="rail ${cls}"><span class="pet-chip all">${ic('paw-print', 1)}${t('All pets')}</span>${USER.pets.map((k) => `<span class="pet-chip${k === USER.pet ? ' on' : ''}">${arch(k, '1.75rem')}${PETS[k].name}</span>`).join('')}<span class="pet-chip add">${ic('plus')}<span class="only-desk">${t('Add pet')}</span></span></div>`;
}
const topIcons = (o = {}) => `<button class="icon-btn tonal" aria-label="Messages">${ic('chat-circle-dots')}${o.msgs ? `<span class="badge">${o.msgs}</span>` : ''}</button><button class="icon-btn tonal" aria-label="Notifications">${ic('bell')}<span class="badge">2</span></button><button class="sos-btn" aria-label="Emergency SOS, hold for 2 seconds">${ic('asterisk')}SOS</button>`;
function sideNav(active) {
  return `<nav class="side">${brand(true)}${TABS.map(([k, l, i]) => `<a class="${k === active ? 'on' : ''}">${ic(i, k === active)}${t(l)}</a>`).join('')}
  <div class="foot"><div class="me">${person(USER.initials, '2.5rem', 'gold')}<div class="grow"><div class="b2 clamp1">${USER.name}</div><div class="m" style="color:var(--on-dark-2)">PawSetu Plus</div></div>${ic('caret-up-down')}</div></div></nav>`;
}
const dock = (active) => `<nav class="dock">${TABS.map(([k, l, i]) => `<a class="${k === active ? 'on' : ''}">${ic(i, k === active)}<span>${t(l)}</span></a>`).join('')}</nav>`;

const statusbar = () => `<div class="statusbar"><b>2:04</b><span>${ic('cell-signal-high', 1)}${ic('wifi-high', 1)}${ic('battery-high', 1)}</span></div>`;
/* o: {nav, kind:'tabs'|'sub'|'focus', title, actions, sos, body, page} */
function shell(o) {
  const page = `<div class="page ${o.page || ''}">${o.body}</div>`;
  if (o.kind === 'focus') return `<div class="app"><div class="body" style="flex:1;display:flex;flex-direction:column">${statusbar()}<main class="main no-dock" style="${o.mainStyle || ''}">${page}</main></div></div>`;
  if (o.kind === 'sub') {
    const acts = (o.actions || '') + (o.sos ? `<button class="sos-btn">${ic('asterisk')}SOS</button>` : '');
    return `<div class="app">${sideNav(o.nav)}<div class="body">${statusbar()}
      <header class="top only-desk"><div class="grow"></div>${topIcons()}</header>
      <header class="back only-phone"><button class="icon-btn" aria-label="Back">${ic('arrow-left')}</button><div class="title clamp1">${o.titleHtml || o.title}</div>${acts}</header>
      <main class="main"><div class="page ${o.page || ''}"><div class="back only-desk row"><button class="icon-btn tonal" aria-label="Back">${ic('arrow-left')}</button><div class="title">${o.titleHtml || o.title}</div>${o.actions || ''}</div>${o.body}</div></main>
      ${dock(o.nav)}</div></div>`;
  }
  return `<div class="app">${sideNav(o.nav)}<div class="body">${statusbar()}
    <header class="top">${brand()}<div class="grow only-phone"></div>${rail('only-desk')}${topIcons()}</header>
    ${rail('only-phone')}
    <main class="main">${page}</main>
    ${dock(o.nav)}</div></div>`;
}
/* Partner portals and the admin panel */
function proShell(o) {
  const side = `<nav class="side">${brand(true)}<div class="cap" style="padding-top:0;margin-top:-.75rem">${o.role}</div>${o.items.map(([l, i], n) => `<a class="${n === 0 ? 'on' : ''}">${ic(i, n === 0)}${l}</a>`).join('')}<div class="foot col gap-1"><a>${ic('gear-six')}Settings</a><a>${ic('sign-out')}Sign out</a></div></nav>`;
  return `<div class="app">${side}<div class="body">${statusbar()}
    <header class="top"><button class="icon-btn only-phone" aria-label="Menu">${ic('list')}</button><div class="title">${o.title}</div><span class="chip only-desk">${ic('user-circle')}${o.user}</span><span class="only-phone">${person(o.initials, '2.5rem', 'ink')}</span></header>
    <main class="main no-dock"><div class="page">${o.body}</div></main></div></div>`;
}

function boot() {
  const name = Q.get('screen') || 'home';
  const h = document.documentElement;
  h.lang = LANG; h.dataset.theme = THEME; if (EASY) h.dataset.easy = '1';
  if (Q.get('user') === 'ravi') Object.assign(USER, { name: 'Ravi Teja', first: 'Ravi', initials: 'RT', pets: ['simba', 'kiwi'], pet: 'simba' });
  document.title = `PawSetu · ${name}`;
  document.body.innerHTML = (SCREENS[name] || (() => `<p style="padding:2rem">Unknown screen: ${name}</p>`))();
}
