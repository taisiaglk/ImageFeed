//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Тася Галкина on 28.12.2023.
//

import Foundation

class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    static let shared = ImagesListService()
     init() {}
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
                        self.photos.append(self.decodedResult(photoResult))
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
    
    // я не очень понимаю, почему оображение не работает, как в учебнике  поэтому сделала через userdefaults
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        guard let token = storageToken.token else { return }
        guard let request = likeRequst(token,
                                       photoId: photoId,
                                       httpMethod: isLike ? "DELETE" : "POST"
        ) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task = nil
                
                switch result {
                case .success(let photoResult):
                    if let index = self.photos.firstIndex(where: { $0.id == photoResult.photo?.id }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked)
                        self.photos = {
                            var photos = ImagesListService.shared.photos
                            photos.replaceSubrange(index...index, with: [newPhoto])
                            return photos
                        }()
                        
                        UserDefaults.standard.set(newPhoto.isLiked, forKey: newPhoto.id)
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
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
    
    private func likeRequst(_ token: String, photoId: String, httpMethod: String) -> URLRequest? {
        let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func decodedResult(_ photoResult: PhotoResult) -> Photo {
        return Photo.init(id: photoResult.id,
                          size: CGSize(width: photoResult.width ?? 0, height: photoResult.height ?? 0),
                          createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt ?? ""),
                          welcomeDescription: photoResult.welcomeDescription,
                          thumbImageURL: photoResult.urls?.trumbImageURL,
                          largeImageURL: photoResult.urls?.largeImageURL,
                          isLiked: photoResult.isLiked ?? false)
    }
    
    func clean() {
        task = nil
        photos = []
        lastLoadedPage = nil
    }
    
}
