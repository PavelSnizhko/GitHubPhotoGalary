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

class OAthService {
    private(set) var state: String?
    private var onAuthenticationResult: ((Result<String, Error>) -> Void)?
    private var oAthNetworkingService: OAthNetworking
    
    init(oAthNetworkingService: OAthNetworking) {
        self.oAthNetworkingService = oAthNetworkingService
        self.state = UUID().uuidString
    }
    
    func exchangeCodeForToken(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let code = getCodeFromUrl(url: url), let state = state else {
            return completion(.failure(NetworkError.badURLResponse))
        }
        let tokenData = TokenData(clientId: APIConstants.clientID.rawValue,
                                  clientSecret: APIConstants.clientSecret.rawValue,
                                  code: code,
                                  scope: "repo",
                                  redirectUrl: APIConstants.redirectURI.rawValue,
                                  state: state)
        guard let url = URLManager.getGithubURL() else { return completion(.failure(NetworkError.badURL)) }
        oAthNetworkingService.uploadTokenData(withURL: url, tokenData: tokenData, type: TokenDataResponse.self) { result in
            switch result {
            case .success(let tokenDataResponse):
                completion(.success(tokenDataResponse.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
   
    func getCodeFromUrl(url: URL) -> String? {
        guard let code = url.valueOf("code"), let state = url.valueOf("state"), state == self.state else { return nil}
        return code
    }
}
