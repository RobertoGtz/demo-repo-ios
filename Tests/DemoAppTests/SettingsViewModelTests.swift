import XCTest

// Protocol for the settings service
protocol SettingsServiceProtocol {
    func isDarkModeEnabled() async -> Bool
    func setDarkModeEnabled(_ enabled: Bool) async
}

// Mock implementation of the settings service
class MockSettingsService: SettingsServiceProtocol {
    private var darkModeEnabled: Bool = false

    func isDarkModeEnabled() async -> Bool {
        return darkModeEnabled
    }

    func setDarkModeEnabled(_ enabled: Bool) async {
        darkModeEnabled = enabled
    }
}

// ViewModel for the settings screen
class SettingsViewModel {
    private let settingsService: SettingsServiceProtocol
    var onDarkModeToggle: ((Bool) -> Void)?

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
    }

    func loadDarkModeState() async {
        let isEnabled = await settingsService.isDarkModeEnabled()
        onDarkModeToggle?(isEnabled)
    }

    func toggleDarkMode() async {
        let currentState = await settingsService.isDarkModeEnabled()
        let newState = !currentState
        await settingsService.setDarkModeEnabled(newState)
        onDarkModeToggle?(newState)
    }
}

// Unit tests for the SettingsViewModel
final class SettingsViewModelTests: XCTestCase {
    private var viewModel: SettingsViewModel!
    private var mockSettingsService: MockSettingsService!

    override func setUp() {
        super.setUp()
        mockSettingsService = MockSettingsService()
        viewModel = SettingsViewModel(settingsService: mockSettingsService)
    }

    override func tearDown() {
        viewModel = nil
        mockSettingsService = nil
        super.tearDown()
    }

    func testLoadDarkModeState() async {
        // Arrange
        await mockSettingsService.setDarkModeEnabled(true)
        let expectation = XCTestExpectation(description: "Dark mode state loaded")

        // Act
        viewModel.onDarkModeToggle = { isEnabled in
            // Assert
            XCTAssertTrue(isEnabled)
            expectation.fulfill()
        }
        await viewModel.loadDarkModeState()

        wait(for: [expectation], timeout: 1.0)
    }

    func testToggleDarkMode() async {
        // Arrange
        await mockSettingsService.setDarkModeEnabled(false)
        let expectation = XCTestExpectation(description: "Dark mode state toggled")

        // Act
        viewModel.onDarkModeToggle = { isEnabled in
            // Assert
            XCTAssertTrue(isEnabled)
            expectation.fulfill()
        }
        await viewModel.toggleDarkMode()

        wait(for: [expectation], timeout: 1.0)
    }
}