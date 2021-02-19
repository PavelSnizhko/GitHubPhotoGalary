//
//  OAthNetworkingService.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 18.02.2021.
//

import Foundation


struct TokenData: Codable {
    let clientId: String
    let clientSecret: String
    let code: String
    let scope: String
    let redirectUrl: String
    let state: String
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectUrl = "redirect_url"
        case scope
        case state
        case code
    }
}



