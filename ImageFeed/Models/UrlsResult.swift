//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Тася Галкина on 28.12.2023.
//

import Foundation

struct UrlsResult: Decodable {
    let trumbImageURL: String?
    let largeImageURL: String?

    private enum CodingKeys: String, CodingKey {
        case trumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}
