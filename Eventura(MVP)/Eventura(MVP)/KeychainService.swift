import Foundation
import Security

struct KeychainService {
    
    private let publicKeyName = "publicKey"
    private let privateKeyName = "privateKey"
    private let walletAddressName = "walletAddress"
    
    func saveCredentials(publicKey: String, privateKey: String, walletAddress: String) {
        save(key: publicKeyName, value: publicKey)
        save(key: privateKeyName, value: privateKey)
        save(key: walletAddressName, value: walletAddress)
    }
    
    func getCredentials() -> (publicKey: String, privateKey: String, walletAddress: String)? {
        guard let publicKey = load(key: publicKeyName),
              let privateKey = load(key: privateKeyName),
              let walletAddress = load(key: walletAddressName)
        else {
            return nil
        }
        return (publicKey: publicKey, privateKey: privateKey, walletAddress: walletAddress)
    }
    
    func deleteCredentials() {
        delete(key: publicKeyName)
        delete(key: privateKeyName)
        delete(key: walletAddressName)
    }
    
    private func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }
        
        var query = makeQuery(key: key)
        query[kSecValueData as String] = data
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func load(key: String) -> String? {
        var query = makeQuery(key: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            return nil
        }
        
        guard let data = result as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    private func delete(key: String) {
        let query = makeQuery(key: key)
        SecItemDelete(query as CFDictionary)
    }
    
    private func makeQuery(key: String) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        return query
    }
}

