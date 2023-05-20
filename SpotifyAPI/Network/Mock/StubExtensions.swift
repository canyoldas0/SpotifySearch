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
                       name: "Test Page",
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
        DetailHeaderData(
            title: "Test Page",
            imageUrl: "testUrl",
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

// MARK: AlbumResponse
extension AlbumResponse {
    
    static func stub() -> AlbumResponse {
        AlbumResponse(items: [.stub()])
    }
}

// MARK: AlbumInfo
extension AlbumInfo {
    
    static func stub() -> AlbumInfo {
        AlbumInfo(
            id: "test1",
            name: "testName",
            images: [.stub()], releaseDate: "2013"
        )
    }
}

// MARK: ImageInfo
extension ImageInfo {
    
    static func stub() -> ImageInfo {
        ImageInfo(
            height: 12,
            url: "testUrl",
            width: 12
        )
    }
}

// MARK: ProfileResponse
extension ProfileResponse {
    
    static func stub() -> ProfileResponse {
        ProfileResponse(
            displayName: "testName",
            images: [.stub()],
            followers: .stub()
        )
    }
}

// MARK: ProfileResponse
extension ProfileViewData {
    
    static func stub() -> ProfileViewData {
        ProfileViewData(
            displayName: "testName",
            imageUrl: "testUrl",
            logoutAction: nil
        )
    }
}
