//
//  ImagesListTests.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 23.11.2026.
//
import XCTest
@testable import ImageFeedProject

final class ImagesListTests: XCTestCase {

    func testViewControllerCallsViewDidLoadOnPresenter() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testHeightHelperCalculatesScaledHeight() {
        // given
        let photoSize = CGSize(width: 1000, height: 2000)
        let tableWidth: CGFloat = 412

        // when
        let height = ImagesListHeightHelper.calculateRowHeight(
            photoSize: photoSize,
            tableViewWidth: tableWidth
        )

        // then
        XCTAssertEqual(height, 768, accuracy: 0.001)
    }

    func testDateHelperReturnsEmptyStringForNilDate() {
        // when
        let result = ImagesListDateHelper.string(from: nil)

        // then
        XCTAssertEqual(result, "")
    }
}

private final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewProtocol?
    var photosCount: Int = 0
    var viewDidLoadCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didReceivePhotosUpdate() {}
    func willDisplayRow(at index: Int) {}
    func didSelectRow(at index: Int) {}
    func didTapLike(at index: Int) {}
    func photo(at index: Int) -> Photo? { nil }
    func formattedDate(for index: Int) -> String { "" }
    func rowHeight(at index: Int) -> CGFloat { 0 }
}

