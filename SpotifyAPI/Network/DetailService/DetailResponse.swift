//
//  DetailResponse.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

struct DetailResponse: Decodable {
    let id: String?
    let name: String?
    let genres: [String]?
    let images: [ImageInfo]?
    let followers: FollowerInfo
}

struct FollowerInfo: Decodable {
    let total: Int?
}
