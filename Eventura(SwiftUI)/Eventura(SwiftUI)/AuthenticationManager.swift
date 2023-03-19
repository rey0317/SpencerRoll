//
//  AuthenticationManager.swift
//  Eventura(SwiftUI)
//
//  Created by Karthik Ganesh on 19/3/23.
//

import Foundation
import Security

class AuthenticationManager {
    private let keychainWrapper = KeychainWrapper()
    
    // Register a new user
    func registerUser(username: String, password: String) -> Bool {
        if let _ = keychainWrapper.readPassword(username: username) {
            return false
        } else {
            keychainWrapper.storePassword(username: username, password: password)
            return true
        }
    }
    
    // Log in the user
    func loginUser(username: String, password: String) -> Bool {
        if let storedPassword = keychainWrapper.readPassword(username: username) {
            return storedPassword == password
        }
        return false
    }
}

class KeychainWrapper {
    func storePassword(username: String, password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error storing password: \(status)")
        }
    }
    
    func readPassword(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        return nil
    }
}
