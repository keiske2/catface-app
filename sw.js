// Service Worker for CatFace PWA
const CACHE_NAME = 'catface-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/catface_sim.html',
  '/manifest.json',
  '/yolov8n.onnx'
];

// 설치 단계
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('CatFace: 캐시 생성됨');
        // 모든 파일을 캐시하려 하지만, ONNX 파일은 선택적
        return Promise.all(
          urlsToCache.map(url => {
            return cache.add(url).catch(err => {
              console.warn(`Failed to cache ${url}:`, err);
            });
          })
        );
      })
  );
  self.skipWaiting();
});

// 활성화 단계
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('CatFace: 이전 캐시 삭제:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Fetch 이벤트 - 캐시 우선 전략
self.addEventListener('fetch', (event) => {
  // ONNX 모델은 네트워크 우선 (크기가 크므로)
  if (event.request.url.includes('.onnx')) {
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          const responseClone = response.clone();
          caches.open(CACHE_NAME)
            .then((cache) => {
              cache.put(event.request, responseClone);
            });
          return response;
        })
        .catch(() => caches.match(event.request))
    );
    return;
  }

  // 나머지 파일은 캐시 우선
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        if (response) {
          return response;
        }
        return fetch(event.request)
          .then((response) => {
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then((cache) => {
                cache.put(event.request, responseToCache);
              });
            return response;
          });
      })
      .catch(() => {
        // 오프라인 상태 - 캐시된 HTML 반환
        return caches.match('/catface_sim.html');
      })
  );
});

// 백그라운드 동기화 (선택사항)
self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-data') {
    event.waitUntil(
      // 필요한 동기화 로직 구현
      Promise.resolve()
    );
  }
});

console.log('CatFace Service Worker 등록됨');
