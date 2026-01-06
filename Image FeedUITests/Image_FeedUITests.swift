//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Timofei Kirichenko on 04.01.2026.
//

import XCTest

final class Image_FeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launchArguments = ["-UITesting"]
        app.launch()
    }
    
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
        
        if !authButton.exists {
            print("🔍 Пользователь уже залогинен. Выполняем logout через UI...")
            
            let profileTab = app.tabBars.buttons.element(boundBy: 1)
            XCTAssertTrue(profileTab.waitForExistence(timeout: 10), "Tab bar not found")
            profileTab.tap()
            
            let logoutButton = app.buttons["LogoutButton"]
            XCTAssertTrue(logoutButton.waitForExistence(timeout: 10), "Logout button not found")
            logoutButton.tap()
            
            let alertYesButton = app.alerts["Пока, пока!"].buttons["Да"]
            XCTAssertTrue(alertYesButton.waitForExistence(timeout: 5), "Alert 'Да' not found")
            alertYesButton.tap()
            
            XCTAssertTrue(authButton.waitForExistence(timeout: 15), "Authenticate button did not appear after logout")
        }
        
        authButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 20))
        
        loginTextField.tap()
        loginTextField.typeText("kirichenko.tmf@yandex.ru")
        hideKeyboard()
        
        webView.swipeUp()
        
        let passwordTextFaild = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextFaild.waitForExistence(timeout: 10))
        
        passwordTextFaild.tap()
        passwordTextFaild.typeText("641$720$KtO")
        webView.swipeUp()
        
        hideKeyboard()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    
    
    func testFeed() throws {
        
        let tableQuery = app.tables
        
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["NoActive"].tap()
        cellToLike.buttons["Active"].tap()
        
        sleep(3)
        
        cellToLike.tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 60))
        
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["ProfileNameLabel"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["ProfileUsernameLabel"].waitForExistence(timeout: 10))
        
        app.buttons["LogoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 10), "Authentication screen did not appear after logout")
    }
    
    func hideKeyboard() {
        let app = XCUIApplication()
        let doneButton = app.buttons["Done"]
        let returnButton = app.buttons["Return"]
        let goButton = app.buttons["Go"]
        
        if doneButton.exists {
            doneButton.tap()
        } else if returnButton.exists {
            returnButton.tap()
        } else if goButton.exists {
            goButton.tap()
        } else {
            
            let webView = app.webViews["UnsplashWebView"]
            if webView.exists {
                webView.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1)).tap()
            } else {
                
                app.swipeDown()
            }
        }
    }
}
