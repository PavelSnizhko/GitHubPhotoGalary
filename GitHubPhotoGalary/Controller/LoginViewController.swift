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

class LoginViewController: UIViewController {
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
        webView.isHidden = true
        launchWebViewDelegation()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func authorizeApp() {
        webView.isHidden = false
        // todo: move to some network helper
        oAthService.state = UUID().uuidString
           var myURL = URLComponents()
            myURL.scheme = "https"
            myURL.host = "github.com"
            myURL.path = "/login/oauth/authorize"
            myURL.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.clientID.rawValue),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI.rawValue),
                URLQueryItem(name: "scope", value: Constants.scope.rawValue),
                URLQueryItem(name: "state", value: oAthService.state)
            ]
            // TODO: not force unwraping
            let myRequest = URLRequest(url: myURL.url!)
                
            webView.load(myRequest)
        }

    @IBAction func pressedLoginButton(_ sender: Any) {
        authorizeApp()
    }
}

private extension LoginViewController {
    
    func launchWebViewDelegation() {
        webView.navigationDelegate = self
    }
}

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // githubphotogalary://authentication?code=3892207108d306ecdba8&state=A86A82D1-C791-4700-AE84-6D48AA97AC5B
        if let url = navigationAction.request.url {
            if url.absoluteString.contains(Constants.redirectURI.rawValue.lowercased()), url.absoluteString.contains("code") {
                print("fsafsdfsa")
                oAthService.exchangeCodeForToken(url: url) { result in
                    switch result {
                    case .success(let token):
                        print("URA toke" + token)
                        
                    case .failure(let error):
                        print("Fuck error \(error)")
                    }
            }
            decisionHandler(.allow)
            
        }
        else {
            decisionHandler(.allow)
        }
    }
  }
}
