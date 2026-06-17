/**
 * Custom SpecAuthor agent — demo-repo-ios (Swift / UIKit + MVVM + Coordinator)
 * Loaded dynamically by PluginLoader. Uses GAIA_HARNESS_ROOT to resolve harness.
 */

const PROJECT_CONTEXT = `
## Project: demo-repo-ios — Swift / UIKit / MVVM + Coordinator

### Architecture layers (MUST respect)
- Presentation/Screens/      → ViewControllers, view lifecycle only. No business logic.
- Presentation/ViewModels/   → all UI state and user interaction logic.
- Presentation/Coordinators/ → all navigation. ViewControllers never push/present directly.
- Domain/                    → pure Swift models and repository protocols. Zero UIKit imports.
- Data/                      → concrete repository and service implementations.

### File path patterns
- ViewController: Sources/DemoApp/Presentation/Screens/{Name}ViewController.swift
- ViewModel:      Sources/DemoApp/Presentation/ViewModels/{Name}ViewModel.swift
- View:           Sources/DemoApp/Presentation/Views/{Name}View.swift
- Model:          Sources/DemoApp/Domain/Models/{Name}.swift
- Repository:     Sources/DemoApp/Data/Repositories/{Name}Repository.swift
- Service:        Sources/DemoApp/Data/Services/{Name}Service.swift
- Coordinator:    Sources/DemoApp/Presentation/Coordinators/{Name}Coordinator.swift
- Test:           Tests/DemoAppTests/{Feature}/{Name}Tests.swift

### Naming conventions
- Types/Files: UpperCamelCase | Variables: lowerCamelCase
- Constants: lowerCamelCase with let
- Protocols: UpperCamelCase — suffix with -able, -ing, or -Protocol

### Spec requirements
- Every ViewController task MUST include a XCTestCase task.
- Every ViewModel task MUST include unit tests for all public methods.
- Use Swift concurrency (async/await) for all async code — no completion handlers.
- UI must use UIKit — no SwiftUI unless explicitly required.
- ViewModels must be final class conforming to a protocol (enables mocking).
- All dependencies injected via initializer — no singletons.
- Repositories must return Result<Success, Failure> — never throw to UI layer.
- No force unwraps (!) — use guard let, if let, or try? with fallback.
- All user-facing strings must be in Localizable.strings — no hardcoded literals.

### Forbidden files — NEVER spec tasks that touch these
- Sources/DemoApp/AppDelegate.swift, Package.swift
`.trim();

const harnessRoot = process.env.GAIA_HARNESS_ROOT!;
const { SpecAuthorAgent } = require(`${harnessRoot}/dist/agents/spec-author`);

export default class IosSpecAuthor extends SpecAuthorAgent {
  name = 'IosSpecAuthor';

  async execute(context: any): Promise<any> {
    context.job.platform = 'ios';
    context.extraPromptContext = PROJECT_CONTEXT;
    return super.execute(context);
  }
}
