//
//  URLComponents.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import UIKit

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
