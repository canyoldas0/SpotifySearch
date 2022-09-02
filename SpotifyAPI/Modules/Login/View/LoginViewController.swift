//
//  LoginViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class LoginViewController: UIViewController, ErrorHandlingProtocol {
    
    deinit {
        print("deinit login")
    }
    
    private lazy var loginButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Click to login", for: .normal)
        temp.setTitleColor(.label, for: .normal)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        view.backgroundColor = .backgroundColor
        configureButton()
    }
    
    private func configureButton() {
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loginButton.addAction {
            print("hello world.")
        }
    }
}
