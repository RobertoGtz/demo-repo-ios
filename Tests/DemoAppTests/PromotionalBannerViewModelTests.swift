import XCTest

final class PromotionalBannerViewModelTests: XCTestCase {

    private var viewModel: PromotionalBannerViewModel!
    private var mockService: MockPromotionalBannerService!

    override func setUp() {
        super.setUp()
        mockService = MockPromotionalBannerService()
        viewModel = PromotionalBannerViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchPromotionalBannersSuccess() async {
        // Given
        let expectedBanners = [
            PromotionalBanner(id: "1", title: "Sale", description: "50% off!"),
            PromotionalBanner(id: "2", title: "New Arrivals", description: "Check out the latest collection.")
        ]
        mockService.promotionalBannersResult = .success(expectedBanners)

        // When
        var receivedBanners: [PromotionalBanner]?
        viewModel.onBannersUpdated = { banners in
            receivedBanners = banners
        }
        await viewModel.fetchPromotionalBanners()

        // Then
        XCTAssertEqual(receivedBanners, expectedBanners)
    }

    func testFetchPromotionalBannersFailure() async {
        // Given
        mockService.promotionalBannersResult = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))

        // When
        var receivedError: Error?
        viewModel.onError = { error in
            receivedError = error
        }
        await viewModel.fetchPromotionalBanners()

        // Then
        XCTAssertNotNil(receivedError)
    }
}

private class MockPromotionalBannerService: PromotionalBannerServiceProtocol {
    var promotionalBannersResult: Result<[PromotionalBanner], Error>?

    func fetchPromotionalBanners() async -> Result<[PromotionalBanner], Error> {
        return promotionalBannersResult ?? .failure(NSError(domain: "NoResult", code: 0, userInfo: nil))
    }
}