import SwiftUI

struct AllQRCodesView: View {
    @ObservedObject var qrCodeStorage = QRCodeStorage()
    
    var body: some View {
        NavigationView {
            VStack {
                List(qrCodeStorage.qrCodes, id: \.self) { qrCodeData in
                    NavigationLink(destination: QRCodeDetailView(qrCode: qrCodeData.qrCode, metaData: qrCodeData.metaData)) {
                        Text(qrCodeData.qrCode)
                    }
                }
                Spacer()
                Button(action: {
                    qrCodeStorage.clear()
                }) {
                    Text("Clear All QR Codes")
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitle("All QR Codes")
        }
    }
}

struct QRCodeData: Hashable {
    let qrCode: String
    let metaData: String
}

class QRCodeStorage: ObservableObject {
    @Published var qrCodes: [QRCodeData] = []
    
    func add(qrCode: String, metaData: String) {
        qrCodes.append(QRCodeData(qrCode: qrCode, metaData: metaData))
    }
    
    func clear() {
        qrCodes.removeAll()
    }
}
