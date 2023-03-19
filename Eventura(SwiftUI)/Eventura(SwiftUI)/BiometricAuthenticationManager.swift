//
//  BiometricAuthenticationManager.swift
//  Eventura(SwiftUI)
//
//  Created by Karthik Ganesh on 19/3/23.
//

import Foundation
import LocalAuthentication

class BiometricAuthenticationManager {
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        }
        return false
    }
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        guard canEvaluatePolicy() else {
            completion(false, "Biometric authentication is not available.")
            return
        }
        
        let reason = "Authenticate with Face ID"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    let message = error?.localizedDescription ?? "Authentication failed"
                    completion(false, message)
                }
            }
        }
    }
}

