//
//  TEst.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 24.11.2026.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        if name.contains("testAuth") {
            app.launchArguments.append("--uitesting-reset-auth")
        }
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap() 
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 17))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 15))
        
        loginTextField.tap()
        loginTextField.typeText("kashcheev271292vh52183@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 15))
        passwordTextField.tap()
        sleep(3)

        UIPasteboard.general.string = "Tech@786271292"
        passwordTextField.press(forDuration: 1.0)

        let pasteButton = app.menuItems["Paste"].firstMatch
        let pasteButtonRu = app.menuItems["Вставить"].firstMatch
        if pasteButton.waitForExistence(timeout: 5) {
            pasteButton.tap()
        } else if pasteButtonRu.waitForExistence(timeout: 5) {
            pasteButtonRu.tap()
        } else {
            passwordTextField.typeText("Tech@786271292")
        }
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 20))
        firstCell.swipeUp()

        let windowFrame = app.windows.firstMatch.frame
        let candidateCells = (0..<6).compactMap { index -> XCUIElement? in
            let cell = tablesQuery.children(matching: .cell).element(boundBy: index)
            guard cell.exists else { return nil }
            let frame = cell.frame
            guard !frame.isEmpty, frame.maxY > 0, frame.minY < windowFrame.maxY else { return nil }
            return cell
        }

        guard let topVisibleCell = candidateCells.min(by: { $0.frame.minY < $1.frame.minY }) else {
            XCTFail("Не найдена верхняя видимая ячейка после прокрутки")
            return
        }

        let likeOffButton = topVisibleCell.buttons["like_button_off"]
        let likeOnButton = topVisibleCell.buttons["like_button_on"]

        if likeOffButton.waitForExistence(timeout: 5) {
            likeOffButton.tap()
            XCTAssertTrue(likeOnButton.waitForExistence(timeout: 10), "Состояние лайка не изменилось на включенное")
            likeOnButton.tap()
            XCTAssertTrue(likeOffButton.waitForExistence(timeout: 10), "Состояние лайка не вернулось в исходное")
        } else if likeOnButton.exists {
            likeOnButton.tap()
            XCTAssertTrue(likeOffButton.waitForExistence(timeout: 10), "Состояние лайка не изменилось на выключенное")
            likeOffButton.tap()
            XCTAssertTrue(likeOnButton.waitForExistence(timeout: 10), "Состояние лайка не вернулось в исходное")
        } else {
            XCTFail("Кнопка лайка не найдена в верхней видимой ячейке")
        }

        topVisibleCell.tap()

        let image = app.scrollViews.images.element(boundBy: 0) //Failed to tap Button (Element at index 1): No matches found for Descendants matching type TabBar from input {(        Application, pid: 30218        )}


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
