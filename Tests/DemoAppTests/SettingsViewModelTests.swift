import XCTest

// Mock protocol for settings storage
protocol SettingsStorage {
    var isDarkModeEnabled: Bool { get set }
}

// ViewModel to be tested
class SettingsViewModel {
    private let storage: SettingsStorage
    var onDarkModePreferenceChanged: ((Bool) -> Void)?

    init(storage: SettingsStorage) {
        self.storage = storage
    }

    func toggleDarkMode() {
        storage.isDarkModeEnabled.toggle()
        onDarkModePreferenceChanged?(storage.isDarkModeEnabled)
    }

    func isDarkModeEnabled() -> Bool {
        return storage.isDarkModeEnabled
    }
}

// Mock implementation of SettingsStorage
class MockSettingsStorage: SettingsStorage {
    var isDarkModeEnabled: Bool = false
}

final class SettingsViewModelTests: XCTestCase {

    func testDarkModePreferencePersistence() {
        // Arrange
        let mockStorage = MockSettingsStorage()
        let viewModel = SettingsViewModel(storage: mockStorage)
        let expectation = XCTestExpectation(description: "Dark mode preference should change")

        viewModel.onDarkModePreferenceChanged = { isEnabled in
            XCTAssertEqual(isEnabled, true)
            expectation.fulfill()
        }

        // Act
        viewModel.toggleDarkMode()

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.isDarkModeEnabled())
    }
}