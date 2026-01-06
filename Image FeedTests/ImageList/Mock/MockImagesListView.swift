@testable import ImageFeed
import Foundation

final class MockImagesListView: ImagesListViewProtocol {
    var updateTableViewAnimatedCalled = false
    var showLoadingIndicatorCalled = false
    var hideLoadingIndicatorCalled = false
    var showErrorCalledWith: Error?
    var presentSingleImageCalledWith: Photo?
    var reloadRowCalledWith: IndexPath?
    var updatePhotosCalledWith: [Photo]?
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalledWith = error
    }
    
    func presentSingleImage(photo: Photo) {
        presentSingleImageCalledWith = photo
    }
    
    func reloadRow(at indexPath: IndexPath) {
        reloadRowCalledWith = indexPath
    }
    
    func updatePhotos(_ photos: [Photo]) {
        updatePhotosCalledWith = photos
    }
}
