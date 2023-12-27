//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Тася Галкина on 24.12.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let storageToken = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    private init() {}
    
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = imageRequest(token: storageToken.token!, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let userResult):
                let largeProfileImage = userResult.profileImage.large
                self.avatarURL = largeProfileImage
                completion(.success(self.avatarURL!))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL" : self.avatarURL as Any])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func imageRequest(token: String, username: String) -> URLRequest {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

