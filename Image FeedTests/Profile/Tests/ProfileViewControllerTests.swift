//
//  ProfileViewControllerTests.swift
//  ImageFeed
//
//  Created by Timofei Kirichenko on 22.12.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    func testViewDidLoadCallsPresenterViewDidLoad() {
        let sut = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()

        sut.configure(with: presenterSpy)

        _ = sut.view

        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
}

