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
    let authManager: AuthManagerProtocol
    
    init(
        window: UIWindow,
        apiConfiguration: URLSessionConfiguration,
        observationManager: ObservationManagerProtocol,
        authManager: AuthManagerProtocol
    ) {
        self.window = window
        self.apiConfiguration = apiConfiguration
        self.observationManager = observationManager
        self.authManager = authManager
    }
}
