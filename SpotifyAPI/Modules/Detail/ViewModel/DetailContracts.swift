//
//  DetailContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

import Foundation

protocol DetailViewModelProtocol {
    
    var coordinatorDelegate: HomeCoordinatorDelegate? { get }
    var delegate: DetailViewOutputProtocol? { get set }
    
    func load()
}

protocol DetailViewOutputProtocol: AnyObject {
    func handleOutput(_ output: DetailViewOutput)
}

enum DetailViewOutput: Equatable {
    case showAlert(Alert)
    case updateAlbumData(AlbumCollectionData)
    case updateTitle(String)
    case updateHeader(DetailHeaderData)
}
