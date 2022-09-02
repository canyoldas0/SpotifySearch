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
    private let homeFactory = HomeFactory()

    init(dependencies: DependencyContainer) {
        self.dependencyContainer = dependencies
    }
    
    func start() {
        let homeVC = homeFactory.createHomeView(coordinatorDelegate: self)
        rootViewController = UINavigationController(rootViewController: homeVC)
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
        loginViewController.title = "Login"
    
        if let sheet = navigationViewController.sheetPresentationController {
            /// Funny thing. Setting this property to true causes a memory leak.
//            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 10
            sheet.detents = [.large()]
        }
    
        rootViewController.present(navigationViewController, animated: true)
    }
    
    func goToProfile() {
        let profileViewController = ProfileViewController()
        
        if let sheet = profileViewController.sheetPresentationController {
            sheet.preferredCornerRadius = 10
            sheet.detents = [.large()]
        }
        
        rootViewController.present(profileViewController, animated: true)
    }
    
    func goToDetail(with id: String) {
        let detail = DetailViewController()
        rootViewController.show(detail, sender: nil)
    }
}