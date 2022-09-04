//
//  SignInViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit
import WebKit

final class AuthrorizationViewController: UIViewController, ErrorHandlingProtocol {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    var completionHandler: GenericHandler<Bool>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInUrl else {
            return
        }
        print(url.absoluteString)
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

// MARK:  WKNavigationDelegate

extension AuthrorizationViewController: WKNavigationDelegate { }
