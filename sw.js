// Service worker webové verze – zajišťuje 100% offline běh.
//
// Šablona: tool/build_web.sh doplní VERSION (hash buildu) a seznam souborů
// PRECACHE. Při instalaci se stáhne a uloží celá aplikace (kód, písmo,
// databáze Bible, SQLite WebAssembly); pak se vše obsluhuje z mezipaměti.
// Nová verze aplikace = nový VERSION → stará mezipaměť se smaže.
const VERSION = '60d87da150a0';
const CACHE = `bible-${VERSION}`;
const PRECACHE = [
  "./",
  "assets/AssetManifest.bin",
  "assets/AssetManifest.bin.json",
  "assets/FontManifest.json",
  "assets/assets/content/book_intros.json",
  "assets/assets/content/chapter_notes/01.json",
  "assets/assets/content/chapter_notes/02.json",
  "assets/assets/content/chapter_notes/03.json",
  "assets/assets/content/chapter_notes/04.json",
  "assets/assets/content/chapter_notes/05.json",
  "assets/assets/content/chapter_notes/06.json",
  "assets/assets/content/chapter_notes/07.json",
  "assets/assets/content/chapter_notes/08.json",
  "assets/assets/content/chapter_notes/09.json",
  "assets/assets/content/chapter_notes/10.json",
  "assets/assets/content/chapter_notes/11.json",
  "assets/assets/content/chapter_notes/12.json",
  "assets/assets/content/chapter_notes/13.json",
  "assets/assets/content/chapter_notes/14.json",
  "assets/assets/content/chapter_notes/15.json",
  "assets/assets/content/chapter_notes/16.json",
  "assets/assets/content/chapter_notes/17.json",
  "assets/assets/content/chapter_notes/18.json",
  "assets/assets/content/chapter_notes/19.json",
  "assets/assets/content/chapter_notes/20.json",
  "assets/assets/content/chapter_notes/21.json",
  "assets/assets/content/chapter_notes/22.json",
  "assets/assets/content/chapter_notes/23.json",
  "assets/assets/content/chapter_notes/24.json",
  "assets/assets/content/chapter_notes/25.json",
  "assets/assets/content/chapter_notes/26.json",
  "assets/assets/content/chapter_notes/27.json",
  "assets/assets/content/chapter_notes/28.json",
  "assets/assets/content/chapter_notes/29.json",
  "assets/assets/content/chapter_notes/30.json",
  "assets/assets/content/chapter_notes/31.json",
  "assets/assets/content/chapter_notes/32.json",
  "assets/assets/content/chapter_notes/33.json",
  "assets/assets/content/chapter_notes/34.json",
  "assets/assets/content/chapter_notes/35.json",
  "assets/assets/content/chapter_notes/36.json",
  "assets/assets/content/chapter_notes/37.json",
  "assets/assets/content/chapter_notes/38.json",
  "assets/assets/content/chapter_notes/39.json",
  "assets/assets/content/chapter_notes/40.json",
  "assets/assets/content/chapter_notes/41.json",
  "assets/assets/content/chapter_notes/42.json",
  "assets/assets/content/chapter_notes/43.json",
  "assets/assets/content/chapter_notes/44.json",
  "assets/assets/content/chapter_notes/45.json",
  "assets/assets/content/chapter_notes/46.json",
  "assets/assets/content/chapter_notes/47.json",
  "assets/assets/content/chapter_notes/48.json",
  "assets/assets/content/chapter_notes/49.json",
  "assets/assets/content/chapter_notes/50.json",
  "assets/assets/content/chapter_notes/51.json",
  "assets/assets/content/chapter_notes/52.json",
  "assets/assets/content/chapter_notes/53.json",
  "assets/assets/content/chapter_notes/54.json",
  "assets/assets/content/chapter_notes/55.json",
  "assets/assets/content/chapter_notes/56.json",
  "assets/assets/content/chapter_notes/57.json",
  "assets/assets/content/chapter_notes/58.json",
  "assets/assets/content/chapter_notes/59.json",
  "assets/assets/content/chapter_notes/60.json",
  "assets/assets/content/chapter_notes/61.json",
  "assets/assets/content/chapter_notes/62.json",
  "assets/assets/content/chapter_notes/63.json",
  "assets/assets/content/chapter_notes/64.json",
  "assets/assets/content/chapter_notes/65.json",
  "assets/assets/content/chapter_notes/66.json",
  "assets/assets/content/church_year.json",
  "assets/assets/content/concepts.json",
  "assets/assets/content/connections.json",
  "assets/assets/content/courses.json",
  "assets/assets/content/harmony.json",
  "assets/assets/content/illustrations.json",
  "assets/assets/content/notes.json",
  "assets/assets/content/people.json",
  "assets/assets/content/plans.json",
  "assets/assets/content/questions.json",
  "assets/assets/content/quiz.json",
  "assets/assets/content/reflections.json",
  "assets/assets/content/scenes.json",
  "assets/assets/content/situations.json",
  "assets/assets/content/stories.json",
  "assets/assets/content/story.json",
  "assets/assets/content/tables.json",
  "assets/assets/content/threads.json",
  "assets/assets/content/topics.json",
  "assets/assets/db/.gitkeep",
  "assets/assets/db/bible.db",
  "assets/assets/db/bible_manifest.json",
  "assets/assets/db/catalog.json",
  "assets/assets/db/study_manifest.json",
  "assets/assets/fonts/Inter.ttf",
  "assets/assets/fonts/Literata.ttf",
  "assets/assets/fonts/extra/AtkinsonHyperlegible-Bold.ttf",
  "assets/assets/fonts/extra/AtkinsonHyperlegible.ttf",
  "assets/assets/fonts/extra/EBGaramond.ttf",
  "assets/assets/map/.gitkeep",
  "assets/assets/map/basemap.json",
  "assets/assets/map/places.json",
  "assets/fonts/MaterialIcons-Regular.otf",
  "assets/fonts/fallback/Roboto-Regular.ttf",
  "assets/shaders/ink_sparkle.frag",
  "assets/shaders/stretch_effect.frag",
  "canvaskit/canvaskit.js",
  "canvaskit/canvaskit.wasm",
  "drift_worker.js",
  "favicon.png",
  "flutter.js",
  "flutter_bootstrap.js",
  "icons/Icon-192.png",
  "icons/Icon-512.png",
  "icons/Icon-maskable-192.png",
  "icons/Icon-maskable-512.png",
  "icons/apple-touch-icon.png",
  "index.html",
  "main.dart.js",
  "manifest.json",
  "sqlite3.wasm",
  "version.json"
];

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
