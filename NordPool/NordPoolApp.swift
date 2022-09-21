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
        //        print("#1 applicationDidFinishLaunching")
        AppDelegate.instance = self
        
        self.stockListVM = StockListViewModel()
        
        statusItem = NSStatusBar.system.statusItem(withLength: 16) //NSStatusItem.variableLength
        
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
        self.popover.contentSize = NSSize(width: 220, height: 230)
        self.popover.behavior = .transient
        self.popover.animates = true
        
        self.popover.contentViewController = NSHostingController(rootView: ContentView(vm: self.stockListVM))
        
        
        
        
    }
    
    
    func applicationDidChangeOcclusionState(_ notification: Notification) {
        //        print("#2 applicationDidChangeOcclusionState")
        //        print("applicationDidChangeOcclusionState \(String(describing: NSApp.windows.first))")
        //        if let window = NSApp.windows.first, window.isMiniaturized {
        //            NSApp.hide(self)
        //        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        //        print("#3 applicationDidBecomeActive")
        //        NSApp.windows.first?.makeKeyAndOrderFront(self)
        //        print("applicationDidBecomeActive \(String(describing: NSApp.windows.first))")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            DispatchQueue.main.async {
                self.togglePopover()
//            }
        }
    }
    

    
    @objc func togglePopover() {
        
        if let button = statusItem.button {
            if popover.isShown {
//                self.popover.performClose(nil)
            } else {
                NSApplication.shared.activate(ignoringOtherApps: true)
                
                Task {
                    await self.stockListVM.populateNordPoolStocks()
                }
                let frame = button.superview?.window?.frame
                
                
                let x = button.window!.frame.origin.x
                let y = button.window!.frame.origin.y
                
                
                
                button.superview?.window?.setFrameOrigin(NSPoint(x:x, y:y))
                
                //                let frame = popover.contentViewController?.view.window?.frame
                
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                //                let popoverWindowX = frame?.origin.x ?? 0
                //                let popoverWindowY = frame?.origin.y ?? 0
                //                print(popoverWindowX)
                //                print(popoverWindowY)
                //                popover.contentViewController?.view.window?.setFrameOrigin(
                //                    NSPoint(x: popoverWindowX - 24, y: popoverWindowY)
                //                )
                popover.contentViewController?.view.window?.makeKey()
                
            }
        }
        
    }
    
}

