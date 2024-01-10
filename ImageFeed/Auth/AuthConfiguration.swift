//
//  Constants.swift
//  ImageFeed
//
//  Created by Тася Галкина on 05.12.2023.
//

import Foundation

//let AccessKey = "7pRNur9oidnF-ge6-KWsu2yaXD5BND6JSMvQrl4cL5k"
let accessKey = "kDFo2bjs28JTtNgl9AdjCX9Z7Z_Swi8brL7yRV5QqDE"
//let SecretKey = "ORbfwzNefLMr4JnC55PH-fqZ2-pe5ezngi4_rUMK_uk"
let secretKey = "iTsMgCI98lXlDkYYm0vQb2D5_d9twQ2cEyKVdAOTGAo"

let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
let defaultBaseURL = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey1: String
    let secretKey1: String
    let redirectURI1: String
    let accessScope1: String
    let defaultBaseURL1: URL
    let authURLString1: String
    
    init(accessKey1: String, secretKey1: String, redirectURI1: String, accessScope1: String, authURLString1: String, defaultBaseURL1: URL) {
        self.accessKey1 = accessKey1
        self.secretKey1 = secretKey1
        self.redirectURI1 = redirectURI1
        self.accessScope1 = accessScope1
        self.defaultBaseURL1 = defaultBaseURL1
        self.authURLString1 = authURLString1
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey1: accessKey,
                                     secretKey1: secretKey,
                                     redirectURI1: redirectURI,
                                     accessScope1: accessScope,
                                     authURLString1: unsplashAuthorizeURLString,
                                     defaultBaseURL1: defaultBaseURL)
        }
}
