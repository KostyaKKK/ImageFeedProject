//
//  ImageFeedProjectTests.swift
//  ImageFeedProjectTests
//
//  Created by Константин Кащеев on 05.09.2026.
//

@testable import ImageFeedProject
import XCTest

final class AuthHelperTests: XCTestCase {

    func testCodeFromURL() {
        // given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        guard let url = urlComponents?.url else {
            XCTFail("Failed to construct URL from URLComponents")
            return
        }
        let authHelper = AuthHelper()

        // when
        let code = authHelper.code(from: url)

        // then
        XCTAssertEqual(code, "test code")
    }
}
