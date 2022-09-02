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
}

protocol HomeViewOutputProtocol: AnyObject {
    func handleOutput(_ output: HomeViewOutput)
}

enum HomeViewOutput: Equatable {
//    case updateTable
    case showAlert(Alert)
}
