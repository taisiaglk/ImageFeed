//
//  Photo.swift
//  ImageFeed
//
//  Created by Тася Галкина on 28.12.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool

    init(decoded: PhotoResult) {
        self.id = decoded.id
        self.size = CGSize(width: decoded.width ?? 0, height: decoded.height ?? 0)
        self.createdAt = dateFormatter.date(from: decoded.createdAt ?? "")
        self.welcomeDescription = decoded.welcomeDescription
        self.thumbImageURL = decoded.urls?.trumbImageURL
        self.largeImageURL = decoded.urls?.largeImageURL
        self.isLiked = decoded.isLiked ?? false
    }

}
