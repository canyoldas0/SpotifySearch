//
//  NetworkError.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

public enum NetworkError: String, LocalizedError {
    case decodingFailed = "Problem occured during decoding."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
    case tokenExpired = "Your session is expired. Please sign in again."

    
    public var errorDescription: String? {
        self.rawValue
    }
}
