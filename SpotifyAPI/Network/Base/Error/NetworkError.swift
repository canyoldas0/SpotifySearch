//
//  NetworkError.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

public enum NetworkError: String, Error {
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}