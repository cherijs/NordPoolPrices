//
//  NetworkMonitor.swift
//  NordPool
//
//  Created by Arturs Cirsis on 20/09/2022.
//

import Foundation
import Network
import AppKit

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected:Bool = false
    
    public private(set) var connetionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self!.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path: path)
            print("connected: \(String(describing: self?.isConnected))")
            print(path.isExpensive)
            
            
            if(self!.isConnected){
                DispatchQueue.main.async {
                    AppDelegate.instance.statusItem.button?.image = NSImage(systemSymbolName: "chart.line.uptrend.xyaxis.circle.fill", accessibilityDescription: "Nord Pool")
                }
            } else {
                DispatchQueue.main.async {
                    AppDelegate.instance.statusItem.button?.image = NSImage(systemSymbolName: "exclamationmark.circle.fill", accessibilityDescription: "Disconected")
                }
            }
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnectionType(path: NWPath){
        if path.usesInterfaceType(.wifi){
            connetionType = .wifi
        }
        else if path.usesInterfaceType(.cellular){
            connetionType = .cellular
        }
        
        else if path.usesInterfaceType(.wiredEthernet){
            connetionType = .ethernet
        }
        
        else {
            connetionType = .unknown
        }
        
    }
}
