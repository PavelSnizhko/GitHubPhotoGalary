//
//  AlertingProtocol.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import UIKit

protocol Alerting {
    func showErrorAlert(from viewController: UIViewController, title: String, message: String)
}

extension Alerting {

    func showErrorAlert(from viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak viewController] (_) in
            viewController?.dismiss(animated: false, completion: nil)
            viewController?.navigationController?.popToRootViewController(animated: true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
