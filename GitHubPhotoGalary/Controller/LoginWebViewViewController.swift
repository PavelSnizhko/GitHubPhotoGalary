//
//  LoginWebViewViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 21.02.2021.
//

import UIKit
import WebKit
import KeychainAccess

class LoginWebViewViewController: UIViewController, Alerting {
    private var token: String?
    private var oAthService: OAthService
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            prefs.allowsContentJavaScript = true
        }
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    init(oAthService: OAthService) {
        self.oAthService = oAthService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = webView
        launchWebView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authorizeApp()
    }
   
    func authorizeApp() {
        // todo: move to some network helper
        
        guard let state = oAthService.state, let url = URLManager.getGithubURL(state: state) else {
            showAlert(from: self, title: "Ooops", message: "Something wrong or state is not the same")
            return
        }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }

}

private extension LoginWebViewViewController {
    
    func launchWebView() {
        webView.navigationDelegate = self
    }
}

extension LoginWebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { decisionHandler(.allow); return }
        if url.absoluteString.contains(APIConstants.redirectURI.rawValue.lowercased()), url.absoluteString.contains("code") {
            oAthService.exchangeCodeForToken(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    let keychain = Keychain(service: ProjectConstants.service)
                    keychain["access-token"] = token
                    let imagesViewController = ImagesViewController(imageLoader: DataLoaderManager(imageNetworkingService: ImageNetworkingService(), container: CoreDataStack.shared.container))
                    UserDefaults.standard.setValue(true, forKey: "activeSession")
                    self.navigationController?.pushViewController(imagesViewController, animated: true)
                    decisionHandler(.cancel)

                case .failure(let error):
                    self.showAlert(from: self, title: "Error", message: error.localizedDescription)
                    webView.isHidden = true
                    print("Fuck error \(error)")
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
