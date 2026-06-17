public struct Settings {
    public var notificationsEnabled: Bool
    public var darkModeEnabled: Bool
    public var preferredLanguage: String

    public init(notificationsEnabled: Bool = true, darkModeEnabled: Bool = false, preferredLanguage: String = "en") {
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
        self.preferredLanguage = preferredLanguage
    }
}