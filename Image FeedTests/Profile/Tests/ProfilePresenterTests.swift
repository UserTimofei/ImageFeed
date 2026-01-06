//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Timofei Kirichenko on 28.12.2025.
//
@testable import ImageFeed
import XCTest

final class ProfilePresenterTests: XCTestCase {
    
    private var sut: ProfilePresenter!
    private var mockProfileService: MockProfileService!
    private var mockImageService: MockImageService!
    private var mockLogoutService: MockLogoutService!
    private var mockAuthStorage: MockAuthStorage!
    private var viewSpy: ProfileViewSpy!
    
    override func setUp() {
        super.setUp()
        mockProfileService = MockProfileService()
        mockImageService = MockImageService()
        mockLogoutService = MockLogoutService()
        mockAuthStorage = MockAuthStorage()
        viewSpy = ProfileViewSpy()
        
        sut = ProfilePresenter(profileService: mockProfileService, imageService: mockImageService, logoutService: mockLogoutService, authStorage: mockAuthStorage
        )
        sut.view = viewSpy
    }
    
    override func tearDown() {
        sut = nil
        mockProfileService = nil
        mockImageService = nil
        mockLogoutService = nil
        mockAuthStorage = nil
        viewSpy = nil
        super.tearDown()
    }
    
    func testViewDidLoad_WhenTokenExists_CallsFetchProfile() {
        mockAuthStorage.tokenDI = "valid_token"
        
        sut.viewDidLoad()
        
        XCTAssertTrue(mockProfileService.fetchProfileCalled)
        XCTAssertEqual(mockProfileService.lastToken, "valid_token")
        XCTAssertTrue(viewSpy.showLoadingPlaceholderCalled)
    }
    
    func testViewDidLoad_WhenNoToken_ShowsLoadingPlaceholderOnly() {
        mockAuthStorage.tokenDI = nil
        
        sut.viewDidLoad()
        
        XCTAssertFalse(mockProfileService.fetchProfileCalled)
        XCTAssertTrue(viewSpy.showLoadingPlaceholderCalled)
    }
    
    func testViewDidLoad_WhenFetchProfileSucceeds_ShowsProfileAndLoadsAvatar() {
        mockAuthStorage.tokenDI = "token"
        
        let profile = Profile(
            username: "test_user",
            name: "Test User",
            loginName: "@test_user",
            bio: "Bio"
        )
        mockProfileService.fetchProfileResult = .success(profile)
        mockImageService.fetchProfileImageURLResult = .success("https://example.com/avatar.jpg")
        
        sut.viewDidLoad()
        waitForMainQueue()
        
        XCTAssertTrue(viewSpy.showProfileCalled)
        XCTAssertEqual(viewSpy.lastProfile, profile)
        
        XCTAssertTrue(mockImageService.fetchProfileImageURLCalled)
        XCTAssertEqual(mockImageService.avatarURL, "test_user")
        
        XCTAssertTrue(viewSpy.showAvatarCalled)
        XCTAssertEqual(viewSpy.lastAvatarURL, URL(string: "https://example.com/avatar.jpg"))
    }
    func testViewDidLoad_WhenFetchProfileFails_ShowLoadingPlaceholder() {
        mockAuthStorage.tokenDI = "token"
        
        mockProfileService.fetchProfileResult = .failure(ProfileServiceError.network)
        
        sut.viewDidLoad()
        waitForMainQueue()
        
        XCTAssertTrue(viewSpy.showLoadingPlaceholderCalled)
        XCTAssertFalse(viewSpy.showProfileCalled)
        XCTAssertFalse(viewSpy.showAvatarCalled)
    }
    
    func testViewDidLoad_WhenFetchProfileSuccedsButAvatarFails_ShowsProfileAndAvatarNil() {
        mockAuthStorage.tokenDI = "token"
        let profile = Profile(username: "user", name: "Name", loginName: "@user", bio: nil)
        mockProfileService.fetchProfileResult = .success(profile)
        mockImageService.fetchProfileImageURLResult = .failure(ProfileImageServiceError.notFound)
        
        
        sut.viewDidLoad()
        waitForMainQueue()
        
        
        XCTAssertTrue(viewSpy.showProfileCalled)
        XCTAssertTrue(viewSpy.showAvatarCalled)
        XCTAssertNil(viewSpy.lastAvatarURL)
    }
    
    func testLogoutButtonTapped_WhenUserConfirms_CallsLogoutService() {
        sut.logoutButtonTapped()
        viewSpy.logoutAlertCompletion?(true)
        
        XCTAssertTrue(mockLogoutService.logoutCalled)
    }
    
    func testLogoutButtonTapped_WhenUserCancels_DoesNotCallLogoutService() {
        sut.logoutButtonTapped()
        viewSpy.logoutAlertCompletion?(false)
        
        XCTAssertFalse(mockLogoutService.logoutCalled)
    }
    
    private func waitForMainQueue() {
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
