//
//  ProfileViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

final class ProfileViewModel: ProfileViewModelProtocol {
   
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    weak var delegate: ProfileViewOutputProtocol?
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func load() {
        let signedIn = AuthManager.shared.isSignedIn
        
        if signedIn {
            callProfileService()
        }
    }
    
    func signInClicked() {
        coordinatorDelegate?.goToAuthScreen()
    }
    
    private func callProfileService() {
        
        let request = APIRequests.createRequest(from: ProfileRequest())
        
        profileService.fetchProfileData(request: request) { [weak self] result in
            
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                self?.delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: error.localizedDescription)))
            }
        }
    }
}
