import Foundation

class NotificationPreferenceService {
    
    private let userDefaults: UserDefaults
    private let preferencesKey = "notificationPreferences"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func savePreference(for type: NotificationType, isEnabled: Bool) {
        var preferences = loadPreferences()
        preferences[type.rawValue] = isEnabled
        userDefaults.set(preferences, forKey: preferencesKey)
    }
    
    func isPreferenceEnabled(for type: NotificationType) -> Bool {
        let preferences = loadPreferences()
        return preferences[type.rawValue] ?? false
    }
    
    private func loadPreferences() -> [String: Bool] {
        return userDefaults.dictionary(forKey: preferencesKey) as? [String: Bool] ?? [:]
    }
}

enum NotificationType: String {
    case news
    case updates
    case promotions
}