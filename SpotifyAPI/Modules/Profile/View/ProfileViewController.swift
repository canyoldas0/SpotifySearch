//
//  ProfileViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class ProfileViewController: UIViewController, ErrorHandlingProtocol {
    
    private var viewModel: ProfileViewModelProtocol!
    
    private let headerView: BottomsheetHeaderView = {
        let temp = BottomsheetHeaderView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private lazy var signInButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Sign In.", for: .normal)
        temp.backgroundColor = .spotifyGreen
        temp.setTitleColor(.white, for: .normal)
        return temp
    }()
    
    private lazy var logOutButton: UIButton = {
        let temp = UIButton()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.setTitle("Logout", for: .normal)
        temp.setTitleColor(.red, for: .normal)
        return temp
    }()
    
    convenience init(viewModel: ProfileViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        prepareUI()
        viewModel.load()
    }
    
    private func prepareUI() {
        view.addSubview(headerView)
        view.addSubview(signInButton)
        
        let buttonWidth = "Sign in".size(font: .systemFont(ofSize: 16, weight: .bold)).width + 80
        
        NSLayoutConstraint.activate([
        
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 42),
        
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
                
        headerView.setData(data: BottomsheetHeaderData(title: "Profile", dismissAction: { [weak self] in
            self?.dismiss(animated: true)
        }))
        
        signInButton.addAction { [weak self] in
            self?.viewModel.signInClicked()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.roundCorner()
    }
}

extension ProfileViewController: ProfileViewOutputProtocol {
    
    func handleOutput(_ output: ProfileViewOutput) {
        switch output {
        case .showAlert(let alert):
            showAlert(with: alert)
        }
    }
}
