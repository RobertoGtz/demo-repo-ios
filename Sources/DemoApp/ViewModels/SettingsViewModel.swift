protocol SettingsServiceProtocol {
    func fetchSettings() async throws -> [String: Any]
    func saveSettings(_ settings: [String: Any]) async throws
}

final class SettingsViewModel {
    private let settingsService: SettingsServiceProtocol
    private var settings: [String: Any] = [:]
    
    var onSettingsUpdated: (([String: Any]) -> Void)?
    
    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }
    
    func loadSettings() async {
        do {
            let fetchedSettings = try await settingsService.fetchSettings()
            self.settings = fetchedSettings
            onSettingsUpdated?(fetchedSettings)
        } catch {
            // Handle error, e.g., log or notify the user
        }
    }
    
    func updateSetting(key: String, value: Any) {
        settings[key] = value
        onSettingsUpdated?(settings)
    }
    
    func saveSettings() async {
        do {
            try await settingsService.saveSettings(settings)
        } catch {
            // Handle error, e.g., log or notify the user
        }
    }
}