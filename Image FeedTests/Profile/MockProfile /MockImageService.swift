@testable import ImageFeed
import Foundation

enum ProfileImageServicError: Error {
    case notFound
}

class MockImageService: ProfileImageServiceProtocol {
    
    var fetchProfileImageURLResult: Result<String, Error> = .success("https://example.com/avatar.jpg")
    var fetchProfileImageURLCalled = false
    var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
        fetchProfileImageURLCalled = true
        avatarURL = username
        completion(fetchProfileImageURLResult)
    }
    
}
