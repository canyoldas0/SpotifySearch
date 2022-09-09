//
//  ProxyService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation

class ProxyService {
    
    var authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
}
