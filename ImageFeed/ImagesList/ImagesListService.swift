//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Тася Галкина on 28.12.2023.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let perPage = "10"
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let storageToken = OAuth2TokenStorage()

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = storageToken.token else { return }

        guard let request = imageListRequest(token,
                                             page: String(nextPage),
                                             perPage: perPage
        ) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil

                switch result {
                case .success(let photoResult):
                    for photoResult in photoResult {
                                            let photo = Photo(decoded: photoResult)
                                            self.photos.append(photo)
                                        }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos] )
                case .failure(let error):
                    assertionFailure("Failed to receive photo \(error)")
                }
            }
        }
        self.task = task
        task.resume()
    }

    private func imageListRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&&per_page=\(perPage)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

}
