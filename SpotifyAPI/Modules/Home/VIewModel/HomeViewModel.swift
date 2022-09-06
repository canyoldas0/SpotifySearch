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
    private let searchService: SearchServiceProtocol
    
    private var searchListData: [ListViewCellData] = []
    
    init(
        profileService: ProfileServiceProtocol,
        searchService: SearchServiceProtocol,
        dataHandler: HomeViewDataHandlerProtocol,
        observationManager: ObservationManagerProtocol
    ) {
        self.profileService = profileService
        self.searchService = searchService
        self.dataHandler = dataHandler
        self.observationManager = observationManager
    }
    
    func load() {
        let signedIn = AuthManager.shared.isSignedIn
        delegate?.handleOutput(.updateProfileIcon(signedIn))
        
        if signedIn {
            callProfileService()
        }
        
        callListService()
        
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
    
    private func callListService() {
        
        let request = APIRequests.createRequest(from: SearchRequest(searchText: "Muse", type: .artist))
        
        searchService.search(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleSearchListResponse(response: response)
                self?.delegate?.handleOutput(.updateTable)
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
    
    private func handleSearchListResponse(response: SearchResponse) {
        guard let list = response.artists.items else {
            delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: "Missing Data")))
            return
        }
        
        searchListData = list.compactMap({ item in
            ListViewCellData(
                id: item.id,
                imageUrl: item.images?.first?.url,
                title: item.name
            )
        })
    }
}

extension HomeViewModel: ItemProviderProtocol {
    
    func getNumberOfItems(in section: Int) -> Int {
        searchListData.count
    }
    
    func itemSelected(at index: Int) {
        guard let id = searchListData[index].id else {
            delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: "Problem occurred during encoding the item id. Please try again.")))
            return
        }
        coordinatorDelegate?.goToDetail(with: id)
    }
    
    func askData(for index: Int) -> DataProtocol? {
        searchListData[index]
    }
}
