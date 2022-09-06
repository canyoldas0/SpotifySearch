//
//  Authorization'Contracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

import Foundation

protocol AuthorizationViewModelProtocol {
    
    var coordinatorDelegate: HomeCoordinatorDelegate? { get }
    var delegate: AuthorizationViewOutputProtocol? { get set }
    
    var signInUrl: URL? { get }
    
    func signInCompleted(code: String)
}

protocol AuthorizationViewOutputProtocol: AnyObject {
    func handleOutput(_ output: AuthorizationViewOutput)
}

enum AuthorizationViewOutput: Equatable {
    case showAlert(Alert)
}
