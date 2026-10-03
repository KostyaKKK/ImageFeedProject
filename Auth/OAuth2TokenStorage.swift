//
//  Untitled.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 01.10.2026.
//

import Foundation

final class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                userDefaults.set(token, forKey: Keys.token.rawValue)
            } else {
                userDefaults.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
}
