//
//  UDPSender.swift
//  UDP-iOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import Foundation
import Network

class UDPSender {
    private let connection: NWConnection

    init(destinationIP: String, port: UInt16 = 8080) {
        connection = NWConnection(host: NWEndpoint.Host(destinationIP), port: NWEndpoint.Port(integerLiteral: port), using: .udp)
        connection.start(queue: .global())
    }

    func send(message: String) {
        if let data = message.data(using: .utf8) {
            connection.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    print("UDP Send Error: \(error)")
                }
            })
        }
    }
}
