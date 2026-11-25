//
//  Constants.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 24.11.2026.
//
import Foundation

enum Constants {
    static let accessKey = "uV980Ccubb6nKKZsca0CjRwQbh8xX2_o1OUTUbuzEnE"

    static var secretKey: String {
        guard let rawKey = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_SECRET_KEY") as? String else {
            print("[Constants.secretKey]: UNSPLASH_SECRET_KEY отсутствует в Info.plist")
            return ""
        }

        let trimmedKey = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedKey.isEmpty || trimmedKey.contains("$(UNSPLASH_SECRET_KEY)") {
            print("[Constants.secretKey]: Некорректное или не подставленное значение UNSPLASH_SECRET_KEY: '\(trimmedKey)'")
            return ""
        }

        if trimmedKey.count > 43 {
            print("[Constants.secretKey]: Обнаружена длина \(trimmedKey.count) символов, обрезаем до 43 символов")
            return String(trimmedKey.prefix(43))
        }

        return trimmedKey
    }

    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com"
}

