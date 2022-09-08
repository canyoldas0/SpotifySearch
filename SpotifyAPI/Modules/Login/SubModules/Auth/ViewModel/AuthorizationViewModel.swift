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
    
    
    var signInUrl: URL? = AuthManager.shared.signInUrl
    
    func signInCompleted(code: String) {
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] _ in
            self?.coordinatorDelegate?.returnHome(completion: nil)
        }
    }
}
