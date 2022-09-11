//
//  HomeCoordinatorContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

protocol HomeCoordinatorDelegate: AnyObject {

    func goBack(completion: VoidHandler?)
    func goToOnboardingLogin()
    func goToProfile(animated: Bool)
    func goToDetail(animated: Bool, with id: String)
    func goToAuthScreen(animated: Bool)
    func returnHome(completion: VoidHandler?)
}
