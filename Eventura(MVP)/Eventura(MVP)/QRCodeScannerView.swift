import SwiftUI
import AVFoundation
import CoreLocation

// QRCodeScanningView
struct QRCodeScanningView: UIViewControllerRepresentable {
    @Binding var boothScanCount: Int
    @Binding var sampleBooths: [Booth]

    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let viewController = QRCodeScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: QRCodeScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScanningView

        init(_ parent: QRCodeScanningView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let boothId = metadataObject.stringValue {
                if let booth = parent.sampleBooths.first(where: { $0.id == boothId }) {
                    if !booth.isScanned {
                        parent.boothScanCount += 1
                        if let index = parent.sampleBooths.firstIndex(where: { $0.id == boothId }) {
                            parent.sampleBooths[index].isScanned = true
                        }
                    }
                }
                DispatchQueue.main.async {
                    output.setMetadataObjectsDelegate(nil, queue: nil)
                }
            }
        }

    }

}

// QRCodeScannerViewController
class QRCodeScannerViewController: UIViewController {
    var delegate: AVCaptureMetadataOutputObjectsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }

        let captureSession = AVCaptureSession()
        captureSession.addInput(input)

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        captureSession.startRunning()
    }
}


