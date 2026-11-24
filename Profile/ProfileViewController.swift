//profileviewcontroller

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewProtocol {

    // MARK: - Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar") ?? .avatar
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(named: "Exit")
        button.tintColor = .ypRed
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGrey
        label.text = "@ekaterina_nov"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        label.text = "Hello, world!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Public Properties
    var presenter: ProfilePresenterProtocol?

    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    private let shimmerHelper = ProfileShimmerHelper()

    // MARK: - Deinit
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if presenter == nil {
            let presenter = ProfilePresenter()
            presenter.view = self
            self.presenter = presenter
        }

        setupView()
        addSubviews()
        setupConstraints()
        observeAvatarUpdates()

        presenter?.viewDidLoad()
    }

    // MARK: - ProfileViewProtocol
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        userNameLabel.text = loginName
        descriptionLabel.text = bio
    }

    func updateAvatar(url: URL) {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self else { return }
            self.presenter?.didFinishAvatarLoading()
            switch result {
            case .success(let value):
                print("[ProfileViewController.updateAvatar]: Success loaded from \(value.cacheType)")
            case .failure(let error):
                print("[ProfileViewController.updateAvatar]: NetworkError - \(error.localizedDescription)")
            }
        }
    }

    func showLoadingState() {
        view.layoutIfNeeded()
        shimmerHelper.show(on: [
            (avatarImageView, 35),
            (nameLabel, 9),
            (userNameLabel, 6),
            (descriptionLabel, 6)
        ])
    }

    func hideLoadingState() {
        shimmerHelper.hide()
    }

    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            self.presenter?.didConfirmLogout()
        }

        let noAction = UIAlertAction(title: "Нет", style: .cancel)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        present(alert, animated: true)
    }

    func switchToSplashScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }

    // MARK: - Private Methods
    private func observeAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.presenter?.didUpdateAvatarNotification()
        }
    }

    private func setupView() {
        view.backgroundColor = .ypBlack
    }

    private func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(userNameLabel)
        view.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),

            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),

            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func didTapLogoutButton() {
        presenter?.didTapLogoutButton()
    }
}
