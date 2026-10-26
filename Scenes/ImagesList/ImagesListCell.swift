//
//  ImagesListCell.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 25.10.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    // MARK: - UI Elements
    
    // Картинка поста
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Кнопка лайка
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_button_off"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Лейбл с датой
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
        
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //Thread 1: Fatal error: init(coder:) has not been implemented
    }
    
    // MARK: - Configuration
    
    func configure(image: UIImage?, date: String, isLiked: Bool) {
        cellImageView.image = image
        dateLabel.text = date
        let likeImageName = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }

    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
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
    }
}
