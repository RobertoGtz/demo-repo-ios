import XCTest

final class FeedViewModelTests: XCTestCase {
    private var viewModel: FeedViewModel!
    private var mockFeedService: MockFeedService!
    
    override func setUp() {
        super.setUp()
        mockFeedService = MockFeedService()
        viewModel = FeedViewModel(feedService: mockFeedService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockFeedService = nil
        super.tearDown()
    }
    
    func testInitialLoadingState() {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.feedItems.isEmpty)
    }
    
    func testRefreshFeedUpdatesItems() async {
        let expectedItems = [
            FeedItem(id: "1", title: "Item1", description: "Description1", timestamp: Date()),
            FeedItem(id: "2", title: "Item2", description: "Description2", timestamp: Date()),
            FeedItem(id: "3", title: "Item3", description: "Description3", timestamp: Date())
        ]
        mockFeedService.mockItems = expectedItems
        
        await viewModel.refreshFeed()
        
        XCTAssertEqual(viewModel.feedItems, expectedItems)
    }
    
    func testLoadingStateDuringRefresh() async {
        let loadingExpectation = expectation(description: "Loading state updated")
        var loadingStates: [Bool] = []
        
        viewModel.onUpdate = {
            loadingStates.append(self.viewModel.isLoading)
            if loadingStates.count == 2 {
                loadingExpectation.fulfill()
            }
        }
        
        Task {
            await self.viewModel.refreshFeed()
        }
        
        await waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(loadingStates, [true, false])
    }
}

private class MockFeedService: FeedServiceProtocol {
    var mockItems: [FeedItem] = []
    
    func fetchFeed() async throws -> [FeedItem] {
        return mockItems
    }
}
