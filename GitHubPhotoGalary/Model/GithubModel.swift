//
//  GithubModel.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation

struct GithubModel: Decodable {
    let name, path, sha, url, type: String
    let size: Int
    let htmlURL: String
    let gitURL: String
    let downloadURL: String
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case name, path, sha, url, size, type
        case htmlURL = "html_url"
        case gitURL = "git_url"
        case downloadURL = "download_url"
        case links = "_links"
    }
}

struct Links: Decodable {
    let own: String
    let git: String
    let html: String
    
    enum CodingKeys: String, CodingKey {
        case git, html
        case own = "self"
    }
}
