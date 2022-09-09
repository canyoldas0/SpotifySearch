//
//  SignInService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

import Foundation

protocol SignInServiceProtocol {
    
    func signIn(with code: String, completion: @escaping GenericHandler<Bool>)
}

final class SignInService: BaseAPI, SignInServiceProtocol {
    
    func signIn(with code: String, completion: @escaping GenericHandler<Bool>) {
//        AuthManager.shared.exchangeCodeForToken(code: code, completion: completion) TODO: 
    }
}
