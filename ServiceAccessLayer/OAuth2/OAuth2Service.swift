//
//  OAuth2Service.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 01.10.2026.
//

import Foundation

// MARK: - Error Types
enum AuthServiceError: Error {
    case invalidRequest
    case missingSecretKey
}

// MARK: - Models
private struct OAuthTokenResponseBody: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

// MARK: - Service
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private let dataStorage = OAuth2TokenStorage.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var authToken: String? {
        get {
            return dataStorage.token
        }
        set {
            dataStorage.token = newValue
        }
    }
    
    private init() { }
    
    func clean() {
        assert(Thread.isMainThread)
        task?.cancel()
        task = nil
        lastCode = nil
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            print("[OAuth2Service.fetchOAuthToken]: InvalidRequest - Duplicate code [code: \(code)]")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[OAuth2Service.fetchOAuthToken]: RequestError - Failed to create URLRequest [code: \(code)]")
            self.lastCode = nil
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        // Логирование параметров запроса перед отправкой
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("[OAuth2Service Request Body]: \(bodyString)")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.task = nil
                self.lastCode = nil
                
                switch result {
                case .success(let body):
                    print("[OAuth2Service Success]: Token successfully obtained!")
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    print("[OAuth2Service.fetchOAuthToken]: NetworkError - \(error) [code: \(code)]")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let secretKey = Constants.secretKey, !secretKey.isEmpty else {
            print("[OAuth2Service.makeOAuthTokenRequest]: Error - secretKey is nil or empty!")
            return nil
        }
        
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("Failed to create URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to get URL from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Переносим собранную строку запроса в httpBody для формата application/x-www-form-urlencoded
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
