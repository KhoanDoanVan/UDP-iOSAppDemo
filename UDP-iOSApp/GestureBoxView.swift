//
//  GestureBoxView.swift
//  UDP-iOSApp
//
//  Created by Đoàn Văn Khoan on 13/2/25.
//

import SwiftUI

struct GestureBoxView: View {
    let destinationIP: String
    @State private var udpSender: UDPSender?
    @State private var boxOffset: CGSize = .zero
    @State private var lastPosition: CGSize = .zero
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)

//                Rectangle()
//                    .fill(Color.red.opacity(0.8))
//                    .frame(width: 50, height: 50)
//                    .offset(boxOffset)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let newOffset = CGSize(
//                                    width: lastPosition.width + value.translation.width,
//                                    height: lastPosition.height + value.translation.height
//                                )
//                                boxOffset = newOffset
//
//                                let relativeX = (newOffset.width + geometry.size.width / 2) / geometry.size.width
//                                let relativeY = (newOffset.height + geometry.size.height / 2) / geometry.size.height
//                                let message = "\(relativeX),\(relativeY)"
//
//                                udpSender?.send(message: message)
//                            }
//                            .onEnded { value in
//                                lastPosition = boxOffset  /// Save position to keep it persistent
//                            }
//                    )
            }
            .onTapGesture { pointTapOnScreen in
                let message = "\(pointTapOnScreen.x),\(pointTapOnScreen.y)"
                
                udpSender?.send(message: message)
            }
        }
        .onAppear {
            udpSender = UDPSender(destinationIP: destinationIP) { error in
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("UDP Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}
