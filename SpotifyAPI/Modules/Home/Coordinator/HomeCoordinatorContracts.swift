//
//  HomeCoordinatorContracts.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

protocol HomeCoordinatorDelegate: AnyObject {
    func goBack(completion: VoidHandler?)
    func goToLogin()
}
