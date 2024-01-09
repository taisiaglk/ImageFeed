//
//  Constants.swift
//  ImageFeed
//
//  Created by Тася Галкина on 05.12.2023.
//

import Foundation

//let AccessKey = "7pRNur9oidnF-ge6-KWsu2yaXD5BND6JSMvQrl4cL5k"
let AccessKey = "kDFo2bjs28JTtNgl9AdjCX9Z7Z_Swi8brL7yRV5QqDE"
//let SecretKey = "ORbfwzNefLMr4JnC55PH-fqZ2-pe5ezngi4_rUMK_uk"
let SecretKey = "iTsMgCI98lXlDkYYm0vQb2D5_d9twQ2cEyKVdAOTGAo"

let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: AccessKey,
                                     secretKey: SecretKey,
                                     redirectURI: RedirectURI,
                                     accessScope: AccessScope,
                                     authURLString: UnsplashAuthorizeURLString,
                                     defaultBaseURL: DefaultBaseURL)
        }
}
