//
//  ImagesListProtocols.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 23.11.2026.
//
import Foundation

protocol ImagesListViewProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var tableViewWidth: CGFloat { get }

    func insertRows(at indexPaths: [IndexPath])
    func reloadCell(at indexPath: IndexPath, isLiked: Bool)
    func setLikeButtonEnabled(_ isEnabled: Bool, at indexPath: IndexPath)
    func openSingleImage(urlString: String)
}

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewProtocol? { get set }
    var photosCount: Int { get }

    func viewDidLoad()
    func didReceivePhotosUpdate()
    func willDisplayRow(at index: Int)
    func didSelectRow(at index: Int)
    func didTapLike(at index: Int)
    func photo(at index: Int) -> Photo?
    func formattedDate(for index: Int) -> String
    func rowHeight(at index: Int) -> CGFloat
}

