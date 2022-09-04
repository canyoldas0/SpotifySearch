//
//  LoginViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class SignInViewController: UIViewController, ErrorHandlingProtocol {
    
    private var viewModel: SignInViewModelProtocol!
    
    private lazy var signInButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Sign In.", for: .normal)
        temp.setTitleColor(.label, for: .normal)
        return temp
    }()
    
    convenience init(viewModel: SignInViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        view.backgroundColor = .backgroundColor
        configureButton()
    }
    
    private func configureButton() {
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        signInButton.addAction { [weak self] in
            self?.viewModel.signInClicked()
        }
    }
}
