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

class OAthService {
    // TODO: create keychain wrapper
    // make private
    var state: String?
    private var onAuthenticationResult: ((Result<String, Error>) -> Void)?
    private var oAthNetworkingService: OAthNetworkngService
    
    init(oAthNetworkingService: OAthNetworkngService) {
        self.oAthNetworkService = oAthNetworkingService
    }
    
    //TODO: change this move state
    func exchangeCodeForToken(url: URL, complition: @escaping (Result<String, Error>) -> Void) {
        guard let code = getCodeFromUrl(url: url), let state = state else {
            return complition(.failure(NetworkError.badURLResponse))
        }
        let tokenData = TokenData(clientId: Constants.clientID.rawValue,
                                  clientSecret: Constants.clientSecret.rawValue,
                                  code: code,
                                  scope: "repo",
                                  redirectUrl: Constants.redirectURI.rawValue,
                                  state: state)
        let urlForToken =
        oAthNetworkingService.loadToken(tokenData: tokenData) { result in
            switch result {
            case .success(let tokenDataResponse):
                print("Token: \(tokenDataResponse.accessToken)")
                complition(.success(tokenDataResponse.accessToken))
            case .failure(let error):
                print(error)
            }      
        }
    }
   
    func getCodeFromUrl(url: URL) -> String? {
        guard let code = url.valueOf("code"), let state = url.valueOf("state"), state == self.state else { return nil}
        return code
    }
}


extension Networking: OAthNetworkngService {
    func loadToken(withURL url: URL, tokenData: TokenData, type:  complition: @escaping ((Result<TokenDataResponse, Error>)) -> Void) {
        guard let url = URLManager.getGithubURL() else { complition(.failure(NetworkError.badURL)) }
        upload(withURL: url, withData: tokenData) { result in
            switch result {
            case .success(let data):
                complition
            }
        }
    }
}
