//
//  ProfileService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

protocol ProfileServiceProtocol {
    
    func fetchProfileData(request: Requestable, completion: @escaping (Result<ProfileResponse,Error>) -> Void)
}

final class ProfileService: ProxyService, ProfileServiceProtocol {
    
    func fetchProfileData(request: Requestable, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        authManager.fetchData(
            endpoint: EndPoints.Profile.currentProfile,
            requestable: request,
            completion: completion
        )
    }
}
