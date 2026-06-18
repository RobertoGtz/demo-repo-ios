protocol SettingsServiceProtocol {
    func isDarkModeEnabled() async -> Bool
    func setDarkModeEnabled(_ enabled: Bool) async
}

final class SettingsViewModel {
    private let settingsService: SettingsServiceProtocol
    var onDarkModeChanged: ((Bool) -> Void)?

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }

    func loadSettings() async {
        let isDarkMode = await settingsService.isDarkModeEnabled()
        onDarkModeChanged?(isDarkMode)
    }

    func toggleDarkMode() async {
        let currentMode = await settingsService.isDarkModeEnabled()
        let newMode = !currentMode
        await settingsService.setDarkModeEnabled(newMode)
        onDarkModeChanged?(newMode)
    }
}