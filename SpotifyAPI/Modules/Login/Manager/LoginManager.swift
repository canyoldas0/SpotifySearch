//
//  LoginManager.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

import Foundation

final class LoginManager {
    
    static let shared = LoginManager()
    
    private init() { }
    
    
    func isLoggedIn() -> Bool {
        return true
    }
}
