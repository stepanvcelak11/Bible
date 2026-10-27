// Service worker webové verze – zajišťuje 100% offline běh.
//
// Šablona: tool/build_web.sh doplní VERSION (hash buildu) a seznam souborů
// PRECACHE. Při instalaci se stáhne a uloží celá aplikace (kód, písmo,
// databáze Bible, SQLite WebAssembly); pak se vše obsluhuje z mezipaměti.
// Nová verze aplikace = nový VERSION → stará mezipaměť se smaže.
const VERSION = '__VERSION__';
const CACHE = `bible-${VERSION}`;
const PRECACHE = __PRECACHE__;

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE)
      .then((cache) => cache.addAll(PRECACHE.map((p) => new Request(p, { cache: 'reload' }))))
      .then(() => self.skipWaiting()),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(
        keys.filter((k) => k.startsWith('bible-') && k !== CACHE).map((k) => caches.delete(k)),
      ))
      .then(() => self.clients.claim()),
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
