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
    
    init(
        window: UIWindow,
        apiConfiguration: URLSessionConfiguration
    ) {
        self.window = window
        self.apiConfiguration = apiConfiguration
    }
}
