//
//  HomeFactory.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit

final class HomeFactory {
    
    func createHomeView(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let dataHandler = HomeViewDataHandler()
        
        let homeViewModel = HomeViewModel(dataHandler: dataHandler)
        homeViewModel.coordinatorDelegate = coordinatorDelegate
        
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.title = "Search"
        homeViewController.navigationController?.navigationBar.prefersLargeTitles = true
        return homeViewController
    }
}
