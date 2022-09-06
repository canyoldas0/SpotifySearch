//
//  AlbumResponse.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//


struct AlbumResponse: Decodable {
    
    let items: [AlbumInfo]
}

struct AlbumInfo: Decodable {
    
    let id: String
    let name: String?
    let images: [ImageInfo]?
    let releaseDate: String?
}
