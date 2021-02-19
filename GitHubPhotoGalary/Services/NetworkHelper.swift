//
//  NetworkHelper.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 18.02.2021.
//

import Foundation


class URLManager {

    static let scheme = "https"
    static let host = "github.com"
    static let path = "/login/oauth/access_token"
    
    static func getGithubURL(forTokenPath path: String = path, host: String = host, scheme: String = scheme) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        return urlComponents.url
    }
    
    static func getGithubURL(state: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/login/oauth/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientID.rawValue),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.rawValue),
            URLQueryItem(name: "scope", value: Constants.scope.rawValue),
            URLQueryItem(name: "state", value: state)
        ]
        
        return urlComponents.url
    }
    
}
