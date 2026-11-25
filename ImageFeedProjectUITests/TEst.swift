//
//  TEst.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 24.11.2026.
//

import XCTest

final class TEst: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        if name.contains("testAuth") {
            app.launchArguments.append("--uitesting-reset-auth")
        }
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap() //Failed to tap "Authenticate" Button: No matches found for Descendants matching type Button from input {(
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("kashcheev271292vh52183@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        passwordTextField.tap()
        sleep(3)

        UIPasteboard.general.string = "Tech@786"
        passwordTextField.press(forDuration: 1.0)

        let pasteButton = app.menuItems["Paste"].firstMatch
        let pasteButtonRu = app.menuItems["Вставить"].firstMatch
        if pasteButton.waitForExistence(timeout: 3) {
            pasteButton.tap()
        } else if pasteButtonRu.waitForExistence(timeout: 3) {
            pasteButtonRu.tap()
        } else {
            passwordTextField.typeText("Volkner1")
        }
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
        cell.swipeUp()

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 10))

        let likeOffButton = cellToLike.buttons["like_button_off"]
        if likeOffButton.waitForExistence(timeout: 5) {
            likeOffButton.tap()
            let likeOnButton = cellToLike.buttons["like_button_on"]
            XCTAssertTrue(likeOnButton.waitForExistence(timeout: 5))
            likeOnButton.tap()
        }

        cellToLike.tap()

        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 10))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        XCTAssertTrue(navBackButtonWhiteButton.waitForExistence(timeout: 10))
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Konstantin Kashcheev"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["@kostya271292"].exists)

        app.buttons["Exit"].tap()

        let alert = app.alerts["Пока, пока!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["Да"].tap()
    }
}
