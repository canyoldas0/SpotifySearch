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
    
    init(
        itemId: String,
        detailService: DetailServiceProtocol
    ) {
        self.itemId = itemId
        self.detailService = detailService
    }
    
    func load() {
        // TODO: Zip these requests with DispatchGroup
        callDetailService()
        callAlbumService()
    }
    
    private func callDetailService() {
        
        let request = APIRequests.createRequest(from: DetailRequest())
        
        detailService.fetchDetailData(itemId: itemId, request: request) { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.handleHeaderResponse(with: response)
            case .failure(let error):
                self?.handleError(for: error)
            }
        }
    }
    
    private func callAlbumService() {
        
        let request = APIRequests.createRequest(from: AlbumRequest())
        
        detailService.fetchArtistAlbumData(itemId: itemId, request: request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleAlbumResponse(for: response)
            case .failure(let error):
                self?.handleError(for: error)
            }
        }
    }
    
    private func handleError(for error: Error) {
        let message: String = error.localizedDescription
        delegate?.handleOutput(.showAlert(Alert.buildDefaultAlert(message: message, action: self.coordinatorDelegate?.goBack(completion: nil))))
    }
    
    private func handleHeaderResponse(with response: DetailResponse) {
        if let name = response.name {
            delegate?.handleOutput(.updateTitle(name))
        }
        
        if let imageItem = response.images?.first,
           let url = imageItem.url,
           let genres = response.genres?.joined(separator: ", ")   {
            delegate?.handleOutput(.updateHeader(DetailHeaderData(imageUrl: url, genreTexts: genres)))
        }
    }
    
    private func handleAlbumResponse(for response: AlbumResponse) {
        
        let imageUrls = response.items.compactMap { album in
            if let count = album.images?.count,
                count > 2 {
                return AlbumCollectionCellData(imageUrl: album.images?[1].url)
            } else {
                return AlbumCollectionCellData(imageUrl: album.images?.last?.url)
            }
        }
        
        let collectionData = AlbumCollectionData(title: "Albums & Singles", albumUrls: imageUrls)
        delegate?.handleOutput(.updateAlbumData(collectionData))
    }
}
