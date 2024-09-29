
import Foundation
import Network

@Observable
final class NetworkMonitor {
    var isConnected = false
    
    private let networkMonitor: NWPathMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "com.NetworkMonitor.networkQueue")
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: networkQueue)
    }
}
