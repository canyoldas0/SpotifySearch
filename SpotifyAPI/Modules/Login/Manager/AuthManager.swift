//
//  AuthManager.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

final class AuthManager {
    
    /// These Private keys can be stored in a configuration file which can be in gitignore for safety.
    private enum Constants {
        static let clientID: String = "d98b8be6187d400885a4260f60a801aa"
        static let clientSecret: String = "88f45f19885e4ba695e7901d649377d8"
    }
    
    static let shared = AuthManager()
    
    var signInUrl: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://www.cyoldas.com/"
        let base = "https://accounts.spotify.com/authorize"
        let str = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)"
        return URL(string: str)
    }
    
    private init() { }
    
    func isLoggedIn() -> Bool {
        return true
    }
    
    func handleSignIn(for state: Bool) {
        
    }
}
