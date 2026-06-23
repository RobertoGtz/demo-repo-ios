public struct PromotionalBanner {
    public let id: String
    public let title: String
    public let description: String
    public let imageUrl: String
    public let actionUrl: String

    public init(id: String, title: String, description: String, imageUrl: String, actionUrl: String) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.actionUrl = actionUrl
    }
}