//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Тася Галкина on 15.12.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let keychain = KeychainWrapper.standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            keychain.string(forKey: "bearerToken")
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: "bearerToken")
            } else {
                keychain.removeObject(forKey: "bearerToken")
            }
        }
    }
}

