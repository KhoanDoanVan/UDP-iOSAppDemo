//
//  UDPSender.swift
//  UDP-iOSApp
//
//  Created by Đoàn Văn Khoan on 10/2/25.
//

import Foundation
import Network

class UDPSender {
    private var connection: NWConnection?
    private let destinationIP: String
    private let port: UInt16 = 8080
    private let errorHandler: (Error) -> Void

    init(destinationIP: String, errorHandler: @escaping (Error) -> Void) {
        self.destinationIP = destinationIP
        self.errorHandler = errorHandler
        setupConnection()
    }

    private func setupConnection() {
        connection = NWConnection(host: NWEndpoint.Host(destinationIP), port: NWEndpoint.Port(integerLiteral: port), using: .udp)
        connection?.stateUpdateHandler = { [weak self] state in
            switch state {
            case .failed(let error):
                self?.errorHandler(error)
            default:
                break
            }
        }
        connection?.start(queue: .global())
    }

    func send(message: String) {
        guard let data = message.data(using: .utf8), let connection = connection else { return }
        connection.send(content: data, completion: .contentProcessed { [weak self] error in
            if let error = error {
                self?.errorHandler(error)
            }
        })
    }
}
