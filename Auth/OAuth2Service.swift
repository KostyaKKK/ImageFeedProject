//
//  OAuth2Service.swift.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 01.10.2026.
//
import Foundation

// MARK: - Response Model
nonisolated struct OAuthTokenResponseBody: Decodable, Sendable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

// MARK: - Service
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() {}
    
    // MARK: - Private Methods

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service]: Failed to create URLComponents for OAuth token request")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            print("[OAuth2Service]: Failed to get URL from URLComponents")
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }

    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            let error = NetworkError.invalidRequest
            print("[OAuth2Service.fetchOAuthToken]: Request Error - invalid URLRequest")
            completion(.failure(error))
            return
        }
        
        let task = urlSession.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(responseBody.accessToken))
                } catch {
                    print("[OAuth2Service.fetchOAuthToken]: DecodingError - \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                // Логирование сетевых ошибок и ошибок Unsplash
                print("[OAuth2Service.fetchOAuthToken]: NetworkError/ServiceError - \(error)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
