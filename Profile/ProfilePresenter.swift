//
//  ProfilePresenter.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 21.11.2026.
//
import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?

    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let logoutService: ProfileLogoutService

    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        logoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }

    func viewDidLoad() {
        view?.showLoadingState()

        if let profile = profileService.profile {
            let displayData = ProfileDisplayHelper.makeDisplayData(from: profile)
            view?.updateProfileDetails(
                name: displayData.name,
                loginName: displayData.loginName,
                bio: displayData.bio
            )
            view?.hideLoadingState()
        }

        updateAvatarIfNeeded()
    }

    func didUpdateAvatarNotification() {
        updateAvatarIfNeeded()
    }

    func didFinishAvatarLoading() {
        view?.hideLoadingState()
    }

    func didTapLogoutButton() {
        view?.showLogoutAlert()
    }

    func didConfirmLogout() {
        logoutService.logout()
        view?.switchToSplashScreen()
    }

    private func updateAvatarIfNeeded() {
        guard
            let avatarURLString = profileImageService.avatarURL,
            let url = URL(string: avatarURLString)
        else {
            return
        }

        view?.updateAvatar(url: url)
    }
}
