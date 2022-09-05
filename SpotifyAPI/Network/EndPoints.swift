//
//  EndPoints.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

enum EndPoints {
    
    private static let base = "https://api.spotify.com/v1"
    
    enum Profile {
        static let currentProfile = base + "/me"
    }
    
    enum Search {
        static let execute = base + "/search"
    }
}
