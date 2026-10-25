//
//  OAuth2TokenStorage.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 01.10.2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}

    private enum KeychainKey: String {
        case token = "auth_token"
    }

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: KeychainKey.token.rawValue)
        }
        set {
            guard let newValue = newValue else {

                KeychainWrapper.standard.removeObject(forKey: KeychainKey.token.rawValue)
                return
            }
            
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: KeychainKey.token.rawValue)
            if !isSuccess {
                print("[OAuth2TokenStorage]: Не удалось сохранить токен в Keychain")
            }
        }
    }
}

