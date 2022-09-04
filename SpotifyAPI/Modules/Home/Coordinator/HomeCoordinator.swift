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
    private let homeFactory: HomeFactory
    
    init(dependencies: DependencyContainer) {
        self.dependencyContainer = dependencies
        homeFactory = HomeFactory(dependencyContainer: dependencies)
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
        let signInVC = homeFactory.createSignInScreen(coordinatorDelegate: self)
        let navigationViewController = UINavigationController(rootViewController: signInVC)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", image: nil, primaryAction: .init(handler: { [weak self] _ in
            self?.rootViewController.presentedViewController?.dismiss(animated: true)
        }))
        signInVC.navigationItem.leftBarButtonItem = cancelButton
        signInVC.title = "Sign In"
        
        if let sheet = navigationViewController.sheetPresentationController {
            /// Funny thing. Setting this property to true causes a memory leak.
            //            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 10
            sheet.detents = [.large()]
        }
        
        rootViewController.present(navigationViewController, animated: true)
    }
    
    func goToProfile() {
        let profileVC = homeFactory.createProfileScreen(coordinatorDelegate: self)
        
        if let sheet = profileVC.sheetPresentationController {
            sheet.preferredCornerRadius = 10
            sheet.detents = [.large()]
        }
        
        rootViewController.present(profileVC, animated: true)
    }
    
    func goToDetail(with id: String) {
        let detailVC = DetailViewController()
        rootViewController.show(detailVC, sender: nil)
    }
    
    func goToAuthScreen() {
        let authVC = homeFactory.createAuthView(coordinatorDelegate: self)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", image: nil, primaryAction: .init(handler: { [weak self] _ in
            self?.rootViewController.presentedViewController?.dismiss(animated: true)
        }))
        authVC.navigationItem.leftBarButtonItem = cancelButton
        
        if let sheet = authVC.sheetPresentationController {
            sheet.preferredCornerRadius = 10
            sheet.detents = [.large()]
        }
        rootViewController.presentedViewController?.present(authVC, animated: true)
    }
    
    func returnHome(completion: VoidHandler?) {
        rootViewController.dismiss(animated: true)
        completion?()
    }
}
