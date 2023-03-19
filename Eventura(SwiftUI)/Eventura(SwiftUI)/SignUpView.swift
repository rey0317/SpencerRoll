//
//  SignUpView.swift
//  Eventura(SwiftUI)
//
//  Created by Karthik Ganesh on 19/3/23.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var enableFaceID: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""

    private let authenticationManager = AuthenticationManager()
    private let biometricAuthenticationManager = BiometricAuthenticationManager()

    var body: some View {
        VStack {
            Text("Sign Up")
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
                Text("Confirm Password")
                    .font(.headline)
                    .padding(.top)
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Toggle(isOn: $enableFaceID) {
                    Text("Enable Face ID")
                        .font(.headline)
                }
                .padding(.top)
            }.padding([.leading, .trailing], 40)

            Button(action: {
                if password != confirmPassword {
                    showErrorAlert = true
                    errorTitle = "Registration Failed"
                    errorMessage = "Passwords do not match. Please try again."
                } else {
                    let registrationSuccess = authenticationManager.registerUser(username: username, password: password)
                    if registrationSuccess {
                        // Successfully registered, proceed to the app
                    } else {
                        showErrorAlert = true
                        errorTitle = "Registration Failed"
                        errorMessage = "Username already exists. Please try another one."
                    }
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing], 40)
            .padding(.top)
            .alert(isPresented: $showErrorAlert, content: {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })

            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
