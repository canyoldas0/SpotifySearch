//
//  ProfileService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

protocol ProfileServiceProtocol {
    
    func fetchProfileData(request: Requestable, completion: @escaping (Result<ProfileResponse,Error>) -> Void)
}

final class ProfileService: BaseAPI, ProfileServiceProtocol {
    
    func fetchProfileData(request: Requestable, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        execute(
            endpoint: EndPoints.Profile.currentProfile,
            requestable: request,
            completion: completion
        )
    }
}
