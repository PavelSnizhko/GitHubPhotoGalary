//
//  LoginViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import UIKit
import CoreData
import LocalAuthentication

class LoginViewController: UIViewController, Alerting {
    let context = LAContext()
    var error: NSError?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func pressedLoginButton(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "activeSession") {
            provideBiometrics()
        } else {
            configureWebViewController()
        }
        
    }
}

private extension LoginViewController {
    func configureImagesViewController() {
        let dataLoaderManager = DataLoaderManager(imageNetworkingService: ImageNetworkingService(), container: CoreDataStack.shared.container)
        let imagesVC = ImagesViewController(imageLoader: dataLoaderManager)
        self.navigationController?.pushViewController(imagesVC, animated: true)
    }
    
    func configureWebViewController() {
        let oAthService = OAthService(oAthNetworkingService: OAthNetworkingService())
        let loginWebViewVC = LoginWebViewViewController(oAthService: oAthService)
        navigationController?.pushViewController(loginWebViewVC, animated: true)
    }
    
    func provideBiometrics() {
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, _ in
                DispatchQueue.main.async {
                    if success {
                        self?.configureImagesViewController()
                    } else {
                        guard let self = self else { return }
                        self.showAlert(from: self, title: "Authentication failed", message: "You could not be verified; please try again.")
                    }
                }
            }
        } else {
            showAlert(from: self, title: "Access Biometrics on your phone ", message: "Move to settings and change biometrics permission")
        }
    }
}
