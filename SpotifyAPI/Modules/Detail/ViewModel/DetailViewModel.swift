//
//  DetailViewModel.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import Foundation

final class DetailViewModel: DetailViewModelProtocol {
    
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    weak var delegate: DetailViewOutputProtocol?
    
    private let itemId: String
    
    private let detailService: DetailServiceProtocol
    
    // MARK: Internal data
    private var headerData: DetailHeaderData? = nil
    private var albumData: AlbumCollectionData? = nil
    
    init(
        itemId: String,
        detailService: DetailServiceProtocol
    ) {
        self.itemId = itemId
        self.detailService = detailService
    }
    
    func load() {
        fetchData()
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        delegate?.handleOutput(.setLoading(true))
        
        let detailRequest = APIRequests.createRequest(from: DetailRequest())
        dispatchGroup.enter()
        detailService.fetchDetailData(itemId: itemId, request: detailRequest) { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.headerData = self?.handleHeaderResponse(with: response)
            case .failure(let error):
                self?.handleError(for: error)
                return
            }
            dispatchGroup.leave()
        }
        
        
        let albumRequest = APIRequests.createRequest(from: AlbumRequest())
        dispatchGroup.enter()
        detailService.fetchArtistAlbumData(itemId: itemId, request: albumRequest) { [weak self] result in
            switch result {
            case .success(let response):
                self?.albumData = self?.handleAlbumResponse(for: response)
            case .failure(let error):
                self?.handleError(for: error)
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            if let headerData {
                self.delegate?.handleOutput(.updateHeader(headerData))
            }
            
            if let albumData {
                delegate?.handleOutput(.updateAlbumData(albumData))
            }
            
            delegate?.handleOutput(.setLoading(false))
        }
    }
    
    
    private func handleError(for error: Error) {
        let message: String = error.localizedDescription
        delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: message, action: self.coordinatorDelegate?.goBack(completion: nil))))
    }
    
    private func handleHeaderResponse(with response: DetailResponse)  -> DetailHeaderData? {
        guard let name = response.name,
              let imageItem = response.images?.first,
              let url = imageItem.url,
              let genres = response.genres?.joined(separator: ", ") else { return nil }
        
        
        return DetailHeaderData(title: name, imageUrl: url, genreTexts: genres)
    }
    
    private func handleAlbumResponse(for response: AlbumResponse) -> AlbumCollectionData {
        
        let imageUrls = response.items.compactMap { album in
            if let count = album.images?.count,
                count > 2 {
                return AlbumCollectionCellData(imageUrl: album.images?[1].url)
            } else {
                return AlbumCollectionCellData(imageUrl: album.images?.last?.url)
            }
        }
        
        return AlbumCollectionData(title: "Albums & Singles", albumUrls: imageUrls)
    }
}
