import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    
    func configure(image: UIImage?, date: String, isLiked: Bool) {
        photoImageView.image = image
        dateLabel.text = date
        let likeImage = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)
    }
}

