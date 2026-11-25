//
//  ImageFeedProjectTests.swift
//  ImageFeedProjectTests
//
//  Created by Константин Кащеев on 05.09.2026.
//

@testable import ImageFeedProject
import XCTest

final class WebViewPresenterTests: XCTestCase {

    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertTrue(viewController.loadRequestCalled)
    }

    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)

        // when
        let result = presenter.shouldHideProgress(for: 1.0)

        // then
        XCTAssertTrue(result)
    }
}

private final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadRequestCalled = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {}

    func setProgressHidden(_ isHidden: Bool) {}
}
