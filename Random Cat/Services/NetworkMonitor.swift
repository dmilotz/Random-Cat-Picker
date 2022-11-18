//
//  NetworkMonitor.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/18/22.
//

import Network
import SwiftUI

enum NetworkStatus: String {
    case connected
    case disconnected
}

class Monitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: NetworkStatus = .connected
    @Published var isConnected = true


    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.status = .connected
                    self.isConnected = true

                } else {
                    self.status = .disconnected
                    self.isConnected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
