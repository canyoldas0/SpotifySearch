//
//  SearchRequest.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

struct SearchRequest: Encodable {
    
    private let q: String
    private let type: String
    private let limit: Int
    private let offset: Int
    
    init(
        searchText: String,
        type: Itemtype,
        limit: Int = 20,
        offset: Int
    ) {
        self.q = searchText
        self.type = type.rawValue
        self.limit = limit
        self.offset = offset
    }
}

enum Itemtype: String {
    case artist
    case track
    case album
}
