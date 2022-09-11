//
//  AppCoordinator.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: ParentCoordinatorDelegate?
    var children: [CoordinatorProtocol] = []
    private(set) var rootViewController: UINavigationController!
    private let dependencyContainer: DependencyContainer
    private let homeCoordinator: HomeCoordinator
    
    init(
        dependencyContainer: DependencyContainer,
        homeCoordinator: HomeCoordinator
    ) {
        self.dependencyContainer = dependencyContainer
        self.homeCoordinator = homeCoordinator
    }
    
    func start() {
        homeCoordinator.start()
        homeCoordinator.parentCoordinator = self
        children.append(homeCoordinator)
        
        rootViewController = homeCoordinator.rootViewController
    }
}
