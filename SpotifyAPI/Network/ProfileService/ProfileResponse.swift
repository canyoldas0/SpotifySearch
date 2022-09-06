//
//  ProfileResponse.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

struct ProfileResponse: Decodable {
    
    let displayName: String?
    let images: [ImageInfo]
    let followers: FollowerInfo
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case images
        case followers
    }
}

