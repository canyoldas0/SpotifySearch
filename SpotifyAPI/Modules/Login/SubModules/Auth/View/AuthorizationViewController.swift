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
    
    private let headerView: BottomsheetHeaderView = {
        let temp = BottomsheetHeaderView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    convenience init(viewModel: AuthorizationViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
        
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 42),
        
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        headerView.setData(data: BottomsheetHeaderData(title: "Sign In", dismissAction: { [weak self] in
            self?.dismiss(animated: true)
        }))
        
        guard let url = viewModel.signInUrl else {
            return
        }
        webView.load(URLRequest(url: url))
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
