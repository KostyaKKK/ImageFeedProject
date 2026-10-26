//
//  SplashViewController.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 01.10.2026.
//
import UIKit

final class SplashViewController: UIViewController {

    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage.shared
// MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "ypBlack")
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
// MARK: - UI Setup
    private func setupUI() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
// MARK: - Navigation

    private func switchToTabBarController() {
        guard let window = view.window else {
            assertionFailure("Invalid window configuration: view is not attached to a window")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "AuthNavigationController") as? UINavigationController,
              let viewController = navigationController.viewControllers.first as? AuthViewController else {
            assertionFailure("Failed to instantiate AuthViewController")
            return
        }
        
        viewController.delegate = self
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case let .success(profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
    
            case let .failure(error):
                print("[SplashViewController.fetchProfile]: NetworkError - \(error.localizedDescription) [token: \(token)]")
                break
            }
        }
    }
}

// MARK: - Navigation
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            guard let token = self.storage.token else { return }
            self.fetchProfile(token: token)
        }
    }
}
