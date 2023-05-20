//
//  HomeViewModelContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

protocol HomeViewModelProtocol {
    
    var coordinatorDelegate: HomeCoordinatorDelegate? { get }
    var delegate: HomeViewOutputProtocol? { get set }
    
    func load()
    func profileClicked()
    func searchTracks(with text: String?)
    func moreMenuClicked()
}

protocol HomeViewOutputProtocol: AnyObject {
    func handleOutput(_ output: HomeViewOutput)
}

enum HomeViewOutput: Equatable {
    case setLoading(Bool)
    case updateTable
    case showAlert(Alert)
    case updateProfileIcon(Bool)
}
