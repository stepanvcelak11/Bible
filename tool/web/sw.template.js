// Service worker webové verze – zajišťuje 100% offline běh.
//
// Šablona: tool/build_web.sh doplní VERSION (hash buildu) a seznam souborů
// PRECACHE. Při instalaci se stáhne a uloží celá aplikace (kód, písmo,
// databáze Bible, SQLite WebAssembly); pak se vše obsluhuje z mezipaměti.
// Nová verze aplikace = nový VERSION → stará mezipaměť se smaže.
const VERSION = '__VERSION__';
const CACHE = `bible-${VERSION}`;
const PRECACHE = __PRECACHE__;

// Jádro aplikace (bez něj se nespustí) se uloží při instalaci – rychle, aby
// se service worker hned aktivoval a prohlížeč nabídl instalaci aplikace.
// Zbytek (databáze, písma…) se dotáhne na pozadí po aktivaci; soubory,
// které se nepodaří stáhnout, se uloží při prvním použití.
const CORE = ['./', 'index.html', 'manifest.json', 'flutter_bootstrap.js',
  'main.dart.js', 'favicon.png', 'icons/Icon-192.png', 'icons/Icon-512.png']
  .filter((p) => PRECACHE.includes(p));

async function cacheRest() {
  const cache = await caches.open(CACHE);
  for (const p of PRECACHE) {
    if (await cache.match(p)) continue;
    try {
      const response = await fetch(new Request(p, { cache: 'reload' }));
      if (response.ok) await cache.put(p, response);
    } catch (_) {
      // Bez sítě – uloží se při prvním použití.
    }
  }
}

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE)
      .then((cache) => cache.addAll(CORE.map((p) => new Request(p, { cache: 'reload' }))))
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener('message', (event) => {
  if (event.data === 'precache') event.waitUntil(cacheRest());
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(
        keys.filter((k) => k.startsWith('bible-') && k !== CACHE).map((k) => caches.delete(k)),
      ))
      .then(() => self.clients.claim())
      .then(() => { cacheRest(); }),
  );
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || url.origin !== self.location.origin) return;
  // Studijní balíček si aplikace ukládá sama do databáze – necachovat dvakrát.
  if (url.pathname.includes('/data/')) return;

  event.respondWith((async () => {
    const cache = await caches.open(CACHE);
    // Navigace (otevření aplikace) → vždy index.html z mezipaměti.
    if (request.mode === 'navigate') {
      return (await cache.match('./')) || (await cache.match('index.html')) || fetch(request);
    }
    const cached = await cache.match(request, { ignoreSearch: true });
    if (cached) return cached;
    // Cokoli dalšího (nepředpokládané soubory) – ze sítě a uložit.
    const response = await fetch(request);
    if (response.ok) cache.put(request, response.clone());
    return response;
  })());
});
