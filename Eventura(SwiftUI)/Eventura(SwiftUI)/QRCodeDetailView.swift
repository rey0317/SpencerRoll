import SwiftUI
import AVFoundation

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
        }
        .padding()
    }
}
