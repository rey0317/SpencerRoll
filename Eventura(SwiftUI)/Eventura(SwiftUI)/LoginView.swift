import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showCameraView: Bool = false

    private let authenticationManager = AuthenticationManager()
    private let biometricAuthenticationManager = BiometricAuthenticationManager()

    var body: some View {
        NavigationView {
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
                        // Successfully logged in, show success message
                        showSuccessAlert = true
                    } else {
                        showErrorAlert = true
                        errorTitle = "Login Failed"
                        errorMessage = "Invalid username or password. Please try again."
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
                            // Successfully logged in using Face ID, show success message
                            showSuccessAlert = true
                        } else {
                            showErrorAlert = true
                            errorTitle = "Face ID Authentication Failed"
                            errorMessage = message ?? "An error occurred. Please try again."
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

                NavigationLink(destination: CameraView(), isActive: $showCameraView) {
                    EmptyView()
                }
                
                Spacer()
            }
            .navigationBarTitle("Login", displayMode: .inline)
            .alert(isPresented: $showSuccessAlert, content: {
                Alert(title: Text("Success"), message: Text("Login successful."), dismissButton: .default(Text("OK"), action: {
                    showCameraView = true
                }))
            })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
