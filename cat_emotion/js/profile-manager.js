// IndexedDB를 사용한 프로필 관리
class ProfileManager {
  constructor() {
    this.dbName = 'CatEmotionDB';
    this.storeName = 'profiles';
    this.db = null;
    this.init();
  }

  async init() {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, 1);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.db = request.result;
        resolve(this.db);
      };

      request.onupgradeneeded = (event) => {
        const db = event.target.result;
        if (!db.objectStoreNames.contains(this.storeName)) {
          db.createObjectStore(this.storeName, { keyPath: 'id' });
        }
      };
    });
  }

  async saveProfile(profile) {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([this.storeName], 'readwrite');
      const store = transaction.objectStore(this.storeName);

      profile.id = 'currentProfile';
      profile.savedAt = new Date().toISOString();

      const request = store.put(profile);
      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve(profile);
    });
  }

  async getProfile() {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([this.storeName], 'readonly');
      const store = transaction.objectStore(this.storeName);
      const request = store.get('currentProfile');

      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve(request.result);
    });
  }

  async clearProfile() {
    return new Promise((resolve, reject) => {
      const transaction = this.db.transaction([this.storeName], 'readwrite');
      const store = transaction.objectStore(this.storeName);
      const request = store.delete('currentProfile');

      request.onerror = () => reject(request.error);
      request.onsuccess = () => resolve();
    });
  }

  // localStorage 폴백 (IndexedDB 실패 시)
  async saveProfileFallback(profile) {
    profile.id = 'currentProfile';
    profile.savedAt = new Date().toISOString();
    localStorage.setItem('catProfile', JSON.stringify(profile));
    return profile;
  }

  async getProfileFallback() {
    const saved = localStorage.getItem('catProfile');
    return saved ? JSON.parse(saved) : null;
  }
}

// 전역 인스턴스
window.profileManager = new ProfileManager();
