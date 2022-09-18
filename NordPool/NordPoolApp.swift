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

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var stockListVM: StockListViewModel!
    
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {

        self.stockListVM = StockListViewModel()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "chart.line.uptrend.xyaxis.circle.fill", accessibilityDescription: "Nord Pool")
            statusButton.action = #selector(togglePopover)
        }
        
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 150, height: 200)
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
                    print("fetched")
        //            TODO update scroll and handle loading
        //            self.v.updateScrollTarget(target: Date.getCurrentHour())
                }
                
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                
                
                let popoverWindowX = popover.contentViewController?.view.window?.frame.origin.x ?? 0
                let popoverWindowY = popover.contentViewController?.view.window?.frame.origin.y ?? 0

                popover.contentViewController?.view.window?.setFrameOrigin(
                    NSPoint(x: popoverWindowX, y: popoverWindowY - 10)
                )
                popover.contentViewController?.view.window?.makeKey()
                
                

            }
        }

    }

}
