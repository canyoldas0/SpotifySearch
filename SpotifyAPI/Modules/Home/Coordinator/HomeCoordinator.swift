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
        let navigationViewController = UINavigationController(rootViewController: loginViewController)
        
        let skipButton = UIBarButtonItem(title: "Cancel", image: nil, primaryAction: .init(handler: { [weak self] _ in
            self?.rootViewController.dismiss(animated: true)
        }))
        loginViewController.navigationItem.leftBarButtonItem = skipButton
    
        if let sheet = navigationViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 10
            sheet.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.8
            })]
        }
    
        rootViewController.present(navigationViewController, animated: true)
    }
    
    func goToProfile() {
        let profileViewController = ProfileViewController()
        
        if let sheet = profileViewController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 50
            sheet.detents = [.custom(resolver: { context in
                context.maximumDetentValue * 0.8
            })]
        }
        
        rootViewController.present(profileViewController, animated: true)
    }
}
