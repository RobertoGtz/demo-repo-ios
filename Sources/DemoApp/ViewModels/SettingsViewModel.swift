protocol SettingsServiceProtocol {
    var isDarkModeEnabled: Bool { get }
    func toggleDarkMode()
}

final class SettingsViewModel {
    private let settingsService: SettingsServiceProtocol
    var onDarkModeChanged: ((Bool) -> Void)?

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }

    func loadSettings() {
        let isDarkMode = settingsService.isDarkModeEnabled
        onDarkModeChanged?(isDarkMode)
    }

    func toggleDarkMode() {
        settingsService.toggleDarkMode()
        let isDarkMode = settingsService.isDarkModeEnabled
        onDarkModeChanged?(isDarkMode)
    }
}