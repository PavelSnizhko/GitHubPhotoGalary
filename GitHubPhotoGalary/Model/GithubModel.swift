//
//  GithubModel.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation

//{
//        "name": "72975551.cms.jpg",
//        "path": "72975551.cms.jpg",
//        "sha": "73b29c1847b3fe465cdc6165794b4bde84047857",
//        "size": 70016,
//        "url": "https://api.github.com/repos/PavelSnizhko/imagesStorage/contents/72975551.cms.jpg?ref=main",
//        "html_url": "https://github.com/PavelSnizhko/imagesStorage/blob/main/72975551.cms.jpg",
//        "git_url": "https://api.github.com/repos/PavelSnizhko/imagesStorage/git/blobs/73b29c1847b3fe465cdc6165794b4bde84047857",
//        "download_url": "https://raw.githubusercontent.com/PavelSnizhko/imagesStorage/main/72975551.cms.jpg?token=AKUOGJWG47MBBT3BKXVY2TLAGASDQ",
//        "type": "file",
//        "_links": {
//            "self": "https://api.github.com/repos/PavelSnizhko/imagesStorage/contents/72975551.cms.jpg?ref=main",
//            "git": "https://api.github.com/repos/PavelSnizhko/imagesStorage/git/blobs/73b29c1847b3fe465cdc6165794b4bde84047857",
//            "html": "https://github.com/PavelSnizhko/imagesStorage/blob/main/72975551.cms.jpg"
//        }
//    }

struct GithubModels {
    let models: [GithubModel]
}



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
