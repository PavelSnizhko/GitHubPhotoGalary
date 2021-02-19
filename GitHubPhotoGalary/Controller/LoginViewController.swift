//
//  LoginViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 17.02.2021.
//

import UIKit
import WebKit


//todo: move to another module
enum Constants: String {
    case clientID = "6c3087837186b7a049a1"
    case clientSecret = "4e649b162128471bc27f8357852ac48a668ac901"
    case redirectURI = "GitHubPhotoGalary://authentication"
    case scope = "repo"
}

class LoginViewController: UIViewController, Alerting {
    //todo replace to keyChainWrapper
    private var token: String?
    private var oAthService: OAthService
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
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
        view.addSubview(webView)
        launchWebView()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func authorizeApp() {
        webView.isHidden = false
        // todo: move to some network helper
        oAthService.state = UUID().uuidString
        guard let state = oAthService.state, let url = URLManager.getGithubURL(state: state) else {
            showErrorAlert(from: self, title: "Ooops", message: "Something wrong")
            return
        }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }

    @IBAction func pressedLoginButton(_ sender: Any) {
        authorizeApp()
    }
}

private extension LoginViewController {
    
    func launchWebView() {
        webView.isHidden = true
        webView.navigationDelegate = self
    }
}

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // githubphotogalary://authentication?code=3892207108d306ecdba8&state=A86A82D1-C791-4700-AE84-6D48AA97AC5B
        guard let url = navigationAction.request.url else { decisionHandler(.allow); return }
        if url.absoluteString.contains(Constants.redirectURI.rawValue.lowercased()), url.absoluteString.contains("code") {
            oAthService.exchangeCodeForToken(url: url) { result in
                switch result {
                case .success(let token):
                    self.token = token
                    print("URA toke" + token)
                    decisionHandler(.cancel)
                    self.showErrorAlert(from: self, title: "token", message: token)
                    webView.isHidden = true
                case .failure(let error):
                    self.showErrorAlert(from: self, title: "Error", message: error.localizedDescription)
                    webView.isHidden = true
                    print("Fuck error \(error)")
                }
            }
        }
        else {
            decisionHandler(.allow)
        }
    }
}

