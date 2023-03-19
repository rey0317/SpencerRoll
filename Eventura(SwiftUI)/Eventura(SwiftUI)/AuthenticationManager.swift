import Foundation
import Security

class AuthenticationManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    @Published var walletAddress: String = ""
    @Published var privateKey: String = ""

    func registerUser(username: String, password: String, walletAddress: String, privateKey: String) -> Bool {
        guard !username.isEmpty, !password.isEmpty else {
            return false
        }
        
        let userExists = getUserPassword(username: username) != nil
        guard !userExists else {
            return false
        }

        setUserPassword(username: username, password: password)
        setUserWalletAddress(username: username, walletAddress: walletAddress)
        setUserPrivateKey(username: username, privateKey: privateKey)

        return true
    }

    func loginUser(username: String, password: String) -> Bool {
        guard let storedPassword = getUserPassword(username: username) else {
            return false
        }

        return password == storedPassword
    }

    private func setUserPassword(username: String, password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "eventura.com",
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    private func getUserPassword(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "eventura.com",
            kSecAttrAccount as String: username,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let passwordData = result as? Data else {
            return nil
        }

        return String(data: passwordData, encoding: .utf8)
    }

    private func setUserWalletAddress(username: String, walletAddress: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "eventura.com",
            kSecAttrAccount as String: "\(username)_walletAddress",
            kSecValueData as String: walletAddress.data(using: .utf8)!
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    private func setUserPrivateKey(username: String, privateKey: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "eventura.com",
            kSecAttrAccount as String: "\(username)_privateKey",
            kSecValueData as String: privateKey.data(using: .utf8)!
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    func logoutUser() {
        isLoggedIn = false
        username = ""
        walletAddress = ""
        privateKey = ""
    }
}

