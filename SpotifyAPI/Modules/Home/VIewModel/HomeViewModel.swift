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
    
    private let searchService: SearchServiceProtocol
    
    private var searchListData: [ListViewCellData] = []
    
    private var latestSearchText: String? {
        didSet {
            resetForNewRequest()
        }
    }
    
    // MARK: Pagination Info Properties
    
    private var offset: Int = 0
    private var total: Int = 0
    private var limit: Int = 20
    private var isFetching: Bool = false
    
    init(
        searchService: SearchServiceProtocol,
        dataHandler: HomeViewDataHandlerProtocol,
        observationManager: ObservationManagerProtocol
    ) {
        self.searchService = searchService
        self.dataHandler = dataHandler
        self.observationManager = observationManager
        
        observationManager.subscribe(name: .signedIn, observer: self) { [weak self] data in
            guard let signedIn = data as? Bool else {
                return
            }

            if signedIn {
                self?.callListService(with: self?.latestSearchText)
            } else {
                self?.coordinatorDelegate?.goToLogin()
            }
            self?.delegate?.handleOutput(.updateProfileIcon(signedIn))
        }
    }
    
    func load() {
        let signedIn = AuthManager.shared.isSignedIn
        delegate?.handleOutput(.updateProfileIcon(signedIn))
        
        if signedIn {
            callListService(with: latestSearchText)
        } else {
            coordinatorDelegate?.goToLogin()
        }
    }
    
    func searchTracks(with text: String) {
        latestSearchText = text
        callListService(with: text)
    }
    
    func profileClicked() {
        coordinatorDelegate?.goToProfile()
    }
    
    // MARK: Search List Service
    
    private func callListService(with text: String?, pagination: Bool = false) {
        guard let text,
              !text.isEmpty else {
            return
        }
        
        // Request Model
        let request = APIRequests.createRequest(from: SearchRequest(
            searchText: text,
            type: .artist,
            limit: limit,
            offset: offset
        ))
        
        searchService.search(request: request) { [weak self] result in
            
            // If request is called for pagination, it keeps the current list.
            // If it's not for pagination, then it means it's a new search and previously fetched data gets removed the list.
            if !pagination {
                self?.searchListData.removeAll()
            }
            
            switch result {
            case .success(let response):
                self?.handleSearchListResponse(response: response)
            case .failure(let error as NetworkError):
                self?.delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: error.rawValue)))
            default:
                break
            }
        }
    }
}

// MARK:  Pagination Methods

extension HomeViewModel {
    
    /// Resets pagination fields and previosly fetched data.
    private func resetForNewRequest() {
        offset = 0
        total = 0
    }
    
    /// Moving to next offset if user asks for more data.
    private func nextOffset() {
        isFetching = true
        offset += limit
    }
}

// MARK: Response Handlers

extension HomeViewModel {
    
    /// Handles successful search list response.
    private func handleSearchListResponse(response: SearchResponse) {
        guard let list = response.artists.items else {
            delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: "Missing Data")))
            return
        }
        
        self.isFetching = false
        
        searchListData.append(contentsOf: list.compactMap({ item in
            ListViewCellData(
                id: item.id,
                imageUrl: item.images?.first?.url,
                title: item.name
            )
        }))
        
        delegate?.handleOutput(.updateTable)
        
        self.total = response.artists.total
        self.offset = response.artists.offset
        self.limit = response.artists.limit
        
    }
}

// MARK:  Item Provider Protocol

extension HomeViewModel: ItemProviderProtocol {
 
    /// Returns number of items will be displayed in the list.
    func getNumberOfItems(in section: Int) -> Int {
        searchListData.count
    }
    
    /// Triggers when list item is selected.
    func itemSelected(at index: Int) {
        guard let id = searchListData[index].id else {
            delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: "Problem occurred during encoding the item id. Please try again.")))
            return
        }
        coordinatorDelegate?.goToDetail(with: id)
    }
    
    func askData(for index: Int) -> GenericDataProtocol? {
        searchListData[index]
    }
    
    /// Checks & fetches more data if user scrolls to the bottom.
    func getMoreData() {
        guard limit <= total && !isFetching else {
            return
        }
        nextOffset()
        callListService(with: latestSearchText, pagination: true)
    }
    
    func isLoadingCell(for index: Int) -> Bool {
        return index + 1 >= searchListData.count
    }
}
