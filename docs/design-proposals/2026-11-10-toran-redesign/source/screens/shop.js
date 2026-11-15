/* Shop: product page, cart (filled and empty) */
const qty = (n) => `<span class="qty"><button aria-label="Less">${ic(n > 1 ? 'minus' : 'trash')}</button><b>${n}</b><button aria-label="More">${ic('plus')}</button></span>`;
SCREENS.product = () => { const p = PRODUCTS.lamb; return shell({ kind: 'sub', nav: 'shop', title: 'Product', actions: `<button class="icon-btn" aria-label="Share">${ic('share-network')}</button><button class="icon-btn" aria-label="Cart">${ic('shopping-cart-simple')}<span class="badge">2</span></button>`, page: '', body: `
  <div class="bento"><div class="s6">
    <div class="photo" style="aspect-ratio:1.1;border-radius:var(--r-xl)">${packOf('lamb')}<span class="over" style="left:.75rem;bottom:.75rem">${tag('13% off', 'ink')}</span></div>
    <div class="row gap-2 mt-3">${[['bag', '#C2552D', '#F9E2D2'], ['can', '#C2552D', '#F4ECE0'], ['pouch', '#C2552D', '#F4ECE0'], ['bag', '#8A3B1E', '#F4ECE0']].map((a, i) => `<span class="tile" style="--w:3.75rem;${i === 0 ? 'box-shadow:0 0 0 2px var(--ink)' : ''}">${pack(...a)}</span>`).join('')}</div></div>
  <div class="s6 stack">
    <section><div class="c">${p.brand}</div><h1 class="d2 mt-1">${p.name}</h1><div class="row gap-2 mt-2">${stars(p.rating)}<a class="link">59 reviews</a></div>
      <div class="row gap-3 mt-3" style="align-items:baseline"><span class="price" style="font-size:2rem">₹${p.price}</span><span class="strike" style="font-size:1rem">₹${p.mrp}</span><span class="b2 green">${p.off} off</span></div><div class="row between mt-1"><span class="c">Inclusive of all taxes</span>${qty(1)}</div></section>
    <section class="wash green row">${arch('bruno', '2.5rem')}<div class="grow"><div class="b2">A good match for Bruno</div><div class="c" style="color:var(--leaf)">Large breed, adult. No chicken, which Bruno avoids.</div></div>${ic('check-circle', 1)}</section>
    <section class="panel" style="padding:.375rem 1rem"><div class="list">
      ${item(tile('truck', 'sky'), 'Delivery by Tue 10 Nov', 'To Indiranagar 560038. Free with Plus above ₹499', '<a class="link">Change</a>')}
      ${item(tile('storefront'), 'Sold by Tail Treats Traders', 'Hyderabad. 4.6 seller rating', chev())}
      ${item(tile('arrow-u-up-left'), '7-day returns', 'Unopened bags only', chev())}
      ${item(tile('repeat', 'gold'), 'Reorder automatically', 'Every 2, 4 or 6 weeks. Skip or stop any time', '<span class="switch"></span>')}</div></section>
    <section>${sec('Details', '', 't2')}<dl class="kv"><dt>Suitable for</dt><dd>Dogs, adult, large breed</dd><dt>Main ingredients</dt><dd style="font-weight:420">Lamb meal, rice, oats, fish oil, beet pulp</dd><dt>Bag size</dt><dd>10 kg, about 31 days for Bruno</dd><dt>Protein, fat</dt><dd>24%, 14%</dd></dl></section>
    <section class="buybar"><div class="grid g2">${btn('Add to cart', 'line', 'shopping-cart-simple', 'block')}${btn('Buy now', 'primary', '', 'block')}</div></section></div></div>` }); };

const cartLine = (k, n) => { const p = PRODUCTS[k]; return `<div class="item" style="align-items:flex-start"><span class="tile" style="--w:4.25rem">${packOf(k)}</span><div class="grow"><div class="b2 clamp2">${p.short}</div><div class="c">${p.brand}</div><div class="row between mt-2">${qty(n)}<span class="price" style="font-size:1.0625rem">₹${p.price}</span></div></div></div>`; };
SCREENS.cart = () => shell({ kind: 'sub', nav: 'shop', title: 'Cart', page: '', body: `
  <div class="bento"><div class="s7 stack">
    <section class="card" style="padding:.375rem 1rem"><div class="list">${cartLine('lamb', 1)}${cartLine('bites', 2)}</div></section>
    <section class="panel"><div class="row between"><div class="row gap-2 b2">${ic('map-pin')}Deliver to Home</div><a class="link">Change</a></div><div class="c mt-1">Priya Sharma, 14, 2nd Cross, Indiranagar, Bengaluru 560038</div>
      <div class="b2 mt-4">Delivery slot</div><div class="hscroll mt-2">${chip('Tue 10 Nov, 7 to 11 AM', 1)}${chip('Tue, 5 to 9 PM')}${chip('Wed, 7 to 11 AM')}</div></section>
    <section class="row"><div class="field sq grow">${ic('ticket')}<span style="color:var(--ink);font-weight:600">PAWS100</span></div>${tag('Applied', 'green', 'check-circle')}<a class="link">Remove</a></section></div>
  <div class="s5 stack">
    <section class="ticket"><h2 class="t2">Bill</h2><dl class="kv mt-3" style="grid-template-columns:1fr auto"><dt>Items (3)</dt><dd>₹4,397</dd><dt>Delivery</dt><dd class="green">Free with Plus</dd><dt>Coupon PAWS100</dt><dd class="green">−₹100</dd></dl>
      <hr class="rule dash" style="margin:.875rem 0"><div class="row between"><span class="b2">To pay</span><span class="price" style="font-size:1.5rem">₹4,297</span></div><div class="c">You save ₹800 on this order</div>
      <div class="mt-4">${btn('Pay ₹4,297', 'primary lg', 'lock-key', 'block')}</div></section>
    ${note('Demo payment. No money is charged. You can try a successful, failed or pending payment.', 'flask', 'gold')}</div></div>` });

SCREENS['cart-empty'] = () => shell({ kind: 'sub', nav: 'shop', title: 'Cart', page: 'narrow', body: `
  <div class="empty" style="padding-top:4rem"><span class="tile" style="--w:8rem;border-radius:50%">${pack('bag', '#2F1D14', '#FDEFCC')}</span><h1 class="t1 mt-4">Your cart is empty</h1><p class="dim" style="max-width:18rem">Food, toys and more for your pet are a tap away.</p><div class="mt-3">${btn('Start shopping', 'primary', 'bag')}</div></div>
  <section class="mt-6">${sec('Buy again', 'My orders')}<div class="panel" style="padding:.375rem 1rem"><div class="list">${['lamb', 'chews'].map((k) => `<div class="item"><span class="tile" style="--w:3.25rem">${packOf(k)}</span><div class="grow"><div class="b2 clamp1">${PRODUCTS[k].short}</div><div class="c">₹${PRODUCTS[k].price}</div></div>${btn('Reorder', 'soft sm', 'arrow-clockwise')}</div>`).join('')}</div></div></section>` });
