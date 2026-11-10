//
//  ImagesListCell.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 25.10.2026.
//

import UIKit
import Kingfisher
// MARK: - Protocol
protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
// MARK: - Image State
enum FeedCellImageState {
    case loading
    case error
    case finished(UIImage)
}
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    // MARK: - Image State
    private var shimmerView: GradientAnimationView?
    
    // MARK: - UI Elements
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .ypBlack
        selectionStyle = .none
        setupUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    
    }
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = nil
        stopShimmer()
    }
    // MARK: - Configuration
    
    func configure(with photo: Photo, dateString: String) {
        dateLabel.text = dateString
        setIsLiked(photo.isLiked)
        
        guard let url = URL(string: photo.thumbImageURL) else { return }
        setCellState(.loading)
        cellImageView.kf.indicatorType = .activity
        cellImageView.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .stub),
            options: []
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                // Загрузка завершена успешно
                self.setCellState(.finished(value.image))
            case .failure:
                // Ошибка загрузки
                self.setCellState(.error)
            }
        }
    }
    func setCellState(_ state: FeedCellImageState) {
        switch state {
        case .loading:
            startShimmer()
        case .finished(let image):
            stopShimmer()
            cellImageView.image = image
        case .error:
            stopShimmer()
            cellImageView.image = UIImage(named: "stub")
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImageName = isLiked ? "like_button_on" : "like_button_off"
        let image = UIImage(named: likeImageName)
        likeButton.setImage(image, for: .normal)
    }
    
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setLikeButtonEnabled(_ isEnabled: Bool) {
        likeButton.isUserInteractionEnabled = isEnabled
    }
    // MARK: - Private Shimmer Helpers
    private func startShimmer() {
        guard shimmerView == nil else { return }
        
        let shimmer = GradientAnimationView()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        shimmer.layer.cornerRadius = 16
        shimmer.clipsToBounds = true
        
        cellImageView.addSubview(shimmer)
        
        NSLayoutConstraint.activate([
            shimmer.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            shimmer.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            shimmer.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            shimmer.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor)
        ])
        
        shimmer.startAnimating()
        self.shimmerView = shimmer
    }
    
    private func stopShimmer() {
        shimmerView?.stopAnimating()
        shimmerView?.removeFromSuperview()
        shimmerView = nil
    }
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            // Растягиваем картинку по контенту ячейки с отступами
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Кнопка лайка в правый верхний угол картинки
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 0),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Дата в левый нижний угол картинки
            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImageView.trailingAnchor, constant: -8)
        ])
        
        // Выводим кнопку и лейбл даты на передний план поверх картинки
        contentView.bringSubviewToFront(likeButton)
        contentView.bringSubviewToFront(dateLabel)
    }
}
