//
//  LoginViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import UIKit
import WebKit

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
        let oAthService = OAthService(oAthNetworkingService: OAthNetworkingService())
        let imageLoader = ImageLoaderManager(imageNetworkingService: ImageNetworkingService())
        let loginWebViewVC = LoginWebViewViewController(oAthService: oAthService, imageLoader: imageLoader)
        navigationController?.pushViewController(loginWebViewVC, animated: true)
    }
}
