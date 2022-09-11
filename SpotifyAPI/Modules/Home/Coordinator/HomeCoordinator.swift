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
    
    func goToOnboardingLogin() {
        let signInVC = homeFactory.createSignInScreen(coordinatorDelegate: self)
        
        signInVC.title = "Sign In"
        
//        if let sheet = signInVC.sheetPresentationController {
//            /// Funny thing. Setting this property to true causes a memory leak.
////              sheet.prefersGrabberVisible = false
//            sheet.preferredCornerRadius = 10
//            sheet.detents = [.large()]
//        }
//
        rootViewController.present(signInVC, animated: true)
    }
    
    func goToProfile(animated: Bool) {
        let profileVC = homeFactory.createProfileScreen(coordinatorDelegate: self)
        
        rootViewController.present(profileVC, animated: animated)
    }
    
    func goToDetail(animated: Bool, with id: String) {
        let detailVC = homeFactory.createDetailView(coordinatorDelegate: self, itemId: id)
        rootViewController.pushViewController(detailVC, animated: animated)
    }
    
    func goToAuthScreen(animated: Bool) {
        let authVC = homeFactory.createAuthView(coordinatorDelegate: self)
        
        guard let presentedVC =  rootViewController.presentedViewController else {
            rootViewController.present(authVC, animated: animated)
            return
        }
        
        presentedVC.present(authVC, animated: animated)
    }
    
    func returnHome(completion: VoidHandler?) {
        rootViewController.dismiss(animated: true)
        completion?()
    }
}
