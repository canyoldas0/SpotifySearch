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
    
    private let observationManager: ObservationManagerProtocol
    
//    var signInUrl: URL? = AuthManager.shared.signInUrl
    
    init(
        observationManager: ObservationManagerProtocol
    ) {
        self.observationManager = observationManager
    }
    
    func signInCompleted(code: String) {
        coordinatorDelegate?.returnHome(completion: nil)
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            if success {
//                self?.observationManager.notifyObservers(for: .signedIn, data: success)
            }
        }
    }
}
