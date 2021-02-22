//
//  OathService.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import Foundation


enum NetworkError: Error {
    case badURLResponse
    case serverError
    case badURL
}

class NetworkHelper {
    enum RequestConstant: String {
        case schema = "https"
        case host = "github.com"
        case path = "/login/oauth/authorize"
    }

    
    static func getUrl() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = RequestConstant.schema.rawValue
        urlComponents.host = RequestConstant.host.rawValue
        urlComponents.path = RequestConstant.path.rawValue
        return urlComponents.url
    }
}

protocol OAthNetworking{
    
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
    


class OAthService {
    // TODO: create keychain wrapper
    // make private
    var state: String?
    private var onAuthenticationResult: ((Result<String, Error>) -> Void)?
    private var oAthNetworkingService: OAthNetworking
    
    init(oAthNetworkingService: OAthNetworking) {
        self.oAthNetworkingService = oAthNetworkingService
    }
    
    //TODO: change this move state
    func exchangeCodeForToken(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let code = getCodeFromUrl(url: url), let state = state else {
            return completion(.failure(NetworkError.badURLResponse))
        }
        let tokenData = TokenData(clientId: GithubConstants.clientID.rawValue,
                                  clientSecret: GithubConstants.clientSecret.rawValue,
                                  code: code,
                                  scope: "repo",
                                  redirectUrl: GithubConstants.redirectURI.rawValue,
                                  state: state)
        guard let url = URLManager.getGithubURL() else { return completion(.failure(NetworkError.badURL)) }
        oAthNetworkingService.uploadTokenData(withURL: url, tokenData: tokenData, type: TokenDataResponse.self) { result in
            switch result {
            case .success(let tokenDataResponse):
                print("Token: \(tokenDataResponse.accessToken)")
                completion(.success(tokenDataResponse.accessToken))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
   
    func getCodeFromUrl(url: URL) -> String? {
        guard let code = url.valueOf("code"), let state = url.valueOf("state"), state == self.state else { return nil}
        return code
    }
}
