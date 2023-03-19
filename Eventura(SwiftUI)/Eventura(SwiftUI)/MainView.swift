import SwiftUI

struct MainView: View {
    @State private var qrCodes: [String] = []
    @State private var showCameraView = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showCameraView = true
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
                
                NavigationLink(destination: AllQRCodesView()) {
                    Text("View All QR Codes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding([.leading, .trailing], 40)
                .padding(.top)
                .disabled(qrCodes.isEmpty)
                
                Spacer()
            }
            .navigationBarTitle("QR Code Scanner")
        }
        .sheet(isPresented: $showCameraView) {
            CameraView()
        }
    }
}

