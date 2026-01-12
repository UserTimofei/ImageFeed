import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewProtocol? { get set }
    func viewDidLoad()
    func didScrollBottom()
    func didTapLike(photoId: String, isLiked: Bool, at indexPath: IndexPath)
    func didTapPhoto(photo: Photo)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    
    
    weak var view: ImagesListViewProtocol?
    
    private let photoService: ImagesListServiceProtocol
    
    init(photoService: ImagesListServiceProtocol) {
        self.photoService = photoService
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            forName: .imagesListServiceDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.view?.updatePhotos(self.photoService.photos)
            self.view?.updateTableViewAnimated()
        }
        
        if photoService.photos.isEmpty {
            photoService.fetchPhotosNextPage()
        }
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func didScrollBottom() {
        
#if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-UITesting") {
            return
        }
#endif
        
        photoService.fetchPhotosNextPage()
    }
    
    func didTapLike(photoId: String, isLiked: Bool, at indexPath: IndexPath) {
        view?.showLoadingIndicator()
        photoService.changeLike(photoId: photoId, isLike: isLiked) { [weak self] result in
            // Передаём всё, что нужно, явно — без захвата замыкания
            self?.handleLikeResult(result, at: indexPath)
        }
    }
    
    private func handleLikeResult(_ result: Result<Void, Error>, at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.view?.hideLoadingIndicator()
            switch result {
            case .success:
                self.view?.updatePhotos(self.photoService.photos)
                self.view?.reloadRow(at: indexPath) // ✅ чисто по протоколу
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
    
    func didTapPhoto(photo: Photo) {
        view?.presentSingleImage(photo: photo)
        
    }
}

