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
    private let observationManager: ObservationManagerProtocol

    
    init(
        observationManager: ObservationManagerProtocol,
        profileService: ProfileServiceProtocol
    ) {
        self.observationManager = observationManager
        self.profileService = profileService
    }
    
    func load() {
        let signedIn = AuthManager.shared.isSignedIn
        
        if signedIn {
            callProfileService()
        } else {
            delegate?.handleOutput(.updateView(signedIn: false, data: nil))
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
                self?.handleProfileResponse(for: response)
            case .failure(let error):
                self?.delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: error.localizedDescription)))
            }
        }
    }
    
    private func handleProfileResponse(for response: ProfileResponse) {
        
        
        var profileData = ProfileViewData(displayName: response.displayName,
                                          imageUrl: response.images.first?.url) { [weak self] in
            self?.observationManager.notifyObservers(for: .signedIn, data: false)
            self?.coordinatorDelegate?.returnHome(completion: nil)
//            AuthManager.shared.logout()
        }
        delegate?.handleOutput(.updateView(signedIn: true, data: profileData))
    }
}
