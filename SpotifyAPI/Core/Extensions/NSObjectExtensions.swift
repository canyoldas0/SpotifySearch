//
//  NSObjectExtensions.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import Foundation

extension NSObject {
    
    static var identifier: String {
        String(describing: self)
    }
}
