// Sources/DemoApp/ViewModels/PromotionalBannerViewModel.swift

protocol PromotionalBannerServiceProtocol {
    func fetchPromotionalBanners() async throws -> [PromotionalBanner]
}

struct PromotionalBanner {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
}

class PromotionalBannerViewModel {
    private let promotionalBannerService: PromotionalBannerServiceProtocol
    private var banners: [PromotionalBanner] = []
    var onBannersUpdated: (() -> Void)?

    init(promotionalBannerService: PromotionalBannerServiceProtocol) {
        self.promotionalBannerService = promotionalBannerService
    }

    func loadBanners() async {
        do {
            banners = try await promotionalBannerService.fetchPromotionalBanners()
            onBannersUpdated?()
        } catch {
            // Handle error appropriately, e.g., log or notify the user
            print("Failed to load promotional banners: \(error)")
        }
    }

    func getBanners() -> [PromotionalBanner] {
        return banners
    }
}