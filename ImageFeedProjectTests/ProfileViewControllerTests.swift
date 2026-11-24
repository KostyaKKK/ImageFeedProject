//
//  ProfileViewControllerTests.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 21.11.2026.
//
import XCTest
@testable import ImageFeedProject

final class ProfileViewControllerTests: XCTestCase {

    func testViewControllerCallsViewDidLoadOnPresenter() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testDidTapLogoutButtonCallsPresenter() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view

        // when
        viewController.perform(Selector(("didTapLogoutButton")))

        // then
        XCTAssertTrue(presenter.didTapLogoutButtonCalled)
    }

    func testUpdateProfileDetailsSetsLabels() {
        // given
        let viewController = ProfileViewController()
        _ = viewController.view

        // when
        viewController.updateProfileDetails(
            name: "Константин Кащеев",
            loginName: "@konstantin",
            bio: "iOS developer"
        )

        // then
        XCTAssertEqual(viewController.nameLabel.text, "Константин Кащеев")
        XCTAssertEqual(viewController.userNameLabel.text, "@konstantin")
        XCTAssertEqual(viewController.descriptionLabel.text, "iOS developer")
    }

    func testProfileDisplayHelperFallbackValues() {
        // given
        let emptyProfile = Profile(
            username: "user",
            name: "",
            loginName: "",
            bio: nil
        )

        // when
        let displayData = ProfileDisplayHelper.makeDisplayData(from: emptyProfile)

        // then
        XCTAssertEqual(displayData.name, "Имя не указано")
        XCTAssertEqual(displayData.loginName, "@неизвестный_пользователь")
        XCTAssertEqual(displayData.bio, "Профиль не заполнен")
    }
}

private final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewProtocol?
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateAvatarNotification() {}

    func didFinishAvatarLoading() {}

    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
    }

    func didConfirmLogout() {}
}
