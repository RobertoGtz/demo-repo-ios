import Foundation
public struct FeedItem: Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let timestamp: Date

    public init(id: String, title: String, description: String, timestamp: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.timestamp = timestamp
    }
}
