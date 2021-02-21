//
//  ImageLoaderManager .swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation


protocol ImageNetworkingService {
//    func load <T: Decodable>(withURL url: URL, token: String?, type: T.Type = T.self, completion: @escaping (Result<T, Error>)
    func loadGithubModels(withURL url: URL, token: String?, type: [GithubModel].Type, completion: @escaping (Result<[GithubModel], Error>) -> Void)
}

class ImageLoaderManager {
    let imageTypesSet: Set<String> = ProjectConstants.fileTypes
    let imageNetworkingService: ImageNetworkingService
    init(imageNetworkingService: ImageNetworkingService) {
        self.imageNetworkingService = imageNetworkingService
    }
    // TODO: replace on wrapperKey
    func getImages(token: String) {
        let url = "https://api.github.com/repos/PavelSnizhko/imagesStorage/contents/"
        imageNetworkingService.loadGithubModels(withURL: URL(string: url)!, token: token, type: [GithubModel].self) {[weak self]  result in
            switch result {
            case .success(let models):
                // TODO: thow further and handle it
                print(self?.filterGithubModels(from: models))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterGithubModels(from githubModels: [GithubModel]) -> [GithubModel] {
        var imageModels = Array<GithubModel>()
        githubModels.forEach { model in
            let fileName = model.name
            if let lastDotIndex = fileName.lastIndex(of: ".") {
                let fileType = String(fileName[lastDotIndex..<fileName.endIndex])
                if imageTypesSet.contains(fileType) {
                    imageModels.append(model)
                }
            }
        }
        return imageModels
    }
}

extension Networking: ImageNetworkingService {
    func loadGithubModels(withURL url: URL, token: String?, type: [GithubModel].Type, completion: @escaping (Result<[GithubModel], Error>) -> Void) {
        load(withURL: url, token: token, type: type) { (result) in
            switch result {
            case .success(let models):
                completion(.success(models))
                print(models)
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
