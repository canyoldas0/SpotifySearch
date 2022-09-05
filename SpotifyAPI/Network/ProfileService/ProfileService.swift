//
//  ProfileService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

protocol ProfileServiceProtocol {
    
    func fetchProfileData(request: Requestable, completion: @escaping (Result<ProfileResponse,ErrorResponse>) -> Void)
}

final class ProfileService: BaseAPI, ProfileServiceProtocol {
    
    func fetchProfileData(request: Requestable, completion: @escaping (Result<ProfileResponse, ErrorResponse>) -> Void) {
        execute(
            endpoint: EndPoints.Profile.currentProfile,
            requestable: request,
            completion: completion
        )
    }
}
