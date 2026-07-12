import Foundation
import Combine
import UIKit

struct CatProfile: Codable {
    var name: String = "멍밍이"
    var age: Int = 3
    var gender: String = "여아"
    var breed: String = "러시안 블루"
    var personality: String = "도도"
    var photoData: Data?

    var language: String = "ko"
    var nyangLevel: Int = 60
    var outputMode: String = "text"

    enum CodingKeys: String, CodingKey {
        case name, age, gender, breed, personality, photoData
        case language, nyangLevel, outputMode
    }
}

class ProfileManager: ObservableObject {
    @Published var currentProfile: CatProfile = CatProfile()
    @Published var isProfileLoaded: Bool = false

    private let profileKey = "catfaceProfile"

    static let shared = ProfileManager()

    init() {
        loadProfile()
    }

    func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(CatProfile.self, from: data) {
            self.currentProfile = decoded
        } else {
            self.currentProfile = CatProfile()
        }
        self.isProfileLoaded = true
    }

    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(currentProfile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }

    func saveProfile(_ profile: CatProfile) {
        self.currentProfile = profile
        saveProfile()
    }

    func deleteProfile() {
        UserDefaults.standard.removeObject(forKey: profileKey)
        self.currentProfile = CatProfile()
    }

    func updateName(_ name: String) {
        currentProfile.name = name
        saveProfile()
    }

    func updateBreed(_ breed: String) {
        currentProfile.breed = breed
        saveProfile()
    }

    func updatePersonality(_ personality: String) {
        currentProfile.personality = personality
        saveProfile()
    }

    func updateLanguage(_ language: String) {
        currentProfile.language = language
        saveProfile()
    }

    func updateNyangLevel(_ level: Int) {
        currentProfile.nyangLevel = level
        saveProfile()
    }

    func updateOutputMode(_ mode: String) {
        currentProfile.outputMode = mode
        saveProfile()
    }

    func setProfilePhoto(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            currentProfile.photoData = data
            saveProfile()
        }
    }

    func getProfilePhoto() -> UIImage? {
        guard let photoData = currentProfile.photoData else { return nil }
        return UIImage(data: photoData)
    }

    func clearProfilePhoto() {
        currentProfile.photoData = nil
        saveProfile()
    }
}
