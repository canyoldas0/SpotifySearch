//
//  APIRequests.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

import Foundation

class APIRequests {
    
    static func createRequest<T: Encodable>(from data: T) -> APIRequest {
        return URLParameterEncoder.encode(with: data.asDictionary())
    }
}

/// Minimum required type for make a request.
protocol Requestable {
    var queryItems: [URLQueryItem]? { get }
}

/// Holds request parameters through the process.
struct APIRequest: Requestable {
    let queryItems: [URLQueryItem]?
}
