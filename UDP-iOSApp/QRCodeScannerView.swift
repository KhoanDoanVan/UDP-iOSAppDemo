//
//  QRCodeScannerView.swift
//  UDP-iOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedIP: String?  /// Store scanned IP

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice)

        if let videoInput = videoInput, captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(_ parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let scannedText = metadataObject.stringValue {
                DispatchQueue.main.async {
                    self.parent.scannedIP = extractIPAddress(from: scannedText)
                }
            }
        }
    }
}

func extractIPAddress(from qrText: String) -> String? {
    let regex = try! NSRegularExpression(pattern: "(\\d{1,3}\\.){3}\\d{1,3}")
    if let match = regex.firstMatch(in: qrText, range: NSRange(location: 0, length: qrText.utf16.count)) {
        if let range = Range(match.range, in: qrText) {
            return String(qrText[range])
        }
    }
    return nil
}
