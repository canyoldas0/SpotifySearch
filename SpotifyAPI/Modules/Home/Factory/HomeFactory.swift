//
//  HomeFactory.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit

final class HomeFactory {
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: Home View
    func createHomeView(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let dataHandler = HomeViewDataHandler()
        
        let searchService = SearchService(configuration: dependencyContainer.apiConfiguration)
        
        let homeViewModel = HomeViewModel(
            searchService: searchService,
            dataHandler: dataHandler,
            observationManager: dependencyContainer.observationManager
        )
        
        homeViewModel.coordinatorDelegate = coordinatorDelegate
        
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.title = "Search"
        homeViewController.navigationController?.navigationBar.prefersLargeTitles = true
        
        return homeViewController
    }
    
    // MARK: SignIn Screen
    func createSignInScreen(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let viewModel = SignInViewModel()
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = SignInViewController(viewModel: viewModel)
        
        return viewController
    }
    
    // MARK: Profile Screen
    func createProfileScreen(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        let profileService = ProfileService(configuration: dependencyContainer.apiConfiguration)
        
        let viewModel = ProfileViewModel(
            observationManager: dependencyContainer.observationManager,
            profileService: profileService
        )
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = ProfileViewController(viewModel: viewModel)
        viewController.title = "Profile"
        
        return viewController
    }
    
    // MARK: Authorization Web Screen
    func createAuthView(coordinatorDelegate: HomeCoordinatorDelegate) -> UIViewController {
        
        let viewModel = AuthorizationViewModel()
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = AuthorizationViewController(viewModel: viewModel)
        viewController.title = "Sign In"
        
        return viewController
    }
    
    // MARK: Detail Screen
    func createDetailView(coordinatorDelegate: HomeCoordinatorDelegate, itemId: String) -> UIViewController {
        let detailService = DetailService(configuration: dependencyContainer.apiConfiguration)
        
        let viewModel = DetailViewModel(
            itemId: itemId,
            detailService: detailService
        )
        viewModel.coordinatorDelegate = coordinatorDelegate
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.title = " "
        
        return viewController
    }
}
