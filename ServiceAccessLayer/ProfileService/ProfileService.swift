//
//  ProfileService.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 19.10.2026.
//
import Foundation

// MARK: - Models
struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    }
struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}


// MARK: - Service

final class ProfileService {
    static let shared = ProfileService()
    private init() { }
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        task?.cancel()

        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            
            switch result {
            case .success(let profileResult):
                let firstName = profileResult.firstName ?? ""
                let lastName = profileResult.lastName ?? ""
                let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                
                let profile = Profile(
                    username: profileResult.username,
                    name: fullName.isEmpty ? profileResult.username : fullName,
                    loginName: "@\(profileResult.username)",
                    bio: profileResult.bio
                )
                
                self.profile = profile
                completion(.success(profile))
                
            case .failure(let error):
                print("[ProfileService.fetchProfile]: NetworkError - \(error.localizedDescription) [token: \(token)]")
                completion(.failure(error))
            
            }
        }

        self.task = task
        task.resume()
    }

    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
