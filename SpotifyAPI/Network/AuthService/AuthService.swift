//
//  AuthService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

protocol AuthServiceProtocol {
    
    var signInUrl: URL? { get }
    
    func retrieveAccessToken(code: String, completion: @escaping (Result<AuthResponse, Error>) -> Void)
    func refreshAccessToken(with token: String, completion: @escaping (Result<AuthResponse, Error>) -> Void)
    func callExecute<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T, Error>) -> Void))
}

final class AuthService: BaseAPI, AuthServiceProtocol {
    
    private enum Constants {
        static let clientID: String = "d98b8be6187d400885a4260f60a801aa"
        static let clientSecret: String = "88f45f19885e4ba695e7901d649377d8"
        static let tokenAPIURL: String = "https://accounts.spotify.com/api/token"
        static let redirectURI: String = "https://www.cyoldas.com/"
        static let grantTypeValue: String = "authorization_code"
    }
    
    /// Sign in URL for Spotify.
    /// Only used for Authorization Page.
    var signInUrl: URL? {
        let scopes = "user-read-private"
        let base = "https://accounts.spotify.com/authorize"
        let str = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: str)
    }
    
    func callExecute<T: Decodable>(request: URLRequest, completion: @escaping ((Result<T, Error>) -> Void)) {
        execute(
            request: request,
            completion: completion
        )
    }
    
    func retrieveAccessToken(code: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let request = try? getRequestForAccessToken(code: code) else {
            return
        }
        execute(
            request: request,
            completion: completion
        )
    }
    
    func refreshAccessToken(with token: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        guard let request = try? getRequestForRefreshToken(token: token) else {
            return
        }
        
        execute(
            request: request,
            completion: completion
        )
    }
}

// MARK:  AuthService Request Helpers

extension AuthService {
    
    private func getRequestForAccessToken(code: String) throws -> URLRequest {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            throw NetworkError.missingURL
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: Constants.grantTypeValue),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        guard let base64string = basicToken.data(using: .utf8)?.base64EncodedString() else {
            throw NetworkError.encodingFailed
        }
        request.setValue("Basic \(base64string)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func getRequestForRefreshToken(token: String) throws -> URLRequest {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            throw NetworkError.missingURL
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: Constants.grantTypeValue),
            URLQueryItem(name: "refresh_token", value: token),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        guard let base64string = basicToken.data(using: .utf8)?.base64EncodedString() else {
            throw NetworkError.encodingFailed
        }
        request.setValue("Basic \(base64string)", forHTTPHeaderField: "Authorization")
        return request
    }
}
