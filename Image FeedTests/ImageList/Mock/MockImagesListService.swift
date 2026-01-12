@testable import ImageFeed
import Foundation

final class MockImagesListService: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalledWith: (photoId: String, isLike: Bool)?
    var changeLikeCompletion: ((Result<Void, Error>) -> Void)?
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalledWith = (photoId, isLike)
        changeLikeCompletion = completion
    }
}
