//
//  SignInViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//


final class SignInViewModel: SignInViewModelProtocol {
 
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    func signInClicked() {
        coordinatorDelegate?.goToAuthScreen()
    }
}
