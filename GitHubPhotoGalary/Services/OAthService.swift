//
//  OathService.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import Foundation

enum RequestConstant: String {
    case schema = "https"
    case host = "github.com"
    case path = "/login/oauth/authorize"
}

enum NetworkError: Error {
    case badURLResponse
    case serverError
    case badURL
}


class NetworkHelper {
    static func getUrl() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = RequestConstant.schema.rawValue
        urlComponents.host = RequestConstant.host.rawValue
        urlComponents.path = RequestConstant.path.rawValue
        return urlComponents.url
    }
}


protocol OAthNetworkingService {
    func loadToken(withURL url: URL, tokenData: TokenData, completion: @escaping ((Result<TokenDataResponse, Error>)) -> Void)
}


class OAthService {
    // TODO: create keychain wrapper
    // make private
    var state: String?
    private var onAuthenticationResult: ((Result<String, Error>) -> Void)?
    private var oAthNetworkingService: OAthNetworkingService
    
    init(oAthNetworkingService: OAthNetworkingService) {
        self.oAthNetworkingService = oAthNetworkingService
    }
    
    //TODO: change this move state
    func exchangeCodeForToken(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let code = getCodeFromUrl(url: url), let state = state else {
            return completion(.failure(NetworkError.badURLResponse))
        }
        let tokenData = TokenData(clientId: Constants.clientID.rawValue,
                                  clientSecret: Constants.clientSecret.rawValue,
                                  code: code,
                                  scope: "repo",
                                  redirectUrl: Constants.redirectURI.rawValue,
                                  state: state)
        guard let url = URLManager.getGithubURL() else { return completion(.failure(NetworkError.badURL)) }
        oAthNetworkingService.loadToken(withURL: url, tokenData: tokenData) { result in
            switch result {
            case .success(let tokenDataResponse):
                print("Token: \(tokenDataResponse.accessToken)")
                completion(.success(tokenDataResponse.accessToken))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }      
        }
    }
   
    func getCodeFromUrl(url: URL) -> String? {
        guard let code = url.valueOf("code"), let state = url.valueOf("state"), state == self.state else { return nil}
        return code
    }
}


extension Networking: OAthNetworkingService {
    
    func loadToken(withURL url: URL, tokenData: TokenData, completion: @escaping (Result<TokenDataResponse, Error>) -> Void) {
        upload(withURL: url, withData: tokenData, type: TokenDataResponse.self) { result in
            switch result {
            case .success(let tokenDataResponse):
                completion(.success(tokenDataResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
