//
//  LoginView.swift
//  Eventura(SwiftUI)
//
//  Created by Karthik Ganesh on 19/3/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoginSuccessful = false
    @State private var loginStatus: String? = nil

    private let authenticationManager = AuthenticationManager()
    private let biometricAuthenticationManager = BiometricAuthenticationManager()

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.headline)
                TextField("Username", text: $username)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("Password")
                    .font(.headline)
                    .padding(.top)
                SecureField("Password", text: $password)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }.padding([.leading, .trailing], 40)

            Button(action: {
                if authenticationManager.loginUser(username: username, password: password) {
                    // Successfully logged in, proceed to the app
                    loginStatus = "Login successful"
                    isLoginSuccessful = true
                } else {
                    loginStatus = "Login failed"
                    isLoginSuccessful = false
                }
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing], 40)
            .padding(.top)

            Button(action: {
                biometricAuthenticationManager.authenticateUser { success, message in
                    if success {
                        // Successfully logged in using Face ID, proceed to the app
                        loginStatus = "Login successful"
                        isLoginSuccessful = true
                    } else {
                        showErrorAlert = true
                        errorTitle = "Face ID Authentication Failed"
                        errorMessage = message ?? "An error occurred. Please try again."
                        loginStatus = "Login failed"
                    }
                }
            }) {
                Text("Log In with Face ID")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing], 40)
            .padding(.top)
            .alert(isPresented: $showErrorAlert, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
            
            if let status = loginStatus {
                Text(status)
                    .foregroundColor(isLoginSuccessful ? .green : .red)
            }

            Spacer()
        }
    }
}
