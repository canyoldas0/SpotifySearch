//
//  HomeCoordinator.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class HomeCoordinator: CoordinatorProtocol, HomeCoordinatorDelegate {
    
    var parentCoordinator: ParentCoordinatorDelegate?
    var children: [CoordinatorProtocol] = []
    private(set) var rootViewController: UINavigationController!
    private let dependencyContainer: DependencyContainer

    init(dependencies: DependencyContainer) {
        self.dependencyContainer = dependencies
    }
    
    func start() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.title = "Search"
        homeViewModel.coordinatorDelegate = self
        rootViewController = UINavigationController(rootViewController: homeViewController)
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    func goBack(completion: VoidHandler? = nil) {
        rootViewController.popViewController(animated: true)
        completion?()
    }
    
    func goToLogin() {
        let loginViewController = LoginViewController()
        
        if let sheet = loginViewController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.8
            })]
        }
        rootViewController.present(loginViewController, animated: true)
    }
}
