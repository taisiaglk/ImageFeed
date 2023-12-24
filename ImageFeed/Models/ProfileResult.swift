//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Тася Галкина on 24.12.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        case profileImage = "profile_mage"
    }
}
