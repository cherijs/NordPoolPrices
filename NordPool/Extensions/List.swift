//
//  List.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import SwiftUI

class InvisibleScroller: NSScroller {
    
    override class var isCompatibleWithOverlayScrollers: Bool {
        return true
    }
    
    override class func scrollerWidth(for controlSize: NSControl.ControlSize, scrollerStyle: NSScroller.Style) -> CGFloat {
        return CGFloat.leastNormalMagnitude // Dimension of scroller is equal to `FLT_MIN`
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Below assignments not really needed, but why not.
        scrollerStyle = .overlay
        alphaValue = 0
    }
}

extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        backgroundColor = NSColor.clear
        enclosingScrollView!.drawsBackground = false
        enclosingScrollView!.horizontalScroller = InvisibleScroller()
        enclosingScrollView!.verticalScroller = InvisibleScroller()
    }
}
