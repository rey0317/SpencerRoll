//
//  MainView.swift
//  Eventura(SwiftUI)
//
//  Created by Karthik Ganesh on 19/3/23.
//

import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("Welcome to the app!")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                // Open the camera to scan a QR code
                // You can implement this functionality using AVFoundation or a third-party library like CodeScanner
            }) {
                Text("Scan QR Code")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding([.leading, .trailing], 40)
            .padding(.top)
            
            Spacer()
        }
    }
}
