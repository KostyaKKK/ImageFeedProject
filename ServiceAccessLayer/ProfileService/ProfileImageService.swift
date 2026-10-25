//
//  ProfileImageService.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 19.10.2026.
//
import Foundation

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
    
    private enum CodingKeys: String, CodingKey {
        
        case small
        case medium
        case large
    }
}

// MARK: - Models

/// Структура для декодирования ответа Unsplash API (GET /users/:username)
struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}


// MARK: - Service

final class ProfileImageService {
    
    static let shared = ProfileImageService() //синглтон
    private init() { }
    private let tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange") // нотификация
    
    /// Загрузка URL аватарки пользователя
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        // Предотвращение гонки: отменяем предыдущую незавершенную таску
        task?.cancel()
        
        guard let token = tokenStorage.token else {
            print("[ProfileImageService.fetchProfileImageURL]: Error - Auth token is missing")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            print("[ProfileImageService.fetchProfileImageURL]: RequestError - Failed to create URLRequest")
            completion(.failure(AuthServiceError.invalidRequest))
            
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": avatarURL]
                )
                
            case .failure(let error):
                print("[ProfileImageService.fetchProfileImageURL]: Ошибка - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    /// Создание URLRequest для эндпоинта GET /users/:username
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("[ProfileImageService.makeProfileImageRequest]: Failed to create URL for username: \(username)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
