import SwiftUI
import LocalAuthentication

struct TextValidator: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newValue in
                let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                if filtered != newValue {
                    text = filtered
                }
            }
    }
}

extension View {
    func validatedText(_ text: Binding<String>) -> some View {
        self.modifier(TextValidator(text: text))
    }
}

struct SignupView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var publicKey = ""
    @State private var privateKey = ""
    @State private var walletAddress = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Public Key", text: $publicKey)
                .font(.system(size: 18, weight: .bold))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 50)
                .validatedText($publicKey)
            
            
            TextField("Private Key", text: $privateKey)
                .font(.system(size: 18, weight: .bold))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 50)
                .validatedText($privateKey)
            
            TextField("Wallet Address", text: $walletAddress)
                .font(.system(size: 18, weight: .bold))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 50)
                .validatedText($walletAddress)
            
            Button(action: {
                if publicKey.isEmpty || privateKey.isEmpty || walletAddress.isEmpty {
                        let alert = UIAlertController(title: "Error", message: "Please make sure every field is not empty.", preferredStyle: .alert)
                                 alert.addAction(UIAlertAction(title: "OK", style: .default))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                        return
                    }
        
                let context = LAContext()
                var error: NSError?
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { success, authenticationError in
                        DispatchQueue.main.async {
                            if success {
                                // Tie credentials to biometrics using Face ID and create account
                                KeychainService().saveCredentials(publicKey: self.publicKey, privateKey: self.privateKey, walletAddress: self.walletAddress)
                                // Navigate to EventMainMenuView
                                self.isLoggedIn = true
                            } else {
                                // Authentication failed
                                // Show an error message to the user
                                let alert = UIAlertController(title: "Authentication Failed", message: "Unable to verify your identity.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    // Face ID not available
                    // Show an error message to the user
                    let alert = UIAlertController(title: "Biometrics Not Available", message: "Your device does not support biometric authentication.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }) {
                Text("Create Account")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}


