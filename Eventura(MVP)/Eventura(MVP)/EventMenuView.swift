import SwiftUI
import LocalAuthentication
import web3swift
import Web3Core
import BigInt

struct EventMainMenuView: View {
    
    @Binding var isLoggedIn: Bool
    let keychainService = KeychainService()
    @State private var booths: [Booth] = sampleBooths
    
    @State private var publicKey = ""
    @State private var privateKey = ""
    @State private var walletAddress = ""
    @State private var isShowingCredentials = false
    @State private var isRetrievingCredentials = false
    @State private var mintTransactionHash: String?
    @State private var showMintTransactionView = false
    @State private var isShowingScannerView = false
    
    // Add state for booth scan count
    @State private var boothScanCount = UserDefaults.standard.integer(forKey: "boothScanCount")
    
    // Load booth scan count on appear
      func loadBoothScanCount() {
          self.boothScanCount = UserDefaults.standard.integer(forKey: "boothScanCount")
      }
      
      // Save booth scan count
      func saveBoothScanCount() {
          UserDefaults.standard.set(self.boothScanCount, forKey: "boothScanCount")
      }
    
        
    // function to enable mint
    func canMintNFT() -> Bool {
        let totalBooths = 4
        let scannedBooths = boothScanCount
        let percentageScanned = Double(scannedBooths) / Double(totalBooths)
        let hasMintedNFT = mintTransactionHash != nil
        return percentageScanned >= 0.75
    }
        
    var body: some View {
        VStack {
            
            if !isShowingCredentials {
                Button(action: {
                    self.isRetrievingCredentials = true
                    let context = LAContext()
                    var error: NSError?
                    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { success, authenticationError in
                            DispatchQueue.main.async {
                                if success {
                                    if let credentials = self.keychainService.getCredentials() {
                                        self.publicKey = credentials.publicKey
                                        self.privateKey = credentials.privateKey
                                        self.walletAddress = credentials.walletAddress
                                        self.isShowingCredentials = true
                                        self.isRetrievingCredentials = false
                                    } else {
                                        // No saved credentials found
                                        // Show an error message to the user
                                        let alert = UIAlertController(title: "No Saved Credentials", message: "You have not saved any wallet credentials yet.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                                        self.isRetrievingCredentials = false
                                    }
                                } else {
                                    // Authentication failed
                                    // Show an error message to the user
                                    let alert = UIAlertController(title: "Authentication Failed", message: "Unable to verify your identity.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                                    self.isRetrievingCredentials = false
                                }
                            }
                        }
                    } else {
                        // Face ID not available
                        // Show an error message to the user
                        let alert = UIAlertController(title: "Biometrics Not Available", message: "Your device does not support biometric authentication.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                        self.isRetrievingCredentials = false
                    }
                }) {
                    Text("Retrieve Wallet Credentials")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            } else {
                VStack {
                    Text("Public Key: \(publicKey)")
                    Text("Private Key: \(privateKey)")
                    Text("Wallet Address: \(walletAddress)")
                    
                    Button(action: {
                        self.isShowingCredentials = false
                    }) {
                        Text("Hide Wallet Credentials")
                            .fontWeight(.semibold)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                }
            }
            
            // Add booth scan counter
            Text("Booths scanned: \(boothScanCount)")
                .onAppear {
                            self.loadBoothScanCount()
                        }
                        .onDisappear {
                            self.saveBoothScanCount()
                        }
       
            Button(action: {
                // Scan QR code
                isShowingScannerView = true
                UserDefaults.standard.set(boothScanCount, forKey: "boothScanCount")

            }) {
                Text("Scan QR Code")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            .sheet(isPresented: $isShowingScannerView) {
                            QRCodeScannerView { code in
                                if let boothCode = code {
                                    boothScanCount += 1
                                    print("Scanned booth code: \(boothCode)")
                                }
                                isShowingScannerView = false
                            }
                        }

            Button(action: {
                // Create NFT and mint to wallet address
                guard self.keychainService.getCredentials() != nil else {
                    // Show an error message to the user
                    let alert = UIAlertController(title: "No Saved Credentials", message: "You have not saved any wallet credentials yet.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                
                // TODO: SMART CONTRACT FUNCTIONALITY
                // Call a basic ERC 721 contract and mint the NFT using the wallet credentials
                // wallet credentials are currently stored on keychain and tied to biometrics (Face ID)
                // We will use a basic ERC 721 Smart Contract that creates an NFT with two main details: IPFS Image Link & Time
                // When the minting is successful and you have the transaction hash, we will display it here:
                // additionally, we also display the IPFS image in the smart contract as well (need to implelemt this as well)
                self.mintTransactionHash = "0x123456789abcdef..." // --> replace with transaction hash from NFT
                self.showMintTransactionView = true
                
                //Render Image from NFT
            }) {
                Text("Mint NFT")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(canMintNFT() ? Color.green : Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .disabled(!canMintNFT())
            .padding()
            
            // Display transaction hash and etherscan link
            if showMintTransactionView {
                VStack {
                    Text("Transaction Hash: \(mintTransactionHash ?? "N/A")")
                        .padding()
                    
                    Button(action: {
                        guard let transactionHash = mintTransactionHash else { return }
                        let etherscanURLString = "https://etherscan.io/tx/\(transactionHash)"
                        guard let etherscanURL = URL(string: etherscanURLString) else { return }
                        UIApplication.shared.open(etherscanURL)
                    }) {
                        Text("View on Etherscan")
                            .fontWeight(.semibold)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                }
            }

            Button(action: {
                // Log out and go back to ContentView
                // KeychainService().deleteCredentials()
                self.isLoggedIn = false
            }) {
                Text("Log Out")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                KeychainService().deleteCredentials()
                self.isLoggedIn = false
                self.boothScanCount = 0
                    boothScanCount = 0
                UserDefaults.standard.set(boothScanCount, forKey: "boothScanCount")
            }) {
                Text("Delete Account")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
        }
    }
    
}


