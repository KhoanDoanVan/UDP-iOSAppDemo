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

//struct GestureBoxView: View {
//    let destinationIP: String
//    let udpSender = UDPSender() /// UDP sender instance
//    
//    var body: some View {
//        GeometryReader { geometry in
//            Color.blue
//                .opacity(0.3)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .gesture(
//                    DragGesture(minimumDistance: 0)
//                        .onChanged { value in
//                            let x = value.location.x / geometry.size.width
//                            let y = value.location.y / geometry.size.height
//                            let message = "\(x),\(y)"
//                            udpSender.send(message: message, to: destinationIP)
//                        }
//                )
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}


struct GestureBoxView: View {
    let destinationIP: String
    let udpSender: UDPSender
    @State private var boxOffset: CGSize = .zero

    init(destinationIP: String) {
        self.destinationIP = destinationIP
        self.udpSender = UDPSender(destinationIP: destinationIP)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)

                Rectangle()
                    .fill(Color.red.opacity(0.8))
                    .frame(width: 50, height: 50)
                    .offset(boxOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = value.translation.width
                                let newY = value.translation.height
                                boxOffset = CGSize(width: newX, height: newY)

                                let relativeX = (newX + geometry.size.width / 2) / geometry.size.width
                                let relativeY = (newY + geometry.size.height / 2) / geometry.size.height
                                let message = "\(relativeX),\(relativeY)"

                                udpSender.send(message: message)
                            }
                    )
            }
        }
    }
}


#Preview {
    ContentView()
}
