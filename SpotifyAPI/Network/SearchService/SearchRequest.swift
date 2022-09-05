//
//  SearchRequest.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

struct SearchRequest: Encodable {
    
    private let q: String
    private let type: String
    
    init(searchText: String, type: Itemtype) {
        self.q = searchText
        self.type = type.rawValue
    }
}

enum Itemtype: String {
    case artist
    case track
    case album
}
