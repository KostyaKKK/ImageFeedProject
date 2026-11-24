import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewProtocol {

    private enum Constants {
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Properties
    var presenter: ImagesListPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?

    var tableViewWidth: CGFloat {
        tableView.bounds.width
    }

    // MARK: - Deinit
    deinit {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if presenter == nil {
            let presenter = ImagesListPresenter()
            presenter.view = self
            self.presenter = presenter
        }

        setupUI()
        setupTableView()
        setupNotificationObserver()

        presenter?.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let fullImageURL = sender as? String
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.fullImageURL = fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - ImagesListViewProtocol
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }

    func reloadCell(at indexPath: IndexPath, isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setIsLiked(isLiked)
    }

    func setLikeButtonEnabled(_ isEnabled: Bool, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setLikeButtonEnabled(isEnabled)
    }

    func openSingleImage(urlString: String) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: urlString)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "ypBlack") ?? .black
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Private Methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }

    private func setupNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.presenter?.didReceivePhotosUpdate()
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell,
            let photo = presenter?.photo(at: indexPath.row)
        else {
            return UITableViewCell()
        }

        cell.delegate = self
        let dateString = presenter?.formattedDate(for: indexPath.row) ?? ""
        cell.configure(with: photo, dateString: dateString)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter?.rowHeight(at: indexPath.row) ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        presenter?.willDisplayRow(at: indexPath.row)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLike(at: indexPath.row)
    }
}
