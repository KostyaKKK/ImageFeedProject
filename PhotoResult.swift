//
//  PhotoResult.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 30.10.2026.
//
import Foundation

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
struct LikeResult: Decodable {
    let photo: PhotoResult
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id, description, width, height, urls
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
    }
}
