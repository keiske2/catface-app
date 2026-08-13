const CACHE_NAME = 'cat-emotion-v1';
const urlsToCache = [
  './',
  './index.html',
  './manifest.json',
  './js/chat-model.js',
  './js/profile-manager.js',
  './js/yolo-detector.js',
  'https://cdn.jsdelivr.net/npm/@tensorflow/tfjs',
  'https://cdn.jsdelivr.net/npm/@tensorflow-models/coco-ssd',
  'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
      .catch(err => console.log('Cache add error:', err))
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') {
    return;
  }

  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }

        return fetch(event.request)
          .then(response => {
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }

            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });

            return response;
          })
          .catch(() => {
            return new Response('Offline - Unable to fetch');
          });
      })
  );
});
