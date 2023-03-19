import Foundation
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject {
    private(set) var session = AVCaptureSession()
    private var captureDevice: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureSessionOutput: AVCaptureMetadataOutput?

    func startSession() {
        DispatchQueue.main.async {
            self.setupSession()
            self.session.startRunning()
        }
    }

    func stopSession() {
        DispatchQueue.main.async {
            self.session.stopRunning()
        }
    }

    private func setupSession() {
        if let device = AVCaptureDevice.default(for: .video) {
            captureDevice = device
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                let output = AVCaptureMetadataOutput()
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    output.metadataObjectTypes = [.qr]
                }
            } catch {
                print("Error setting up the capture session: \(error)")
            }
        }
    }

    func capture() {
        print("Capture function called")
        // Capture QR code and process it
    }
}

extension CameraViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .qr, let stringValue = object.stringValue {
            print("QR Code: \(stringValue)")

            DispatchQueue.main.async {
                self.session.stopRunning()
                // Process the QR code, navigate to the success page, and pass the metadata
            }
        }
    }
}
