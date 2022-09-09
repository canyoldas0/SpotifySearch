//
//  KeychainWrapper.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation

final class KeychanWrapper {
    
    static let standard = KeychanWrapper()
    
    private init() { }
    
    @discardableResult
    func set(_ key: String, value: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return setData(key, value: data)
        }
        
        return false
    }
    
    @discardableResult
    func setData(_ key: String, value: Data) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: value
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        return status == noErr
    }
    
    @discardableResult
    func delete(_ key: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)

        return status == noErr
    }
    
    func getData(_ key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]
        
        var result: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        return status == noErr ? result as? Data : nil
    }
    
    func getObject(_ key: String) -> NSCoding? {
        guard let data = getData(key) else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSCoding
    }
}
