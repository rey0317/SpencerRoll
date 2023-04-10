//
//  LoginView.swift
//  Eventura(MVP)
//
//  Created by Rey Ng on 4/8/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = true
    @State private var errorMessage: String?
    @EnvironmentObject private var authenticationManager: AuthenticationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isLoggingIn ? "Log In" : "Sign Up")
                .font(.largeTitle)
                .bold()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button(isLoggingIn ? "Log In" : "Sign Up") {
                if isLoggingIn {
                    authenticationManager.login(withEmail: email, password: password) { success, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        }
                    }
                } else {
                    authenticationManager.signup(withEmail: email, password: password) { success, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            Button(isLoggingIn ? "Don't have an account? Sign up" : "Already have an account? Log in") {
                isLoggingIn.toggle()
            }
        }
        .padding()
    }
}
