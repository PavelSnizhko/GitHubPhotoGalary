//
//  GithubApi.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation






//
//class GithubAPI {
//
//let baseUrl = "https://api.github.com"
//
//
//    var defaultHeaders = [
//          "Accept" : "application/vnd.github.v3+json",
//          "Content-Type" : "application/json; charset=utf-8"
//      ]
//
//
//    public func gh_get<T:Decodable>(path: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, completion: @escaping (T?, Error?) -> Swift.Void) {
////           let (newHeaders, newParameters) = self.addAuthenticationIfNeeded(headers, parameters: parameters)
//           self.get(url: self.baseUrl + path, parameters: newParameters, headers: newHeaders) { (data, _, error) in
//               if let data = data {
//                   do {
//                       let model = try GithubAPI.decoder.decode(T.self, from: data)
//                       completion(model, error)
//                   } catch {
//                       completion(nil, error)
//                   }
//               } else {
//                   completion(nil, error)
//               }
//           }
//       }
//
//}
