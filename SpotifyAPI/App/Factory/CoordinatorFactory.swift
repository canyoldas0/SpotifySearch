//
//  CoordinatorFactory.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

final class CoordinatorFactory {
    
    static func buildAppCoordinator(dependencies: DependencyContainer) -> AppCoordinator {
        let homeCoordinator = HomeCoordinator(dependencies: dependencies)
        
        return AppCoordinator(
            dependencyContainer: dependencies,
            homeCoordinator: homeCoordinator
        )
    }
}
