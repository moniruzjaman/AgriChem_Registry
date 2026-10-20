/* ============================================================
   AgriChem Registry — Service Worker
   Provides offline PWA support for the unified index.html.

   Strategy:
     - HTML shell (index.html, "./")      : network-first, fall back to cache
     - icon.svg / og-image.svg / manifest : cache-first (rarely change)
     - Other same-origin GET requests     : cache-first with network fallback

   Bump CACHE_VERSION below whenever you ship a breaking change
   to force a clean cache flush on existing users.
   ============================================================ */
const CACHE_VERSION = 'agrichem-registry-v1';
const CACHE = CACHE_VERSION;
const SHELL = [
  './',
  './index.html',
  './AgriChem_Registry_Explorer.html',
  './icon.svg',
  './og-image.svg',
  './manifest.webmanifest'
];

self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE)
      .then(c => c.addAll(SHELL).catch(err => {
        // Don't fail the whole install if one resource is missing
        console.warn('[AgriChem SW] precache partial failure:', err.message);
      }))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(
        keys.filter(k => k !== CACHE).map(k => caches.delete(k))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  const url = new URL(e.request.url);
  // Only handle same-origin requests; cross-origin (e.g. d3js if it were
  // external) goes straight to network.
  if (url.origin !== self.location.origin) return;

  // For navigation requests (the HTML shell), network-first so users get
  // the latest version when online; cache fallback when offline.
  if (e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request)
        .then(res => {
          const copy = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, copy)).catch(()=>{});
          return res;
        })
        .catch(() =>
          caches.match(e.request).then(r => r || caches.match('./') || caches.match('./index.html'))
        )
    );
    return;
  }

  // For everything else (icons, manifest, etc.), cache-first with a
  // network fallback that also populates the cache for next time.
  e.respondWith(
    caches.match(e.request).then(hit => hit || fetch(e.request)
      .then(res => {
        const copy = res.clone();
        caches.open(CACHE).then(c => c.put(e.request, copy)).catch(()=>{});
        return res;
      })
      .catch(() => caches.match('./'))
    )
  );
});
