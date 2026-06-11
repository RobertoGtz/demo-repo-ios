import XCTest
@testable import DemoApp

final class HomeViewControllerTests: XCTestCase {
    func testHomeTitle() {
        let vc = HomeViewController()
        XCTAssertEqual(vc.title, "Home")
    }

    func testViewDidLoad() {
        let vc = HomeViewController()
        vc.viewDidLoad()
        // Should not crash
    }
}
