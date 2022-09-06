//
//  SignInViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit
import WebKit

final class AuthorizationViewController: UIViewController, ErrorHandlingProtocol {
    
    private var viewModel: AuthorizationViewModelProtocol!
    
    convenience init(viewModel: AuthorizationViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = viewModel.signInUrl else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

extension AuthorizationViewController: AuthorizationViewOutputProtocol {
    
    func handleOutput(_ output: AuthorizationViewOutput) {
        switch output {
        case .showAlert(let alert):
            showAlert(with: alert)
        }
    }
}

// MARK:  WKNavigationDelegate

extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        guard let component = URLComponents(string: url.absoluteString),
              let code = component.queryItems?.first(where: { $0.name == "code"})?.value else {
            return
        }
        
        viewModel.signInCompleted(code: code)
    }
}
