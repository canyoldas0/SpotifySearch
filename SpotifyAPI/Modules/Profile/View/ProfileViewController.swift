//
//  ProfileViewController.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class ProfileViewController: UIViewController, ErrorHandlingProtocol {
    
    private var viewModel: ProfileViewModelProtocol!
    
    // MARK: Views
    
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
    
    private lazy var profileView: ProfileView = {
       let temp = ProfileView()
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    // MARK: Init
    convenience init(viewModel: ProfileViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        prepareUI()
        viewModel.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.roundCorner()
    }
    
    // MARK: Setup UIs
    private func prepareUI() {
        view.addSubview(headerView)        
        
        NSLayoutConstraint.activate([
        
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 42)
        ])
                
        headerView.setData(data: BottomsheetHeaderData(title: "Profile", dismissAction: { [weak self] in
            self?.dismiss(animated: true)
        }))
    }
    
    private func configureLoggedOutView() {
        profileView.removeFromSuperview()
        
        guard !view.subviews.contains(signInButton) else {
            return
        }
        
        view.addSubview(signInButton)
        
        // Calculating button width according to text and add padding from both side.
        let buttonWidth = "Sign in".size(font: .systemFont(ofSize: 16, weight: .bold)).width + 30*2
        
        NSLayoutConstraint.activate([
        
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
        
        signInButton.addAction { [weak self] in
            self?.viewModel.signInClicked()
        }
    }
    
    private func configureProfileView(with data: ProfileViewData) {
        signInButton.removeFromSuperview()
        
        guard !view.subviews.contains(profileView) else {
            return
        }
        
        view.addSubview(profileView)
        
        NSLayoutConstraint.activate([
        
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        profileView.setData(data: data)
    }
    
    private func configureView(for status: Bool, with data: ProfileViewData?) {
        guard status,
            let data else {
            configureLoggedOutView()
            return
        }
        
        configureProfileView(with: data)
    }
}

extension ProfileViewController: ProfileViewOutputProtocol {
    
    func handleOutput(_ output: ProfileViewOutput) {
        switch output {
        case .showAlert(let alert):
            showAlert(with: alert)
        case .updateView(let signedIn, let data):
            configureView(for: signedIn, with: data)
            
        }
    }
}
