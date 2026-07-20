import Foundation

enum UserProfileStorage {

    private static let profileKey = "olive.userProfile"

    static func load() -> UserProfile {
        guard
            let data = UserDefaults.standard.data(forKey: profileKey),
            let profile = try? JSONDecoder().decode(UserProfile.self, from: data)
        else {
            return UserProfile()
        }

        return profile
    }

    static func save(_ profile: UserProfile) {
        guard let data = try? JSONEncoder().encode(profile) else {
            return
        }

        UserDefaults.standard.set(data, forKey: profileKey)
    }
}
