//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Тася Галкина on 08.01.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
    
}

class AuthHelper: AuthHelperProtocol {
    func code(from url: URL) -> String? {
            if
               let urlComponents = URLComponents(string: url.absoluteString),
               urlComponents.path == "/oauth/authorize/native",
               let item = urlComponents.queryItems,
               let codeItem = item.first(where: { $0.name == "code" })
            {
                return codeItem.value
            } else {
                return nil
            }
        }
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }

    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString1)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey1),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI1),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope1)
        ]
        return urlComponents.url!
    }
}
