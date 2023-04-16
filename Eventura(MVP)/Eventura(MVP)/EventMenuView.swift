import SwiftUI
import LocalAuthentication
import Web3

// Optional
import Web3PromiseKit
import Web3ContractABI

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
           
    func sendSugihToken(to receiverAddress: String, amount: String, privateKey: String) {
        // Replace with the actual RPC URL for the Ethereum network you're using (e.g., Mainnet, Ropsten, etc.)
        let web3 = Web3(rpcURL: "https://sepolia.infura.io/v3/4538bc3b71db4c7394b6f13cd63f29ff")
        
        do {
            // Replace with the actual contract address for the "Sugih" token
            let contractAddress = try EthereumAddress(hex:"0x46A2A9f830664e25feAEe84bC7ebC86E0AB9f7e0", eip55: true)
            print(contractAddress)
            // Use the ERC20 ABI or the ABI specific to your "Sugih" token
            let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)
            let senderAddress = try EthereumAddress(hex:"0x07F85d73Bc89dB56C6141E49b6eE51EECc56ed74", eip55: true)
            print(senderAddress)
            let keychainService = KeychainService()
            let receiverAddress = keychainService.getCredentials()?.walletAddress
            print(receiverAddress)
            let privateKey = keychainService.getCredentials()?.privateKey
            guard let receiverWalletAddress = receiverAddress else { return }
            let receiver = try EthereumAddress(hex: receiverWalletAddress, eip55: true)
            print(receiver)
            
            let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: privateKey!)
            print(myPrivateKey)
            firstly {
                web3.eth.getTransactionCount(address: receiver, block: .latest)
            }.then { nonce in
                try contract.transfer(to: EthereumAddress(hex: receiverWalletAddress, eip55: true), value: 100).createTransaction(
                    nonce: 0,
                    gasPrice: EthereumQuantity(quantity: 1.gwei),
                    maxFeePerGas: EthereumQuantity(quantity: 2.gwei),
                    maxPriorityFeePerGas: EthereumQuantity(quantity: 2.gwei),
                    gasLimit: 35000,
                    from: senderAddress,
                    value: 0,
                    accessList: [:],
                    transactionType: .legacy
                )!.sign(with: myPrivateKey).promise
            }.then { tx in
                web3.eth.sendRawTransaction(transaction: tx)
            }.done { txHash in
                print(txHash)
            }.catch { error in
                print(error)
            }
            
        } catch {
            print("Error: \(error)")
        }
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
            
//            Spacer()
            
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
                        .padding()
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                }
                
            } else {
                VStack {
                    
                    Button(action: {
                        self.isShowingCredentials = false
                    }) {
                        Text("Hide Wallet Credentials")
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Public Key: \(publicKey)")
                        Text("Private Key: \(privateKey)")
                        Text("Wallet Address: \(walletAddress)")
                    }
                }
            }
        
            Spacer()
            
            // Add booth scan counter
            Text("Booths scanned: \(boothScanCount)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .modifier(GradientText())
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
                guard let credentials = self.keychainService.getCredentials() else {
                        // Show an error message to the user
                        let alert = UIAlertController(title: "No Saved Credentials", message: "You have not saved any wallet credentials yet.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                        return
                    }
                
                let receiverAddress = credentials.walletAddress
                  let amountToSend = "10" // Replace with the desired amount of "Sugih" tokens to send
                  
                  // Call the sendSugihToken function
                  sendSugihToken(to: receiverAddress, amount: amountToSend, privateKey: credentials.privateKey)
                
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
                            .padding()
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                
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
                        .padding(.horizontal, 10)
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
                        .padding(.horizontal, 10)
                }
            }
            
        }
    }
    
}


