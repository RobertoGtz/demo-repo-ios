import XCTest

@testable import DemoApp

// Mock service to simulate settings storage
protocol SettingsServiceProtocol {
    func isDarkModeEnabled() async -> Bool
    func setDarkModeEnabled(_ enabled: Bool) async
}

class MockSettingsService: SettingsServiceProtocol {
    private var darkModeEnabled: Bool = false

    func isDarkModeEnabled() async -> Bool {
        return darkModeEnabled
    }

    func setDarkModeEnabled(_ enabled: Bool) async {
        darkModeEnabled = enabled
    }
}

// ViewModel to be tested
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

final class SettingsViewModelTests: XCTestCase {
    private var viewModel: SettingsViewModel!
    private var mockService: MockSettingsService!

    override func setUp() {
        super.setUp()
        mockService = MockSettingsService()
        viewModel = SettingsViewModel(settingsService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadDarkModeState() async {
        await mockService.setDarkModeEnabled(true)
        let expectation = XCTestExpectation(description: "Dark mode state loaded")

        viewModel.onDarkModeToggle = { isEnabled in
            XCTAssertTrue(isEnabled)
            expectation.fulfill()
        }

        await viewModel.loadDarkModeState()
        await waitForExpectations(timeout: 1, handler: nil)
    }

    func testToggleDarkMode() async {
        await mockService.setDarkModeEnabled(false)
        let expectation = XCTestExpectation(description: "Dark mode toggled")

        viewModel.onDarkModeToggle = { isEnabled in
            XCTAssertTrue(isEnabled)
            expectation.fulfill()
        }

        await viewModel.toggleDarkMode()
        await waitForExpectations(timeout: 1, handler: nil)
    }
}