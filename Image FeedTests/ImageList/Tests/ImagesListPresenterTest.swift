
@testable import ImageFeed
import XCTest

class ImagesListPresenterTests: XCTestCase {

    var presenter: ImagesListPresenter!
    var mockService: MockImagesListService!
    var mockView: MockImagesListView!

    override func setUp() {
        super.setUp()
        mockService = MockImagesListService()
        mockView = MockImagesListView()
        presenter = ImagesListPresenter(photoService: mockService)
        presenter.view = mockView
    }

    override func tearDown() {
        presenter = nil
        mockService = nil
        mockView = nil
        super.tearDown()
    }

    // MARK: - viewDidLoad

    func testViewDidLoad_SubscribesToNotification() {
        // Вызываем viewDidLoad
        presenter.viewDidLoad()

        // Имитируем уведомление
        NotificationCenter.default.post(name: .imagesListServiceDidChange, object: nil)

        // Проверяем, что view обновилась
        XCTAssertNotNil(mockView.updatePhotosCalledWith)
        XCTAssertTrue(mockView.updateTableViewAnimatedCalled)
    }

    func testViewDidLoad_FetchesPhotosIfEmpty() {
        mockService.photos = []
        presenter.viewDidLoad()
        XCTAssertTrue(mockService.fetchPhotosNextPageCalled)
    }

    func testViewDidLoad_DoesNotFetchIfPhotosNotEmpty() {
        mockService.photos = [Photo.stub()] // нужно реализовать stub, см. ниже
        presenter.viewDidLoad()
        XCTAssertFalse(mockService.fetchPhotosNextPageCalled)
    }

    // MARK: - didScrollBottom

    func testDidScrollBottom_CallsFetchPhotosNextPage() {
        presenter.didScrollBottom()
        XCTAssertTrue(mockService.fetchPhotosNextPageCalled)
    }

    // MARK: - didTapLike

    func testDidTapLike_ShowsLoadingIndicator() {
        presenter.didTapLike(photoId: "1", isLiked: true, at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockView.showLoadingIndicatorCalled)
    }

    func testDidTapLike_CallsChangeLikeWithCorrectParams() {
        let photoId = "123"
        let isLiked = false
        let indexPath = IndexPath(row: 5, section: 0)

        presenter.didTapLike(photoId: photoId, isLiked: isLiked, at: indexPath)

        XCTAssertEqual(mockService.changeLikeCalledWith?.photoId, photoId)
        XCTAssertEqual(mockService.changeLikeCalledWith?.isLike, isLiked)
    }

    func testDidTapLike_Success_HidesLoadingAndReloadsRow() {
        let indexPath = IndexPath(row: 2, section: 0)
        presenter.didTapLike(photoId: "1", isLiked: true, at: indexPath)

        let expectation = XCTestExpectation(description: "Handle like success")

        // Имитируем успех
        mockService.changeLikeCompletion?(.success(()))

        // Ждём, пока выполнится DispatchQueue.main.async
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertTrue(self.mockView.hideLoadingIndicatorCalled)
            XCTAssertEqual(self.mockView.reloadRowCalledWith, indexPath)
            XCTAssertNotNil(self.mockView.updatePhotosCalledWith)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testDidTapLike_Failure_ShowsError() {
        let error = NSError(domain: "TestError", code: 1, userInfo: nil)
        presenter.didTapLike(photoId: "1", isLiked: true, at: IndexPath(row: 0, section: 0))

        let expectation = XCTestExpectation(description: "Handle like failure")

        mockService.changeLikeCompletion?(.failure(error))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            XCTAssertTrue(self.mockView.hideLoadingIndicatorCalled)
            XCTAssertEqual(self.mockView.showErrorCalledWith as? NSError, error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - didTapPhoto

    func testDidTapPhoto_PresentsSingleImage() {
        let photo = Photo.stub()
        presenter.didTapPhoto(photo: photo)
        XCTAssertEqual(mockView.presentSingleImageCalledWith, photo)
    }
}
