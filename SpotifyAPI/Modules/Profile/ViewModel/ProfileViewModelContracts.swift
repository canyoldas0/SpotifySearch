//
//  ProfileViewModelContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

protocol ProfileViewModelProtocol {
    
    var coordinatorDelegate: HomeCoordinatorDelegate? { get }
    var delegate: ProfileViewOutputProtocol? { get set }
    
    func load()
    func signInClicked()
}

protocol ProfileViewOutputProtocol: AnyObject {
    func handleOutput(_ output: ProfileViewOutput)
}

enum ProfileViewOutput: Equatable {
    case showAlert(Alert)
}
