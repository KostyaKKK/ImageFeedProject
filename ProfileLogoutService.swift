//
//  ProfileLogoutService.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 04.11.2026.
//
import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanToken()
    }
    
    private func cleanCookies() {
        // Очищаем куки HTTPCookieStorage
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        // Очищаем все данные и сессии WKWebsiteDataStore (WKWebView)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanToken() {
        OAuth2TokenStorage.shared.token = nil
    }
}
