//
//  Networking.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation

class Networking {
    static let shared = Networking()
    
    private init() { }
    
    enum NetworkingErrors: String, Error {
        case serverError = "Something wrong on the server"
        case transportError = "Something wrong on the client"
    }
    
    enum HttpMethods: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let session = URLSession.shared
    
    func load(withURL url: URL, token: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        // two separete load function to have acces to Data type(for image) and custom type
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get.rawValue
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) {(data, response, error) in
            guard error == nil else { return completion(.failure(NetworkingErrors.transportError)) }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data else {
                return completion(.failure(NetworkingErrors.serverError))
            }
            completion(.success(data))
        }.resume()
    }
    
    func upload <T: Encodable>(withURL url: URL, withData data: T, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = HttpMethods.post.rawValue
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(data)
            
            session.uploadTask(with: request, from: jsonData) { data, response, error in
                guard error == nil else { return completion(.failure(NetworkingErrors.transportError)) }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data else {
                    completion(.failure(NetworkError.serverError))
                    return
                }
                completion(.success(data))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
