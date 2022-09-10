//
//  KeychainWrapper.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 9.09.2022.
//

import Foundation

protocol KeychainWrapperProtocol {
    
    func string(for key: String) -> String?
    
    @discardableResult
    func set(_ value: String, for key: String) -> Bool
    
    @discardableResult
    func set<T: Encodable>(_ data: T, for key: String) -> Bool
    
    func get<T: Decodable>(for key: String) -> T?
    
    @discardableResult
    func setDate(_ value: Date, for key: String) -> Bool
    
    func getDate(for key: String) -> Date?
    
    @discardableResult
    func removeObject(for key: String) -> Bool
    
    @discardableResult
    func clear() -> Bool
}


final class KeychanWrapper {
    
    static let standard = KeychanWrapper()
    
    private init() { }
    
    // MARK: Private Methods
    
    @discardableResult
    private func set(_ key: String, value: String) -> Bool {
        if let data = value.data(using: String.Encoding.utf8) {
            return setData(key, value: data)
        }
        
        return false
    }
    
    @discardableResult
    private func set(_ key: String, value: NSCoding) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        return setData(key, value: data)
    }
    
    @discardableResult
    private func setData(_ key: String, value: Data) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: value
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        return status == noErr
    }
    
    private func get(_ key: String)  -> String? {
        guard let data = getData(key) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8) as String?
    }
    
    @discardableResult
    private func delete(_ key: String) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)

        return status == noErr
    }
    
    private func getData(_ key: String) -> Data? {
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
    
    @discardableResult
    private func clearAll() -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
    func getObject(_ key: String) -> NSCoding? {
        guard let data = getData(key) else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSCoding
    }
}

// MARK: KeychainWrapperProtocol Methods

extension KeychanWrapper: KeychainWrapperProtocol {
  
    func string(for key: String) -> String? {
        get(key)
    }
    
    func set(_ value: String, for key: String) -> Bool {
        set(key, value: value)
    }
    
    func set<T>(_ value: T, for key: String) -> Bool where T : Encodable {
        do {
            let data = try JSONEncoder().encode(value)
            return setData(key, value: data)
        } catch {
            return false
        }
    }
    
    func get<T>(for key: String) -> T? where T : Decodable {
        do {
            guard let encodedData = getData(key) else {
                return nil
            }
            
            return try JSONDecoder().decode(T.self, from: encodedData)
        } catch {
            return nil
        }
    }
    
    func setDate(_ value: Date, for key: String) -> Bool {
        set(key, value: value as NSCoding)
    }
    
    func getDate(for key: String) -> Date? {
        getObject(key) as? Date
    }
    
    func removeObject(for key: String) -> Bool {
        delete(key)
    }
    
    func clear() -> Bool {
        clearAll()
    }
}
