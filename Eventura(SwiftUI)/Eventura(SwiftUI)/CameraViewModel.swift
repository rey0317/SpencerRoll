import SwiftUI
import Combine
import AVFoundation

class CameraViewModel: NSObject, ObservableObject {
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var scannedCode: (message: String, metadata: [String])?

    private let captureSession = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer = previewLayer
        } catch {
            print("Error setting up the capture session: \(error)")
        }
    }

    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
    }

    private func processQRCode(_ metadataObjects: [AVMetadataObject]) {
        if let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            let metadata = readableObject.type.rawValue
            DispatchQueue.main.async {
                self.scannedCode = (message: stringValue, metadata: [metadata])
            }
        }
    }
}

extension CameraViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        processQRCode(metadataObjects)
    }
}
