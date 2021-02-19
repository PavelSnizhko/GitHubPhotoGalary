//
//  OAthNetworkingService.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 18.02.2021.
//

import Foundation


struct TokenData: Codable {
    let clientId: String
    let clientSecret: String
    let code: String
    let scope: String
    let redirectUrl: String
    let state: String
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectUrl = "redirect_url"
        case scope
        case state
        case code
    }
}


struct TokenDataResponse: Codable {
    let accessToken: String
    let tokenType: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}


// todo delete this

//
//class OAthNetworkingService {
//   private enum HttpMethods: String {
//        case get = "GET"
//        case post = "POST"
//    }
//
//    private let session = URLSession.shared
//
//    func sendRequestToServer(tokenData: TokenData, complition: @escaping ((Result<TokenDataResponse, Error>)) -> Void) {
//
//        //TODO: refactor move to abstarct
//        var myURL = URLComponents()
//        myURL.scheme = "https"
//        myURL.host = "github.com"
//        myURL.path = "/login/oauth/access_token"
//        guard let url = myURL.url else { return }
//
//        var request = URLRequest(url: url)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpMethod = HttpMethods.post.rawValue
//
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let jsonData = try encoder.encode(tokenData)
//            print(String(data: jsonData, encoding: .utf8)!)
//
//            let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
//                print(data)
//                guard let data = data else { return complition(.failure(NetworkError.serverError)) }
//                do {
//
//                    let tokenResponseData = try JSONDecoder().decode(TokenDataResponse.self, from: data)
//
//                    complition(.success(tokenResponseData))
//                    return
//                } catch {
//                    print(error.localizedDescription)
//                    complition(.failure(error))
//                }
//            }
//            task.resume()
//        }
//        catch {
//            complition(.failure(error))
//        }
//    }
//}
//
//
