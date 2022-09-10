//
//  Session.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation

final class Session {
    
    static let current = Session()
    
    private init() { }
    
    private(set) var keychainService: KeychainService?
    
    func setKeychainService(_ keychain: KeychainService) {
        self.keychainService = keychain
    }
    
    func getAccessToken() -> String? {
        keychainService?.getAccessToken()
    }
    
    func getRefreshToken() -> String? {
        keychainService?.getRefreshToken()
    }
    
    func getExpirationDate() -> Date? {
        keychainService?.getExpirationDate()
    }
}
