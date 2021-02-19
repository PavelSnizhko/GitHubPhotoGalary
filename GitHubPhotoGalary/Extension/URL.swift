//
//  URL.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 18.02.2021.
//

import UIKit


extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
