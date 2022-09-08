//
//  URLEncoder.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

import Foundation

typealias Parameters = [String: Any]


struct URLParameterEncoder {
    
    /// This method encodes the properties of an object to query items.
    /// - parameters:
    ///     - parameters: Dictionary to be converted to queries.
    static func encode(with parameters: Parameters) -> APIRequest {
        
        var queryItems = [URLQueryItem]()
        
        if !parameters.isEmpty {
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                queryItems.append(queryItem)
            }
        }
        return APIRequest(queryItems: queryItems)
    }
}
