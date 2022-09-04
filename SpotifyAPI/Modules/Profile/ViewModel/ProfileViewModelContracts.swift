//
//  ProfileViewModelContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

protocol ProfileViewModelProtocol {
    
    var coordinatorDelegate: HomeCoordinatorDelegate? { get }
    
    func signInClicked()
}

protocol ProfileViewOutputProtocol: AnyObject {
    func handleOutput(_ output: SignInViewOutput)
}

enum ProfileViewOutput: Equatable {
    case showAlert(Alert)
}
