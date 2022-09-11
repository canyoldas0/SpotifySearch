//
//  TestKeychainWrapper.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 11.09.2022.
//

import Foundation

final class TestKeychainWrapper: KeychainWrapperProtocol {
        
    private var keychain: [String: Any] = [:]
    
    init() { }
    
    
    func string(for key: String) -> String? {
        guard let stringValue = keychain[key] as? String else {
            return nil
        }
        
        return stringValue
    }
    
    func set(_ value: String, for key: String) -> Bool {
        keychain[key] = value
        return true
    }
    
    func set<T>(_ data: T, for key: String) -> Bool where T : Encodable {
        keychain[key] = data
        return true
    }
    
    func get<T>(for key: String) -> T? where T : Decodable {
        guard let value = keychain[key] as? T else {
            return nil
        }
        
        return value
    }
    
    func setDate(_ value: Date, for key: String) -> Bool {
        keychain[key] = value
        return true
    }
    
    func getDate(for key: String) -> Date? {
        guard let date = keychain[key] as? Date else {
            return nil
        }
        return date
    }
    
    func removeObject(for key: String) -> Bool {
        keychain.removeValue(forKey: key)
        return true
    }
    
    func clear() -> Bool {
        keychain.removeAll()
        return true
    }
    
    
}
