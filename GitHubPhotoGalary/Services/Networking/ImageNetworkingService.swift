//
//  ImageNetworkingService.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 22.02.2021.
//

import Foundation


protocol ImageNetworking {
    func loadGithubModels<T: Decodable>(withURL url: URL, token: String?, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func loadImages(withURL string: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class ImageNetworkingService: ImageNetworking {
    func loadGithubModels<T>(withURL url: URL, token: String?, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        Networking.shared.load(withURL: url, token: token) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseModel = try decoder.decode(type, from: data)
                    DispatchQueue.main.async {
                        completion(.success(responseModel))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadImages(withURL string: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: string) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        Networking.shared.load(withURL: url, token: nil, completion: completion)
    }
}
