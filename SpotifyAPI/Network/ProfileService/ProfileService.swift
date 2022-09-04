//
//  ProfileService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

protocol ProfileServiceProtocol {
    
    func fetchProfileData(completion: @escaping (Result<ProfileResponse,ErrorResponse>) -> Void)
}

final class ProfileService: BaseAPI, ProfileServiceProtocol {
    
    func fetchProfileData(completion: @escaping (Result<ProfileResponse, ErrorResponse>) -> Void) {
        execute(
            endpoint: EndPoints.Profile.currentProfile,
            completion: completion
        )
    }
}
