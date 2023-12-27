//
//  Profile.swift
//  ImageFeed
//
//  Created by Тася Галкина on 24.12.2023.
//

import Foundation

struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(decoded: ProfileResult) {
        self.username = decoded.username
        self.name = decoded.firstName + " " + (decoded.lastName ?? "")
        self.loginName = "@" + decoded.username
        self.bio = decoded.bio
    }
}
