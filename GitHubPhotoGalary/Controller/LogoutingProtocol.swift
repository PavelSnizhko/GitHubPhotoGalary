//
//  LogoutingProtocol.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 24.02.2021.
//

import Foundation
import KeychainAccess
import WebKit

protocol Logouting {
    func logOut()
}

extension Logouting {
    func logOut() {
        ImageEntity.clearAllCoreData()
        UserDefaults.standard.set(false, forKey: "activeSession")
        Keychain(service: ProjectConstants.service)["access-token"] = nil
        WKWebView.clean {  }
    }
}
