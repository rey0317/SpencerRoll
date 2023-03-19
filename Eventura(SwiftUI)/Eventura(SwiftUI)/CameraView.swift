import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject private var cameraViewModel = CameraViewModel()
    
    @State private var showQRCodeDetailView = false
    @State private var scannedQRCode: String = ""
    @State private var metaData: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                if let previewLayer = cameraViewModel.previewLayer {
                    CameraPreviewView(previewLayer: previewLayer)
                        .onAppear {
                            cameraViewModel.startSession()
                        }
                        .onDisappear {
                            cameraViewModel.stopSession()
                        }
                }
            }
            .ignoresSafeArea()
            
            QRCodeScannerOverlay()
        }
        .onReceive(cameraViewModel.$scannedCode, perform: { scannedCode in
            if let code = scannedCode {
                scannedQRCode = code.message
                metaData = code.metadata.joined(separator: "\n")
                showQRCodeDetailView = true
            }
        })
        .sheet(isPresented: $showQRCodeDetailView) {
            QRCodeDetailView(qrCode: scannedQRCode, metaData: metaData)
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
