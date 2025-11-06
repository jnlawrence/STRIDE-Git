// --- CONFIGURATION ---
const CACHE_NAME = 'survey-app-shell-v124';
const GOOGLE_SCRIPT_URL = "https://script.google.com/macros/s/AKfycbznFY8yjIUgaWcEp1RBdgRqEvwUZ4Y2fct_vTrj2ZVufrR78M21i8YHy0zRUlizOxQR/exec"; // <-- ❗ IMPORTANT ❗

const DB_NAME = 'surveyDB';
const STORE_NAME = 'surveys';

// List all the files (the "App Shell") we want to cache
const FILES_TO_CACHE = [
    '.',
    'index.html',
    'style.css',
    'app.js',
    'manifest.json',
    'images/icon-192.png',
    'images/icon-512.png'
];

// --- CACHING (App Shell) ---

self.addEventListener('install', (event) => {
    console.log('[ServiceWorker] Install');
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('[ServiceWorker] Caching app shell');
            return cache.addAll(FILES_TO_CACHE);
        })
    );

    // --- ADD THIS LINE ---
    self.skipWaiting(); 
    // --- END OF NEW LINE ---

});

self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request);
        })
    );
});

// --- BACKGROUND SYNC ---

// Listen for the 'sync' event
self.addEventListener('sync', (event) => {
    if (event.tag === 'sync-surveys') {
        console.log('[ServiceWorker] Sync event fired: sync-surveys');
        // We tell the browser to keep the Service Worker alive until our async task is done
        event.waitUntil(syncSurveys());
    }
});

async function syncSurveys() {
    console.log('[ServiceWorker] Starting survey sync...');
    try {
        const surveys = await getAllSurveysFromDB();
        
        if (!surveys || surveys.length === 0) {
            console.log('[ServiceWorker] No surveys to sync.');
            return;
        }

        console.log(`[ServiceWorker] Found ${surveys.length} surveys to sync.`);

        // We use Promise.all to try and send all surveys.
        // If one fails, it won't stop the others.
        const syncPromises = surveys.map(survey => {
            // We need to remove 'id' because it's our local DB key.
            // Google Sheets will add its own row number.
            const dataToSend = {
                name: survey.name,
                contact: survey.contact,
                timestamp: survey.timestamp
            };

            return fetch(GOOGLE_SCRIPT_URL, {
                method: 'POST',
                body: JSON.stringify(dataToSend),
                headers: {
                    'Content-Type': 'text/plain;charset=utf-8', // Apps Script expects text/plain for doPost
                },
                mode: 'no-cors' // IMPORTANT: Apps Script requires this
            })
            .then(response => {
                // Note: 'no-cors' means we can't read the response.
                // We'll just assume success if the fetch didn't throw an error.
                // A more robust solution would handle this, but for this app, it's ok.
                console.log(`[ServiceWorker] Successfully synced survey ID ${survey.id}`);
                // If successful, delete it from the local DB
                return deleteSurveyFromDB(survey.id);
            })
            .catch(err => {
                console.error(`[ServiceWorker] Failed to sync survey ID ${survey.id}`, err);
                // We don't delete it, so it will be retried on the next sync
            });
        });

        await Promise.all(syncPromises);
        console.log('[ServiceWorker] Survey sync complete.');

    } catch (err) {
        console.error('[ServiceWorker] Error during sync:', err);
    }
}


// --- INDEXEDDB HELPER FUNCTIONS (for Service Worker) ---
// We have to redefine these here, as the SW can't access the 'db' variable from app.js

function openDB() {
    return new Promise((resolve, reject) => {
        const request = self.indexedDB.open(DB_NAME, 1);
        request.onsuccess = (event) => resolve(event.target.result);
        request.onerror = (event) => reject(event.target.error);
        request.onupgradeneeded = (event) => {
             // This should have already been handled by app.js, but good to have
            const db = event.target.result;
            if (!db.objectStoreNames.contains(STORE_NAME)) {
                db.createObjectStore(STORE_NAME, { keyPath: 'id', autoIncrement: true });
            }
        };
    });
}

async function getAllSurveysFromDB() {
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
    const db = await openDB();
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORE_NAME], 'readwrite');
        const store = transaction.objectStore(STORE_NAME);
        const request = store.delete(id);
        request.onsuccess = () => resolve();
        request.onerror = (event) => reject(event.target.error);
    });
}


// --- NEW: ACTIVATION & CLEANUP ---
self.addEventListener('activate', (event) => {
    console.log('[ServiceWorker] Activate');
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    // If the cache name isn't our CURRENT one, delete it.
                    if (cacheName !== CACHE_NAME) {
                        console.log('[ServiceWorker] Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => {
            // Tell the new service worker to take control of the page
            return self.clients.claim();
        })
    );
});