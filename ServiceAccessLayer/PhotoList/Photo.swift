//
//  Photo.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 30.10.2026.
//
import Foundation
import CoreGraphics

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    private static let dateFormatter: ISO8601DateFormatter = { return ISO8601DateFormatter()
        
    }()
    
    init(
        id: String,
        size: CGSize,
        createdAt: Date?,
        welcomeDescription: String?,
        thumbImageURL: String,
        largeImageURL: String,
        isLiked: Bool
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
    
    init(result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        
        if let createdAtString = result.createdAt {
            self.createdAt = Photo.dateFormatter.date(from: createdAtString)
        } else {
            self.createdAt = nil
        }
        
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
    }
}
