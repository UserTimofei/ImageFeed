@testable import ImageFeed
import Foundation

enum ProfileServiceError: Error {
    case network
}

final class MockProfileService: ProfileServiceProtocol {
    var profile: ImageFeed.Profile?
    var fetchProfileResult: Result<Profile, Error> = .success(Profile.stub())
    var fetchProfileCalled = false
    var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) {
        
        fetchProfileCalled = true
        lastToken = token
        completion(fetchProfileResult)
        
    }
}
