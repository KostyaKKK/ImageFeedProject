//
//  ImageFeedProjectTests.swift
//  ImageFeedProjectTests
//
//  Created by Константин Кащеев on 05.09.2026.
//

@testable import ImageFeedProject
import XCTest

final class ImagesFeedProjectTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService.shared 
            
            let expectation = self.expectation(description: "Wait for Notification")
            NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
            
            service.fetchPhotosNextPage()
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
        }
    }
