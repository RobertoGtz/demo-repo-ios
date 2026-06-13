# Gaia Agent Rules — demo-repo-ios (Swift / UIKit)

> These rules are injected into every agent prompt. Follow them strictly when generating, modifying, or reviewing code in this repository.

---

## Architecture

This project follows **MVVM + Coordinator**. Layer responsibilities:

- `Presentation/Screens/` → ViewControllers own the view lifecycle only. No business logic.
- `Presentation/ViewModels/` → all UI state and user interaction logic.
- `Presentation/Coordinators/` → all navigation. ViewControllers never push/present directly.
- `Domain/` → pure Swift models and repository protocols. Zero UIKit imports.
- `Data/` → concrete repository and service implementations.

---

## Code Rules

- Use **Swift concurrency (`async/await`)** for all asynchronous code. Do **not** use completion handlers or `DispatchQueue` callbacks for new code.
- UI layer must be **UIKit**. Do **not** introduce SwiftUI unless the feature spec explicitly requires it.
- ViewModels must be `final class` conforming to a protocol — this enables protocol-based mocking in tests.
- All dependencies must be **injected via initializer** — no singletons, no service locators, no `shared` instances.
- Repositories must return `Result<Success, Failure>` — never throw directly to the UI layer.
- **No force unwraps (`!`)** — use `guard let`, `if let`, or `try?` with proper fallback.
- Apply strict **access control**: mark everything `private` or `internal` unless a `public` API is intentional.
- All user-facing strings must be localized via `Localizable.strings` — no hardcoded string literals in the UI.

---

## Test Rules

- Every new ViewController must have a corresponding `XCTestCase` in `Tests/DemoAppTests/`.
- Every new ViewModel must have unit tests covering all its public methods.
- Test file naming: `{TypeName}Tests.swift` — must mirror the source type name.
- Use **XCTest only** — no third-party test frameworks (no Quick/Nimble unless the spec requires it).
- Use **protocol mocks** for all dependencies, injected via `init` — never stub the real network.
- Every test must cover: **success response**, **failure/error response**, and **empty data** cases.
- Async tests must use `async`/`await` with `XCTestExpectation` or native async test methods.

---

## What NOT to do

- Do **not** modify `Sources/DemoApp/AppDelegate.swift` — it is the app entry point.
- Do **not** add packages to `Package.swift` unless the task explicitly requires a new dependency.
- Do **not** introduce **Combine** unless the feature spec explicitly requires it.
- Do **not** use `DispatchQueue.main.async` for UI updates — use `@MainActor` or `MainActor.run`.
- Do **not** commit Xcode derived data or `.xcuserdata` files.
