import Foundation
import BigInt
import web3swift
import Web3Core

class MintNFT: ObservableObject {
    @Published var network: Networks = .Goerli
    
    
    @Published var endpointURL = URL(string: "https://goerli.infura.io/v3/28ba402a8bee40ee88efc116e3b81d9c")!
    @Published var password = ""
    @Published var privateKey = "5be307eed5a14f93eccb720abb9febaeeefcae43609566920ac573864fe294e0"
    @Published var contractAddress = ""
    private var abiString: String?

    init(abiString: String?) {
        self.abiString = abiString
    }

    func importWalletWith(privateKey: String) -> EthereumKeystoreV3? {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let dataKey = Data.fromHex(formattedKey) else {
            return nil
        }
        return try? EthereumKeystoreV3(privateKey: dataKey, password: password)
    }
    
    private func getWeb3Instance() async -> Web3? {
        guard let keystore = importWalletWith(privateKey: privateKey) else { return nil }
        let keystoreManager = KeystoreManager([keystore])
        do {
            let provider = try await Web3HttpProvider(url: endpointURL, network: network, keystoreManager: keystoreManager)
            let web3Instance = Web3(provider: provider)
            return web3Instance
        } catch {
            print("Error creating Web3HttpProvider: \(error)")
            return nil
        }
    }
    
     func mintNFT(to address: EthereumAddress, tokenId: BigUInt, metadata: String) async throws -> String? {
         guard let web3Instance = await getWeb3Instance() else { return nil }
         let contract = web3Instance.contract(abiString ?? "", at: EthereumAddress(contractAddress))
         let transaction = contract!.write(
             "mintWithTokenURI",
             parameters: [address, tokenId, metadata],
             extraData: Data(),
         )
         let result = try await transaction!.sendPromise(password: password)
         return result.hash
     }
 }



