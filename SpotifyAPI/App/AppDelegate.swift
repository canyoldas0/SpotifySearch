//
//  AppDelegate.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dependencyContainer: DependencyContainer!
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let apiConfiguration = URLSessionConfiguration.default
        apiConfiguration.waitsForConnectivity = true
        apiConfiguration.timeoutIntervalForResource = 350
        apiConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        dependencyContainer = DependencyContainer(window: window, apiConfiguration: apiConfiguration)
        
        appCoordinator = CoordinatorFactory.buildAppCoordinator(dependencies: dependencyContainer)
        appCoordinator?.start()
                
        window.rootViewController = appCoordinator?.rootViewController
        window.makeKeyAndVisible()
        return true
    }

}

