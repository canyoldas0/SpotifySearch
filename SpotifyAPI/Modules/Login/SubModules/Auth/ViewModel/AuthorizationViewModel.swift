//
//  AuthorizationViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

import Foundation

final class AuthorizationViewModel: AuthorizationViewModelProtocol {
    
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    weak var delegate: AuthorizationViewOutputProtocol?
    
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        signInUrl = authManager.signInUrl
    }

    var signInUrl: URL?
    
    func signInCompleted(code: String) {
        
        authManager.exchangeCodeForToken(code: code) { [weak self] _ in
            self?.coordinatorDelegate?.returnHome(completion: nil)
        }
    }
}
