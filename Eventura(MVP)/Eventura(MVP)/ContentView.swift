import SwiftUI
import LocalAuthentication

struct ContentView: View {
    
    @State private var isLoggedIn = false
    let keychainService = KeychainService()
    
    var body: some View {
        Group {
            if isLoggedIn {
                NavigationView {
                    EventMainMenuView(isLoggedIn: $isLoggedIn)
                }
            } else {
                NavigationView {
                    VStack(spacing: 200) {
                        Text("Eventura")
                           .font(.largeTitle)
                           .fontWeight(.bold)
                           .modifier(GradientText())
                           .padding(.top, 100)
                        Spacer()
                        
                        HStack(spacing: 20) {
                            if keychainService.getCredentials() == nil {
                                NavigationLink(destination: SignupView(isLoggedIn: $isLoggedIn)) {
                                    Text("Sign Up")
                                        .fontWeight(.semibold)
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .padding(.horizontal, 40)
                                }
                            }
                            
                            Button(action: {
                                let context = LAContext()
                                var error: NSError?
                                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { success, authenticationError in
                                        DispatchQueue.main.async {
                                            if success {
                                                if self.keychainService.getCredentials() != nil {
                                                    // Navigate to EventMainMenuView
                                                    self.isLoggedIn = true
                                                } else {
                                                    // No saved credentials found
                                                    // Show an error message to the user
                                                    let alert = UIAlertController(title: "Credentials Not Found", message: "No credentials were found for your account. Please sign up first.", preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                                                }
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
                                Text("Log In")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 40)
                            }
                        }
//                        .navigationTitle("Eventura")
                    }
                }
            }
        }
    }
}

struct GradientText: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .mask(content)
        )
        .foregroundColor(.white)
    }
}
