import XCTest

final class UserProfileViewModelTests: XCTestCase {
    
    private class MockUserProfileService: UserProfileServiceProtocol {
        var userProfile: UserProfile?
        var error: Error?
        
        func fetchUserProfile() async throws -> UserProfile {
            if let error = error {
                throw error
            }
            return userProfile!
        }
    }
    
    private class MockUserProfileViewModelDelegate: UserProfileViewModelDelegate {
        var didUpdateProfile: ((UserProfile) -> Void)?
        var didFailWithError: ((Error) -> Void)?
        
        func userProfileViewModel(_ viewModel: UserProfileViewModel, didUpdateProfile profile: UserProfile) {
            didUpdateProfile?(profile)
        }
        
        func userProfileViewModel(_ viewModel: UserProfileViewModel, didFailWithError error: Error) {
            didFailWithError?(error)
        }
    }
    
    func testFetchUserProfileSuccess() async {
        let mockService = MockUserProfileService()
        let expectedProfile = UserProfile(name: "John Doe", age: 30, email: "john.doe@example.com")
        mockService.userProfile = expectedProfile
        
        let viewModel = UserProfileViewModel(service: mockService)
        let delegate = MockUserProfileViewModelDelegate()
        viewModel.delegate = delegate
        
        let expectation = XCTestExpectation(description: "Profile updated")
        
        delegate.didUpdateProfile = { profile in
            XCTAssertEqual(profile.name, expectedProfile.name)
            XCTAssertEqual(profile.age, expectedProfile.age)
            XCTAssertEqual(profile.email, expectedProfile.email)
            expectation.fulfill()
        }
        
        await viewModel.fetchUserProfile()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUserProfileFailure() async {
        let mockService = MockUserProfileService()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockService.error = expectedError
        
        let viewModel = UserProfileViewModel(service: mockService)
        let delegate = MockUserProfileViewModelDelegate()
        viewModel.delegate = delegate
        
        let expectation = XCTestExpectation(description: "Error received")
        
        delegate.didFailWithError = { error in
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
            expectation.fulfill()
        }
        
        await viewModel.fetchUserProfile()
        
        wait(for: [expectation], timeout: 1.0)
    }
}