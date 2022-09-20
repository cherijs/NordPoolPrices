//
//  NordPoolApp.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import SwiftUI


@main
struct NordPoolApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
//        WindowGroup {
//            ContentView(vm: StockListViewModel())
//        }
        Settings {  }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    static private(set) var instance: AppDelegate! = nil
    
    public private(set) var statusItem: NSStatusItem!
    public private(set) var popover: NSPopover!
    public private(set) var stockListVM: StockListViewModel!
    
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        
        self.stockListVM = StockListViewModel()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        NetworkMonitor.shared.startMonitoring()
        
        var symbol = "chart.line.uptrend.xyaxis.circle.fill"
        if NetworkMonitor.shared.isConnected {
            print("You are connected")
        } else {
            print("Disconected")
            symbol = "exclamationmark.circle.fill"
        }
        
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: symbol, accessibilityDescription: "Nord Pool")
            statusButton.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 200, height: 230)
        self.popover.behavior = .transient
        self.popover.animates = true

        self.popover.contentViewController = NSHostingController(rootView: ContentView(vm: self.stockListVM))
        
        
    }
    

    @objc func togglePopover() {
      
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
            } else {
                
                Task {
                    await self.stockListVM.populateNordPoolStocks()
                }
                
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                
                let popoverWindowX = popover.contentViewController?.view.window?.frame.origin.x ?? 0
                let popoverWindowY = popover.contentViewController?.view.window?.frame.origin.y ?? 0
                
                popover.contentViewController?.view.window?.setFrameOrigin(
                    NSPoint(x: popoverWindowX, y: popoverWindowY - 30)
                )
                popover.contentViewController?.view.window?.makeKey()


            }
        }

    }

}

