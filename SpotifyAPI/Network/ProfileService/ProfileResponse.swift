//
//  ProfileResponse.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

struct ProfileResponse: Decodable {
    
    let images: [ImageInfo]
}

struct ImageInfo: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}
