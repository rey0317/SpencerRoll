//
//  MainView.swift
//  Eventura(SwiftUI)
//
//  Created by Joshua Sum on 19/3/23.
//

import SwiftUI


struct NFTMetadataView: View {
    @State private var showLoginView: Bool = true
    
    // The CID of the NFT whose metadata will be displayed
    let cid: String
    
    // The manager object that will retrieve the NFT metadata
    let metadataManager = NFTMetadataManager()
    
    // The state variable that will hold the NFT metadata
    @State private var metadata: [String: Any]?
    
    var body: some View {
        NavigationView {
            VStack {
                if showLoginView {
                    LoginView()
                } else {
                    SignUpView()
                }

                if let metadata = metadata {
                    // Display the NFT metadata
                    Text("NFT Name: \(metadata["name"] as? String ?? "")")
                    Text("NFT Description: \(metadata["description"] as? String ?? "")")
                    // Add more fields as needed
                } else {
                    // Show a loading spinner while the metadata is being retrieved
                    ProgressView()
                }
            }
            .onAppear {
                // Retrieve the NFT metadata when the view appears
                metadataManager.fetchMetadata(forCID: cid) { result in
                    switch result {
                    case .success(let metadata):
                        self.metadata = metadata
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            .navigationBarTitle(showLoginView ? "Login" : "Sign Up", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showLoginView.toggle()
            }) {
                Text(showLoginView ? "Sign Up" : "Login")
            })
        }
    }
}
