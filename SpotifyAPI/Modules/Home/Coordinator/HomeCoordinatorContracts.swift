//
//  HomeCoordinatorContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

protocol HomeCoordinatorDelegate: AnyObject {

    func goBack(completion: VoidHandler?)
    func goToLogin()
    func goToProfile()
    func goToDetail(with id: String)
    func goToAuthScreen()
    func returnHome(completion: VoidHandler?)
    func goToRoot(completion: VoidHandler?)
}
