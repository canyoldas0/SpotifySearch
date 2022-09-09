//
//  DependencyContainer.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

final class DependencyContainer {
    
    let window: UIWindow
    let apiConfiguration: URLSessionConfiguration
    let observationManager: ObservationManagerProtocol
    let authManager: AuthManager
    
    init(
        window: UIWindow,
        apiConfiguration: URLSessionConfiguration,
        observationManager: ObservationManagerProtocol,
        authManager: AuthManager
    ) {
        self.window = window
        self.apiConfiguration = apiConfiguration
        self.observationManager = observationManager
        self.authManager = authManager
    }
}
