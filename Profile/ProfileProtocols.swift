//
//  ProfileProtocols.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 21.11.2026.
//
import Foundation

protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(name: String, loginName: String, bio: String)
    func updateAvatar(url: URL)
    func showLoadingState()
    func hideLoadingState()
    func showLogoutAlert()
    func switchToSplashScreen()
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func didUpdateAvatarNotification()
    func didFinishAvatarLoading()
    func didTapLogoutButton()
    func didConfirmLogout()
}
