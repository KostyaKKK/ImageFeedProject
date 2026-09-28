import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            if let image {
                rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        guard let image else { return }
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - Actions
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    // MARK: - Private Methods
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        guard visibleRectSize.width > 0, visibleRectSize.height > 0 else { return }
        let imageSize = image.size
        imageView.frame = CGRect(origin: .zero, size: imageSize)
        scrollView.contentSize = imageSize
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = max(hScale, vScale)
        
        scrollView.minimumZoomScale = min(hScale, vScale)
        scrollView.maximumZoomScale = max(scale * 3.0, 3.0)
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = max((newContentSize.width - visibleRectSize.width) / 2, 0)
        let y = max((newContentSize.height - visibleRectSize.height) / 2, 0)
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

