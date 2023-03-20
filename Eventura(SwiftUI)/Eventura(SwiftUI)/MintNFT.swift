import Foundation
import BigInt
import web3swift
import Web3Core

class MintNFT: ObservableObject {
    @Published var network: Networks = .Goerli
    
    
    @Published var endpointURL = URL(string: "https://goerli.infura.io/v3/4538bc3b71db4c7394b6f13cd63f29ff")!
    @Published var password = ""
    @Published var privateKey = "7985fd08ccd8ba63e88a7504754b2519ffac68a42ccc83ead56681e978de8ff0"
    @Published var contractAddress = "0x46A2A9f830664e25feAEe84bC7ebC86E0AB9f7e0"


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
         guard let web3 = await getWeb3Instance() else { return nil }
         let eventcontract = EthereumAddress(contractAddress)
         let abiString = """
        [
         {
             "inputs": [],
             "stateMutability": "nonpayable",
             "type": "constructor"
         },
         {
             "anonymous": false,
             "inputs": [
                 {
                     "indexed": true,
                     "internalType": "address",
                     "name": "owner",
                     "type": "address"
                 },
                 {
                     "indexed": true,
                     "internalType": "address",
                     "name": "approved",
                     "type": "address"
                 },
                 {
                     "indexed": true,
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "Approval",
             "type": "event"
         },
         {
             "anonymous": false,
             "inputs": [
                 {
                     "indexed": true,
                     "internalType": "address",
                     "name": "owner",
                     "type": "address"
                 },
                 {
                     "indexed": true,
                     "internalType": "address",
                     "name": "operator",
                     "type": "address"
                 },
                 {
                     "indexed": false,
                     "internalType": "bool",
                     "name": "approved",
                     "type": "bool"
                 }
             ],
             "name": "ApprovalForAll",
             "type": "event"
         },
         {
             "anonymous": false,
             "inputs": [
                 {
                     "indexed": true,
                     "internalType": "address",
                     "name": "from",
                     "type": "address"
                 },
                 {
                     "indexed": true,
                     "internalType": "address",
                     "name": "to",
                     "type": "address"
                 },
                 {
                     "indexed": true,
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "Transfer",
             "type": "event"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "to",
                     "type": "address"
                 },
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "approve",
             "outputs": [],
             "stateMutability": "nonpayable",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "owner",
                     "type": "address"
                 }
             ],
             "name": "balanceOf",
             "outputs": [
                 {
                     "internalType": "uint256",
                     "name": "",
                     "type": "uint256"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "uint256",
                     "name": "",
                     "type": "uint256"
                 }
             ],
             "name": "eventToOwner",
             "outputs": [
                 {
                     "internalType": "address",
                     "name": "",
                     "type": "address"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "uint256",
                     "name": "",
                     "type": "uint256"
                 }
             ],
             "name": "events",
             "outputs": [
                 {
                     "internalType": "uint256",
                     "name": "id",
                     "type": "uint256"
                 },
                 {
                     "internalType": "string",
                     "name": "time",
                     "type": "string"
                 },
                 {
                     "internalType": "string",
                     "name": "location",
                     "type": "string"
                 },
                 {
                     "internalType": "string",
                     "name": "date",
                     "type": "string"
                 },
                 {
                     "internalType": "string",
                     "name": "image",
                     "type": "string"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "getApproved",
             "outputs": [
                 {
                     "internalType": "address",
                     "name": "",
                     "type": "address"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "owner",
                     "type": "address"
                 },
                 {
                     "internalType": "address",
                     "name": "operator",
                     "type": "address"
                 }
             ],
             "name": "isApprovedForAll",
             "outputs": [
                 {
                     "internalType": "bool",
                     "name": "",
                     "type": "bool"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "string",
                     "name": "_time",
                     "type": "string"
                 },
                 {
                     "internalType": "string",
                     "name": "_location",
                     "type": "string"
                 },
                 {
                     "internalType": "string",
                     "name": "_date",
                     "type": "string"
                 },
                 {
                     "internalType": "string",
                     "name": "_image",
                     "type": "string"
                 },
                 {
                     "internalType": "address",
                     "name": "recipient",
                     "type": "address"
                 }
             ],
             "name": "mint",
             "outputs": [],
             "stateMutability": "nonpayable",
             "type": "function"
         },
         {
             "inputs": [],
             "name": "name",
             "outputs": [
                 {
                     "internalType": "string",
                     "name": "",
                     "type": "string"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "ownerOf",
             "outputs": [
                 {
                     "internalType": "address",
                     "name": "",
                     "type": "address"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "from",
                     "type": "address"
                 },
                 {
                     "internalType": "address",
                     "name": "to",
                     "type": "address"
                 },
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "safeTransferFrom",
             "outputs": [],
             "stateMutability": "nonpayable",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "from",
                     "type": "address"
                 },
                 {
                     "internalType": "address",
                     "name": "to",
                     "type": "address"
                 },
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 },
                 {
                     "internalType": "bytes",
                     "name": "data",
                     "type": "bytes"
                 }
             ],
             "name": "safeTransferFrom",
             "outputs": [],
             "stateMutability": "nonpayable",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "operator",
                     "type": "address"
                 },
                 {
                     "internalType": "bool",
                     "name": "approved",
                     "type": "bool"
                 }
             ],
             "name": "setApprovalForAll",
             "outputs": [],
             "stateMutability": "nonpayable",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "bytes4",
                     "name": "interfaceId",
                     "type": "bytes4"
                 }
             ],
             "name": "supportsInterface",
             "outputs": [
                 {
                     "internalType": "bool",
                     "name": "",
                     "type": "bool"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [],
             "name": "symbol",
             "outputs": [
                 {
                     "internalType": "string",
                     "name": "",
                     "type": "string"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "tokenURI",
             "outputs": [
                 {
                     "internalType": "string",
                     "name": "",
                     "type": "string"
                 }
             ],
             "stateMutability": "view",
             "type": "function"
         },
         {
             "inputs": [
                 {
                     "internalType": "address",
                     "name": "from",
                     "type": "address"
                 },
                 {
                     "internalType": "address",
                     "name": "to",
                     "type": "address"
                 },
                 {
                     "internalType": "uint256",
                     "name": "tokenId",
                     "type": "uint256"
                 }
             ],
             "name": "transferFrom",
             "outputs": [],
             "stateMutability": "nonpayable",
             "type": "function"
         }
     ]
 """
         let contract = web3.contract(abiString, at: eventcontract, abiVersion: 2)!
         let mintFunction = contract.createWriteOperation("mint", parameters: ["2022-01-01", "New York", "2022-01-01", "https://example.com/image", "0x6D5914e611C8B902a19a4f38aE203a5ab3e5FE82"] as [AnyObject])
         let transaction = try await mintFunction?.writeToChain(password: password)
         return transaction?.hash
     }
 }



