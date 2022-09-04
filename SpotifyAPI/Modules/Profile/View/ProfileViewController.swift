//
//  ProfileViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class ProfileViewController: UIViewController, ErrorHandlingProtocol {
    
    private var viewModel: ProfileViewModelProtocol!
    
    private let titleLabel: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = ""
        temp.font = .systemFont(ofSize: 16, weight: .semibold)
        temp.textAlignment = .center
        return temp
    }()
    
    private let dismissButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Dismiss", for: .normal)
        temp.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        temp.setTitleColor(.systemBlue, for: .normal)
        return temp
    }()
    
    private lazy var signInButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Sign In.", for: .normal)
        temp.setTitleColor(.label, for: .normal)
        return temp
    }()
    
    convenience init(viewModel: ProfileViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        prepareUI()
    }
    
    private func prepareUI() {
        view.addSubview(titleLabel)
        view.addSubview(dismissButton)
        view.addSubview(signInButton)
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
        
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        dismissButton.addAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
        signInButton.addAction { [weak self] in
            self?.viewModel.signInClicked()
        }
    }
}
