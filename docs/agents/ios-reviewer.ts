/**
 * Custom Reviewer agent — demo-repo-ios (Swift / UIKit + MVVM + Coordinator)
 * Loaded dynamically by PluginLoader. Uses GAIA_HARNESS_ROOT to resolve harness.
 */

const REVIEW_CHECKLIST = `
## PR Review Checklist — demo-repo-ios (Swift / UIKit)

### Architecture compliance
- [ ] ViewControllers own only view lifecycle — zero business logic.
- [ ] All UI state lives in ViewModels.
- [ ] All navigation goes through Coordinators — no direct push/present from VCs.
- [ ] Domain layer has zero UIKit imports.
- [ ] Data layer implements domain repository protocols.

### Code quality
- [ ] async/await used for ALL async operations — no completion handlers or DispatchQueue for new code.
- [ ] No force unwraps (!) — guard let / if let / try? used with fallback.
- [ ] ViewModels are final class conforming to a protocol.
- [ ] All dependencies injected via initializer — no singletons, no shared instances.
- [ ] Repositories return Result<Success, Failure>.
- [ ] All user-facing strings in Localizable.strings — no hardcoded literals.
- [ ] @MainActor or MainActor.run used for UI updates — no DispatchQueue.main.async.
- [ ] Strict access control applied (private/internal by default).

### Test coverage
- [ ] Every new ViewController has a XCTestCase.
- [ ] Every new ViewModel has unit tests for all public methods.
- [ ] Tests cover: success, failure/error, and empty data cases.
- [ ] Protocol mocks used for all dependencies.
- [ ] Async tests use async/await correctly.

### Forbidden files check
- [ ] Sources/DemoApp/AppDelegate.swift NOT modified.
- [ ] Package.swift NOT modified (unless task required new dependency).
`.trim();

const harnessRoot = process.env.GAIA_HARNESS_ROOT!;
const { ReviewerAgent } = require(`${harnessRoot}/dist/agents/reviewer`);

export default class IosReviewer extends ReviewerAgent {
  name = 'IosReviewer';

  async execute(context: any): Promise<any> {
    context.job.platform = 'ios';
    context.extraPromptContext = REVIEW_CHECKLIST;
    return super.execute(context);
  }
}
