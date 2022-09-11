//
//  ProxyService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation

/// Base class for data related services such as: Detail, Search, Profile...
class ProxyService {
    
    var authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
}
