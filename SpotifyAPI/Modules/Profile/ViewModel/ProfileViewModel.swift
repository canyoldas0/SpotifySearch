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
    private let authManager: AuthManagerProtocol

    
    init(
        authManager: AuthManagerProtocol,
        profileService: ProfileServiceProtocol
    ) {
        self.authManager = authManager
        self.profileService = profileService
    }
    
    func load() {
        let signedIn = authManager.isSignedIn()
        
        if signedIn {
            callProfileService()
        } else {
            delegate?.handleOutput(.updateView(signedIn: false, data: nil))
        }
    }
    
    func signInClicked() {
        coordinatorDelegate?.goToAuthScreen(animated: true)
    }
    
    private func callProfileService() {
        
        let request = APIRequests.createRequest(from: ProfileRequest())
        
        profileService.fetchProfileData(request: request) { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.handleProfileResponse(for: response)
            case .failure(let error):
                self?.handleError(with: error)
            }
        }
    }
    
    private func handleError(with error: Error) {
        delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: error.localizedDescription)))
    }
    
    private func handleProfileResponse(for response: ProfileResponse) {
        
        let profileData = ProfileViewData(displayName: response.displayName,
                                          imageUrl: response.images.first?.url) { [weak self] in
            self?.authManager.logout()
            self?.coordinatorDelegate?.returnHome(completion: nil)
        }
        delegate?.handleOutput(.updateView(signedIn: true, data: profileData))
    }
}
