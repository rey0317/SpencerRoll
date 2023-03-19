import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var walletAddress: String = ""
    @State private var privateKey: String = ""

    @State private var isRegistered: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""

    @ObservedObject private var authenticationManager = AuthenticationManager()
    
    struct RoundedRectangleButtonStyle: ButtonStyle {
        var cornerRadius: CGFloat = 25

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(configuration.isPressed ? Color.gray : Color.blue)
                )
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                TextField("Username", text: $username)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.bottom, 20)

                SecureField("Password", text: $password)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.bottom, 20)

                TextField("Wallet Address", text: $walletAddress)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.bottom, 20)

                TextField("Private Key", text: $privateKey)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.bottom, 20)

                Button("Register") {
                    if authenticationManager.registerUser(username: username, password: password, walletAddress: walletAddress, privateKey: privateKey) {
                        isRegistered = true
                        alertMessage = "Registration successful!"
                    } else {
                        isRegistered = false
                        alertMessage = "Registration failed. Please try again."
                    }

                    isShowingAlert = true
                }
                .buttonStyle(RoundedRectangleButtonStyle())
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text(alertMessage))
                }

                Spacer()

            }
            .padding(.horizontal, 30)
        }
    }
}

