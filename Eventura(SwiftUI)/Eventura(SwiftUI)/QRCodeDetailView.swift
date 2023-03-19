import SwiftUI

struct QRCodeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let qrCode: String
    let metaData: String
    
    var body: some View {
        VStack {
            Text("QR Code Details")
                .font(.largeTitle)
            Spacer()
            Text("QR Code:")
                .font(.headline)
            Text(qrCode)
            Spacer()
            Text("Metadata:")
                .font(.headline)
            Text(metaData)
            Spacer()
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Spacer()
                Button(action: {
                    let qrCodeData = (qrCode: qrCode, metaData: metaData)
                    NotificationCenter.default.post(name: Notification.Name("AddQRCodeToEventList"), object: qrCodeData)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add to Events List")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
