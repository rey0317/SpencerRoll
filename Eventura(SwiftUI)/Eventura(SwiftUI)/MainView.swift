import SwiftUI

struct MainView: View {
    @State private var showCameraView = false
    @State private var qrCodes: [(qrCode: String, metaData: String)] = []
    
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
                
                Spacer()
            }
            .navigationBarTitle("Main")
            .sheet(isPresented: $showCameraView) {
                CameraView()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AddQRCodeToEventList"))) { notification in
                if let qrCodeData = notification.object as? (qrCode: String, metaData: String) {
                    qrCodes.append(qrCodeData)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
