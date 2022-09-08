//
//  DetailService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 6.09.2022.
//

protocol DetailServiceProtocol {
    
    func fetchDetailData(itemId: String, request: Requestable, completion: @escaping (Result<DetailResponse,Error>) -> Void)
    func fetchArtistAlbumData(itemId: String, request: Requestable, completion: @escaping (Result<AlbumResponse,Error>) -> Void)

}

final class DetailService: BaseAPI, DetailServiceProtocol {
  
    func fetchDetailData(
        itemId: String,
        request: Requestable,
        completion: @escaping (Result<DetailResponse, Error>) -> Void
    ) {
        execute(
            endpoint: EndPoints.Artist.detail(itemId).getEndpoint(),
            requestable: request,
            completion: completion
        )
    }
    
    func fetchArtistAlbumData(
        itemId: String,
        request: Requestable,
        completion: @escaping (Result<AlbumResponse, Error>) -> Void
    ) {
        execute(
            endpoint: EndPoints.Artist.albums(itemId).getEndpoint(),
            requestable: request,
            completion: completion
        )
    }
}
