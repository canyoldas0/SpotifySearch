//
//  ProfileViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

final class ProfileViewModel: ProfileViewModelProtocol {
   
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    func signInClicked() {
        coordinatorDelegate?.goToAuthScreen()
    }
}
