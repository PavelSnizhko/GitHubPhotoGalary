//
//  OAthNetworking.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 22.02.2021.
//

import Foundation

protocol OAthNetworking {
    
    func uploadTokenData <Type1: Decodable, Type2: Encodable>(withURL url: URL, tokenData data: Type2, type: Type1.Type, completion: @escaping (Result<Type1, Error>) -> Void)
}

class OAthNetworkingService: OAthNetworking {

    func uploadTokenData <Type1: Decodable, Type2: Encodable>(withURL url: URL, tokenData data: Type2, type: Type1.Type, completion: @escaping (Result<Type1, Error>) -> Void) {
        Networking.shared.upload(withURL: url, withData: data) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponseData = try JSONDecoder().decode(type.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(tokenResponseData))
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
}
