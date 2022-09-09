//
//  SearchService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

protocol SearchServiceProtocol {
    
    func search(request: Requestable, completion: @escaping (Result<SearchResponse,Error>) -> Void)
}

final class SearchService: ProxyService, SearchServiceProtocol {
    
    func search(request: Requestable, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        authManager.fetchData(endpoint: EndPoints.Search.execute,
                requestable: request,
                completion: completion)
    }
}
