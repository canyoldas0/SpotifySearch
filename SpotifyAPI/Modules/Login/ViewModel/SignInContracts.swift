//
//  SignInContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

protocol SignInViewModelProtocol {
    
    var coordinatorDelegate: HomeCoordinatorDelegate? { get }
    
    func signInClicked()
}

protocol SignInViewOutputProtocol: AnyObject {
    func handleOutput(_ output: SignInViewOutput)
}

enum SignInViewOutput: Equatable {
    case showAlert(Alert)
}
