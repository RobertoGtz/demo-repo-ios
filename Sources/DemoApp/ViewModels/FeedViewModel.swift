protocol FeedServiceProtocol {
    func fetchFeed() async throws -> [FeedItem]
}

class FeedViewModel {
    private let feedService: FeedServiceProtocol
    private(set) var feedItems: [FeedItem] = []
    private(set) var isLoading: Bool = false
    var onUpdate: (() -> Void)?

    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }

    func loadFeed() async {
        isLoading = true
        onUpdate?()
        do {
            feedItems = try await feedService.fetchFeed()
        } catch {
            // Handle error appropriately, e.g., log or set an error state
            feedItems = []
        }
        isLoading = false
        onUpdate?()
    }

    func refreshFeed() async {
        await loadFeed()
    }
}
