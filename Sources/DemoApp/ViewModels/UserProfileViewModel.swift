protocol UserProfileServiceProtocol {
    func fetchUserProfile(userId: String) async throws -> UserProfile
}

struct UserProfile {
    let userId: String
    let name: String
    let email: String
    let bio: String
}

class UserProfileViewModel {
    private let userProfileService: UserProfileServiceProtocol
    private let userId: String
    var onProfileUpdate: ((UserProfile) -> Void)?
    var onError: ((Error) -> Void)?

    init(userId: String, userProfileService: UserProfileServiceProtocol) {
        self.userId = userId
        self.userProfileService = userProfileService
    }

    func loadUserProfile() {
        Task {
            do {
                let userProfile = try await userProfileService.fetchUserProfile(userId: userId)
                onProfileUpdate?(userProfile)
            } catch {
                onError?(error)
            }
        }
    }
}