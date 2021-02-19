//
//  ViewControllerExtension.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 18.02.2021.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
