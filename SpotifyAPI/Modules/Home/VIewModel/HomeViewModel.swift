//
//  HomeViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewOutputProtocol?
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    private let dataHandler: HomeViewDataHandlerProtocol
    private let observationManager: ObservationManagerProtocol
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol,
        dataHandler: HomeViewDataHandlerProtocol,
         observationManager: ObservationManagerProtocol
    ) {
        self.profileService = profileService
        self.dataHandler = dataHandler
        self.observationManager = observationManager
    }
    
    func load() {
        let signedIn = AuthManager.shared.isSignedIn
        delegate?.handleOutput(.updateProfileIcon(signedIn))
        
        if signedIn {
            callProfileService()
        }
        
        observationManager.subscribe(name: .signedIn, observer: self) { [weak self] data in
            guard let signedIn = data as? Bool else {
                return
            }
            
            if signedIn {
                self?.callProfileService()
            } else {
                self?.coordinatorDelegate?.goToLogin()
            }
            self?.delegate?.handleOutput(.updateProfileIcon(signedIn))
        }
        
        delegate?.handleOutput(.updateTable)
    }
    
    func profileClicked() {
        coordinatorDelegate?.goToProfile()
    }
    
    // MARK: Profile Call
    private func callProfileService() {
        
        profileService.fetchProfileData { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.handleProfileResponse(for: response)
            case .failure(let error):
                self?.delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: error.localizedDescription)))
            }
        }
    }
}

// MARK: Response Handlers

extension HomeViewModel {
    
    private func handleProfileResponse(for response: ProfileResponse) {
        guard let url = response.images.first?.url else {
            return
        }
        delegate?.handleOutput(.setImageUrl(url))
    }
}

extension HomeViewModel: ItemProviderProtocol {
    
    func getNumberOfItems(in section: Int) -> Int {
        return 3
    }
    
    func itemSelected(at index: Int) {
        coordinatorDelegate?.goToDetail(with: "3")
    }
    
    func askData(for index: Int) -> DataProtocol? {
        ListViewCellData(imageUrl: "https://picsum.photos/200", title: "Hello")
    }
}
