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
        temp.backgroundColor = .spotifyGreen
        temp.setTitleColor(.white, for: .normal)
        return temp
    }()
    
    private let headerView: BottomsheetHeaderView = {
        let temp = BottomsheetHeaderView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    convenience init(viewModel: SignInViewModelProtocol) {
        self.init()
        view.backgroundColor = .backgroundColor
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
        view.addSubview(headerView)
        
        
        let buttonWidth = "Sign in".size(font: .systemFont(ofSize: 16, weight: .bold)).width + 30
        
        
        NSLayoutConstraint.activate([
            
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 42),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        headerView.setData(data: BottomsheetHeaderData(title: "Sign In", dismissAction: { [weak self] in
            self?.dismiss(animated: true)
        }))
        
        signInButton.roundCorner()
        
        signInButton.addAction { [weak self] in
            self?.viewModel.signInClicked()
        }
    }
}
