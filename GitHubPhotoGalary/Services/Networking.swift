//
//  Networking.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation


class Networking {
    enum NetworkingErrors: String, Error {
        case serverError = "Something wrong on the server"
    }
    
    enum HttpMethods: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let session = URLSession.shared
    
    func load <T: Decodable>(withURL url: URL, token: String?, type: T.Type = T.self, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get.rawValue
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) {(data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let responseModel = try decoder.decode(type, from: data)
                        DispatchQueue.main.async {
                            completion(.success(responseModel))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingErrors.serverError))
                }
            }
        }.resume()
    }
    
    func upload <Type1: Decodable, Type2: Encodable>(withURL url: URL, withData data: Type2, type: Type1.Type, completion: @escaping (Result<Type1, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = HttpMethods.post.rawValue
 
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(data)
            
            let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
                guard let data = data else { return completion(.failure(NetworkError.serverError)) }
                do {
                    let tokenResponseData = try JSONDecoder().decode(type.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(tokenResponseData))
                    }
                    return
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        
    }
}
