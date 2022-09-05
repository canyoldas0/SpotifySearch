//
//  SearchResponse.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

struct SearchResponse: Decodable {
    let artists: ArtistInfo
}

struct ArtistInfo: Decodable {
    let items: [ArtistItem]?
}

struct ArtistItem: Decodable {
    let id: String?
    let name: String?
    let images: [ImageInfo]?
}
