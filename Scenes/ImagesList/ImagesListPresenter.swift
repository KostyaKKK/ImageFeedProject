//
//  ImagesListPresenter.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 23.11.2026.
//
import Foundation
import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?

    private let imagesListService: ImagesListService
    private(set) var photos: [Photo] = []

    var photosCount: Int {
        photos.count
    }

    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }

    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }

    func didReceivePhotosUpdate() {
        let oldCount = photos.count
        let updatedPhotos = imagesListService.photos
        let newCount = updatedPhotos.count
        photos = updatedPhotos

        if newCount > oldCount {
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            view?.insertRows(at: indexPaths)
        }
    }

    func willDisplayRow(at index: Int) {
        if index == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }

    func didSelectRow(at index: Int) {
        guard photos.indices.contains(index) else { return }
        view?.openSingleImage(urlString: photos[index].largeImageURL)
    }

    func didTapLike(at index: Int) {
        guard photos.indices.contains(index) else { return }
        let photo = photos[index]
        let indexPath = IndexPath(row: index, section: 0)

        view?.setLikeButtonEnabled(false, at: indexPath)

        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }

            view?.setLikeButtonEnabled(true, at: indexPath)

            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                if self.photos.indices.contains(index) {
                    self.view?.reloadCell(at: indexPath, isLiked: self.photos[index].isLiked)
                }
            case .failure(let error):
                print("[ImagesListPresenter]: Error - \(error.localizedDescription)")
            }
        }
    }

    func photo(at index: Int) -> Photo? {
        guard photos.indices.contains(index) else { return nil }
        return photos[index]
    }

    func formattedDate(for index: Int) -> String {
        guard photos.indices.contains(index) else { return "" }
        return ImagesListDateHelper.string(from: photos[index].createdAt)
    }

    func rowHeight(at index: Int) -> CGFloat {
        guard photos.indices.contains(index), let tableViewWidth = view?.tableViewWidth else {
            return 0
        }
        return ImagesListHeightHelper.calculateRowHeight(
            photoSize: photos[index].size,
            tableViewWidth: tableViewWidth
        )
    }
}

