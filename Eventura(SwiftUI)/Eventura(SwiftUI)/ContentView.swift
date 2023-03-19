//
//  ContentView.swift
//  Eventura(SwiftUI)
//
//  Created by Karthik Ganesh on 19/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoginView: Bool = true
    var body: some View {
        NavigationView {
            VStack {
                if showLoginView {
                    LoginView()
                } else {
                    SignUpView()
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

