# Unit Test Guide — demo-repo-ios (Swift / XCTest)

> This document defines how unit tests must be written in this project.
> The agent must follow these patterns exactly when creating or modifying test files.

---

## Test Structure

Every test file must follow this structure:

```swift
import XCTest
@testable import DemoApp

// MARK: - Mocks

final class MockExampleRepository: ExampleRepositoryProtocol {
    var fetchDataCallCount = 0
    var fetchDataResult: Result<[String], Error> = .success([])

    func fetchData() async -> Result<[String], Error> {
        fetchDataCallCount += 1
        return fetchDataResult
    }
}

// MARK: - Tests

final class ExampleViewModelTests: XCTestCase {

    private var sut: ExampleViewModel!
    private var mockRepository: MockExampleRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockExampleRepository()
        sut = ExampleViewModel(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: loadData

    func test_loadData_emitsLoadedState_whenRepositorySucceeds() async {
        // Arrange
        mockRepository.fetchDataResult = .success(["item1", "item2"])

        // Act
        await sut.loadData()

        // Assert
        XCTAssertEqual(sut.state, .loaded(["item1", "item2"]))
        XCTAssertEqual(mockRepository.fetchDataCallCount, 1)
    }

    func test_loadData_emitsErrorState_whenRepositoryFails() async {
        // Arrange
        mockRepository.fetchDataResult = .failure(NetworkError.timeout)

        // Act
        await sut.loadData()

        // Assert
        XCTAssertEqual(sut.state, .error)
    }

    func test_loadData_emitsEmptyState_whenRepositoryReturnsEmptyList() async {
        // Arrange
        mockRepository.fetchDataResult = .success([])

        // Act
        await sut.loadData()

        // Assert
        XCTAssertEqual(sut.state, .empty)
    }
}
```

---

## Naming Conventions

| What | Convention | Example |
|---|---|---|
| Test file | `{TypeName}Tests.swift` | `HomeViewModelTests.swift` |
| Test method | `test_{method}_{expectedResult}_{condition}` | `test_loadData_emitsError_whenNetworkFails` |
| Mock class | `Mock{ProtocolName}` | `MockHomeRepository` |
| Spy class | `Spy{ProtocolName}` | `SpyHomeCoordinator` |

---

## Required Test Cases per Type

### ViewModel
- Initial state has correct default value
- Async method emits loading state before completing
- Success path updates state with correct data
- Failure path emits error state
- Empty response emits empty state
- All public methods are called the expected number of times

### Repository
- Returns `.success` with correctly mapped model when data source succeeds
- Returns `.failure` with domain error when data source throws
- Maps raw data source errors to typed domain errors

### Coordinator (navigation)
- `start()` pushes or presents the correct ViewController
- Navigation calls happen exactly once
- Delegate callbacks trigger the expected navigation

---

## Mocking Rules

- Use **protocol-based manual mocks** — define a `Mock{Protocol}` class that records calls and returns configurable results
- Track call counts with `var {methodName}CallCount = 0`
- Store the last arguments with `var {methodName}ReceivedArgs: ArgType?`
- Never use `XCTAssertNoThrow` to mask errors — let the test fail clearly
- Inject all mocks via `init` — never use method swizzling or global state

---

## Async Test Rules

- All async tests must be `async` functions: `func test_... async { ... }`
- Never use `XCTestExpectation` for simple async/await tests — only use it when testing delegate callbacks or notifications
- Use `await sut.method()` directly, never `Task { }` inside tests

---

## Coverage Requirements

- **ViewModels**: all public methods and all state transitions must be tested
- **Repositories**: all `Result` branches (`.success`, `.failure`) must be covered
- **Coordinators**: all navigation paths must have at least one test

---

## File Location

```
Tests/
└── DemoAppTests/
    ├── Presentation/
    │   ├── ViewModels/
    │   │   └── HomeViewModelTests.swift
    │   └── Coordinators/
    │       └── HomeCoordinatorTests.swift
    └── Data/
        └── Repositories/
            └── HomeRepositoryTests.swift
```
