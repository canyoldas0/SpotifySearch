//
//  KeychainService.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation

struct KeychainService {
    
    private enum Key: String {
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
        case expirationDate = "expirationDate"
    }
    
    let wrapper: KeychainWrapperProtocol
    
    init(wrapper: KeychainWrapperProtocol) {
        self.wrapper = wrapper
    }
    
    func saveAccessToken(_ token: String) {
        wrapper.set(token, for: Key.accessToken.rawValue)
    }
    
    func saveRefreshToken(_ token: String) {
        wrapper.set(token, for: Key.refreshToken.rawValue)
    }
    
    func saveExpirationDate(_ date: Date) {
        wrapper.setDate(date, for: Key.expirationDate.rawValue)
    }
    
    func getAccessToken() -> String? {
        wrapper.string(for: Key.accessToken.rawValue)
    }
    
    func getRefreshToken() -> String? {
        wrapper.string(for: Key.refreshToken.rawValue)
    }
    
    func getExpirationDate() -> Date? {
        wrapper.getDate(for: Key.expirationDate.rawValue)
    }
}
