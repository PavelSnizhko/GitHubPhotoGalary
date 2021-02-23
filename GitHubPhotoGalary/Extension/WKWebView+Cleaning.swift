//
//  WKWebView+Cleaning.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 23.02.2021.
//

import WebKit

extension WKWebView {

    class func clean(completion :  (() -> Void)?) {
        
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let group = DispatchGroup()
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                group.enter()
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    group.leave()
                })
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
            group.notify(queue: DispatchQueue.main) {
                completion?() //
            }
        }
    }
}
