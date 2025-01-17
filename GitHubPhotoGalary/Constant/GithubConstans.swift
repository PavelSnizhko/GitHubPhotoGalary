//
//  GithubConstans.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import Foundation

enum APIConstants: String {
    case url = "https://api.github.com/repos/PavelSnizhko/imagesStorage/contents/"
    case clientID = "6c3087837186b7a049a1"
    case clientSecret = "4e649b162128471bc27f8357852ac48a668ac901"
    case redirectURI = "GitHubPhotoGalary://authentication"
    case scope = "repo"
}
