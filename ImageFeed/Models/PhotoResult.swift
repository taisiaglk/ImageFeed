//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Тася Галкина on 28.12.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int?
    let height: Int?
    let isLiked: Bool?
    let welcomeDescription: String?
    let urls: UrlsResult?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case isLiked = "liked_by_user"
        case welcomeDescription = "description"
        case urls = "urls"
    }
}
