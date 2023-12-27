//
//  UserResult.swift
//  ImageFeed
//
//  Created by Тася Галкина on 24.12.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

