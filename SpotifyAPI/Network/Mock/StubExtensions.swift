//
//  StubExtensions.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 10.09.2022.
//

import Foundation

// MARK: STUB - MOCK FOR TESTS

// MARK: DetailResponse
extension DetailResponse {
    
    static func stub() -> DetailResponse {
        DetailResponse(id: "123",
                       name: "Test",
                       genres: ["testGenre"],
                       images: [.stub()],
                       followers: .stub())
    }
}

// MARK:  FollowerInfo
extension FollowerInfo {
    
    static func stub() -> FollowerInfo {
        return .init(total: 23)
    }
}

// MARK: DetailHeaderData
extension DetailHeaderData {
    
    static func stub() -> DetailHeaderData {
        DetailHeaderData(imageUrl: "testUrl",
                         genreTexts: "testGenre")
    }
}

// MARK: AlbumCollectionData
extension AlbumCollectionData {
    
    static func stub() -> AlbumCollectionData {
        AlbumCollectionData(title: "Albums & Singles",
                            albumUrls: [.stub()])
    }
}

// MARK: AlbumCollectionCellData
extension AlbumCollectionCellData {
    
    static func stub() -> AlbumCollectionCellData {
        AlbumCollectionCellData(imageUrl: "testUrl")
    }
}

extension AlbumResponse {
    
    static func stub() -> AlbumResponse {
        AlbumResponse(items: [.stub()])
    }
}

extension AlbumInfo {
    
    static func stub() -> AlbumInfo {
        AlbumInfo(
            id: "test1",
            name: "testName",
            images: [.stub()], releaseDate: "2013"
        )
    }
}

extension ImageInfo {
    
    static func stub() -> ImageInfo {
        ImageInfo(
            height: 12,
            url: "testUrl",
            width: 12
        )
    }
}
