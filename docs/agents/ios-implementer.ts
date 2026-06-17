/**
 * Custom Implementer agent — demo-repo-ios (Swift / UIKit + MVVM + Coordinator)
 * Loaded dynamically by PluginLoader. Uses GAIA_HARNESS_ROOT to resolve harness.
 */

const PROJECT_CONTEXT = `
## Project: demo-repo-ios — Swift / UIKit / MVVM + Coordinator

### File placement rules
- ViewController: Sources/DemoApp/Presentation/Screens/{Name}ViewController.swift
- ViewModel:      Sources/DemoApp/Presentation/ViewModels/{Name}ViewModel.swift
- View:           Sources/DemoApp/Presentation/Views/{Name}View.swift
- Model:          Sources/DemoApp/Domain/Models/{Name}.swift
- Repository:     Sources/DemoApp/Data/Repositories/{Name}Repository.swift
- Service:        Sources/DemoApp/Data/Services/{Name}Service.swift
- Coordinator:    Sources/DemoApp/Presentation/Coordinators/{Name}Coordinator.swift
- Test:           Tests/DemoAppTests/{Feature}/{Name}Tests.swift

### Code rules
- Use Swift concurrency (async/await) for ALL async code. No completion handlers or DispatchQueue for new code.
- UI layer must be UIKit. No SwiftUI unless feature spec explicitly requires it.
- ViewModels must be final class conforming to a protocol — this enables protocol-based mocking.
- All dependencies injected via initializer — no singletons, no shared instances.
- Repositories must return Result<Success, Failure> — never throw directly to UI layer.
- No force unwraps (!) — use guard let, if let, or try? with proper fallback.
- Strict access control: mark everything private or internal unless public API is intentional.
- All user-facing strings must be localized via Localizable.strings — no hardcoded string literals in UI.
- No Combine unless feature spec explicitly requires it.
- No DispatchQueue.main.async for UI updates — use @MainActor or MainActor.run.

### Test rules
- Every ViewController → XCTestCase in Tests/DemoAppTests/.
- Every ViewModel → unit tests for all public methods.
- Test naming: {TypeName}Tests.swift.
- XCTest only — no Quick/Nimble unless spec requires it.
- Protocol mocks for all dependencies injected via init.
- Every test must cover: success response, failure/error response, empty data.
- Async tests: async/await with XCTestExpectation or native async test methods.

### Forbidden files — NEVER modify
- Sources/DemoApp/AppDelegate.swift, Package.swift
`.trim();

const harnessRoot = process.env.GAIA_HARNESS_ROOT!;
const { ImplementerAgent } = require(`${harnessRoot}/dist/agents/implementer`);

export default class IosImplementer extends ImplementerAgent {
  name = 'IosImplementer';

  async execute(context: any): Promise<any> {
    context.job.platform = 'ios';
    context.extraPromptContext = PROJECT_CONTEXT;
    return super.execute(context);
  }
}
