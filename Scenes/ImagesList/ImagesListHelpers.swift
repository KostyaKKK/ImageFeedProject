//
//  ImagesListHelpers.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 23.11.2026.
//
import Foundation
import CoreGraphics

enum ImagesListDateHelper {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    static func string(from date: Date?) -> String {
        guard let date else { return "" }
        return formatter.string(from: date)
    }
}

enum ImagesListHeightHelper {
    static func calculateRowHeight(
        photoSize: CGSize,
        tableViewWidth: CGFloat,
        imageInsets: CGFloat = 32, // 16 left + 16 right
        verticalInsets: CGFloat = 8 // 4 top + 4 bottom
    ) -> CGFloat {
        let imageViewWidth = tableViewWidth - imageInsets
        guard photoSize.width > 0, imageViewWidth > 0 else { return 0 }

        let scale = imageViewWidth / photoSize.width
        return photoSize.height * scale + verticalInsets
    }
}

