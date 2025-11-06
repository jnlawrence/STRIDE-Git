// --- CONFIGURATION ---
const CACHE_NAME = 'survey-app-shell-v129'; // <-- UPDATED VERSION
const GOOGLE_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbznFY8yjIUgaWcEp1RBdgRqEvwUZ4Y2fct_vTrj2ZVufrR78M21i8YHy0zRUlizOxQR/exec"; 

const DB_NAME = 'surveyDB';
const STORE_NAME = 'surveys';

const FILES_TO_CACHE = [
    '.',
    'index.html',
    'style.css',
    'app.js',
    'manifest.json',
    'images/icon-192.png',
    'images/icon-512.png'
];

// --- NEW: Message Listener ---
// This listens for the 'SKIP_WAITING' command from app.js
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        console.log('[ServiceWorker] Received SKIP_WAITING message. Activating now.');
        self.skipWaiting();
    }
});
// --- END: Message Listener ---

// --- CACHING (App Shell) ---
self.addEventListener('install', (event) => {
    console.log('[ServiceWorker] Install');
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('[ServiceWorker] Caching app shell');
            return cache.addAll(FILES_TO_CACHE);
        })
    );
    
    // We still keep this here for the first-install scenario
    self.skipWaiting(); 
});

// --- FETCH (Unchanged) ---
self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request);
        })
    );
});

// --- BACKGROUND SYNC (Unchanged) ---
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-surveys') {
        console.log('[ServiceWorker] Sync event fired: sync-surveys');
        event.waitUntil(syncSurveys());
    }
});

async function syncSurveys() {
    // ... (unchanged)
    console.log('[ServiceWorker] Starting survey sync...');
    try {
        const surveys = await getAllSurveysFromDB();
        
        if (!surveys || surveys.length === 0) {
            console.log('[ServiceWorker] No surveys to sync.');
            return;
        }

        console.log(`[ServiceWorker] Found ${surveys.length} surveys to sync.`);

        const syncPromises = surveys.map(survey => {
            
            const dataToSend = { ...survey };
            delete dataToSend.id; 

            return fetch(GOOGLE_SCRIPT_URL, {
                method: 'POST',
                body: JSON.stringify(dataToSend),
                headers: {
                    'Content-Type': 'text/plain;charset=utf-8', 
                },
                mode: 'no-cors'
            })
            .then(response => {
                console.log(`[ServiceWorker] Successfully synced survey ID ${survey.id}`);
                return deleteSurveyFromDB(survey.id);
            })
            .catch(err => {
                console.error(`[ServiceWorker] Failed to sync survey ID ${survey.id}`, err);
            });
        });

        await Promise.all(syncPromises);
        console.log('[ServiceWorker] Survey sync complete.');

    } catch (err) {
        console.error('[ServiceWorker] Error during sync:', err);
    }
}


// --- INDEXEDDB HELPER FUNCTIONS (Unchanged) ---
function openDB() {
    // ... (unchanged)
    return new Promise((resolve, reject) => {
        const request = self.indexedDB.open(DB_NAME, 1);
        request.onsuccess = (event) => resolve(event.target.result);
        request.onerror = (event) => reject(event.target.error);
        request.onupgradeneeded = (event) => {
            const db = event.target.result;
            if (!db.objectStoreNames.contains(STORE_NAME)) {
                db.createObjectStore(STORE_NAME, { keyPath: 'id', autoIncrement: true });
            }
        };
    });
}

async function getAllSurveysFromDB() {
    // ... (unchanged)
    const db = await openDB();
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORE_NAME], 'readonly');
        const store = transaction.objectStore(STORE_NAME);
        const request = store.getAll();
        request.onsuccess = () => resolve(request.result);
        request.onerror = (event) => reject(event.target.error);
    });
}

async function deleteSurveyFromDB(id) {
    // ... (unchanged)
    const db = await openDB();
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORE_NAME], 'readwrite');
        const store = transaction.objectStore(STORE_NAME);
        const request = store.delete(id);
        request.onsuccess = () => resolve();
        request.onerror = (event) => reject(event.target.error);
    });
}


// --- ACTIVATION & CLEANUP (Unchanged) ---
self.addEventListener('activate', (event) => {
    console.log('[ServiceWorker] Activate');
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('[ServiceWorker] Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => {
            return self.clients.claim();
        })
    );
});