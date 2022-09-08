//
//  AuthManager.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

final class AuthManager {
    
    private enum Constants {
        static let accessToken: String = "accessToken"
        static let refreshToken: String = "refreshToken"
        static let expirationDate: String = "expirationDate"
        static let extraTime: TimeInterval = 240
    }
    
    static var shared = AuthManager()
    
    var observationManager: ObservationManagerProtocol?
    
    private let authService: AuthServiceProtocol = AuthService(configuration: .default)
    
    var signInUrl: URL? {
        authService.signInUrl
    }
    
    var isSignedIn: Bool {
        accessToken != nil
    }
    
    private var refreshingToken: Bool = false
    private var onRefreshCompletions: [ResponseHandler<String>] = []
    
    private var accessToken: String? {
        UserDefaults.standard.string(forKey: Constants.accessToken)
    }
    
    private var refreshToken: String? {
        UserDefaults.standard.string(forKey: Constants.refreshToken)
    }
    
    private var expirationDate: Date? {
        UserDefaults.standard.object(forKey: Constants.expirationDate) as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate else {
            return true
        }
        
        let currentDate = Date()
        
        return currentDate.addingTimeInterval(Constants.extraTime) >= expirationDate
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping GenericHandler<Bool>) {
        
        authService.retrieveAccessToken(code: code) { [weak self] result in
            
            switch result {
            case .success(let response):
                self?.cacheToken(response: response)
                completion(true)
                self?.notifySignIn(true)
            case .failure(_):
                completion(false)
                self?.notifySignIn(false)
            }
        }
    }
    
    /// This method should be used whenever new API request will be executed.
    /// It passes the valid access token, if the token is expired, it refreshes.
    /// If There are API calls during the token expiration, stores those calls in 'onRefreshCompletions', and when the token is refreshed, completions get executed.
    func withValidToken(completion: @escaping ResponseHandler<String>) {
        guard !refreshingToken else {
            onRefreshCompletions.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessToken { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(.success(token))
                    self?.notifySignIn(true)
                } else {
                    completion(.failure(NetworkError.tokenExpired))
                    self?.notifySignIn(false)
                }
            }
        } else if let token = accessToken {
            completion(.success(token))
        } else {
            completion(.failure(NetworkError.tokenExpired))
        }
    }
    
    private func refreshAccessToken(completion: @escaping GenericHandler<Bool>) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion(false)
            return
        }
        
        refreshingToken = true
        
        authService.refreshAccessToken(with: refreshToken) { [weak self] result in
            guard let self else {
                return
            }
            
            self.refreshingToken = false
            
            switch result {
            case .success(let response):
                // Triggers completions in queue whenever token is renewed.
                self.onRefreshCompletions.forEach { closure in
                    closure(.success(response.accessToken))
                }
                self.onRefreshCompletions.removeAll()
                self.cacheToken(response: response)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    private func cacheToken(response: AuthResponse) {
        UserDefaults.standard.setValue(response.accessToken, forKey: Constants.accessToken)
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(response.expiresIn)), forKey: Constants.expirationDate)
        
        if let refreshToken = response.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: Constants.refreshToken)
        }
    }
    
    /// Cleans the stored tokens.
    /// Notifies observers.
    func logout() {
        removeCaches()
        
        observationManager?.notifyObservers(for: .signedIn, data: false)
    }
    
    /// This function gets called only when it is necessary to remove tokens on the initialization of the app.
    /// Fired once on app start.
    func removeCacheIfNeeded() {
        if shouldRefreshToken {
           removeCaches()
        }
    }
    
    /// Removes cached data.
    private func removeCaches() {
        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
        UserDefaults.standard.removeObject(forKey: Constants.refreshToken)
        UserDefaults.standard.removeObject(forKey: Constants.expirationDate)
    }
    
    private func notifySignIn(_ status: Bool) {
        observationManager?.notifyObservers(for: .signedIn, data: status)
    }
}
