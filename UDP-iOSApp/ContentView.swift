//
//  ContentView.swift
//  UDP-iOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//


import SwiftUI
import Network

struct ContentView: View {
    @State private var scannedIP: String?
    
    var body: some View {
        VStack {

            if let ip = scannedIP {
                GestureBoxView(destinationIP: ip)  /// Show gesture UI
                    .onAppear {
                        print("IP ADDRESS: \(ip)")
                    }
            } else {
                VStack {
                    Text("Scan a Wi-Fi QR Code to get the IP")
                        .font(.headline)
                        .padding()

                    Button("Scan QR Code") {
                        scannedIP = nil
                    }
                    .fullScreenCover(isPresented: Binding(
                        get: { scannedIP == nil },
                        set: { _ in }
                    )) {
                        QRCodeScannerView(scannedIP: $scannedIP)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
