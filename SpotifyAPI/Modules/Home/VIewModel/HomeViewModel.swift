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
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol,
        dataHandler: HomeViewDataHandlerProtocol
    ) {
        self.profileService = profileService
        self.dataHandler = dataHandler
    }
    
    func load() {
        let signedIn = AuthManager.shared.isSignedIn
        if !signedIn {
            coordinatorDelegate?.goToLogin()
        }
        callProfileService()
        delegate?.handleOutput(.updateProfileIcon(signedIn))
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
