//
//  LoginViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import UIKit
import WebKit
import CoreData

class LoginViewController: UIViewController {

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
        // TODO: maybe make login view controller under protocol
        if UserDefaults.standard.bool(forKey: "activeSession") {
            // use face id
            //load from cache
            navigationController?.pushViewController(ImagesViewController(imageLoader: DataLoaderManager(imageNetworkingService:
                                                                                                            ImageNetworkingService(), container: CoreDataStack.shared.container)), animated: true)
        } else {
            let oAthService = OAthService(oAthNetworkingService: OAthNetworkingService())
            let loginWebViewVC = LoginWebViewViewController(oAthService: oAthService)
            navigationController?.pushViewController(loginWebViewVC, animated: true)
        }
        
    }
}
