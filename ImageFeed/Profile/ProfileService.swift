//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Тася Галкина on 24.12.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let request = userProfileRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            self.task = nil
            switch result {
            case .success(let object):
                let profile = Profile(decoded: object)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func userProfileRequest(token: String) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func clean() {
        profile = nil
        task = nil
    }
}
