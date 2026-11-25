//
//  WebViewPresenterProtocol.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 24.11.2026.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
