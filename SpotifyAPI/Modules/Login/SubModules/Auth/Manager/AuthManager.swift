//
//  AuthManager.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

protocol AuthManagerProtocol {
    
    var observationManager: ObservationManagerProtocol { get }

    func isSignedIn() -> Bool
    func getSignInUrl() -> URL?
    func removeCacheIfNeeded()
    func logout()
    func exchangeCodeForToken(code: String, completion: @escaping GenericHandler<Bool>)
    func fetchData<T>(
        endpoint: String,
        httpMethod: HTTPMethod,
        requestable: Requestable,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) where T: Decodable
}

final class AuthManager: AuthManagerProtocol {
    
    private enum Constants {
        static let accessToken: String = "accessToken"
        static let refreshToken: String = "refreshToken"
        static let expirationDate: String = "expirationDate"
        static let extraTime: TimeInterval = 240
    }
        
    private(set) var observationManager: ObservationManagerProtocol
    private let authService: AuthServiceProtocol
        
    init(
        observationManager: ObservationManagerProtocol,
        authService: AuthServiceProtocol
    ) {
        self.observationManager = observationManager
        self.authService = authService
    }
    
    private var signInUrl: URL? {
        authService.signInUrl
    }
    
    private var refreshingToken: Bool = false
    private var onRefreshCompletions: [ResponseHandler<String>] = []
    
    
    // MARK: Session Properties -
    
    private var accessToken: String? {
        Session.current.getAccessToken()
    }

    private var refreshToken: String? {
        Session.current.getRefreshToken()
    }

    private var expirationDate: Date? {
        Session.current.getExpirationDate()
    }
    
    func isSignedIn() -> Bool {
        accessToken != nil
    }
    
    func getSignInUrl() -> URL? {
        signInUrl
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate else {
            return true
        }
        
        let currentDate = Date()
        
        return currentDate.addingTimeInterval(Constants.extraTime) >= expirationDate
    }
    
    // MARK: Network Calls
    
    /// This method is used to make a service call with authorized token.
    /// Every Sub services needs to pass through this to get valid token to make successful request.
    /// - parameters:
    ///     - endpoint: Endpoint of the URL without the query parameters.
    ///     - httpMethod: HTTP method type of the request.
    ///     - requestable: Model that contains query items.
    ///     - completion: Returns result type. Generic type.
    func fetchData<T>(
        endpoint: String,
        httpMethod: HTTPMethod = .GET,
        requestable: Requestable,
        completion: @escaping ((Result<T, Error>) -> Void)
    ) where T: Decodable {

        createRequest(from: endpoint, for: httpMethod, with: requestable) { [weak self] result in
            
            switch result {
            case .success(let urlRequest):
                self?.authService.callExecute(
                    request: urlRequest,
                    completion: completion
                )
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// Authorization method. Exchanges the code with the accessTokens when authorization completed.
    /// - Parameters:
    /// - code: Authorization code that comes from Spotify.
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
    
    
    /// Whenever refreshing needed for the token, this method will be executed.
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
    
    /// Storing exchanged tokens for the current session.
    private func cacheToken(response: AuthResponse) {
        Session.current.keychainService?.saveAccessToken(response.accessToken)
        
        if let refreshToken = response.refreshToken {
            Session.current.keychainService?.saveRefreshToken(refreshToken)
        }
        
        Session.current.keychainService?.saveExpirationDate(Date().addingTimeInterval(TimeInterval(response.expiresIn)))
    }
    
    /// Cleans the stored tokens and ends the active session.
    /// Notifies observers.
    func logout() {
        removeCaches()
        
        observationManager.notifyObservers(for: .signedIn, data: false)
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
        Session.current.keychainService?.clear()
        notifySignIn(false)
    }
    
    /// Common method to notify observers for signIn status.
    /// - parameters:
    /// - status: New SignIn status. If user signed in it should be true.
    private func notifySignIn(_ status: Bool) {
        observationManager.notifyObservers(for: .signedIn, data: status)
    }
    
    /// Creates request with the valid accessToken and necessary queries.
    /// - parameters:
    ///     - endpoint: URL endpoint for the request.
    ///     - type: HTTP type for the request.
    ///     - requestable: Request model that can contain query parameters.
    ///     - completion: Final URLRequest is given to completion block.
    private func createRequest(
        from endpoint: String,
        for type: HTTPMethod,
        with requestable: Requestable,
        completion: @escaping ResponseHandler<URLRequest>
    ) {
        withValidToken { result in
            guard let url = URL(string: endpoint) else {
                return
            }
            
            switch result {
            case .success(let token):
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    urlComponents.queryItems = requestable.queryItems
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = type.rawValue
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    request.url = urlComponents.url
                    
                    completion(.success(request))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
